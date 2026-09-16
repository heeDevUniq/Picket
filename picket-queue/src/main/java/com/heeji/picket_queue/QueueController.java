package com.heeji.picket_queue;

import java.time.Duration;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.redis.core.ReactiveStringRedisTemplate;
import org.springframework.data.redis.core.script.RedisScript;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RestController;

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

    public QueueController(ReactiveStringRedisTemplate redis) {
        this.redis = redis;
    }

    @GetMapping("/queue/rank")
    public Mono<Long> rank(@RequestParam Long showId, @RequestParam Long userId) {
        String key = "picket:q:wait:" + showId;
        return redis.opsForZSet().rank(key, String.valueOf(userId));
    }

    // 순번/총 대기 인원/입장 가능 여부
    @GetMapping("/queue/status")
    public Mono<QueueStatus> status(@RequestParam Long showId, @RequestParam Long userId) {
        String key = "picket:q:wait:" + showId;
        String passKey = "picket:q:pass:" + showId + ":" + userId;

        return Mono.zip(
            redis.opsForZSet().rank(key, String.valueOf(userId)).defaultIfEmpty(-1L),
            redis.opsForZSet().size(key),
            redis.hasKey(passKey)
        ).map(t -> new QueueStatus(t.getT1() + 1, t.getT2(), t.getT3()));
    }

    // 실시간 갱신, 입장 시 종료
    @GetMapping(value = "/queue/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<QueueStatus> stream(@RequestParam Long showId, @RequestParam Long userId) {
        String key = "picket:q:wait:" + showId;

        return Flux.interval(Duration.ofSeconds(1)).flatMap(tick -> status(showId, userId))
                .distinctUntilChanged()
                .takeUntil(QueueStatus::allowed)
                .doFinally(signal -> {
                    logger.info("스트림 종료 : userId = {}, 사유 = {}", userId, signal);
                    redis.opsForZSet().remove(key, String.valueOf(userId)).subscribe();
                });
    }

    // 줄 세우기
    @PostMapping("/queue/enter")
    public Mono<QueueStatus> enter(@RequestParam Long showId, @RequestParam Long userId) {
        String key = "picket:q:wait:" + showId;
        String member = String.valueOf(userId);
        String score = String.valueOf(System.currentTimeMillis());

        return redis.execute(ENTER, List.of(key), List.of(score, member))
                .then(status(showId, userId));
    }

}