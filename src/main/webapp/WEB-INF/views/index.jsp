<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="./com/header.jsp"%>
<style>
.main-banner {
    max-width: 100%;
    margin: 0 auto;
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: #000;
    color: #fff;
    height: 500px;
}
.main-banner .banner-text h1 {
    font-size: 36px;
    line-height: 1.3;
}
.main-banner .banner-text p {
    margin-top: 15px;
    font-size: 16px;
    color: #aaa;
}
.main-banner .banner-image img {
    height: 500px;
    object-fit: cover;
}

/* Genre Ranking */
.genre-ranking {
    padding: 40px;
}
.genre-ranking h2 {
    font-size: 24px;
    margin-bottom: 20px;
}
.genre-tabs {
    display: flex;
    gap: 15px;
    margin-bottom: 30px;
}
.genre-tabs button {
    border: 1px solid #007bff;
    background: #fff;
    color: #007bff;
    padding: 8px 20px;
    border-radius: 20px;
    cursor: pointer;
    font-size: 14px;
}
.genre-tabs button.active {
    background: #007bff;
    color: #fff;
}
.ranking-list {
    display: flex;
    gap: 20px;
}
.ranking-item {
    width: 160px;
    text-align: center;
}
.ranking-item .ranking-number {
    font-size: 20px;
    font-weight: bold;
    margin-bottom: 10px;
}
.ranking-item .ranking-img {
    width: 160px;
    height: 240px;
    background: #ccc;
    margin-bottom: 10px;
}
.ranking-item .ranking-title {
    font-weight: bold;
    font-size: 14px;
}
.ranking-item .ranking-location {
    font-size: 12px;
    color: #666;
}
.ranking-item .ranking-date {
    font-size: 12px;
    color: #999;
    margin-top: 5px;
}

/* Event Banner */
.event-banner {
}

/* Open Soon */
.open-soon {
    padding: 40px;
}
.open-soon h2 {
    font-size: 24px;
    margin-bottom: 20px;
}
.open-list {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
}
.open-item {
    display: flex;
    background: #f8f8f8;
    border-radius: 8px;
    overflow: hidden;
    width: calc(50% - 10px);
}
.open-item .open-img {
    width: 100px;
    height: 100px;
    background: #ccc;
}
.open-item .open-info {
    padding: 10px;
}
.open-item .badge {
    display: inline-block;
    background: #007bff;
    color: #fff;
    font-size: 12px;
    padding: 2px 6px;
    border-radius: 4px;
    margin-bottom: 5px;
}
.open-item .date {
    font-size: 12px;
    color: #333;
}
.open-item p {
    font-size: 14px;
    margin-top: 5px;
    color: #333;
}
.title_btn{

}
</style>
<section class="main-banner">
        <div class="banner-text">
            <h1>Karsten Winegeart<br>최초 내한 사진전</h1>
            <p>예술의전당<br>2025.05.09 - 06.09</p>
        </div>
        <div class="banner-image">
            <img src="images/main_view.png" alt="Karsten Winegeart Banner">
        </div>
    </section>

<section class="genre-ranking">
    <h2>장르별 랭킹</h2>
    <div class="genre-tabs">
        <button class="active">뮤지컬/연극</button>
        <button>콘서트</button>
        <button>클래식/무용</button>
        <button>전시</button>
    </div>
    <div class="ranking-list">
        <c:forEach var="show" items="${shows.content}" varStatus="i">
            <a href="/shows/view/${show.showId}">
                <div class="ranking-item">
                    <span class="ranking-number">${i.count}</span>
                    <div class="ranking-img"></div>
                    <div class="ranking-title">${show.title}</div>
                    <div class="ranking-location">${show.place}</div>
                    <div class="ranking-date">2025.02.06</div>
                </div>
            </a>
        </c:forEach>
    </div>
</section>

<section class="event-banner">
        <img src="images/banner.png" alt="event Banner" style="display:block; margin:0 auto; width:70%;">
</section>

<section class="open-soon">
    <h2>오픈예정</h2>
    <div class="open-list">
        <c:forEach var="show" items="${shows.content}">
            <div class="open-item">
                <div class="open-img"></div>
                <div class="open-info">
                    <span class="badge">오픈일시</span>
                    <span class="date">${show.openDate}</span>
                    <p>${show.title}<br>${show.place}</p>
                </div>
            </div>
        </c:forEach>
    </div>
</section>
<%@include file="./com/footer.jsp"%>