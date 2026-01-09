package jh.product.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import ih.product.domain.ProductDTO;

public class ProductDAO_imple implements ProductDAO {

    private DataSource ds;

    public ProductDAO_imple() {
    	try {
            Context initContext = new InitialContext();
            Context envContext  = (Context)initContext.lookup("java:/comp/env");
            ds = (DataSource)envContext.lookup("SemiProject");
        } catch (NamingException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<ProductDTO> searchProductsByName(String q, int size, int offset) throws SQLException {

        List<ProductDTO> list = new ArrayList<>();

        String sql =
              " select p.product_id, p.product_name, p.sale_price, p.pimage, "
            + "        c.category_name, ps.spec_name "
            + " from tbl_product p "
            + " join tbl_category c on p.fk_category_id = c.category_id "
            + " join tbl_product_spec ps on p.fk_spec_id = ps.spec_id "
            + " where lower(p.product_name) like '%' || lower(?) || '%' "
            + " order by p.product_id desc "
            + " offset ? rows fetch next ? rows only ";

        try (Connection conn = ds.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
        	
        	System.out.println("DB USER = " + conn.getMetaData().getUserName());

            pstmt.setString(1, q);
            pstmt.setInt(2, offset);
            pstmt.setInt(3, size);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ProductDTO dto = new ProductDTO();

                    dto.setProduct_id(rs.getInt("product_id"));
                    dto.setProduct_name(rs.getString("product_name"));
                    dto.setSale_price(rs.getInt("sale_price"));
                    dto.setPimage(rs.getString("pimage"));

                    dto.setCategory_name(rs.getString("category_name"));
                    dto.setSpec_name(rs.getString("spec_name"));  // ✅ ps.spec_name

                    list.add(dto);
                }
            }
        }

        return list;
    }

}
