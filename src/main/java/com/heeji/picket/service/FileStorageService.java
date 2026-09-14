package com.heeji.picket.service;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Map;
import java.util.UUID;

import javax.imageio.ImageIO;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class FileStorageService {

    private static final Logger logger = LoggerFactory.getLogger(FileStorageService.class);

    private static final long MAX_BYTES = 5L * 1024 * 1024;

    // 실제 이미지로 확인된 형식만 저장, 확장자도 서버가 결정
    private static final Map<String, String> ALLOWED = Map.of(
            "image/jpeg", ".jpg",
            "image/png", ".png",
            "image/gif", ".gif",
            "image/webp", ".webp");

    @Value("${picket.upload.dir:./uploads}")
    private String uploadDir;

    public String savePoster(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("이미지를 선택해주세요");
        }
        if (file.getSize() > MAX_BYTES) {
            throw new IllegalArgumentException("이미지는 5MB 이하만 올릴 수 있습니다.");
        }

        String contentType = file.getContentType();
        String ext = ALLOWED.get(contentType == null ? "" : contentType.toLowerCase());
        if (ext == null) {
            throw new IllegalArgumentException("JPG, PNG, GIF, WEBP 형식만 올릴 수 있습니다.");
        }
        // 확장자만 바꿔 올린 파일 차단
        if (!isImage(file)) {
            throw new IllegalArgumentException("이미지 파일이 아닙니다.");
        }

        try {
            Path dir = Paths.get(uploadDir, "posters").toAbsolutePath().normalize();
            Files.createDirectories(dir);
            // 원본 파일명 미사용
            String name = UUID.randomUUID().toString().replace("-", "") + ext;
            Path target = dir.resolve(name);
            try (InputStream in = file.getInputStream()) {
                Files.copy(in, target, StandardCopyOption.REPLACE_EXISTING);
            }
            logger.debug("포스터 저장, path : {}", target);
            return "/uploads/posters/" + name;
        } catch (IOException e) {
            logger.error("포스터 저장 실패", e);
            throw new IllegalStateException("이미지를 저장하지 못했습니다.");
        }
    }

    private boolean isImage(MultipartFile file) {
        try (InputStream in = file.getInputStream()) {
            return ImageIO.read(in) != null;
        } catch (Exception e) {
            return false;
        }
    }

}
