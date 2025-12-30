<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<jsp:include page="../header.jsp" />

<style>
    body {
        font-family: 'Pretendard', sans-serif;
        background-color: #fff;
        color: #333;
    }

    .mypage-wrap {
        max-width: 520px;
        margin: 80px auto;
    }

    .mypage-title {
        text-align: center;
        font-size: 28px;
        margin-bottom: 40px;
    }

    .user-box {
        background: #faf7f2;
        padding: 25px;
        border-radius: 4px;
        margin-bottom: 25px;
    }

    .user-name {
        font-weight: 700;
        font-size: 16px;
        margin-bottom: 10px;
    }

    .user-summary {
        font-size: 13px;
        color: #666;
        line-height: 1.6;
    }

    .order-status {
        display: flex;
        justify-content: space-between;
        margin-top: 20px;
        text-align: center;
        font-size: 13px;
    }

    .order-status div span {
        display: block;
        margin-top: 8px;
        font-weight: 600;
    }

    .menu-list {
        border-top: 1px solid #e5e5e5;
    }

    .menu-item {
        display: flex;
        justify-content: space-between;
        padding: 18px 5px;
        border-bottom: 1px solid #e5e5e5;
        font-size: 14px;
        cursor: pointer;
    }

    .menu-item:hover {
        background-color: #fafafa;
    }
</style>

<div class="mypage-wrap">

    <div class="mypage-title">My page</div>

    <!-- 사용자 정보 박스 -->
    <div class="user-box">
        <div class="user-name">
            ${sessionScope.loginuser.name}님 &nbsp; <span style="font-weight:400;">일반회원</span>
        </div>

        <div class="user-summary">
            최근 3개월 동안<br>
            구매금액 : KRW 0 | 구매건수 : 0건
        </div>

        <div class="order-status">
            <div>
                입금전
                <span>0</span>
            </div>
            <div>
                배송준비중
                <span>0</span>
            </div>
            <div>
                배송중
                <span>0</span>
            </div>
            <div>
                배송완료
                <span>0</span>
            </div>
        </div>
    </div>

    <!-- 메뉴 영역 -->
    <div class="menu-list">
        <div class="menu-item">
            <span>적립금</span>
            <span>0원</span>
        </div>

        <div class="menu-item">
            <span>쿠폰</span>
            <span>1개</span>
        </div>

        <div class="menu-item" onclick="location.href='<%= request.getContextPath() %>/member/edit.sp'">
            <span>회원정보</span>
            <span>+</span>
        </div>

        <div class="menu-item">
            <span>주문내역</span>
            <span>+</span>
        </div>

        <div class="menu-item">
            <span>관심상품</span>
            <span>+</span>
        </div>

        <div class="menu-item" onclick="location.href='<%= request.getContextPath() %>/logout.sp'">
            <span>로그아웃</span>
        </div>
    </div>

</div>

<jsp:include page="../footer.jsp" />
