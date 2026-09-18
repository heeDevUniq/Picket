package com.heeji.picket_queue;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.config.CorsRegistry;
import org.springframework.web.reactive.config.WebFluxConfigurer;

@Configuration
public class CorsConfig implements WebFluxConfigurer {

    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/queue/**")
                .allowedOrigins("http://localhost:3000")   // Picket 만 허용
                .allowedMethods("GET", "POST");
    }

}
