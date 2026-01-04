function goWish(productId, contextPath) {

    const $wishIcon = $(".wish-icon-" + productId); 

    $.ajax({
        url: contextPath + "/product/wishProcess.sp",
        type: "POST",
        data: {"product_id": productId},
        dataType: "JSON",
        success: function(json) {
            /* {"result": "added", "message": "찜 목록에 추가되었습니다."} */
            
            if(json.result === "login_required") {
                if(confirm("로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?")) {
                    location.href = contextPath + "/login.sp";
                }
            } 
            else if(json.result === "added") {
                alert(json.message);
                $wishIcon.removeClass("far").addClass("fas text-danger");
            } 
            else if(json.result === "removed") {
                alert(json.message);
                $wishIcon.removeClass("fas text-danger").addClass("far");
            }
			// far는 비어있는 하트 
			// fas는 색이 꽉 찬 하트
        },
        error: function() {
            alert("서버 통신 중 오류가 발생했습니다.");
        }
    });
}
function goCart(productId, contextPath) {
    alert(productId + "번 상품이 장바구니에 담겼습니다.");
}