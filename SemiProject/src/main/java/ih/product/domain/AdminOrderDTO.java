package ih.product.domain;

public class AdminOrderDTO {
    
    private String odrcode;    // 주문번호
    private String fk_userid;  // 회원아이디
    private String name;       // 회원명 (JOIN으로 가져올 것)
    private String pName;      // 상품명 (JOIN으로 가져올 것)
    private int totalprice;    // 총주문금액
    private String odrdate;    // 주문일자
    private int delivery_status; // 배송상태 (1:결제완료, 2:배송중, 3:배송완료 등)
	
    
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


}