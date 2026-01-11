$(document).ready(function() {

    let originStatus = "";

    $(".status-select").on("focus", function() {
        originStatus = $(this).val(); // 클릭시 값을 저장
    }).on("change", function() {
        const $this = $(this);
        const orderNo = $this.data("order-no");
        const newStatus = $this.val();
        const ctxPath = $("#ctxPath").val(); 

        if(confirm("주문번호 [" + orderNo + "]의 상태를 변경하시겠습니까?")) {

            $this.prop("disabled", true);

            $.ajax({
                url: ctxPath + "/admin/updateOrderStatus.sp",
                type: "POST",
                data: {
                    "orderNo": orderNo,
                    "status": newStatus
                },
                dataType: "json",
                success: function(json) {
                    if(json.result == 1) {
                        alert("성공적으로 변경되었습니다.");

                        $this.closest("tr").fadeOut(200).fadeIn(200);
                        originStatus = newStatus;
                    } else {
                        alert("상태 변경에 실패했습니다.");
                        $this.val(originStatus); 
                    }
                },
                error: function() {
                    alert("서버 통신 오류가 발생했습니다.");
                    $this.val(originStatus); 
                },
                complete: function() {
                    $this.prop("disabled", false);
                }
            });
        } else {

            $this.val(originStatus);
        }
    });

    // 주문 상세 보기 버튼
    $(".btn-order-detail").on("click", function() {
        const orderNo = $(this).val();
        const ctxPath = $("#ctxPath").val();
        
        location.href = ctxPath + "/admin/orderDetail.sp?orderNo=" + orderNo;
    });
});