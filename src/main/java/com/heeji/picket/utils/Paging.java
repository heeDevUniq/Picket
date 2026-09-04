package com.heeji.picket.utils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

// 목록 페이징 계산
public class Paging {

    public static final int DEFAULT_SIZE = 10;
    private static final int MAX_SIZE = 100;
    // 페이지 번호 블록 크기
    private static final int BLOCK = 10;

    private Paging() {
        // Prevent instantiation
    }

    // 목록 쿼리 실행 전 호출. params 에 offset/size 세팅 후 정규화된 page/size 반환
    public static int[] apply(Map<String, Object> params, Integer page, Integer size) {
        int p = (page == null || page < 1) ? 1 : page;
        int s = (size == null || size < 1) ? DEFAULT_SIZE : Math.min(size, MAX_SIZE);
        params.put("offset", (p - 1) * s);
        params.put("size", s);
        return new int[] { p, s };
    }

    // count 와 list 조회 사이에 호출, 마지막 페이지를 넘긴 요청의 offset 을 다시 잡는다
    public static int clamp(Map<String, Object> params, int page, int size, int totalCount) {
        int totalPages = Math.max(1, (totalCount + size - 1) / size);
        int p = Math.min(Math.max(page, 1), totalPages);
        params.put("offset", (p - 1) * size);
        return p;
    }

    // 조회 결과 + 전체 건수 -> 화면용 페이징 정보
    public static Map<String, Object> wrap(List<Map<String, Object>> list, int totalCount, int page, int size) {
        int totalPages = (totalCount + size - 1) / size;
        if (totalPages < 1) {
            totalPages = 1;
        }
        // 마지막 페이지 초과 시 보정
        int current = Math.min(page, totalPages);

        int blockStart = ((current - 1) / BLOCK) * BLOCK + 1;
        int blockEnd = Math.min(blockStart + BLOCK - 1, totalPages);

        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("totalCount", totalCount);
        result.put("page", current);
        result.put("size", size);
        result.put("totalPages", totalPages);
        result.put("blockStart", blockStart);
        result.put("blockEnd", blockEnd);
        result.put("hasPrev", current > 1);
        result.put("hasNext", current < totalPages);
        result.put("prevPage", Math.max(1, current - 1));
        result.put("nextPage", Math.min(totalPages, current + 1));
        // 번호 컬럼 역순 시작값
        result.put("startNo", totalCount - (long) (current - 1) * size);
        // empty 는 EL 예약어라 noData 사용
        result.put("noData", totalCount == 0);
        return result;
    }

}
