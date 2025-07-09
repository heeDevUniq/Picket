<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../com/header.jsp"%>
<style>
.page-title {
    font-size: 24px;
    font-weight: bold;
    margin: 30px 0 20px;
    color: #2979ff;
}

.show-list {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
    gap: 30px;
}

.show-card {
    background: #fff;
    border: 1px solid #e0e0e0;
    border-radius: 8px;
    overflow: hidden;
    transition: transform 0.3s, box-shadow 0.3s;
    cursor: pointer;
}

.show-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 4px 20px rgba(0,0,0,0.1);
}

.show-card .poster img {
    width: 100%;
    height: 280px;
    object-fit: cover;
    display: block;
}

.show-info {
    padding: 15px;
}

.show-info .title {
    font-size: 16px;
    font-weight: bold;
    margin-bottom: 8px;
    color: #333;
}

.show-info .venue,
.show-info .date {
    font-size: 14px;
    color: #666;
    margin-bottom: 5px;
}

.ticket-info .label {
    display: inline-block;
    background-color: #2979ff;
    color: #fff;
    font-size: 12px;
    padding: 2px 6px;
    border-radius: 3px;
    margin-top: 5px;
}
</style>
<div class="container">
    <main class="main-content">
        <h2 class="page-title">티켓</h2>
        <div class="show-list">
            <c:forEach var="show" items="${shows.content}">
                <a href="/shows/view/${show.showId}">
                    <div class="show-card">
                        <div class="poster">
                            <img src="${show.posterLink}" alt="${show.title}">
                        </div>
                        <div class="show-info">
                            <h3 class="title">${show.title}</h3>
                            <p class="venue">${show.place}</p>
                            <p class="date">${show.startDate} ~ ${show.endDate}</p>
                        </div>
                    </div>
                </a>
            </c:forEach>
        </div>
    </main>
</div>
<%@include file="../com/footer.jsp"%>