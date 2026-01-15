package ih.product.controller;

import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jh.review.model.ReviewDAO_imple;
import jh.review.domain.ReviewDTO;
import jh.review.model.ReviewDAO;
import java.util.List;

import hk.member.domain.MemberDTO;
import ih.product.domain.ProductDTO;
import ih.product.model.*;

public class ProductDetailController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 목록에서 넘겨준 상품번호 받기
        String product_id = request.getParameter("product_id");
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");
        String userid = (loginuser != null) ? loginuser.getUserid() : null;
        
        // DB에서 해당 상품의 정보를 가져오기
        ProductDAO pdao = new ProductDAO_imple();
        ProductDTO pdto = pdao.selectOneProduct(product_id, userid);
        ReviewDAO rdao = new ReviewDAO_imple();
        List<ReviewDTO> allReviews = rdao.getReviewsByProductId(product_id);
        
        if(pdto != null) {
            // 데이터를 JSP에 전달
            request.setAttribute("pdto", pdto);
            request.setAttribute("allReviews", allReviews);
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/ih_product/productDetail.jsp");
        } else {
            // 상품이 없을 경우 처리
            request.setAttribute("message", "해당 상품은 존재하지 않습니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/msg.jsp");
        }
    }
}