package jh.reserve.admin.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sp.common.controller.AbstractController;

public class AdminSchedulePageController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/jh_admin/reservation/admin_schedule.jsp");
    }
}
