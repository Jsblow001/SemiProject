$(document).ready(function() {
    const ctxPath = $("#ctxPath").val();

    // 배송 상태 변경 (Select Box)
    $(".status-select").on("focus", function() {

        $(this).data("originStatus", $(this).val()); 
    }).on("change", function(e) {
        const $this = $(this);
        const orderNo = $this.data("order-no");
        const newStatus = $this.val();
        const oldStatus = $this.data("originStatus");

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
                        $this.closest("tr").fadeOut(100).fadeIn(100);
                        $this.data("originStatus", newStatus); // 원본 값 갱신
                    } else {
                        alert("상태 변경에 실패했습니다.");
                        $this.val(oldStatus); 
                    }
                },
                error: function() {
                    alert("서버 통신 오류가 발생했습니다.");
                    $this.val(oldStatus); 
                },
                complete: function() {
                    $this.prop("disabled", false);
                }
            });
        } else {
            $this.val(oldStatus); 
        }
    });
});

// 주문 상세 이동 (행 클릭 시 호출)
function goOrderDetail(odrcode) {
    const ctxPath = $("#ctxPath").val();
    location.href = ctxPath + "/admin/adminOrderDetail.sp?odrcode=" + odrcode;
}