function goWish(productId, contextPath) {

    const $wishIcon = $(".wish-icon-" + productId); 

    $.ajax({
        url:contextPath+"/product/wishProcess.sp",
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
				location.reload(true);
			}
			// far는 비어있는 하트 
			// fas는 색이 꽉 찬 하트
        },
        error: function() {
            alert("서버 통신 중 오류가 발생했습니다.");
        }
    });
}

function goCart(productId, qty, contextPath) {
	
	const $cartIcon = $(".cart-icon-" + productId); 
	
	// 수량이 없거나 0 이하인 경우
    if(!qty) qty = "1";

    $.ajax({
        url:contextPath+"/product/cartAdd.sp", // 장바구니 추가 컨트롤러 주소
        type: "POST",
        data: {"product_id": productId,
               "cart_qty": qty},
        dataType: "JSON",
        success: function(json) {
			
			console.log("서버 응답 데이터:", json);
			
			if (json.result == 0 || json.result == "0") {
                if(confirm("로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?")) {
					location.href = contextPath + "/login.sp";
                }
            } 
            else if (json.result == 1 || json.result == "1") {
                if (confirm("장바구니에 담겼습니다. 장바구니로 이동하시겠습니까?")) {
                    location.href = contextPath + "/product/cartList.sp";
                }
            }
			else {
                alert(json.message || "오류가 발생했습니다.");
            }
        },
		error: function(request, status, error) {
            console.log("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
            alert("서버 통신 중 오류가 발생했습니다.");
        }
    });
}

function updateQty(cart_id, change, ctxPath) {

    const $row = $("input[value='" + cart_id + "']").closest("tr");
    const $qtyInput = $row.find(".qty-input");
    let currentQty = parseInt($qtyInput.val());

    $.ajax({
        url: ctxPath + "/product/cartUpdateQty.sp",
        type: "POST",
        data: { "cart_id": cart_id, "change": change },
        dataType: "json",
        success: function(json) {
            if(json.result == 1) {

                let newQty = currentQty + parseInt(change);
                $qtyInput.val(newQty); 

                const unitPrice = parseInt($row.find(".chk").data("unit-price"));
                const newRowTotal = unitPrice * newQty;
                
                $row.find("td:eq(5)").html(newRowTotal.toLocaleString() + "원");
                
                $row.find(".chk").attr("data-price", newRowTotal);
                
                calculateTotal();
                
            } else {
                alert(json.message || "수량 변경이 불가능합니다.");
            }
        },
        error: function() {
            alert("서버 통신 오류가 발생했습니다.");
        }
    });
}

function deleteCart(cartId, contextPath) {
    
    if(confirm("정말로 장바구니에서 삭제하시겠습니까?")) {
        $.ajax({
            url: contextPath + "/product/cartDelete.sp",
            type: "POST",
            data: { "cart_id": cartId },
            dataType: "JSON",
            success: function(json) {
                if(json.result == 1) {
                    location.reload(); // 삭제 성공 시 새로고침
                } else {
                    alert("삭제에 실패하였습니다.");
                }
            },
            error: function() {
                alert("서버 통신 중 오류가 발생했습니다.");
            }
        });
    }
}
