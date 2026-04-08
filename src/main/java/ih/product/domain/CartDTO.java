package ih.product.domain;


public class CartDTO  {
	private int cart_id;
    private String fk_member_id;
    private int fk_product_id;
    private int cart_qty;
    private String cart_date;

    private ProductDTO pdto;

    
	public int getCart_id() {
		return cart_id;
	}

	public void setCart_id(int cart_id) {
		this.cart_id = cart_id;
	}

	public String getFk_member_id() {
		return fk_member_id;
	}

	public void setFk_member_id(String fk_member_id) {
		this.fk_member_id = fk_member_id;
	}

	public int getFk_product_id() {
		return fk_product_id;
	}

	public void setFk_product_id(int fk_product_id) {
		this.fk_product_id = fk_product_id;
	}

	public int getCart_qty() {
		return cart_qty;
	}

	public void setCart_qty(int cart_qty) {
		this.cart_qty = cart_qty;
	}

	public String getCart_date() {
		return cart_date;
	}

	public void setCart_date(String cart_date) {
		this.cart_date = cart_date;
	}

	public ProductDTO getPdto() {
		return pdto;
	}

	public void setPdto(ProductDTO pdto) {
		this.pdto = pdto;
	}
    
    

}
