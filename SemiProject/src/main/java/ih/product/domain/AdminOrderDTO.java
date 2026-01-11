package ih.product.domain;

public class AdminOrderDTO {
    
    private String odrcode;    // 주문번호
    private String fk_userid;  // 회원아이디
    private String name;       // 회원명 (JOIN으로 가져올 것)
    private String pName;      // 상품명 (JOIN으로 가져올 것)
    private int totalprice;    // 총주문금액
    private String odrdate;    // 주문일자
    private int delivery_status; // 배송상태 (1:결제완료, 2:배송중, 3:배송완료 등)
    
    // ---------------------------------------- //
    
    private String mobile;
    private String email;
    private String postcode;
    private String address;
    private String detailaddress;
    private int odrtotalprice;
    private int odrtotalpoint;
    private int payment_status;
    private String grade_name; // 등급명
    private int odrdetailno;   // 상세번호
    private String pname;      // 상품명
    private String pimage;     // 상품이미지
    private int odrqty;        // 수량
    private int odrprice;      // 단가
    private int deliverystatus; // 배송상태
    
    
    // Getter, Setter
    public String getOdrcode() {
		return odrcode;
	}
	public void setOdrcode(String odrcode) {
		this.odrcode = odrcode;
	}
	public String getFk_userid() {
		return fk_userid;
	}
	public void setFk_userid(String fk_userid) {
		this.fk_userid = fk_userid;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getpName() {
		return pName;
	}
	public void setpName(String pName) {
		this.pName = pName;
	}
	public int getTotalprice() {
		return totalprice;
	}
	public void setTotalprice(int totalprice) {
		this.totalprice = totalprice;
	}
	public String getOdrdate() {
		return odrdate;
	}
	public void setOdrdate(String odrdate) {
		this.odrdate = odrdate;
	}
	public int getDelivery_status() {
		return delivery_status;
	}
	public void setDelivery_status(int delivery_status) {
		this.delivery_status = delivery_status;
	}
	public String getMobile() {
		return mobile;
	}
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
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
	public int getOdrtotalprice() {
		return odrtotalprice;
	}
	public void setOdrtotalprice(int odrtotalprice) {
		this.odrtotalprice = odrtotalprice;
	}
	public int getOdrtotalpoint() {
		return odrtotalpoint;
	}
	public void setOdrtotalpoint(int odrtotalpoint) {
		this.odrtotalpoint = odrtotalpoint;
	}
	public int getPayment_status() {
		return payment_status;
	}
	public void setPayment_status(int payment_status) {
		this.payment_status = payment_status;
	}
	public String getGrade_name() {
		return grade_name;
	}
	public void setGrade_name(String grade_name) {
		this.grade_name = grade_name;
	}
	public int getOdrdetailno() {
		return odrdetailno;
	}
	public void setOdrdetailno(int odrdetailno) {
		this.odrdetailno = odrdetailno;
	}
	public String getPname() {
		return pname;
	}
	public void setPname(String pname) {
		this.pname = pname;
	}
	public String getPimage() {
		return pimage;
	}
	public void setPimage(String pimage) {
		this.pimage = pimage;
	}
	public int getOdrqty() {
		return odrqty;
	}
	public void setOdrqty(int odrqty) {
		this.odrqty = odrqty;
	}
	public int getOdrprice() {
		return odrprice;
	}
	public void setOdrprice(int odrprice) {
		this.odrprice = odrprice;
	}
	public int getDeliverystatus() {
		return deliverystatus;
	}
	public void setDeliverystatus(int deliverystatus) {
		this.deliverystatus = deliverystatus;
	}
	
	


}