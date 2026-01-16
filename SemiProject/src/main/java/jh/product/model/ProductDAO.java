package jh.product.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import ih.product.domain.ProductDTO;

public interface ProductDAO {
	
    List<ProductDTO> searchProductsByName(String q, int size, int offset) throws SQLException;
    
    List<String> selectBulkProductImages() throws Exception;
    
    int deleteBulkProducts() throws Exception;

    // tbl_map(위,경도) 테이블에 있는 정보를 가져오기(select)
	List<Map<String, String>> selectStoreMap() throws Exception;

}
