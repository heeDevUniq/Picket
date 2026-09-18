package com.heeji.picket_queue;

import java.time.Duration;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.redis.core.ReactiveStringRedisTemplate;
import org.springframework.data.redis.core.ScanOptions;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Component
public class QueueAdmitter {

    private static final Logger logger = LoggerFactory.getLogger(QueueAdmitter.class);

    private static final int CAPACITY = 20; // 수용인원
    private static final int ADMIT = 5; // 한번에 들일 최대 인원
    private static final Duration PASS_TTL = Duration.ofMinutes(10);

    private final ReactiveStringRedisTemplate redis;

    public QueueAdmitter(ReactiveStringRedisTemplate redis) {
        this.redis = redis;
    }

    // 2초 마다 입장권 발급, 줄이 선 공연 전부
    @Scheduled(fixedDelay = 2000)
    public void admit() {
        redis.scan(ScanOptions.scanOptions().match(QueueKeys.WAIT_PREFIX + "*").count(100).build())
                .flatMap(this::admitOne)
                .subscribe();
    }

    private Flux<String> admitOne(String waitKey) {
        String showId = QueueKeys.showIdOf(waitKey);
        return countInside(showId).flatMapMany(inside -> {
            long room = CAPACITY - inside;
            if (room <= 0) {
                return Flux.empty();
            }
            return popAndPass(waitKey, showId, Math.min(room, ADMIT));
        });
    }

    // 안에 있는 사람 수 = 발급된 입장권 수
    private Mono<Long> countInside(String showId) {
        String pattern = QueueKeys.PASS_PREFIX + showId + ":*";
        return redis.scan(ScanOptions.scanOptions().match(pattern).count(100).build()).count();
    }

    private Flux<String> popAndPass(String waitKey, String showId, long n) {
        return redis.opsForZSet().popMin(waitKey, n)
                .flatMap(popped -> {
                    String userId = popped.getValue();
                    return redis.opsForValue().set(QueueKeys.pass(showId, userId), "1", PASS_TTL)
                            .thenReturn(userId);
                })
                .doOnNext(userId -> {
                    if (!userId.startsWith("demo-")) {
                        logger.info("입장 : showId = {}, userId = {}", showId, userId);
                    }
                });
    }

}
