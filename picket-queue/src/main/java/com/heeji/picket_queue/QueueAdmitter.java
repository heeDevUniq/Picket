package com.heeji.picket_queue;

import java.time.Duration;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.redis.core.ReactiveStringRedisTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component 
public class QueueAdmitter {
    
    private static final Logger logger = LoggerFactory.getLogger(QueueAdmitter.class);

    private static final long SHOW_ID = 1;
    private static final int ADMIT = 1; // 한번에 들일 최대 인원
    private static final Duration PASS_TTL = Duration.ofMinutes(10);

    private final ReactiveStringRedisTemplate redis;

    public QueueAdmitter(ReactiveStringRedisTemplate redis) {
        this.redis = redis;
    }

    // 5초 마다 입장권 발급
    @Scheduled(fixedDelay = 5000)
    public void admit() {
        String waitKey = "picket:q:wait:" + SHOW_ID;

        redis.opsForZSet().popMin(waitKey, ADMIT).flatMap(popped -> {
            String userId = popped.getValue();
            String passKey = "picket:q:pass:" + SHOW_ID + ":" + userId;
            return redis.opsForValue().set(passKey, "1", PASS_TTL).thenReturn(userId);
        }).doOnNext(userId -> logger.info("입장 : {}", userId))
        .subscribe();
    }

}
