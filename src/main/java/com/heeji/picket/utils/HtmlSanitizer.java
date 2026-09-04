package com.heeji.picket.utils;

import org.owasp.html.HtmlPolicyBuilder;
import org.owasp.html.PolicyFactory;
import org.owasp.html.Sanitizers;

public class HtmlSanitizer {

    private HtmlSanitizer() {
    }

    // 에디터가 쓰는 태그만 허용하고 script/style/on* 은 제거
    private static final PolicyFactory POLICY = Sanitizers.FORMATTING
            .and(Sanitizers.BLOCKS)
            .and(Sanitizers.STYLES)
            .and(Sanitizers.TABLES)
            .and(new HtmlPolicyBuilder()
                    // 링크는 http/https/mailto 만 허용
                    .allowElements("a")
                    .allowAttributes("href", "title").onElements("a")
                    .allowUrlProtocols("http", "https", "mailto")
                    .requireRelNofollowOnLinks()
                    // 이미지는 외부 주소와 data URI 허용
                    .allowElements("img")
                    .allowAttributes("src", "alt", "title", "width", "height").onElements("img")
                    .allowUrlProtocols("http", "https", "data")
                    .allowElements("hr", "br")
                    .toFactory());

    public static String clean(String html) {
        if (html == null || html.isBlank()) {
            return html;
        }
        return POLICY.sanitize(html);
    }

}
