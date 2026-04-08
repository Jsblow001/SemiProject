package sp.common.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebInitParam;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.InputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.reflect.Constructor;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

/*
 * =========================================================================
 *  FrontController
 * -------------------------------------------------------------------------
 *  - 모든 *.sp 요청을 단일 서블릿에서 처리
 *  - /WEB-INF/Command.properties 파일을 읽어
 *    URI (*.sp) → Controller 매핑
 *
 *  - Tomcat 10 / Jakarta 환경 대응
 * =========================================================================
 */

@WebServlet(
      description = "사용자가 웹에서 *.sp 을 했을 경우 이 서블릿이 응답을 해주도록 한다.", 
      urlPatterns = { "*.sp" }, 
	  initParams = {
			    @WebInitParam(name = "propertyConfig", value = "/Command.properties", description = "*.sp 에 대한 클래스의 매핑파일")
			})
@MultipartConfig(
       fileSizeThreshold = 1024 * 1024 * 1,  // 1MB 이상이면 메모리 대신 임시 디렉토리 사용
       maxFileSize = 1024 * 1024 * 10,       // 파일 한 개 최대 크기 (10MB)
       maxRequestSize = 1024 * 1024 * 50     // 전체 요청 최대 크기 (50MB)
   )
public class FrontController extends HttpServlet {

   private static final long serialVersionUID = 1L;
   
   /*
    * cmdMap
    * - key   : /index.sp, /login.sp 등
    * - value : 해당 URI를 처리할 Controller 객체
    */
   private Map<String, Object> cmdMap = new HashMap<>();

   public void init(ServletConfig config) throws ServletException {

	    super.init(config);

	    InputStream is = null;

	    String props = config.getInitParameter("propertyConfig");
	    if (props == null || props.isBlank()) {
	        props = "/Command.properties";
	    }

	    try {
	        is = getServletContext().getResourceAsStream(props);

	        if (is == null) {
	            throw new FileNotFoundException("웹 리소스를 찾을 수 없습니다: " + props);
	        }

	        Properties pr = new Properties();
	        pr.load(is);

	        Enumeration<Object> en = pr.keys();

	        while (en.hasMoreElements()) {

	            String key = (String) en.nextElement();
	            String className = pr.getProperty(key);

	            if (className != null) {

	                className = className.trim();

	                Class<?> cls = Class.forName(className);
	                Constructor<?> constrt = cls.getDeclaredConstructor();
	                Object obj = constrt.newInstance();

	                cmdMap.put(key, obj);
	            }
	        }

	    } catch (FileNotFoundException e) {
	        e.printStackTrace();
	    } catch (IOException e) {
	        e.printStackTrace();
	    } catch (ClassNotFoundException e) {
	        System.out.println(">> 문자열로 명명되어진 클래스가 존재하지 않습니다. <<");
	        e.printStackTrace();
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        if (is != null) {
	            try {
	                is.close();
	            } catch (IOException e) {
	                e.printStackTrace();
	            }
	        }
	    }
	}
   
   
   @Override
   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {   
      
      // 웹브라우저의 주소 입력창에서
      // http://localhost:9090/MyMVC/member/idDuplicateCheck.up?userid=leess 와 같이 입력되었더라면 
      //   String url = request.getRequestURL().toString();
      //   System.out.println("~~~ 확인용 url => " + url);
      // ~~~ 확인용 url => http://localhost:9090/MyMVC/member/idDuplicateCheck.up
   
      // 웹브라우저의 주소 입력창에서
      // http://localhost:9090/MyMVC/member/idDuplicateCheck.up?userid=leess 와 같이 입력되었더라면 
      String uri = request.getRequestURI();
   //   System.out.println("~~~ 확인용 uri => " + uri);
      // ~~~ 확인용 uri => /MyMVC/member/idDuplicateCheck.up
      // ~~~ 확인용 uri => /MyMVC/test1.up
      // ~~~ 확인용 uri => /MyMVC/test/test2.up
      // ~~~ 확인용 uri => /MyMVC/test3.up
      
      if(uri.contains("/img/")) {
          return; // 여기서 바로 끝내면 톰캣이 실제 파일을 찾아줍니다.
      }
      
      String key = uri.substring(request.getContextPath().length());
      /* 
           /member/idDuplicateCheck.up
          /test1.up
          /test/test2.up
          /test3.up
      */
      
      AbstractController action = (AbstractController) cmdMap.get(key);
      
      if(action == null) {
         System.out.println(">>> "+ key +" 은 URI 패턴에 매핑된 클래스는 없습니다. <<<");
         // 
      }
      else {
         
         try {
            action.execute(request, response);
            
            boolean bool = action.isRedirect();
            String viewPage = action.getViewPage();
            
            if(!bool) {
               // viewPage 에 명기된 view단 페이지로 forward(dispatcher)를 하겠다는 말이다.
               // forward 되어지면 웹브라우저의 URL주소 변경되지 않고 그대로 이면서 화면에 보여지는 내용은 forward 되어지는 jsp 파일이다.
               // 또한 forward 방식은 forward 되어지는 페이지로 데이터를 전달할 수 있다는 것이다.
            
               if(viewPage != null) {
                  RequestDispatcher dispatcher = request.getRequestDispatcher(viewPage); 
                  dispatcher.forward(request, response);
               }
            }
            else {
               // viewPage 에 명기된 주소로 sendRedirect(웹브라우저의 URL주소 변경됨)를 하겠다는 말이다.
               // 즉, 단순히 페이지이동을 하겠다는 말이다. 
               // 암기할 내용은 sendRedirect 방식은 sendRedirect 되어지는 페이지로 데이터를 전달할 수가 없다는 것이다.
               
               if(viewPage != null) {
                  response.sendRedirect(viewPage);
               }
            }
            
         } catch (Exception e) {
            e.printStackTrace();
         }
         
      }
      
   }

   @Override
   protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      doGet(request, response);
   }

}
