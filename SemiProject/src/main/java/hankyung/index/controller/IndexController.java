package hankyung.index.controller;

import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class IndexController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // 메인 페이지만 보여줌 (DB 접근 없음)
        super.setRedirect(false);
        super.setViewPage("/index.jsp");
    }
}
