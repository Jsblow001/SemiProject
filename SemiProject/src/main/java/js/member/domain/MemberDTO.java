package js.member.domain;

public class MemberDTO {
    private String member_id;   		// 회원아이디
    private String name;        		// 성명
    private String passwd;      		// 비밀번호
    private String email;       		// 이메일
    private String mobile;      		// 연락처
    private String postcode;    		// 우편번호
    private String address;     		// 주소
    private String detailaddress;	// 상세주소
    private String extraaddress;		// 주소참고항목
    private String gender;      		// 성별 (1:남, 2:여)
    private String birthday;    		// 생년월일
    private int point;          		// 포인트
    private String registerday; 		// 가입일자
    private int status;         		// 회원상태 (1:사용, 0:탈퇴)
    private String grade_code;  		// 등급코드
    
    
	public String getMember_id() {
		return member_id;
	}
	
	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}
	
	public String getName() {
		return name;
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
	public String getPasswd() {
		return passwd;
	}
	
	public void setPasswd(String passwd) {
		this.passwd = passwd;
	}
	
	public String getEmail() {
		return email;
	}
	
	public void setEmail(String email) {
		this.email = email;
	}
	
	public String getMobile() {
		return mobile;
	}
	
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	
	public String getPostcode() {
		return postcode;
	}
	
	public void setPostcode(String postcode) {
		this.postcode = postcode;
	}
	
	public String getAddress() {
	 	return address;
	}
	
	public void setAddress(String address) {
		this.address = address;
	}
	
	public String getDetailaddress() {
		return detailaddress;
	}
	
	public void setDetailaddress(String detailaddress) {
		this.detailaddress = detailaddress;
	}
	
	public String getExtraaddress() {
		return extraaddress;
	}
	
	public void setExtraaddress(String extraaddress) {
		this.extraaddress = extraaddress;
	}
	
	public String getGender() {
		return gender;
	}
	
	public void setGender(String gender) {
		this.gender = gender;
	}
	
	public String getBirthday() {
		return birthday;
	}
	
	public void setBirthday(String birthday) {
		this.birthday = birthday;
	}
	
	public int getPoint() {
		return point;
	}
	
	public void setPoint(int point) {
		this.point = point;
	}
	
	public String getRegisterday() {
		return registerday;
	}
	
	public void setRegisterday(String registerday) {
		this.registerday = registerday;
	}
	
	public int getStatus() {
		return status;
	}
	
	public void setStatus(int status) {
		this.status = status;
	}
	
	public String getGrade_code() {
		return grade_code;
	}
	
	public void setGrade_code(String grade_code) {
		this.grade_code = grade_code;
	}

	
}