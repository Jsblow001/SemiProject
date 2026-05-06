# 👓 SISEON (가상 안경 쇼핑몰)
> **세미프로젝트 1팀 (팀 프로젝트 - 4인)**
> 
> 안경 브랜드 **'CARIN'**을 모델로 한 쇼핑몰 서비스입니다. 프레임워크 없이 **순수 Java Servlet과 JDBC**를 사용하여 웹 애플리케이션의 동작 원리를 직접 구현했으며, 저는 **관리자 운영 시스템**과 **사용자 정보 관리**의 백엔드 로직 전반을 담당했습니다.

<br>

## 1. 📅 프로젝트 기간
- 2025.11 - 2025.12 (약 2주)

<br>

## 2. 🛠 기술 스택

### 💻 Backend
<img src="https://img.shields.io/badge/Java%2017-007396?style=for-the-badge&logo=java&logoColor=white"/> <img src="https://img.shields.io/badge/Servlet-007396?style=for-the-badge&logo=oracle&logoColor=white"/> <img src="https://img.shields.io/badge/JSP%20(SSR)-007396?style=for-the-badge&logo=java&logoColor=white"/> <img src="https://img.shields.io/badge/JDBC-007396?style=for-the-badge&logo=oracle&logoColor=white"/>

### 🗄️ Database
<img src="https://img.shields.io/badge/Oracle-F80000?style=for-the-badge&logo=oracle&logoColor=white"/>

### 🌐 Frontend
<img src="https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black"/> <img src="https://img.shields.io/badge/jQuery-0769AD?style=for-the-badge&logo=jquery&logoColor=white"/> <img src="https://img.shields.io/badge/Bootstrap%204-7952B3?style=for-the-badge&logo=bootstrap&logoColor=white"/> <img src="https://img.shields.io/badge/Chart.js-FF6384?style=for-the-badge&logo=chartdotjs&logoColor=white"/>

### 🔧 Tools & Server
<img src="https://img.shields.io/badge/Apache%20Tomcat%209-F8DC75?style=for-the-badge&logo=apachetomcat&logoColor=black"/> <img src="https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white"/> <img src="https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white"/>

<br>

## 👤 3. 담당 역할 및 기여도 (My Role)
- **MVC Model 2 기반 관리자 시스템 구축**
  - **수익 및 방문자 관리:** Servlet을 활용한 실시간 매출 통계 및 일일 방문자 수 집계 로직 구현
  - **대시보드 시각화:** `Chart.js` 연동을 통해 통계 데이터를 시각적으로 표현하는 Admin 메인 페이지 전담
  - **회원 등급 시스템:** 구매 실적에 따른 등급 자동 업데이트 트리거 및 권한 관리 로직 설계
- **사용자 정보 및 활동 관리**
  - **마이페이지:** 개인별 주문 현황 및 활동 내역 조회를 위한 다중 테이블 Join 쿼리 및 로직 구현
  - **보안 강화 회원수정:** 세션(Session) 기반의 본인 인증 절차를 거친 정보 수정 API 개발
- **기초 설계:** 데이터 정합성을 위한 DAO(Data Access Object) 패턴 적용 및 공통 DB Connection 풀 관리

<br>

## 🏗 4. DB 설계 (ERD)
- **설계 포인트:** 통계 데이터 추출을 위해 `VISIT_LOG`, `SALES_DATA`, `MEMBER_GRADE` 등의 테이블을 설계했으며, **정규화**를 통해 데이터 중복을 방지하고 무결성을 확보했습니다.

<div align="center">
  <img src="https://via.placeholder.com/800x400.png?text=SISEON+Project+ERD" width="800" alt="SISEON ERD"/>
</div>

<br>

## 🚀 5. 핵심 기능 및 트러블슈팅

### ✅ 순수 JDBC를 활용한 데이터 처리 최적화 (관리자)
- **문제 상황:** 대량의 주문 내역 조회 시 매번 커넥션을 생성하여 발생하는 성능 저하 우려.
- **해결 방안:** DB Connection Pool 개념을 적용하고, Oracle의 집계 함수(`SUM`, `COUNT`)와 `GROUP BY`를 활용해 필요한 데이터만 조회하는 최적화된 SQL 작성.
- **결과:** 서버 부하를 줄이고 관리자 대시보드의 응답 속도를 개선함.

### ✅ Servlet 세션 관리를 통한 보안 강화 (사용자)
- **문제 상황:** 회원 정보 수정 시 URL 조작 등을 통한 타인의 정보 접근 가능성 차단 필요.
- **해결 방안:** HttpServletRequest의 세션 정보를 엄격히 체크하는 로직을 Controller(Servlet) 단계에 구현하여 본인 인증이 완료된 사용자만 접근 가능하도록 설계.
- **결과:** 보안 안정성을 확보하고 데이터 수정 프로세스의 신뢰도 향상.

<br>

## 📂 7. 프로젝트 구조 (My Part)
```text
/* Backend: MVC Model 2 (Servlet/DAO 패턴) */
src/main/java/js
  ├── admin (관리자 시스템)
  │    ├── controller/AdminController.java  # HttpServlet 상속, 요청 매핑
  │    ├── service/AdminService.java        # 비즈니스 로직 처리
  │    └── model/ (AdminDAO, AdminVO)       # JDBC 기반 DB 접근 및 데이터 객체
  └── member (사용자 시스템)
       ├── controller/MemberController.java # 회원 수정 및 마이페이지 제어
       └── model/ (MemberDAO, MemberVO)     # 회원 데이터 처리 및 유효성 검증

/* Frontend: View (JSP/CSS/JS) */
src/main/webapp/WEB-INF/views/js
  ├── admin/          # 관리자용 JSP (대시보드, 매출 통계, 회원 관리)
  └── member/         # 사용자용 JSP (마이페이지, 정보 수정)

/* Settings */
WebContent/WEB-INF/web.xml  # 서블릿 매핑 및 프로젝트 설정
