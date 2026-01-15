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
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    public ProductDAO_imple() {
        try {
            Context initContext = new InitialContext();
            Context envContext  = (Context)initContext.lookup("java:/comp/env");
            ds = (DataSource)envContext.lookup("SemiProject");
        } catch (NamingException e) {
            e.printStackTrace();
        }
    }

    private void close() {
        try {
            if(rs != null)    { rs.close(); rs=null; }
            if(pstmt != null) { pstmt.close(); pstmt=null; }
            if(conn != null)  { conn.close(); conn=null; }
        } catch(SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<ProductDTO> searchProductsByName(String q, int size, int offset) throws SQLException {

        List<ProductDTO> list = new ArrayList<>();

        if(q == null) q = "";
        q = q.trim();

        String sql =
              " select p.product_id, p.product_name, p.sale_price, p.pimage, "
            + "        c.category_name, ps.spec_name "
            + " from tbl_product p "
            + " join tbl_category c on p.fk_category_id = c.category_id "
            + " join tbl_product_spec ps on p.fk_spec_id = ps.spec_id "
            + " where lower(p.product_name) like '%' || lower(?) || '%' "
            + " order by p.product_id desc "
            + " offset ? rows fetch next ? rows only ";

        try {
            conn = ds.getConnection();
            System.out.println("DB USER = " + conn.getMetaData().getUserName());

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, q);
            pstmt.setInt(2, offset);
            pstmt.setInt(3, size);

            rs = pstmt.executeQuery();

            while(rs.next()) {
                ProductDTO dto = new ProductDTO();

                dto.setProduct_id(rs.getInt("product_id"));
                dto.setProduct_name(rs.getString("product_name"));
                dto.setSale_price(rs.getInt("sale_price"));
                dto.setPimage(rs.getString("pimage"));

                dto.setCategory_name(rs.getString("category_name"));
                dto.setSpec_name(rs.getString("spec_name"));

                list.add(dto);
            }

        } finally {
            close();
        }

        return list;
    }

    
    @Override
    public List<String> selectBulkProductImages() throws Exception {
        List<String> list = new java.util.ArrayList<>();

        try {
            conn = ds.getConnection();
            String sql = " select pimage from tbl_product where pimage like 'BULK_%' ";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while(rs.next()) {
                list.add(rs.getString("pimage"));
            }
        } finally {
            close();
        }
        return list;
    }

    @Override
    public int deleteBulkProducts() throws Exception {
        int result = 0;
        try {
            conn = ds.getConnection();

            // ✅ 혹시 주문 상세에서 참조 중이면 삭제 안될 수 있음.
            // 그럼 아래처럼 "주문 참조 없는 것만 삭제"로 안전하게 가는게 좋음.
            String sql =
              " delete from tbl_product p " +
              "  where p.pimage like 'BULK_%' " +
              "    and not exists (select 1 from tbl_order_detail d where d.fk_product_id = p.product_id) ";

            pstmt = conn.prepareStatement(sql);
            result = pstmt.executeUpdate();

        } finally {
            close();
        }
        return result;
    }


}
