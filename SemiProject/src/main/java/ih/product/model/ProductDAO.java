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

    // 페이징이 적용된 관리자용 전체 상품 리스트 조회
	List<ProductDTO> selectAllProductPaging(Map<String, String> paraMap)  throws SQLException;

	// 상품 상세 정보를 가져오는 메서드
	ProductDTO selectOneProduct(String productId, String userid) throws SQLException;

	// 관리자전용 - 등록된 상품 리스트
	// List<ProductDTO> selectAllProduct(String category) throws SQLException;
	
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

	// 페이징된 상품 목록 가져오기
	List<ProductDTO> selectProductByCategoryPaging(Map<String, String> paraMap) throws SQLException;

	// 해당 카테고리의 총 상품 개수 가져오기 (페이지바 생성용)
	int getTotalCountByCategory(String categoryId) throws SQLException;

	//  페이지바 생성
	String getPageBar(int currentShowPageNo, int sizePerPage, int totalCount, String categoryId) throws SQLException;
	
	// 페이지바를 만들기 위한 해당 카테고리의 총 상품 개수
	int getTotalProductCount(String category) throws SQLException;
	
	// 관리자 전용 페이지바 생성 
	String getAdminPageBar(int currentShowPageNo, int sizePerPage, int totalCount, String category);
	
	// 장바구니 번호로 상품의 상태와 정보 조회 (주문 전 검증용)
	ProductDTO getProductByCartId(String cid) throws SQLException;

}