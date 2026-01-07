package jh.review.controller;

import java.io.File;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.StringJoiner;
import java.util.UUID;

import hk.member.domain.MemberDTO;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import sp.common.controller.AbstractController;
import jh.review.domain.ReviewDTO;
import jh.review.model.ReviewDAO;
import jh.review.model.ReviewDAO_imple;

@MultipartConfig(
  maxFileSize = 10 * 1024 * 1024,
  maxRequestSize = 30 * 1024 * 1024
)
public class ReviewWriteController extends AbstractController {

    private ReviewDAO rdao = new ReviewDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        if(loginuser == null) {
            request.setAttribute("message", "로그인이 필요합니다.");
            request.setAttribute("loc", request.getContextPath() + "/login.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        if("GET".equalsIgnoreCase(request.getMethod())) {

            List<Map<String, String>> purchaseList = rdao.selectPurchasesForReview(loginuser.getUserid());
            request.setAttribute("purchaseList", purchaseList);

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/jh_review/review_write.jsp");
            return;
        }

        // ===== POST =====
        try {
            String fk_product_id = request.getParameter("fk_product_id");
            String review_title = request.getParameter("review_title");
            String review_content = request.getParameter("review_content");
            String ratingStr = request.getParameter("rating");

            if(fk_product_id == null || fk_product_id.isBlank()
            || review_title == null || review_title.isBlank()
            || review_content == null || review_content.isBlank()
            || ratingStr == null || ratingStr.isBlank()) {

                request.setAttribute("message", "필수값이 누락되었습니다.");
                request.setAttribute("loc", "javascript:history.back()");
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/msg.jsp");
                return;
            }

            int rating = Integer.parseInt(ratingStr);

            // praise(복수)
            String[] praises = request.getParameterValues("praise");
            String praise_keywords = null;
            if(praises != null && praises.length > 0) {
                StringJoiner sj = new StringJoiner(",");
                for(String p : praises) {
                    if(p != null && !p.isBlank()) sj.add(p.trim());
                }
                praise_keywords = sj.toString();
            }

            long review_id = rdao.getReviewSeqNextVal();

            ReviewDTO dto = new ReviewDTO();
            dto.setReview_id(review_id);
            dto.setFk_product_id(Integer.parseInt(fk_product_id));
            dto.setFk_member_id(loginuser.getUserid());
            dto.setRating(rating);
            dto.setReview_title(review_title.trim());
            dto.setReview_content(review_content.trim());
            dto.setPraise_keywords(praise_keywords); // null 가능

            int n = rdao.insertReview(dto);

            if(n != 1) {
                request.setAttribute("message", "리뷰 등록에 실패했습니다.");
                request.setAttribute("loc", "javascript:history.back()");
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/msg.jsp");
                return;
            }

            // ===== 이미지 업로드(선택) =====
            // input name="review_images" 로 받는다고 JSP에 되어 있으면 getParts로 처리
            for(Part part : request.getParts()) {

                if(!"review_images".equals(part.getName())) continue;
                if(part.getSize() <= 0) continue;

                String submitted = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                if(submitted == null || submitted.isBlank()) continue;

                // 확장자
                String ext = "";
                int dot = submitted.lastIndexOf(".");
                if(dot > -1) ext = submitted.substring(dot);

                String newFileName = UUID.randomUUID().toString() + ext;

                // ✅ 실제 저장 경로는 프로젝트에 맞춰 바꿔야 함
                // (QnA 업로드 저장 폴더가 이미 있으면 그 방식 그대로 쓰는 게 정답)
                String uploadDir = request.getServletContext().getRealPath("/images/review");
                File dir = new File(uploadDir);
                if(!dir.exists()) dir.mkdirs();

                part.write(uploadDir + File.separator + newFileName);

                rdao.insertReviewImage(review_id, newFileName);
            }

            request.setAttribute("message", "리뷰가 등록되었습니다.");
            request.setAttribute("loc", request.getContextPath() + "/reviews.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");

        } catch(SQLException e) {
            // unique (fk_product_id, fk_member_id) 위반 가능
            e.printStackTrace();
            request.setAttribute("message", "이미 해당 상품에 대한 리뷰를 작성하셨습니다.");
            request.setAttribute("loc", request.getContextPath() + "/reviews.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
        }
    }
}
