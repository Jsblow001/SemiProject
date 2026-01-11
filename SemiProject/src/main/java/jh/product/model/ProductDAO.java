package jh.product.model;

import java.sql.SQLException;
import java.util.List;
import ih.product.domain.ProductDTO;

public interface ProductDAO {
    List<ProductDTO> searchProductsByName(String q, int size, int offset) throws SQLException;
}
