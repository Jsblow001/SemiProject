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
        
        String product_id = request.getParameter("product_id");
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");
        String userid = (loginuser != null) ? loginuser.getUserid() : null;
        
        ProductDAO pdao = new ProductDAO_imple();
        ProductDTO pdto = pdao.selectOneProduct(product_id, userid);
        
        // 판매 가능 여부 체크 
        if(pdto != null && pdto.getPstatus() == 1) {
            
            // 정상 판매 중인 상품일 때만 리뷰를 가져오고 상세페이지로 이동
            ReviewDAO rdao = new ReviewDAO_imple();
            List<ReviewDTO> allReviews = rdao.getReviewsByProductId(product_id);
            
            request.setAttribute("pdto", pdto);
            request.setAttribute("allReviews", allReviews);
            
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/ih_product/productDetail.jsp");
            
        } else {
            // 상품이 DB에 없거나(null), 상태값이 0(판매중지/삭제됨)인 경우
            String msg = (pdto == null) ? "해당 상품은 존재하지 않습니다." : "해당 상품은 판매가 종료되었습니다.";
            
            request.setAttribute("message", msg);
            request.setAttribute("loc", "javascript:history.back()");
            
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp"); 
            return;
        }
    }
}