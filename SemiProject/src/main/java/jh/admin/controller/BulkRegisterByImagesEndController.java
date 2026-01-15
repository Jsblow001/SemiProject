package jh.admin.controller;

import sp.common.controller.AbstractController;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import ih.product.domain.ProductDTO;
import ih.product.model.ProductDAO;
import ih.product.model.ProductDAO_imple;

import java.io.File;
import java.nio.file.*;
import java.util.Collection;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,
    maxFileSize = 1024 * 1024 * 15,
    maxRequestSize = 1024 * 1024 * 100
)
public class BulkRegisterByImagesEndController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        if(!"POST".equalsIgnoreCase(request.getMethod())) {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/admin/allproductList.sp");
            return;
        }

        // ✅ 사용자 입력값: 카테고리 + 정가
        int fk_category_id = 2;
        int list_price = 200000;

        try { fk_category_id = Integer.parseInt(request.getParameter("fk_category_id")); } catch(Exception ignore) {}
        try { list_price = Integer.parseInt(request.getParameter("list_price")); } catch(Exception ignore) {}

        // ✅ 판매가 정책
        int sale_price = list_price - 20000;
        if(sale_price < 0) sale_price = 0;

        // ✅ 고정값
        final int DEFAULT_STOCK = 10;
        final int DEFAULT_SPEC_ID = 1; // NEW

        String uploadPath = request.getServletContext().getRealPath("/img");
        String devImgDir = "C:\\git\\SemiProject\\SemiProject\\src\\main\\webapp\\img";

        ProductDAO pdao = new ProductDAO_imple();

        int success = 0;
        int fail = 0;

        Collection<Part> parts = request.getParts();

        for(Part part : parts) {
            if(!"pimages".equals(part.getName())) continue;
            if(part.getSize() == 0) continue;

            try {
                String originalName = getFileName(part);
                if(originalName == null || originalName.isBlank()) continue;

                // ✅ 제품명/설명
                String baseName = removeExtension(originalName);
                String productName = normalizeName(baseName);
                String desc = makeDescription(productName);

                // ✅ 저장 파일명(BULK_ prefix)
                String savedName = "BULK_" + System.currentTimeMillis() + "_" + originalName;

                // ✅ 서버(img) 저장
                part.write(uploadPath + File.separator + savedName);

                // ✅ 개발 폴더 복사
                Path from = Paths.get(uploadPath, savedName);
                Path to   = Paths.get(devImgDir, savedName);
                Files.copy(from, to, StandardCopyOption.REPLACE_EXISTING);

                // ✅ DTO 생성
                ProductDTO pdto = new ProductDTO();
                pdto.setFk_category_id(fk_category_id);
                pdto.setFk_spec_id(DEFAULT_SPEC_ID);
                pdto.setProduct_name(productName);
                pdto.setProduct_description(desc);
                pdto.setList_price(list_price);
                pdto.setSale_price(sale_price);
                pdto.setStock(DEFAULT_STOCK);
                pdto.setPimage(savedName);

                // ✅ insert
                int n = pdao.productInsert(pdto);  // ⭐ DTO 방식
                if(n == 1) success++;
                else fail++;

            } catch(Exception e) {
                fail++;
                e.printStackTrace();
            }
        }

        request.setAttribute("message",
            "이미지 일괄등록 완료 ✅ 성공: " + success + " / 실패: " + fail
            + " (카테고리ID=" + fk_category_id + ", 정가=" + list_price + ", 판매가=" + sale_price + ")"
        );
        request.setAttribute("loc", request.getContextPath() + "/admin/allproductList.sp");
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/msg.jsp");
    }

    private String getFileName(Part part) {
        String cd = part.getHeader("content-disposition");
        if(cd == null) return "";
        for(String temp : cd.split(";")) {
            if(temp.trim().startsWith("filename")) {
                return temp.substring(temp.indexOf("=") + 2, temp.length() - 1);
            }
        }
        return "";
    }

    private String removeExtension(String fileName) {
        int dot = fileName.lastIndexOf(".");
        if(dot == -1) return fileName;
        return fileName.substring(0, dot);
    }

    private String normalizeName(String baseName) {
        String s = baseName.trim();
        s = s.replaceAll("[\\\\/:*?\"<>|]", " ");
        s = s.replace("_", " ").replace("-", " ");
        s = s.replaceAll("\\s+", " ").trim();
        return s;
    }

    private String makeDescription(String productName) {
        return productName + " 모델입니다.\n"
             + "과하지 않은 디자인과 편안한 착용감을 위해 설계되었습니다.\n"
             + "디테일한 스펙은 상세 페이지 또는 고객센터를 통해 안내드립니다.";
    }
}
