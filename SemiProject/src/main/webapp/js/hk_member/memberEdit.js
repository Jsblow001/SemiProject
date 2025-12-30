/*
-- js --
window.onload = function(){};

-- jquery --
$(document).ready(function(){});*/

// 우편번호 찾기 클릭
let b_zipcodeSearch_click = false; // *** 우편번호 찾기 클릭했는지 여부를 알아오기 위한 용도

// 아이디 중복확인 클릭
let b_idCheck_click = false; // ***아이디 중복확인를 클릭했는지 여부를 알아오기 위한 용도

// 이메일 중복확인 클릭
let b_emailCheck_click = false; // ***이메일 중복확인를 클릭했는지 여부를 알아오기 위한 용도

// 유효성 검사
$(function(){
	$('span.error').hide(); // memberRegister.jsp 내 스팬태그.클래스명 error 인거 잡아서
	$('input:text[id="name"]').focus();
	// 또는 $('input#name').focus();
			
	// 성명
	// 또는 $('input:text[id="name"]').bind('blur', function(e){});
	// 또는 $('input:text[id="name"]').blur(function(e){});
	// $('input:text[id="name"]').blur((e)=>{ alert('name에 있던 포커스를 잃어버렸습니다.');}); // 탭키나 클릭하면 포커스 잃는 거
	$('input:text[id="name"]').blur((e)=>{ // 탭키나 클릭하면
		const name = $(e.target).val().trim();
		
		if(name == "") {
			// 이름을 입력하지 않거나 공백만 입력했을 경우
			$('table#tblMemberEdit :input').prop("disabled",true); // 모든 인풋태그 입력 못하게 막음
			$(e.target).prop("disabled",false).val("").focus(); // 얘빼고 (name)
			
			// $(e.target).next().show();  // $(e.target).next() --> 형제 태그 : span class="error"
			// 또는
			$(e.target).parent().find('span.error').show(); //  $(e.target).parent() --> <td>
		}
		else {
			// 공백이 아닌 문자 입력하는 경우
			$('table#tblMemberEdit :input').prop("disabled",false);  
			
			// $(e.target).next().show();  // $(e.target).next() --> 형제 태그 : span class="error"
			// 또는
			$(e.target).parent().find('span.error').hide(); //  $(e.target).parent() --> <td>    						
		}
	}); // end of 아이디가 name 인 것에 포커스를 잃어버렸을 경우(blur) 이벤트 처리를 해주는 것
	
	
	// 비밀번호
	$('input#pwd').blur((e)=>{      
	      const regExp_pwd = /^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g;
	      // 숫자/문자/특수문자 포함 형태의 8~15자리 이내의 암호 정규표현식 객체 생성
	      
	      const bool = regExp_pwd.test($(e.target).val());
	            
	      if(!bool) {
	         // 암호가 정규표현식에 위배된 경우
	         
	         $('table#tblMemberEdit :input').prop("disabled", true);
	         $(e.target).prop("disabled", false).val("").focus();
	         
	      // $(e.target).next().show();
	      // 또는
	         $(e.target).parent().find('span.error').show();
	      } 
	      else {
	         // 암호가 정규표현식에 맞는 경우
	         $('table#tblMemberEdit :input').prop("disabled", false);
	        
	       // $(e.target).next().hide();
	       // 또는     
	         $(e.target).parent().find('span.error').hide();
	      }
	      
	   });// end of 아이디가 pwd 인 것에 포커스를 잃어버렸을 경우(blur) 이벤트 처리를 해주는 것
	   
	   
   // 비밀번호 확인
   $('input#pwdcheck').blur((e)=>{
	
	  if($('input#pwd').val() != $(e.target).val()) { // 암호와 암호확인 같은 경우		
		  $('table#tblMemberEdit :input').prop("disabled", true);
		  $('input#pwd').prop("disabled", false).val("").focus();
		  $(e.target).prop("disabled", false).val("");
	  }
	
      else { 
         $(e.target).parent().find('span.error').hide();
      
      }
   });// end of 아이디가 pwd 인 것에 포커스를 잃어버렸을 경우(blur) 이벤트 처리를 해주는 것
   
   
   // 이메일
   	$('input#email').blur((e)=>{      
   	      const regExp_email = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i; 
   	      // 숫자/문자/특수문자 포함 형태의 8~15자리 이내의 암호 정규표현식 객체 생성
   	      
   	      const bool = regExp_email.test($(e.target).val());
   	            
   	      if(!bool) {
   	         // 이메일이 정규표현식에 위배된 경우
   	         
   	         $('table#tblMemberEdit :input').prop("disabled", true);
   	         $(e.target).prop("disabled", false).val("").focus();
   	         
   	      // $(e.target).next().show();
   	      // 또는
   	         $(e.target).parent().find('span.error').show();
   	      } 
   	      else {
   	         // 이메일이 정규표현식에 맞는 경우
   	         $('table#tblMemberEdit :input').prop("disabled", false);
   	        
   	       // $(e.target).next().hide();
   	       // 또는     
   	         $(e.target).parent().find('span.error').hide();
   	      }
   	      
   	   });// end of 아이디가 email 인 것에 포커스를 잃어버렸을 경우(blur) 이벤트 처리를 해주는 것
	   
	   
    // 연락처1
  	$('input#hp2').blur((e)=>{      
  	      const regExp_hp2 = /^[1-9][0-9]{3}$/; 
  	      // 연락처 국번(숫자 4자리인데 첫번째 숫자는 1-9 이고 나머지는 0-9) 정규표현식 객체 생성
  	      
  	      const bool = regExp_hp2.test($(e.target).val());
  	            
  	      if(!bool) {
  	         // 연락처 국번이 정규표현식에 위배된 경우
  	         
  	         $('table#tblMemberEdit :input').prop("disabled", true);
  	         $(e.target).prop("disabled", false).val("").focus();
  	         
  	      // $(e.target).next().show();
  	      // 또는
  	         $(e.target).parent().find('span.error').show();
  	      } 
  	      else {
  	         // 연락처 국번이 정규표현식에 맞는 경우
  	         $('table#tblMemberEdit :input').prop("disabled", false);
  	        
  	       // $(e.target).next().hide();
  	       // 또는     
  	         $(e.target).parent().find('span.error').hide();
  	      }
  	      
  	   });// end of 아이디가 hp2 인 것에 포커스를 잃어버렸을 경우(blur) 이벤트 처리를 해주는 것
		   
		
	    // 연락처2
     	$('input#hp3').blur((e)=>{      
     	      const regExp_hp3 = /^[0-9]{4}$/; 
			  // 또는
			  // const regExp_hp3 = /^d{4}$/;
     	      // 연락처 마지막 4자리(숫자만 되어야 함) 정규표현식 객체 생성
     	      
     	      const bool = regExp_hp3.test($(e.target).val());
     	            
     	      if(!bool) {
     	         // 마지막 전화번호 4자리가 정규표현식에 위배된 경우
     	         
     	         $('table#tblMemberEdit :input').prop("disabled", true);
     	         $(e.target).prop("disabled", false).val("").focus();
     	         
     	      // $(e.target).next().show();
     	      // 또는
     	         $(e.target).parent().find('span.error').show();
     	      } 
     	      else {
     	         // 마지막 전화번호 4자리이 정규표현식에 맞는 경우
     	         $('table#tblMemberEdit :input').prop("disabled", false);
     	        
     	       // $(e.target).next().hide();
     	       // 또는     
     	         $(e.target).parent().find('span.error').hide();
     	      }
     	      
     	   });// end of 아이디가 hp3 인 것에 포커스를 잃어버렸을 경우(blur) 이벤트 처리를 해주는 것   
			   
			   
	   // 우편번호
/*    	$('input#postcode').blur((e)=>{      
    	      const regExp_postcode = /^[0-9]{5}$/; 
			  // 또는
			  // const regExp_postcode = /^d{5}$/;
    	      // 숫자 5자리만 들어오도록 검사해주는 정규표현식 객체 생성
    	      
    	      const bool = regExp_postcode.test($(e.target).val());
    	            
    	      if(!bool) {
    	         // 우편번호가 정규표현식에 위배된 경우
    	         
    	         $('table#tblMemberRegister :input').prop("disabled", true);
    	         $(e.target).prop("disabled", false).val("").focus();
    	         
    	      // $(e.target).next().show();
    	      // 또는
    	         $(e.target).parent().find('span.error').show();
    	      } 
    	      else {
    	         // 우편번호가 정규표현식에 맞는 경우
    	         $('table#tblMemberRegister :input').prop("disabled", false);
    	        
    	       // $(e.target).next().hide();
    	       // 또는     
    	         $(e.target).parent().find('span.error').hide();
    	      }
    	      
    	   });// end of 아이디가 postcode 인 것에 포커스를 잃어버렸을 경우(blur) 이벤트 처리를 해주는 것 
		   
		   */
		   // ================================================= //
		   /*   
               >>>> .prop() 와 .attr() 의 차이 <<<<            
                    .prop() ==> form 태그내에 사용되어지는 엘리먼트의 disabled, selected, checked 의 속성값 확인 또는 변경하는 경우에 사용함. 
                    .attr() ==> 그 나머지 엘리먼트의 속성값 확인 또는 변경하는 경우에 사용함.
           */
		   // 우편번호를 읽기전용(readonly)로 만들기
		   $('input#postcode').attr('readonly', true);
		   
		   // 주소를 읽기전용(readonly)로 만들기
		   $('input#address').attr('readonly', true);
		   
		   // 참고항목을 읽기전용(readonly)로 만들기
		   $('input#extraAddress').attr('readonly', true);
		   
		   
		   // ===== "우편번호찾기"를 클릭했을 때 이벤트 처리하기 시작 ====== //
		    /*	
		   	$('img#zipcodeSearch').bind('click', function(){});
		   	$('img#zipcodeSearch').click(function(){});
		   	$('img#zipcodeSearch').click(()=>{});
		    */
		   	$('img#zipcodeSearch').click(()=>{
				b_zipcodeSearch_click = true; // *** "우편번호 찾기"를 클릭했다는 뜻이다.
		   		new daum.Postcode({
		               oncomplete: function(data) {
		                   // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
		       
		                   // 각 주소의 노출 규칙에 따라 주소를 조합한다.
		                   // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
		                   let addr = ''; // 주소 변수
		                   let extraAddr = ''; // 참고항목 변수
		       
		                   //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
		                   if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
		                       addr = data.roadAddress;
		                   } else { // 사용자가 지번 주소를 선택했을 경우(J)
		                       addr = data.jibunAddress;
		                   }
		       
		                   // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
		                   if(data.userSelectedType === 'R'){
		                       // 법정동명이 있을 경우 추가한다. (법정리는 제외)
		                       // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
		                       if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
		                           extraAddr += data.bname;
		                       }
		                       // 건물명이 있고, 공동주택일 경우 추가한다.
		                       if(data.buildingName !== '' && data.apartment === 'Y'){
		                           extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
		                       }
		                       // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
		                       if(extraAddr !== ''){
		                           extraAddr = ' (' + extraAddr + ')';
		                       }
		                       // 조합된 참고항목을 해당 필드에 넣는다.
		                       document.getElementById("extraAddress").value = extraAddr;
		                   
		                   } else {
		                       document.getElementById("extraAddress").value = '';
		                   }
		       
		                   // 우편번호와 주소 정보를 해당 필드에 넣는다.
		                   document.getElementById('postcode').value = data.zonecode;
		                   document.getElementById("address").value = addr;
		                   // 커서를 상세주소 필드로 이동한다.
		                   document.getElementById("detailAddress").focus();
		               }
		           }).open();	
				   
				  // === 참고 === 
				  // 주소를 비활성화로 만들기
				  // $('input#address').prop('disabled', true);
				   	
				  // 주소를 쓰기 가능으로 만들기
				  // $('input#address').removeAttr('readonly');
				  
				  // 주소를 활성화로 만들기
	  			  // $('input#address').removeAttr('disabled');
				  
				  // 주소를 읽기전용(readonly)로 만들기
		  		  // $('input#address').attr('readonly', true);
				  
		   	});
		   	// ===== "우편번호찾기"를 클릭했을 때 이벤트 처리하기 끝 ====== //

		   
			
		// ================================================================= //
	
		// 이메일 값이 변경되면 가입하기 버튼을 클릭시 "이메일중복확인" 을 클릭했는지 알아보기 위한 용도 초기화 시키기 //
		$('input#email').bind("change", function(){
			b_emailCheck_click = false; // 초기화
		});
		
		
		// "이메일중복확인" 을 클릭했을 때 이벤트 처리하기 시작 //
				$('span#emailcheck').click(function(){
					b_emailCheck_click = true;
					
					// + 추가
				  	if($('input#userid').val().trim() != "") {}
					
					// ==== jQuery Ajax 를 사용한 두 번째 방법(이메일) ==== //
					$.ajax({
						url:"emailDuplicateCheck2.up",
						data:{"email":$('input#email').val(),
							  "userid":$('input:text[name="userid"]').val()  // 내 아이디 빼고 나머지를 검사해야하므로 이부분 추가
						}, // emailduplicatecheck.java 내의 getparameter로 온 값(email) 및 변수명 : jsp 내 인풋태그 // data 속성은 http://localhost:9090/MyMVC/member/idDuplicateCheck.up 로 전송해야할 데이터를 말한다.
						type:"post", // method:"post" 아님. type 을 생략하면 GET 이다.
						async:true,  // async:true 가 비동기 방식을 말한다. async 을 생략하면 기본값이 비동기 방식인 async:true 이다.
					                 // async:false 가 동기 방식이다. 지도를 할때는 반드시 동기방식인 async:false 을 사용해야만 지도가 올바르게 나온다.
						
						dataType: "json", // datatype 아님. // *** String 이 아니라 처음부터 객체로!!						
						// Javascript Standard Object Notation.  dataType은 /MyMVC/member/emailDuplicateCheck.up 로 부터 실행되어진 결과물을 받아오는 데이터타입을 말한다. 
                        // 만약에 dataType:"xml" 으로 해주면 /MyMVC/member/emailDuplicateCheck.up 로 부터 받아오는 결과물은 xml 형식이어야 한다. 
                        // 만약에 dataType:"json" 으로 해주면 /MyMVC/member/emailDuplicateCheck.up 로 부터 받아오는 결과물은 json 형식이어야 한다.
									 
						success:function(json) {
							 //console.log("확인용 json =>", json); 
							// 확인용 json => {"isExists":true}
							
							//console.log("확인용 json 의 데이터타입 => ", typeof json);
							// 확인용 json 의 데이터타입 => object						
								
							if(json.isExists){ // json.키	
								// 입력한 userid 가 있으면 (true)
								$('span#emailCheckResult').html($('input#email').val() + "은 현재 다른 사용자가 사용 중이므로 다른 이메일을 사용하시기 바랍니다! ").css({"color":"red"});
								$('input#email').val("");
							}
							else {
								// 입력한 userid 가 없으면 (false), db상에 존재하지 않는다면
								$('span#emailCheckResult').html($('input#email').val() + "은 사용 가능 합니다! ").css({"color":"green"});
							}
						},
						error:function(request, status, error){
			                alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			            }
								
					 });
					
				}); // 이메일 중복확인 끝
		
}); // end of $(function(){} -----------------------------



// Function Declaration
// "수정하기" 버튼 클릭시 호출되는 함수
function goEdit() {
	
	// *** 필수입력사항에 모두 입력이 되었는지 검사하기 시작 *** //
	let b_requiredInfo = true;
	
	// 첫 번째 방법(JavaScript)
	/* const requiredInfo = document.querySelectorAll("input.requiredInfo"); // 유사배열 (인풋태그)
	for(let i=0; i<requiredInfo.length; i++) {
		const val = requiredInfo[i].value.trim();
		
		if(!val) {
			alert("*표시된 필수입력사항은 모두 입력하셔야 합니다.");
			b_requiredInfo = false;
			break;
		}
	} // end of for ------------------------------
	
	if(!b_requiredInfo) { // 입력 안했을 시
		return; // 함수 종료.
	}
	*/
	
	// 두 번째 방법(JQuery)
	// 또는 $('input.requiredInfo').each((index, elmt)=>{});
	$('input.requiredInfo').each(function(index, elmt){ /* javascript 에서는 elmt, index 순서임. 반대 순서 */
		const val = $(elmt).val().trim();
	
		if(val == "") {
			alert("*표시된 필수입력사항은 모두 입력하셔야 합니다.");
			b_requiredInfo = false;
			return false; // break; 와 같은 의미이다.
		}
	
	});
	
	if(!b_requiredInfo) { // 입력 안했을 시
			return; // 함수 종료 (goEdit)
	}
	// *** 필수입력사항에 모두 입력이 되었는지 검사하기 끝 *** //
	
	
	// *** 이메일중복확인 클했는지 확인하기 *** //
		if(!b_emailCheck_click) { // false 이면 (이메일 중복확인 클릭 안했으면)
			alert("이메일 중복확인을 클릭하셔야 합니다.");
			return; // 함수 종료 (goEdit)
		}
	
	
	// *** "우편번호찾기"를 클릭했는지 알아보기 *** //
	if(!b_zipcodeSearch_click) { // false 이면(우편번호 찾기 클릭 안했으면)
		alert("우편번호 찾기를 클릭하셔야 합니다.");
		return; // 함수 종료 (goEdit)
	}
	else { // 클릭 했을 때
		if($('input#postcode').val().trim() == "" ||
		   $('input#address').val().trim() == "" ||
	       $('input#detailAddress').val().trim() == "") {
				alert("우편번호 및 주소를 입력하셔야 합니다.");
				return;
		   }
	}
	
	
	// ----------------------------------------------------------- //
	// 변경된 암호가 현재 사용중인 암호이라면 현재 사용중인 암호가 아닌 새로운 암호로 입력해야 한다.!!! 
	let isNewPwd = true;
	
	// ==== jQuery Ajax 를 사용한 방법 ==== //
	$.ajax({
		url:"pwdDuplicateCheck.up",
		data:{"new_pwd":$('input:password[name="pwd"]').val(),
			  "userid":$('input:text[name="userid"]').val()  // 내 아이디 빼고 나머지를 검사해야하므로 이부분 추가
		}, // emailduplicatecheck.java 내의 getparameter로 온 값(email) 및 변수명 : jsp 내 인풋태그 // data 속성은 http://localhost:9090/MyMVC/member/pwdDuplicateCheck.up 로 전송해야할 데이터를 말한다.
		type:"post", // method:"post" 아님. type 을 생략하면 GET 이다.
		async:false,  //!!!!! 반드시 비동기방식이어야 한다 !!!!!!!!!!
	                 // async:false 가 동기 방식이다. 지도를 할때는 반드시 동기방식인 async:false 을 사용해야만 지도가 올바르게 나온다.
		
		dataType: "json", // datatype 아님. // *** String 이 아니라 처음부터 객체로!!						
		// Javascript Standard Object Notation.  dataType은 /MyMVC/member/emailDuplicateCheck.up 로 부터 실행되어진 결과물을 받아오는 데이터타입을 말한다. 
        // 만약에 dataType:"xml" 으로 해주면 /MyMVC/member/emailDuplicateCheck.up 로 부터 받아오는 결과물은 xml 형식이어야 한다. 
        // 만약에 dataType:"json" 으로 해주면 /MyMVC/member/emailDuplicateCheck.up 로 부터 받아오는 결과물은 json 형식이어야 한다.
					 
		success:function(json) {
			// json ==> {"isExists" : true}       또는    {"isExists" : false} 
			//          새암호가 기존암호와 동일한 경우          새암호가 기존암호와 다른 경우						
				
			if(json.isExists){ // json.키	
				// 새암호가 기존암호와 동일한 경우
				$('span#duplicate_pwd').html($('input#email').val() + "현재 사용중인 비밀번호로 비밀번호 변경은 불가합니다.").css({"color":"red"});
				isNewPwd = false;
			}
			
		},
		error:function(request, status, error){
            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
        }
				
	 });
						
	
	 // ----------------------------------------------------------- //
	// 폼태그에 입력한 데이터 전송하기
	if(isNewPwd) { // 새 암호가 기존암호와 다른 경우
		alert("db에 사용자를 수정하러 간다.");
		const frm = document.editFrm;
		frm.action = "memberEditEnd.up"; 
		frm.method = "post";
		frm.submit();
	}
	
} // end of function goEdit() {} -----------------------------


