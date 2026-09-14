package com.heeji.picket.config;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    private static final Logger logger = LoggerFactory.getLogger(WebConfig.class);

    @Value("${picket.upload.dir:./uploads}")
    private String uploadDir;

    // 업로드 파일은 WAR 밖에 두고 정적 경로로만 노출
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        Path root = Paths.get(uploadDir).toAbsolutePath().normalize();
        try {
            Files.createDirectories(root);
        } catch (IOException e) {
            logger.warn("업로드 디렉터리를 만들지 못했습니다 : {}", root);
        }
        // 끝 슬래시가 없으면 하위 경로 해석 불가
        String location = root.toUri().toString();
        if (!location.endsWith("/")) {
            location = location + "/";
        }
        logger.info("업로드 경로 : {} -> /uploads/**", location);
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations(location)
                .setCachePeriod(60 * 60 * 24 * 30);
    }

}
