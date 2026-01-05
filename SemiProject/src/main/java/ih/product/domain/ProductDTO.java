package ih.product.domain;

public class ProductDTO {
    
    private int product_id;             // 상품아이디
    private int fk_category_id;         // 카테고리번호
    private String product_name;        // 상품명
    private int sale_price;             // 판매가
    private int list_price;             // 정가
    private int stock;                  // 재고
    private int fk_spec_id;             // 스펙번호(HIT, NEW 등)
    private String product_description; // 상세설명 (CLOB)
    private String stock_date;          // 입고일자
    private int point;                  // 포인트
    
    // 조인해서 가져올 데이터
    private String pimage;              // 상품 이미지 파일명
    private String category_name;       // 카테고리 이름 
    private String spec_name;           // 스텍 이름
    private int is_wish;                // DB에서 가져온 찜하기 상태 변수
    // ------------------------------------------------ // 
    
    // Getter & Setter
	public int getProduct_id() {
		return product_id;
	}

	public void setProduct_id(int product_id) {
		this.product_id = product_id;
	}

	public int getFk_category_id() {
		return fk_category_id;
	}

	public void setFk_category_id(int fk_category_id) {
		this.fk_category_id = fk_category_id;
	}

	public String getProduct_name() {
		return product_name;
	}

	public void setProduct_name(String product_name) {
		this.product_name = product_name;
	}

	public int getSale_price() {
		return sale_price;
	}

	public void setSale_price(int sale_price) {
		this.sale_price = sale_price;
	}

	public int getList_price() {
		return list_price;
	}

	public void setList_price(int list_price) {
		this.list_price = list_price;
	}

	public int getStock() {
		return stock;
	}

	public void setStock(int stock) {
		this.stock = stock;
	}

	public int getFk_spec_id() {
		return fk_spec_id;
	}

	public void setFk_spec_id(int fk_spec_id) {
		this.fk_spec_id = fk_spec_id;
	}

	public String getProduct_description() {
		return product_description;
	}

	public void setProduct_description(String product_description) {
		this.product_description = product_description;
	}

	public String getStock_date() {
		return stock_date;
	}

	public void setStock_date(String stock_date) {
		this.stock_date = stock_date;
	}

	public int getPoint() {
		return point;
	}

	public void setPoint(int point) {
		this.point = point;
	}

	public String getPimage() {
		return pimage;
	}

	public void setPimage(String pimage) {
		this.pimage = pimage;
	}

	public String getCategory_name() {
		return category_name;
	}

	public void setCategory_name(String category_name) {
		this.category_name = category_name;
	}

	public String getSpec_name() {
		return spec_name;
	}

	public void setSpec_name(String spec_name) {
		this.spec_name = spec_name;
	}

	public int getIs_wish() {
		return is_wish;
	}

	public void setIs_wish(int is_wish) {
		this.is_wish = is_wish;
	}

    
}