package ih.product.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import ih.product.domain.CartDTO;
import ih.product.domain.ProductDTO;

public interface ProductDAO {
    
    // 카테고리 코드(sunglasses, eyeglasses 등)를 받아 해당 상품 리스트를 가져오는 메서드
    List<ProductDTO> selectProductByCategory(String categoryId, String userid) throws SQLException;
    
    // 상품 등록하는 메서드
    int productInsert(ProductDTO pdto) throws SQLException;

    // 아까 DAO에 추가한 메소드
	List<ProductDTO> selectProductAll(String productId, String userid)  throws SQLException;

	// 상품 상세 정보를 가져오는 메서드
	ProductDTO selectOneProduct(String productId, String userid) throws SQLException;

	// 관리자전용 - 등록된 상품 리스트
	//List<ProductDTO> selectAllProduct() throws SQLException;
	List<ProductDTO> selectAllProduct(String category) throws SQLException;
	
	// 관리자전용 - 상품 수정
	int updateProduct(ProductDTO pdto) throws SQLException;
		
	// 관리자전용 - 상품 삭제
	int deleteProduct(String productId) throws SQLException;

	// 찜하기 
	int processWish(String userid, String product_id) throws SQLException;

	// 위시리스트 보기
	List<ProductDTO> getWishList(String userid) throws SQLException;

	// 장바구니 상품 추가
	int addCart(Map<String, String> paraMap) throws SQLException;

	// 장바구니 목록 조회
	List<CartDTO> getCartList(String userid) throws SQLException;

	// 장바구니 상품 수량 업데이트
	int updateCartQty(Map<String, String> paraMap) throws SQLException;

	// 장바구니 상품 삭제
	int deleteCart(String cart_id) throws SQLException;

	// 주문하기
	int orderAdd(Map<String, Object> paraMap) throws SQLException;

	// 상품 정보 가져오기
	ProductDTO getProductDetail(String productId) throws SQLException;

	// 주소 가져오기
	List<Map<String, String>> getAddressList(String userid) throws SQLException;

	// 장바구니에서 여러 상품 주문 시
	List<Map<String, Object>> getCartListByCartIds(String cartIds) throws SQLException;

	// 주문 완료 후 장바구니 비우기
	int deleteCartList(String cartIds) throws SQLException;
    
	// 주소 등록하기
	int registerAddress(Map<String, String> paraMap) throws SQLException;
	
	
    // 카테고리 리스트 가져오기 메서드 (상품 등록 폼용)
    // List<CategoryDTO> selectCategoryList() throws SQLException;
    
    // 스펙 리스트 가져오기 메서드 (상품 등록 폼용)
    // List<SpecDTO> selectSpecList() throws SQLException;
}