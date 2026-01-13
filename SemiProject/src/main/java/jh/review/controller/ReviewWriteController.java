package jh.review.controller;

import java.io.File;
import java.nio.file.Paths;
import java.sql.Connection;
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

        // ===== GET: 작성폼 =====
        if("GET".equalsIgnoreCase(request.getMethod())) {
            List<Map<String, String>> purchaseList = rdao.selectPurchasesForReview(loginuser.getUserid());
            request.setAttribute("purchaseList", purchaseList);

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/jh_review/review_write.jsp");
            return;
        }

        // ===== POST: 등록 =====
        Connection conn = null;

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

            // ✅ 트랜잭션 시작
            conn = rdao.getConnection();     // (DAO에 getConnection() 추가한 상태여야 함)
            conn.setAutoCommit(false);

            long reviewId = rdao.getReviewSeqNextVal(); // seq는 커넥션 없이 뽑아도 OK
                                                     // (원하면 conn버전으로 맞춰도 됨)

            ReviewDTO dto = new ReviewDTO();
            dto.setReview_id(reviewId);
            dto.setFk_product_id(Integer.parseInt(fk_product_id));
            dto.setFk_member_id(loginuser.getUserid());
            dto.setRating(rating);
            dto.setReview_title(review_title.trim());
            dto.setReview_content(review_content.trim());
            dto.setPraise_keywords(praise_keywords); // null 가능

            // ✅ conn 버전 insertReview 사용 (DAO에 구현되어 있어야 함)
            int n = rdao.insertReview(conn, dto);
            if(n != 1) {
                conn.rollback();
                request.setAttribute("message", "리뷰 등록에 실패했습니다.");
                request.setAttribute("loc", "javascript:history.back()");
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/msg.jsp");
                return;
            }

            // ✅ 업로드 경로 (너 프로젝트는 img 폴더 쓰고 있음)
            String uploadDir = request.getServletContext().getRealPath("/img/review");
            String devImgDir = "C:\\git\\SemiProject\\SemiProject\\src\\main\\webapp\\img\\review"; // 너 환경
            new File(uploadDir).mkdirs();
            new File(devImgDir).mkdirs();

            // ✅ 이미지 업로드 + DB 저장 (여러장 가능)
            for(Part part : request.getParts()) {
                if(!"files".equals(part.getName())) continue;
                if(part.getSize() == 0) continue;

                String orgName = Paths.get(part.getSubmittedFileName()).getFileName().toString();

                String ext = "";
                int dot = orgName.lastIndexOf('.');
                if(dot > -1) ext = orgName.substring(dot);

                String saveName = UUID.randomUUID().toString().replace("-", "") + ext;

                // 1) 물리 저장
                part.write(uploadDir + File.separator + saveName);

                // 2) (선택) 개발 폴더 복사
                java.nio.file.Files.copy(
                    java.nio.file.Paths.get(uploadDir, saveName),
                    java.nio.file.Paths.get(devImgDir, saveName),
                    java.nio.file.StandardCopyOption.REPLACE_EXISTING
                );

                // 3) DB 저장: TBL_REVIEW_IMAGE
                // ✅ conn 버전 insertReviewImage 사용 (DAO에 구현되어 있어야 함)
                rdao.insertReviewImage(conn, reviewId, saveName);
            }

            conn.commit();

            request.setAttribute("message", "리뷰가 등록되었습니다.");
            request.setAttribute("loc", request.getContextPath() + "/reviews.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");

        }
        catch(SQLException e) {
            if(conn != null) try { conn.rollback(); } catch(Exception ignore) {}
            e.printStackTrace();

            request.setAttribute("message", "이미 해당 상품에 대한 리뷰를 작성하셨습니다.");
            request.setAttribute("loc", request.getContextPath() + "/reviews.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
        }
        catch(Exception e) {
            if(conn != null) try { conn.rollback(); } catch(Exception ignore) {}
            e.printStackTrace();
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/error.sp");
        }
        finally {
            if(conn != null) try { conn.setAutoCommit(true); conn.close(); } catch(Exception ignore) {}
        }
    }
}
