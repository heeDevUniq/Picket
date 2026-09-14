package com.heeji.picket.controller;

import com.heeji.picket.service.BookingService;
import com.heeji.picket.service.FileStorageService;
import com.heeji.picket.service.ShowAdminService;
import com.heeji.picket.service.SeatGradeService;
import com.heeji.picket.service.SeatService;
import com.heeji.picket.service.ShowDateService;
import com.heeji.picket.service.ShowLikesService;
import com.heeji.picket.service.ShowReviewsService;
import com.heeji.picket.service.ShowsService;
import com.heeji.picket.service.TossPaymentsService;
import com.heeji.picket.service.UserAlarmService;
import com.heeji.picket.utils.SessionUtil;
import com.heeji.picket.utils.HtmlSanitizer;
import com.heeji.picket.utils.Paging;
import com.heeji.picket.utils.SeatTakenException;
import com.heeji.picket.utils.TossPaymentException;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.regex.Pattern;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@Controller
@RequestMapping("/shows")
public class ShowsController {

    private static final Logger logger = LoggerFactory.getLogger(ShowsController.class);

    // FileStorageService 가 만드는 경로 형태
    private static final Pattern POSTER_PATH = Pattern.compile("^/uploads/posters/[0-9a-f]{32}\\.(?:jpg|png|gif|webp)$");
    private static final Pattern HTTP_URL = Pattern.compile("^https?://[^\\s\"'<>]+$");

    @Autowired
    ShowsService showsService;

    @Autowired
    ShowDateService showDateService;

    @Autowired
    ShowLikesService showLikesService;

    @Autowired
    UserAlarmService userAlarmService;

    @Autowired
    ShowReviewsService showReviewsService;

    @Autowired
    SeatGradeService seatGradeService;

    @Autowired
    SeatService seatService;

    @Autowired
    TossPaymentsService tossPaymentsService;

    @Autowired
    BookingService bookingService;

    @Autowired
    ShowAdminService showAdminService;

    @Autowired
    FileStorageService fileStorageService;

    @Value("${picket.app.base-url:}")
    private String appBaseUrl;

    // 장르 코드 -> 화면 표기, Map.of 는 순서를 보장하지 않아 정렬이 흔들림
    private static final Map<String, String> GENRE_LABELS = new LinkedHashMap<String, String>();
    static {
        GENRE_LABELS.put("musical", "뮤지컬/연극");
        GENRE_LABELS.put("concert", "콘서트");
        GENRE_LABELS.put("classic", "클래식/무용");
        GENRE_LABELS.put("exhibit", "전시/행사");
        GENRE_LABELS.put("festival", "페스티벌");
        GENRE_LABELS.put("etc", "기타");
    }

    @GetMapping("/list/{genre}")
    public String index(Model model, @PathVariable("genre") String genre, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size) {
        logger.debug("shows index 진입, genre : {}, page : {}", genre, page);
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("genre", genre);
        // 장르별 목록
        Map<String, Object> paged = showsService.pagedList(params, page, size == null ? 12 : size);
        model.addAttribute("paging", paged);
        model.addAttribute("shows", paged.get("list"));
        model.addAttribute("genre", genre);
        model.addAttribute("genreLabel", GENRE_LABELS.getOrDefault(genre, "티켓"));
        // JSP 오픈 여부 비교용
        model.addAttribute("nowMillis", System.currentTimeMillis());
        return "shows/index";
    }

    @GetMapping("/view/{showId}")
    public String view(Model model, @PathVariable("showId") Long showId, HttpSession session) {
        Map<String, Object> deletedCheck = new HashMap<String, Object>();
        deletedCheck.put("showId", showId);
        Map<String, Object> target = showsService.info(deletedCheck);
        if (target == null || target.get("isDeleted") != null) {
            return "redirect:/index";
        }
        logger.debug("shows view 진입, showId : {}", showId);
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("showId", showId);
        // 좋아요/알림은 로그인 회원 기준
        params.put("userId", SessionUtil.getLoginId(session));

        model.addAttribute("show", showsService.info(params));
        model.addAttribute("showDates", showDateService.list(params));
        model.addAttribute("likeCount", showLikesService.likeTotCnt(params));
        model.addAttribute("likeMyCount", showLikesService.likeYn(params));
        model.addAttribute("alarmMyCount", userAlarmService.alarmYn(params));
        model.addAttribute("reviews", showReviewsService.list(params));
        // JSP 오픈 여부 비교용
        model.addAttribute("nowMillis", System.currentTimeMillis());
        return "shows/view";
    }

    @GetMapping("/getTickets")
    public String getTickets(Model model, HttpSession session, @RequestParam("showDateId") Long showDateId) {
        logger.debug("getTickets 진입, showDateId : {}", showDateId);
        if (!SessionUtil.isLogin(session)) {
            model.addAttribute("failTitle", "로그인이 필요해요");
            model.addAttribute("failCode", "LOGIN_REQUIRED");
            model.addAttribute("failMessage", "예매는 로그인 후에 진행할 수 있습니다.");
            model.addAttribute("failAction", "login");
            return "shows/popup/payFail";
        }
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("showDateId", showDateId);
        model.addAttribute("showDateId", showDateId);
        // 선택한 날짜의 공연 정보
        Map<String, Object> show = showDateService.info(params);
        // 좌석이 없는 지난 회차는 링크 직접 접근도 차단
        Object showDate = show == null ? null : show.get("showDate");
        if (showDate instanceof Date && ((Date) showDate).before(new Date())) {
            model.addAttribute("failTitle", "지난 공연이에요");
            model.addAttribute("failCode", "PAST_SHOW_DATE");
            model.addAttribute("failMessage", "이미 종료된 회차입니다. 다른 관람일자를 선택해주세요.");
            return "shows/popup/payFail";
        }
        // 티켓 오픈 전 예매 차단
        Object openDate = show == null ? null : show.get("openDate");
        if (openDate instanceof Date && ((Date) openDate).after(new Date())) {
            model.addAttribute("failTitle", "아직 티켓이 열리지 않았어요");
            model.addAttribute("failCode", "NOT_OPENED");
            model.addAttribute("failMessage", "티켓 오픈 후에 예매할 수 있습니다. 티켓팅 알림을 신청해두시면 오픈 때 알려드릴게요.");
            return "shows/popup/payFail";
        }
        model.addAttribute("show", show);
        model.addAttribute("grades", seatGradeService.list(params));
        model.addAttribute("seats", seatService.list(params));
        // 관람일자 드롭다운용 전체 회차
        if (show != null) {
            Map<String, Object> dateParams = new HashMap<String, Object>();
            dateParams.put("showId", show.get("showId"));
            model.addAttribute("showDates", showDateService.list(dateParams));
        }
        return "shows/popup/step01";
    }

    @PostMapping("/payment")
    public String payment(Model model, HttpSession session, @RequestParam("showId") Long showId, @RequestParam("showDateId") Long showDateId, @RequestParam(value = "seatArrays", required = false) Long[] seatArrays) {
        logger.debug("payment 진입, showId : {}, showDateId : {}", showId, showDateId);
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("showId", showId);
        params.put("showDateId", showDateId);

        Map<String, Object> show = showDateService.info(params);
        List<Map<String, Object>> seats = (seatArrays != null && seatArrays.length > 0) ? seatService.selectedSeatList(seatArrays) : List.of();

        model.addAttribute("showDateId", showDateId);
        model.addAttribute("show", show);
        model.addAttribute("seats", seats);

        // 금액은 서버 재계산분만 사용
        long amount = totalAmount(seats);
        String orderId = newOrderId();
        boolean ready = tossPaymentsService.isConfigured() && amount > 0 && SessionUtil.isLogin(session);

        if (ready) {
            // 승인 콜백은 크로스사이트라 세션이 없으므로 주문을 DB 에 보관
            bookingService.createOrder(SessionUtil.getLoginId(session), showId, showDateId, orderId, amount, seatArrays, seats);
        }

        model.addAttribute("orderId", orderId);
        model.addAttribute("orderName", orderName(show, seats));
        model.addAttribute("amount", amount);
        model.addAttribute("tossClientKey", tossPaymentsService.getClientKey());
        model.addAttribute("appBaseUrl", appBaseUrl);
        model.addAttribute("payReady", ready);
        return "shows/popup/step02";
    }

    // 토스 결제 성공 리다이렉트
    @GetMapping("/payment/success")
    public String paymentSuccess(Model model, @RequestParam("paymentKey") String paymentKey, @RequestParam("orderId") String orderId, @RequestParam("amount") Long amount) {
        logger.debug("paymentSuccess 진입, orderId : {}, amount : {}", orderId, amount);

        Map<String, Object> order = bookingService.findOrder(orderId);
        if (order == null) {
            return payFail(model, "ORDER_NOT_FOUND", "주문 정보를 찾을 수 없습니다. 처음부터 다시 예매해주세요.");
        }
        // 이미 끝난 주문이면 완료 화면 재표시
        if ("DONE".equals(order.get("status"))) {
            return renderComplete(model, order, null);
        }
        if (!"READY".equals(order.get("status"))) {
            return payFail(model, "ORDER_CLOSED", "이미 처리된 주문입니다.");
        }

        long expected = ((Number) order.get("amount")).longValue();
        if (amount == null || amount.longValue() != expected) {
            logger.warn("결제 금액 불일치, orderId : {}, 요청 : {}, 서버 : {}", orderId, amount, expected);
            return payFail(model, "AMOUNT_MISMATCH", "결제 금액이 일치하지 않아 승인하지 않았습니다. 결제는 이루어지지 않았습니다.");
        }

        Long[] seatArrays = BookingService.parseIds(order.get("seatIds"));
        if (seatArrays.length == 0) {
            return payFail(model, "NO_SEAT", "선택한 좌석 정보가 없습니다. 처음부터 다시 예매해주세요.");
        }
        Long paidId = order.get("paidId") == null ? null : ((Number) order.get("paidId")).longValue();

        // 승인 전에 좌석을 선점하고, 실패하면 결제하지 않음
        try {
            bookingService.holdSeats(paidId, orderId, seatArrays);
        } catch (SeatTakenException e) {
            bookingService.dropOrder(orderId);
            return payFail(model, "SEAT_TAKEN", e.getMessage() + " 결제는 이루어지지 않았습니다.");
        }

        Map<String, Object> paid;
        try {
            paid = tossPaymentsService.confirm(paymentKey, orderId, expected);
        } catch (TossPaymentException e) {
            // 승인 실패 시 좌석 반환
            bookingService.releaseSeats(orderId);
            bookingService.dropOrder(orderId);
            return payFail(model, e.getCode(), e.getMessage());
        }

        bookingService.completeOrder(orderId, paymentKey, paid);
        return renderComplete(model, order, paid);
    }

    // 토스 결제 취소·실패 리다이렉트
    @GetMapping("/payment/fail")
    public String paymentFail(Model model, @RequestParam(value = "code", required = false) String code, @RequestParam(value = "message", required = false) String message, @RequestParam(value = "orderId", required = false) String orderId) {
        logger.debug("paymentFail 진입, code : {}, message : {}", code, message);
        if (orderId != null && !orderId.isBlank()) {
            bookingService.dropOrder(orderId);
        }
        return payFail(model, code, message);
    }

    private String renderComplete(Model model, Map<String, Object> order, Map<String, Object> paid) {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("showId", order.get("showId"));
        params.put("showDateId", order.get("showDateId"));
        model.addAttribute("show", showDateService.info(params));
        model.addAttribute("seats", seatService.selectedSeatList(BookingService.parseIds(order.get("seatIds"))));
        model.addAttribute("bookedNumber", order.get("bookedNumber"));
        model.addAttribute("payMethod", paid == null ? order.get("method") : paid.get("method"));
        return "shows/popup/step03";
    }

    private String payFail(Model model, String code, String message) {
        model.addAttribute("failCode", code == null ? "UNKNOWN" : code);
        model.addAttribute("failMessage", (message == null || message.isBlank()) ? "결제가 완료되지 않았습니다." : message);
        return "shows/popup/payFail";
    }

    private long totalAmount(List<Map<String, Object>> seats) {
        long sum = 0;
        for (Map<String, Object> seat : seats) {
            Object price = seat.get("price");
            if (price instanceof Number) {
                sum += ((Number) price).longValue();
            }
        }
        return sum;
    }

    // 토스 주문번호는 6~64자
    private String newOrderId() {
        return "PK" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")) + UUID.randomUUID().toString().substring(0, 6);
    }

    private String orderName(Map<String, Object> show, List<Map<String, Object>> seats) {
        String title = show == null ? "공연" : String.valueOf(show.get("title"));
        return seats.size() > 1 ? title + " 외 " + (seats.size() - 1) + "건" : title;
    }

    @GetMapping("/my/list")
    public String myList(Model model, HttpSession session, HttpServletRequest request, @RequestParam(value = "page", required = false) Integer page) {
        logger.debug("myList 진입");
        String guard = sellerGuard(session, request);
        if (guard != null) {
            return guard;
        }
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("userId", SessionUtil.getLoginId(session));
        int[] ps = Paging.apply(params, page, 10);
        int total = showAdminService.mineCount(params);
        ps[0] = Paging.clamp(params, ps[0], ps[1], total);

        model.addAttribute("shows", Paging.wrap(showAdminService.mine(params), total, ps[0], ps[1]));
        return "myShows/index";
    }

    @GetMapping("/my/write")
    public String myWriteNew(Model model, HttpSession session, HttpServletRequest request) {
        return myWrite(model, session, request, null);
    }

    @GetMapping("/my/write/{showId}")
    public String myWrite(Model model, HttpSession session, HttpServletRequest request, @PathVariable(value = "showId", required = false) Long showId) {
        logger.debug("myWrite 진입, showId : {}", showId);
        String guard = sellerGuard(session, request);
        if (guard != null) {
            return guard;
        }

        if (showId != null && showId > 0) {
            Map<String, Object> params = new HashMap<String, Object>();
            params.put("showId", showId);
            Map<String, Object> show = showsService.info(params);
            if (show == null || show.get("isDeleted") != null || !isMine(session, show)) {
                return "redirect:/shows/my/list";
            }
            model.addAttribute("show", show);

            Map<String, Object> dateParams = new HashMap<String, Object>();
            dateParams.put("showId", showId);
            // 수정 화면에서는 지난 회차도 노출
            dateParams.put("includePast", true);
            List<Map<String, Object>> showDates = showDateService.list(dateParams);
            model.addAttribute("showDates", showDates);

            model.addAttribute("grades", seatGradeService.listByShowId(showId));
            model.addAttribute("hasBooking", showAdminService.hasBooking(showId));
        }
        model.addAttribute("genreLabels", GENRE_LABELS);
        return "myShows/write";
    }

    @PostMapping("/my/save")
    @ResponseBody
    public Map<String, Object> mySave(HttpSession session, @RequestBody Map<String, Object> body) {
        Map<String, Object> result = new HashMap<String, Object>();
        if (!isSeller(session)) {
            result.put("success", false);
            result.put("message", "티켓셀러만 공연을 등록할 수 있습니다.");
            return result;
        }

        Long loginId = SessionUtil.getLoginId(session);
        Map<String, Object> show = new HashMap<String, Object>();
        show.put("showId", blankToNull(body.get("showId")));
        show.put("title", body.get("title"));
        show.put("genre", body.get("genre"));
        show.put("place", body.get("place"));
        show.put("placeAddress", body.get("placeAddress"));
        show.put("host", body.get("host"));
        show.put("contact", body.get("contact"));
        show.put("ageLimit", body.get("ageLimit"));
        show.put("posterLink", safePoster(body.get("posterLink")));
        show.put("info", HtmlSanitizer.clean(asString(body.get("info"))));
        show.put("openDate", asString(body.get("openDate")).replace('T', ' '));
        show.put("loginId", loginId);

        if (asString(show.get("title")).isBlank() || asString(show.get("place")).isBlank()) {
            result.put("success", false);
            result.put("message", "공연명과 장소는 필수입니다.");
            return result;
        }

        @SuppressWarnings("unchecked")
        List<String> showDates = (List<String>) body.get("showDates");
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> grades = (List<Map<String, Object>>) body.get("grades");

        try {
            Long savedId = showAdminService.save(show, showDates, grades);
            result.put("success", true);
            result.put("showId", savedId);
        } catch (IllegalArgumentException | IllegalStateException e) {
            logger.warn("공연 저장 실패, loginId : {}, msg : {}", loginId, e.getMessage());
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    // 업로드 경로와 http(s) 이미지 주소만 허용, javascript: data: 같은 스킴을 막는다
    private String safePoster(Object raw) {
        String link = asString(raw).trim();
        if (link.isEmpty()) {
            return null;
        }
        if (!POSTER_PATH.matcher(link).matches() && !HTTP_URL.matcher(link).matches()) {
            throw new IllegalArgumentException("포스터 주소가 올바르지 않습니다.");
        }
        return link;
    }

    @PostMapping("/my/poster")
    @ResponseBody
    public Map<String, Object> uploadPoster(HttpSession session, @RequestParam("file") MultipartFile file) {
        Map<String, Object> result = new HashMap<String, Object>();
        if (!isSeller(session)) {
            result.put("success", false);
            result.put("message", "티켓셀러만 업로드할 수 있습니다.");
            return result;
        }
        try {
            result.put("success", true);
            result.put("url", fileStorageService.savePoster(file));
        } catch (IllegalArgumentException | IllegalStateException e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    @PostMapping("/my/delete")
    @ResponseBody
    public Map<String, Object> myDelete(HttpSession session, @RequestBody Map<String, Object> body) {
        Map<String, Object> result = new HashMap<String, Object>();
        if (!isSeller(session)) {
            result.put("success", false);
            result.put("message", "티켓셀러만 삭제할 수 있습니다.");
            return result;
        }
        try {
            showAdminService.delete(Long.valueOf(asString(body.get("showId"))), SessionUtil.getLoginId(session));
            result.put("success", true);
        } catch (IllegalStateException e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    private boolean isSeller(HttpSession session) {
        return SessionUtil.isLogin(session) && "seller".equals(session.getAttribute("LOGIN_ROLE"));
    }

    private boolean isMine(HttpSession session, Map<String, Object> show) {
        Long loginId = SessionUtil.getLoginId(session);
        Object insertId = show.get("insertId");
        return loginId != null && insertId != null && loginId.longValue() == ((Number) insertId).longValue();
    }

    // 비로그인은 로그인으로, 일반 회원은 메인으로
    private String sellerGuard(HttpSession session, HttpServletRequest request) {
        if (!SessionUtil.isLogin(session)) {
            SessionUtil.setReturnUrl(session, request.getRequestURI());
            return "redirect:/login";
        }
        return isSeller(session) ? null : "redirect:/index";
    }

    private Object blankToNull(Object value) {
        return (value == null || value.toString().isBlank()) ? null : value;
    }

    private String asString(Object value) {
        return value == null ? "" : value.toString();
    }

}
