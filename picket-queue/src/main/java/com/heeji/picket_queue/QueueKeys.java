package com.heeji.picket_queue;

public final class QueueKeys {

    public static final String WAIT_PREFIX = "picket:q:wait:";
    public static final String PASS_PREFIX = "picket:q:pass:";
    public static final String AUTH_PREFIX = "picket:q:auth:";

    private QueueKeys() {
    }

    public static String wait(Object showId) {
        return WAIT_PREFIX + showId;
    }

    public static String pass(Object showId, String userId) {
        return PASS_PREFIX + showId + ":" + userId;
    }

    // picket:q:wait:12 -> 12
    public static String showIdOf(String waitKey) {
        return waitKey.substring(WAIT_PREFIX.length());
    }
}
