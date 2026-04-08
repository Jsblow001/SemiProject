package jh.admin.controller;

import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class BulkRegisterByImagesController extends AbstractController {
    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/jh_admin/productBulkRegister.jsp");
    }
}
