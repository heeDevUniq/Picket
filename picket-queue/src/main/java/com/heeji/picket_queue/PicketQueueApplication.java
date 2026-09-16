package com.heeji.picket_queue;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@EnableScheduling
@SpringBootApplication
public class PicketQueueApplication {

	public static void main(String[] args) {
		SpringApplication.run(PicketQueueApplication.class, args);
	}

}
