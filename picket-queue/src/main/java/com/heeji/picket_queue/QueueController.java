package com.heeji.picket_queue;

import java.time.Duration;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.redis.core.ReactiveStringRedisTemplate;
import org.springframework.data.redis.core.script.RedisScript;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;


@RestController 
public class QueueController {

    private static final Logger logger = LoggerFactory.getLogger(QueueController.class);
    
    private final ReactiveStringRedisTemplate redis;

    private static final RedisScript<Long> ENTER = RedisScript.of(
        "return redis.call('ZADD', KEYS[1], 'NX', ARGV[1], ARGV[2])", Long.class
    );

    private final DemoQueueFiller demo;

    public QueueController(ReactiveStringRedisTemplate redis, DemoQueueFiller demo) {
        this.redis = redis;
        this.demo = demo;
    }

    // status를 실제 수행
    private Mono<QueueStatus> statusOf(Long showId, String userId) {
        String key = "picket:q:wait:" + showId;
        String passKey = "picket:q:pass:" + showId + ":" + userId;

        return Mono.zip(
            redis.opsForZSet().rank(key, String.valueOf(userId)).defaultIfEmpty(-1L),
            redis.opsForZSet().size(key),
            redis.hasKey(passKey)
        ).map(t -> new QueueStatus(t.getT1() + 1, t.getT2(), t.getT3()));
    }

    // 순번/총 대기 인원/입장 가능 여부
    @GetMapping("/queue/status")
    public Mono<QueueStatus> status(@RequestParam Long showId, @RequestParam String token) {
        return resolveUserId(token).flatMap(userId -> statusOf(showId, userId))
                .switchIfEmpty(Mono.error(
                    new ResponseStatusException(HttpStatus.UNAUTHORIZED, "유효하지 않은 토큰입니다.")
                ));
    }

    // 실시간 갱신, 입장 시 종료
    @GetMapping(value = "/queue/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<QueueStatus> stream(@RequestParam Long showId, @RequestParam String token) {
        String key = "picket:q:wait:" + showId;

        return resolveUserId(token).flatMapMany(userId -> 
                Flux.interval(Duration.ofSeconds(1)).flatMap(tick -> statusOf(showId, userId))
                    .distinctUntilChanged()
                    .takeUntil(QueueStatus::allowed)
                    .doFinally(signal -> {
                        logger.info("스트림 종료 : userId = {}, 사유 = {}", userId, signal);
                        redis.opsForZSet().remove(key, String.valueOf(userId)).subscribe();
                    }))
                .switchIfEmpty((Flux.error(
                    new ResponseStatusException(HttpStatus.UNAUTHORIZED, "유효하지 않은 토큰입니다.")
                )));
    }

    // 줄 세우기
    @PostMapping("/queue/enter")
    public Mono<QueueStatus> enter(@RequestParam Long showId, @RequestParam String token) {
        String key = "picket:q:wait:" + showId;
        long now = System.currentTimeMillis();
        String score = String.valueOf(now);

        return resolveUserId(token)
                .flatMap(userId -> seedDemo(key, now)
                        .then(redis.execute(ENTER, List.of(key), List.of(score, userId)).then())
                        .then(statusOf(showId, userId)))
                .switchIfEmpty(Mono.error(
                    new ResponseStatusException(HttpStatus.UNAUTHORIZED, "유효하지 않은 토큰입니다.")
                ));
    }

    // 시연용, 줄이 짧으면 과거 시각으로 채워 내 앞에 세움
    private Mono<Void> seedDemo(String waitKey, long now) {
        if (!demo.isEnabled()) {
            return Mono.empty();
        }
        return demo.topUp(waitKey, now - demo.getAhead()).then();
    }

    // 토큰을 받아서 풀기
    private Mono<String> resolveUserId(String token) {
        return redis.opsForValue().get("picket:q:auth:" + token);
    }

}