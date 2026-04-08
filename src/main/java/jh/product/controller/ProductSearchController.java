package jh.product.controller;

import java.util.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import sp.common.controller.AbstractController;

import com.google.gson.Gson;

import jh.product.model.ProductDAO;
import jh.product.model.ProductDAO_imple;
import ih.product.domain.ProductDTO;

public class ProductSearchController extends AbstractController {

    private final ProductDAO pdao = new ProductDAO_imple();
    private final Gson gson = new Gson();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String q = request.getParameter("q");
        if (q == null) q = "";
        q = q.trim();

        int offset = 0;
        int size = 12; // 기본 12개

        // offset 파싱 + 음수 방지
        try {
            offset = Integer.parseInt(request.getParameter("offset"));
        } catch (Exception ignore) {}
        if (offset < 0) offset = 0;

        // size 파싱 + 범위 제한
        try {
            size = Integer.parseInt(request.getParameter("size"));
        } catch (Exception ignore) {}
        if (size <= 0) size = 12;
        if (size > 50) size = 50;

        // 너무 짧으면 빈 배열
        if (q.length() < 2) {
            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().write("[]");
            return;
        }

        // offset 기반 페이징
        List<ProductDTO> list = pdao.searchProductsByName(q, size, offset);

        // 프론트가 기대하는 키 유지 + category/spec 추가
        List<Map<String, Object>> out = new ArrayList<>();

        for (ProductDTO p : list) {
            Map<String, Object> m = new HashMap<>();
            m.put("pnum", p.getProduct_id());
            m.put("pname", p.getProduct_name());
            m.put("price", p.getSale_price());
            m.put("pimage1", p.getPimage());           // null/"" 가능 (미구현이면)
            m.put("category_name", p.getCategory_name());
            m.put("spec_name", p.getSpec_name());
            out.add(m);
        }

        response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write(gson.toJson(out));
    }
}
