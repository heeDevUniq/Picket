package com.heeji.picket;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.heeji.picket.mapper")
public class PicketApplication {

	public static void main(String[] args) {
		SpringApplication.run(PicketApplication.class, args);
	}

}