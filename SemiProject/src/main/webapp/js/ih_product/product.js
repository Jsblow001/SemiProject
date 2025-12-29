function goWish(productId, contextPath) {
    // productId: 상품번호, contextPath: 프로젝트 경로
    alert(productId + "번 상품을 찜 목록에 담았습니다!\n마이페이지에서 확인 가능하게 구현할 예정입니다.");
    
    // 나중에 Ajax 구현 시 예시:
    /*
    $.ajax({
        url: contextPath + "/product/wishAdd.sp",
        type: "POST",
        data: {"product_id": productId},
        success: function(json) {
            // 성공 로직
        }
    });
    */
}

function goCart(productId, contextPath) {
    alert(productId + "번 상품이 장바구니에 담겼습니다.");
}