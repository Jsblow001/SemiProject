package jh.admin.controller;

import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import jh.product.model.ProductDAO;
import jh.product.model.ProductDAO_imple;

import java.nio.file.*;

import java.util.List;

public class BulkDeleteAllEndController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        if(!"POST".equalsIgnoreCase(request.getMethod())) {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/admin/allproductList.sp");
            return;
        }

        String uploadPath = request.getServletContext().getRealPath("/img");
        String devImgDir  = "C:\\git\\SemiProject\\SemiProject\\src\\main\\webapp\\img";

        ProductDAO pdao = new ProductDAO_imple();

        // ✅ 1) 삭제할 이미지 파일명 먼저 조회
        List<String> imgList = pdao.selectBulkProductImages();  // BULK_로 시작하는 pimage 리스트

        // ✅ 2) DB 삭제 실행
        int deleted = pdao.deleteBulkProducts(); // BULK_로 시작하는 상품 삭제

        // ✅ 3) 파일 삭제 (운영폴더 + 개발폴더)
        int fileDeleted = 0;
        for(String img : imgList) {
            try {
                Path p1 = Paths.get(uploadPath, img);
                Path p2 = Paths.get(devImgDir, img);

                if(Files.deleteIfExists(p1)) fileDeleted++;
                Files.deleteIfExists(p2); // 개발폴더는 카운트 따로 안 세도 됨
            } catch(Exception e) {
                e.printStackTrace();
            }
        }

        request.setAttribute("message",
            "벌크 삭제 완료 ✅ DB삭제: " + deleted + "건 / 파일삭제: " + fileDeleted + "건"
        );
        request.setAttribute("loc", request.getContextPath() + "/admin/allproductList.sp");
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/msg.jsp");
    }
}
