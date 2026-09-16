package com.heeji.picket_queue;

import java.time.Duration;

import org.springframework.data.redis.core.ReactiveStringRedisTemplate;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RestController;

import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;


@RestController 
public class QueueController {
    
    private final ReactiveStringRedisTemplate redis;

    public QueueController(ReactiveStringRedisTemplate redis) {
        this.redis = redis;
    }

    @GetMapping("/queue/rank")
    public Mono<Long> rank(@RequestParam Long showId, @RequestParam Long userId) {
        String key = "picket:q:wait:" + showId;
        return redis.opsForZSet().rank(key, String.valueOf(userId));
    }

    @GetMapping("/queue/status")
    public Mono<QueueStatus> status(@RequestParam Long showId, @RequestParam Long userId) {
        String key = "picket:q:wait:" + showId;

        return Mono.zip(
            redis.opsForZSet().rank(key, String.valueOf(userId)).defaultIfEmpty(-1L),
            redis.opsForZSet().size(key)
        ).map(t -> new QueueStatus(t.getT1() + 1, t.getT2()));
    }

    @GetMapping(value = "/queue/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<QueueStatus> stream(@RequestParam Long showId, @RequestParam Long userId) {
        return Flux.interval(Duration.ofSeconds(1)).flatMap(tick -> status(showId, userId)).distinctUntilChanged();
    }

}