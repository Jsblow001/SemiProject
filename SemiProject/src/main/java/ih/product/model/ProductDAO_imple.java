package ih.product.model;

import java.sql.*;
import java.util.*;
import javax.naming.*;
import javax.sql.DataSource;

import ih.product.domain.CartDTO;
import ih.product.domain.ProductDTO;

public class ProductDAO_imple implements ProductDAO {

    private DataSource ds; 
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    // 생성자 (커넥션 풀 설정)
    public ProductDAO_imple() {
        try {
            Context initContext = new InitialContext();
            Context envContext  = (Context)initContext.lookup("java:/comp/env");
            ds = (DataSource)envContext.lookup("SemiProject"); // context.xml의 name과 일치해야 함
        } catch (NamingException e) {
            e.printStackTrace();
        }
    }

    // 자원 반납 메소드
    private void close() {
        try {
            if(rs != null)    {rs.close(); rs=null;}
            if(pstmt != null) {pstmt.close(); pstmt=null;}
            if(conn != null)  {conn.close(); conn=null;}
        } catch(SQLException e) {
            e.printStackTrace();
        }
    }

    // 카테고리 번호를 받아 해당 카테고리 상품만 조회
    @Override
    public List<ProductDTO> selectProductByCategory(String categoryId, String userid) throws SQLException {
        
        List<ProductDTO> productList = new ArrayList<>();
        
        try {
            conn = ds.getConnection();
            
            String sql = " SELECT product_id, product_name, pimage, sale_price, list_price, stock, fk_category_id, "
            		   + " (SELECT count(*) FROM tbl_wishlist WHERE product_id = P.product_id AND member_id = ?) AS is_wish "
            		   + " FROM tbl_product P "
                       + " WHERE fk_category_id = ? " // 카테고리 필터링
                       + " ORDER BY product_id DESC ";
            
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, userid); 
            pstmt.setInt(2, Integer.parseInt(categoryId)); 
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                ProductDTO pdto = new ProductDTO();
                pdto.setProduct_id(rs.getInt("product_id"));
                pdto.setProduct_name(rs.getString("product_name"));
                pdto.setPimage(rs.getString("pimage"));
                pdto.setSale_price(rs.getInt("sale_price"));
                pdto.setList_price(rs.getInt("list_price"));
                pdto.setStock(rs.getInt("stock"));
                pdto.setFk_category_id(rs.getInt("fk_category_id"));
                pdto.setIs_wish(rs.getInt("is_wish"));
                productList.add(pdto);
            }
        } finally {
            close();
        }
        return productList;
    }

    // 상품 상세 정보 조회
    @Override
    public ProductDTO selectOneProduct(String productId, String userid) throws SQLException {
        ProductDTO pdto = null;
        try {
            conn = ds.getConnection();
            
            String sql = " SELECT P.*,"
            		   + " (SELECT count(*) FROM tbl_wishlist WHERE product_id = P.product_id AND member_id = ?) AS is_wish "
            		   + " FROM tbl_product P "
            		   + " WHERE P.product_id = ? ";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userid); // String으로 받아도 DB가 숫자로 자동 변환 .
            pstmt.setString(2, productId);
            
            rs = pstmt.executeQuery();
            
            if(rs.next()) {
                pdto = new ProductDTO();
                pdto.setProduct_id(rs.getInt("product_id"));
                pdto.setProduct_name(rs.getString("product_name"));
                pdto.setFk_category_id(rs.getInt("fk_category_id"));
                pdto.setSale_price(rs.getInt("sale_price"));
                pdto.setList_price(rs.getInt("list_price"));
                pdto.setStock(rs.getInt("stock"));
                pdto.setFk_spec_id(rs.getInt("fk_spec_id"));
                pdto.setProduct_description(rs.getString("product_description"));
                pdto.setPimage(rs.getString("pimage"));
                // 만약 DTO에 point 필드가 있다면 추가
                // pdto.setPoint(rs.getInt("point")); 
            }
        } finally {
            close();
        }
        return pdto;
    } // end of public ProductDTO selectOneProduct(String productId) throws SQLException ----

    // 상품 등록 (테이블 설계 컬럼명 반영)
    @Override
    public int productInsert(ProductDTO dto) throws SQLException {
        int result = 0;
        try {
            conn = ds.getConnection();
            
            // SQL문의 순서: (1)name, (2)category, (3)pimage, (4)sale_price, (5)list_price, (6)stock, (7)fk_spec_id, (8)description
            String sql = " INSERT INTO tbl_product (product_id, product_name, fk_category_id, pimage, "
                       + " sale_price, list_price, stock, fk_spec_id, product_description, stock_date) "
                       + " VALUES (seq_product.nextval, ?, ?, ?, ?, ?, ?, ?, ?, sysdate) ";
            
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, dto.getProduct_name());      // (1) name
            pstmt.setInt(2, dto.getFk_category_id());       // (2) category_id
            pstmt.setString(3, dto.getPimage());            // (3) pimage (String)
            pstmt.setInt(4, dto.getSale_price());           // (4) sale_price
            pstmt.setInt(5, dto.getList_price());           // (5) list_price
            pstmt.setInt(6, dto.getStock());                // (6) stock
            pstmt.setInt(7, dto.getFk_spec_id());           // (7) fk_spec_id (중요!)
            pstmt.setString(8, dto.getProduct_description()); // (8) description

            result = pstmt.executeUpdate();
            
        } finally {
            close();
        }
        return result;
    } // end of  public int productInsert(ProductDTO dto) throws SQLException ----
    
    // 전체 상품 목록 조회 (관리자용/사용자용 공통)
    public List<ProductDTO> selectProductAll(String productId, String userid) throws SQLException {
        List<ProductDTO> productList = new ArrayList<>();
        try {
            conn = ds.getConnection();
            // 최신 등록순으로 조회
            String sql = " SELECT product_id, product_name, pimage, sale_price, stock, " 
            		   + " (SELECT count(*) FROM tbl_wishlist WHERE product_id = P.product_id AND member_id = ?) AS is_wish "  
            		   + " FROM tbl_product ORDER BY product_id DESC ";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userid);
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                ProductDTO pdto = new ProductDTO();
                pdto.setProduct_id(rs.getInt("product_id"));
                pdto.setProduct_name(rs.getString("product_name"));
                pdto.setPimage(rs.getString("pimage"));
                pdto.setSale_price(rs.getInt("sale_price"));
                pdto.setStock(rs.getInt("stock"));
                pdto.setIs_wish(rs.getInt("is_wish"));
                
                productList.add(pdto);
            }
        } finally { close(); }
        return productList;
    } // end of public List<ProductDTO> selectProductAll() throws SQLException ----
    
    // 관리자전용 - 등록된 상품 리스트
    @Override
    public List<ProductDTO> selectAllProduct(String category) throws SQLException {
        List<ProductDTO> productList = new ArrayList<>();
        try {
            conn = ds.getConnection();
            
            String sql = " SELECT * FROM tbl_product ";
            
            if(category != null && !category.isEmpty()) {
                sql += " WHERE fk_category_id = ? ";
            }
            
            sql += " ORDER BY product_id DESC ";
            
            pstmt = conn.prepareStatement(sql);
            
            if(category != null && !category.isEmpty()) {
                pstmt.setString(1, category);
            }
            
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                ProductDTO pdto = new ProductDTO();
                pdto.setProduct_id(rs.getInt("product_id"));
                pdto.setProduct_name(rs.getString("product_name"));
                pdto.setFk_category_id(rs.getInt("fk_category_id"));
                pdto.setPimage(rs.getString("pimage"));
                pdto.setSale_price(rs.getInt("sale_price"));
                pdto.setStock(rs.getInt("stock"));

                productList.add(pdto);
            }
        } finally {
            close();
        }
        return productList;
    } // end of public List<ProductDTO> selectAllProduct(String category) throws SQLException ----
    
    // 관리자전용 - 상품 수정
    @Override
    public int updateProduct(ProductDTO pdto) throws SQLException {
        int result = 0;
        try {
        	conn = ds.getConnection();
            
            String sql = " UPDATE tbl_product SET fk_category_id = ?, "
                       + " product_name = ?, sale_price = ?, stock = ?, "
                       + " product_description = ?, pimage = ? " // 추가됨
                       + " WHERE product_id = ? ";
         
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, pdto.getFk_category_id());
	        pstmt.setString(2, pdto.getProduct_name());
	        pstmt.setInt(3, pdto.getSale_price());
	        pstmt.setInt(4, pdto.getStock());
	        pstmt.setString(5, pdto.getProduct_description()); // 추가됨
	        pstmt.setString(6, pdto.getPimage());
	        pstmt.setInt(7, pdto.getProduct_id());
	         
	        result = pstmt.executeUpdate();
        } finally {
            close();
        }
        return result;
    } // end of public int updateProduct(ProductDTO pdto) throws SQLException ----
    
    // 관리자전용 - 상품 삭제
    @Override
    public int deleteProduct(String productId) throws SQLException {
        int result = 0;
        try {
            conn = ds.getConnection();
            
            // 상품 테이블에서 해당 ID 삭제
            String sql = " DELETE FROM tbl_product WHERE product_id = ? ";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, productId);
            
            result = pstmt.executeUpdate();
        } finally {
            close();
        }
        return result;
    } // end of  public int deleteProduct(String productId) throws SQLException ----

    // 찜하기
	@Override
	public int processWish(String userid, String product_id) {
	    int n = 0;
	    try {
	        conn = ds.getConnection();
	        
	        // 유저가 이 상품을 찜했는지 확인
	        String sql = " SELECT count(*) FROM tbl_wishlist "
	        		   + " WHERE member_id = ? AND product_id = ? ";
	        
	        pstmt = conn.prepareStatement(sql);
	        
	        pstmt.setString(1, userid);
	        pstmt.setString(2, product_id);
	        
	        rs = pstmt.executeQuery();
	        rs.next();
	        
	        int count = rs.getInt(1);

	        if(count == 0) {
	            // 찜 기록 없으면 추가(Insert)
	            sql = " INSERT INTO tbl_wishlist(wish_id, member_id, product_id, wish_date) "
	            	+ " VALUES(seq_wishlist_id.nextval, ?, ?, default) ";
	            
	            pstmt = conn.prepareStatement(sql);
	            
	            pstmt.setString(1, userid);
	            pstmt.setString(2, product_id);
	            
	            if(pstmt.executeUpdate() == 1) {
	            	n = 1; 
	            }
	        } else {
	            // 찜 기록 있으면 삭제(Delete)
	            sql = " DELETE FROM tbl_wishlist "
	            	+ " WHERE member_id = ? AND product_id = ? ";
	            
	            pstmt = conn.prepareStatement(sql);
	            
	            pstmt.setString(1, userid);
	            pstmt.setString(2, product_id);
	            
	            if(pstmt.executeUpdate() == 1) {
	            	n = -1; 
	            }
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	        n = 0;
	    } finally {
	        close();
	    }
	    return n;
	}

	// 위시리스트 보기
	@Override
	public List<ProductDTO> getWishList(String userid) throws SQLException {
		
		List<ProductDTO> wishList = new ArrayList<>();
	    
	    try {
	        conn = ds.getConnection();
	        
	        // tbl_wish, tbl_product -> JOIN
	        String sql = " SELECT P.product_id, P.product_name, P.pimage, P.sale_price, P.stock " +
	                     " FROM tbl_wishlist W JOIN tbl_product P " +
	                     " ON W.product_id = P.product_id " +
	                     " WHERE W.member_id = ? " +
	                     " ORDER BY W.wish_date DESC "; 
	        
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, userid);
	        
	        rs = pstmt.executeQuery();
	        
	        while(rs.next()) {
	            ProductDTO pdto = new ProductDTO();
	            pdto.setProduct_id(rs.getInt("product_id"));
	            pdto.setProduct_name(rs.getString("product_name"));
	            pdto.setPimage(rs.getString("pimage"));
	            pdto.setSale_price(rs.getInt("sale_price"));
	            pdto.setStock(rs.getInt("stock"));
	            
	            wishList.add(pdto);
	        }
	        
	    } finally {
	        close();
	    }
	    
	    return wishList;
	}
	
	// 장바구니
	@Override
	public int addCart(Map<String, String> paraMap) throws SQLException {
	    int result = 0;
	    
	    try {
	        conn = ds.getConnection();
	        
	        // 1. 해당 사용자의 장바구니에 해당 상품이 이미 있는지 확인합니다.
	        String sql = " SELECT cart_id FROM tbl_cart " +
	                     " WHERE fk_member_id = ? AND fk_product_id = ? ";
	        
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, paraMap.get("userid"));
	        pstmt.setString(2, paraMap.get("product_id"));
	        
	        rs = pstmt.executeQuery();
	        
	        if(rs.next()) {
	            // 2. 이미 있다면 수량만 더해주는 UPDATE를 실행합니다.
	            int cart_id = rs.getInt("cart_id");
	            
	            sql = " UPDATE tbl_cart SET cart_qty = cart_qty + ? " +
	                  " WHERE cart_id = ? ";
	            
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setInt(1, Integer.parseInt(paraMap.get("cart_qty")));
	            pstmt.setInt(2, cart_id);
	            
	            result = pstmt.executeUpdate();
	        } 
	        else {
	            // 3. 없다면 새로 저장하는 INSERT를 실행합니다.
	            sql = " INSERT INTO tbl_cart(cart_id, fk_member_id, fk_product_id, cart_qty) " +
	                  " VALUES(seq_cart_id.nextval, ?, ?, ?) "; // 시퀀스명 확인 필요!
	            
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setString(1, paraMap.get("userid"));
	            pstmt.setString(2, paraMap.get("product_id"));
	            pstmt.setInt(3, Integer.parseInt(paraMap.get("cart_qty")));
	            
	            result = pstmt.executeUpdate();
	        }
	        
	    } finally {
	        close();
	    }
	    
	    return result;
	} // end of public int addCart(Map<String, String> paraMap) throws SQLException ----
	
	// 장바구니 목록 조회
	@Override
	public List<CartDTO> getCartList(String userid) throws SQLException {
	    
	    List<CartDTO> cartList = new ArrayList<>();
	    
	    try {
	        conn = ds.getConnection();
	        
	        // 장바구니 정보와 상품 정보를 JOIN하여 가져옵니다.
	        String sql = " SELECT C.cart_id, C.fk_member_id, C.fk_product_id, C.cart_qty, " +
	                     "        P.product_name, P.pimage, P.sale_price, P.stock " +
	                     " FROM tbl_cart C JOIN tbl_product P " +
	                     " ON C.fk_product_id = P.product_id " +
	                     " WHERE C.fk_member_id = ? " +
	                     " ORDER BY C.cart_date DESC ";
	        
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, userid);
	        
	        rs = pstmt.executeQuery();
	        
	        while(rs.next()) {
	            CartDTO cdto = new CartDTO();
	            cdto.setCart_id(rs.getInt("cart_id"));
	            cdto.setCart_qty(rs.getInt("cart_qty"));
	            
	            // JOIN된 상품 정보를 ProductDTO에 담습니다.
	            ProductDTO pdto = new ProductDTO();
	            pdto.setProduct_id(rs.getInt("fk_product_id"));
	            pdto.setProduct_name(rs.getString("product_name"));
	            pdto.setPimage(rs.getString("pimage"));
	            pdto.setSale_price(rs.getInt("sale_price"));
	            pdto.setStock(rs.getInt("stock"));
	            
	            // CartDTO에 ProductDTO를 꽂아줍니다.
	            cdto.setPdto(pdto);
	            
	            cartList.add(cdto);
	        }
	        
	    } finally {
	        close();
	    }
	    
	    return cartList;
	} // end of public List<CartDTO> getCartList(String userid) throws SQLException ----
    
	// 장바구니 상품 수량 업데이트
	@Override
	public int updateCartQty(Map<String, String> paraMap) throws SQLException {
	    int result = 0;
	    try {
	        conn = ds.getConnection();
	        
	        String sql = " UPDATE tbl_cart SET cart_qty = cart_qty + ? " +
	                     " WHERE cart_id = ? AND (cart_qty + ?) >= 1 ";
	        
	        pstmt = conn.prepareStatement(sql);
	        int change = Integer.parseInt(paraMap.get("change"));
	        
	        pstmt.setInt(1, change);
	        pstmt.setString(2, paraMap.get("cart_id"));
	        pstmt.setInt(3, change);
	        
	        result = pstmt.executeUpdate();
	        
	    } finally {
	        close();
	    }
	    return result;
	} // end of public int updateCartQty(Map<String, String> paraMap) throws SQLException  ----
	
	// 장바구니 상품 삭제
	@Override
	public int deleteCart(String cart_id) throws SQLException {
	    int result = 0;
	    try {
	        conn = ds.getConnection();
	        
	        String sql = " DELETE FROM tbl_cart WHERE cart_id = ? ";
	        
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, cart_id);
	        
	        result = pstmt.executeUpdate();
	        
	    } finally {
	        close();
	    }
	    return result;
	}

	// 주문하기
	@Override
	public int orderAdd(Map<String, Object> paraMap) throws SQLException {
		
		return 0;
	}

	// 주문 상품 정보 불러오기
	@Override
	public ProductDTO getProductDetail(String productId) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}

	// 주문자 주소 가져오기
	@Override
	public List<Map<String, String>> getAddressList(String userid) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
}