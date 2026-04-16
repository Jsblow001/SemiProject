# 👓 SISEON (가상 안경 쇼핑몰)
> **세미프로젝트 1팀 (팀 프로젝트 - 4인)**
> 
> 안경 브랜드 **'CARIN'**을 모델로 한 쇼핑몰 서비스입니다. 본 프로젝트에서 저는 **관리자 운영 시스템**과 **사용자 정보 관리**의 백엔드 로직 전반을 담당하여 데이터 기반의 관리 환경을 구축했습니다.

<br>

## 1. 📅 프로젝트 기간
- 2025.11 - 2025.12 (약 2주)

<br>

## 2. 🛠 기술 스택

### 💻 Backend
<img src="https://img.shields.io/badge/Java%2017-007396?style=for-the-badge&logo=java&logoColor=white"/> <img src="https://img.shields.io/badge/Spring%20Boot-6DB33F?style=for-the-badge&logo=springboot&logoColor=white"/> <img src="https://img.shields.io/badge/Mybatis-black?style=for-the-badge&logo=apache&logoColor=white"/>

### 🗄️ Database
<img src="https://img.shields.io/badge/Oracle-F80000?style=for-the-badge&logo=oracle&logoColor=white"/>

### 🌐 Frontend
<img src="https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black"/> <img src="https://img.shields.io/badge/jQuery-0769AD?style=for-the-badge&logo=jquery&logoColor=white"/> <img src="https://img.shields.io/badge/Bootstrap%204-7952B3?style=for-the-badge&logo=bootstrap&logoColor=white"/> <img src="https://img.shields.io/badge/JSP-007396?style=for-the-badge&logo=java&logoColor=white"/> <img src="https://img.shields.io/badge/Chart.js-FF6384?style=for-the-badge&logo=chartdotjs&logoColor=white"/>

### 🔧 Tools
<img src="https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white"/> <img src="https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white"/>

<br>

## 👤 3. 담당 역할 및 기여도 (My Role)
- **관리자 시스템 (Back-end/Front-end)**
  - **수익 및 방문자 관리:** 실시간 매출 통계 및 일일 방문자 수 집계 로직 구현
  - **대시보드 시각화:** `Chart.js`를 활용한 데이터 시각화 및 운영 현황 요약 페이지 구축
  - **회원 등급 관리:** 구매 실적 기반 등급 자동 업데이트 및 권한 관리 시스템 설계
- **사용자 시스템 (Back-end/Front-end)**
  - **마이페이지:** 개인별 주문 현황, 활동 내역 조회 기능 구현
  - **회원 정보 수정:** 보안을 고려한 세션 기반 본인 인증 및 개인정보 수정 API 개발
- **시스템 연동:** 대시보드와 마이페이지 간 데이터 정합성을 위한 공통 DAO/Service 로직 최적화

<br>

## 🏗 4. DB 설계 (ERD)
- **설계 포인트:** 통계 데이터 추출을 위해 `VISIT_LOG`, `SALES_DATA`, `MEMBER_GRADE` 등의 테이블을 직접 설계하고 정규화를 진행하여 데이터 중복을 최소화했습니다.

<div align="center">
  <img src="https://via.placeholder.com/800x400.png?text=SISEON+Project+ERD" width="800" alt="SISEON ERD"/>
</div>

<br>

## 🚀 5. 핵심 기능 및 트러블슈팅

### ✅ 대용량 매출 데이터 가공 및 실시간 통계 (관리자)
- **문제 상황:** 누적된 주문 데이터를 매번 전체 조회할 경우 대시보드 로딩 속도가 저하되는 이슈 예상.
- **해결 방안:** Oracle의 집계 함수(`SUM`, `COUNT`)와 `GROUP BY`를 활용해 DB 레벨에서 1차 가공된 통계치만 불러오도록 쿼리를 최적화함.
- **결과:** 서버 부하를 줄이고, 관리자가 실시간으로 수익 현황을 파악할 수 있는 대시보드 구현.

### ✅ 사용자 데이터 보안 및 정보 수정 로직 (사용자)
- **문제 상황:** 회원 수정 시 잘못된 접근으로 인한 정보 유출 방지 및 변경된 항목만 효율적으로 업데이트해야 하는 과제 발생.
- **해결 방안:** 세션(Session) 정보를 기반으로 한 본인 인증 로직을 강화하고, MyBatis 동적 쿼리를 사용하여 변경된 필드만 선택적으로 업데이트하도록 구현.
- **결과:** 데이터 수정의 안정성을 확보하고 불필요한 DB 트랜잭션 발생을 차단함.

<br>

## 📺 6. 실행 화면
| 관리자 대시보드 (통계) | 수익 및 회원 등급 관리 | 사용자 마이페이지 |
| :---: | :---: | :---: |
| <img src="이미지주소" width="300"/> | <img src="이미지주소" width="300"/> | <img src="이미지주소" width="300"/> |
| Chart.js 기반 실시간 현황 | 데이터 정제 및 관리 로직 | 개인별 활동 정보 조회 |

<br>

## 📂 7. 프로젝트 구조 (My Part)
```text
/* 백엔드: 담당 모듈별 독립 패키지 구성 */
src/main/java/js
  ├── admin (관리자 시스템)
  │    ├── controller/AdminController.java  # 매출/방문자 통계 API 제어
  │    ├── service/AdminService.java        # 통계 데이터 가공 로직
  │    └── model/ (dao, vo)                 # MyBatis 인터페이스 및 객체 정의
  └── member (사용자 시스템)
       ├── controller/MemberController.java # 마이페이지/회원수정 API 제어
       └── service/MemberService.java        # 회원 정보 유효성 검사 및 처리 로직

/* 프론트엔드: MVC 패턴에 따른 View 분리 */
src/main/webapp/WEB-INF/views/js
  ├── admin (관리자 UI)
  │    ├── admin_main.jsp                   # 매출 시각화 대시보드 메인
  │    ├── admin_revenue.jsp                # 상세 수익 관리 페이지
  │    └── admin_member.jsp                 # 회원 등급 및 권한 관리
  └── member (사용자 UI)
       ├── mypage.jsp                       # 개인 활동 및 주문 내역 조회
       └── edit_profile.jsp                 # 비밀번호 확인 및 회원 정보 수정
