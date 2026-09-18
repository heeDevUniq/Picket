package com.heeji.picket_queue;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.ReactiveStringRedisTemplate;
import org.springframework.data.redis.core.ScanOptions;
import org.springframework.data.redis.core.ZSetOperations;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import reactor.core.publisher.Mono;

@Component
public class DemoQueueFiller {

    @Value("${picket.queue.demo.enabled:false}")
    private boolean enabled;

    // 내 앞에 가상 대기자 수 : 100명
    @Value("${picket.queue.demo.ahead:100}")
    private int ahead;

    private final ReactiveStringRedisTemplate redis;

    public DemoQueueFiller(ReactiveStringRedisTemplate redis) {
        this.redis = redis;
    }

    public boolean isEnabled() {
        return enabled;
    }

    public int getAhead() {
        return ahead;
    }

    // 줄이 선 공연마다 뒤쪽을 채워 총원 유지
    @Scheduled(fixedDelay = 1000)
    public void refill() {
        if (!enabled) {
            return;
        }
        redis.scan(ScanOptions.scanOptions().match(QueueKeys.WAIT_PREFIX + "*").count(100).build())
                .flatMap(key -> topUp(key, System.currentTimeMillis()))
                .subscribe();
    }

    // 모자란 만큼 보충
    public Mono<Long> topUp(String waitKey, long base) {
        return redis.opsForZSet().size(waitKey)
                .filter(size -> size < ahead)
                .flatMap(size -> redis.opsForZSet().addAll(waitKey, dummies((int) (ahead - size), base)));
    }

    // 실제 사용자보다 앞에 세우려면 과거 시각을 넘김
    private List<ZSetOperations.TypedTuple<String>> dummies(int count, long base) {
        List<ZSetOperations.TypedTuple<String>> people = new ArrayList<>(count);
        for (int i = 0; i < count; i++) {
            // 보충마다 다른 이름, 같은 이름이면 점수만 갱신돼 인원이 안 늘어남
            people.add(ZSetOperations.TypedTuple.of("demo-" + base + "-" + i, (double) (base + i)));
        }
        return people;
    }
}
