package com.heeji.picket;

import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

// 외부 톰캣 WAR 배포용 진입점 (JSP 때문에 JAR 불가)
public class ServletInitializer extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(PicketApplication.class);
    }

}
