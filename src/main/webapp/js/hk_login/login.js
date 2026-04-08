$(function(){

    // === localStorage 아이디 불러오기 ===
    const savedId = localStorage.getItem("saveid");
    if(savedId) {
        $("#userid").val(savedId);
        $("#saveid").prop("checked", true);
    }

    // === 로그인 버튼 클릭 ===
    $("#btnLogin").on("click", function(){
        if($("#userid").val().trim() === "") {
            alert("아이디를 입력하세요.");
            $("#userid").focus();
            return;
        }

        if($("#pwd").val().trim() === "") {
            alert("비밀번호를 입력하세요.");
            $("#pwd").focus();
            return;
        }

        // 아이디 저장
        if($("#saveid").is(":checked")) {
            localStorage.setItem("saveid", $("#userid").val());
        } else {
            localStorage.removeItem("saveid");
        }

        document.loginFrm.submit();
    });

    // === 엔터 로그인 ===
    $("#pwd").on("keydown", function(e){
        if(e.keyCode === 13) {
            $("#btnLogin").click();
        }
    });
});
