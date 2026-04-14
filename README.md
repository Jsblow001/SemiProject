# 👓 SISEON (가상 안경 쇼핑몰)
> **세미프로젝트 1팀 (팀 프로젝트 - 4인)**
> 
> 안경 및 선글라스 브랜드 **'CARIN'**을 모델로 한 사용자 중심 가상 쇼핑몰 서비스입니다. 실무적인 데이터 흐름을 이해하기 위해 상품 관리부터 매출 통계까지 아우르는 풀스택 시스템을 구축했습니다.

<br>

## 1. 📅 프로젝트 기간
- 2025.11 - 2025.12 (약 2주)

<br>

## 2. 🛠 기술 스택

| 분류 | 기술 스택 |
| :--- | :--- |
| **Backend** | <img src="https://img.shields.io/badge/Java%2017-007396?style=flat-square&logo=java&logoColor=white"/> <img src="https://img.shields.io/badge/Spring%20Boot-6DB33F?style=flat-square&logo=springboot&logoColor=white"/> <img src="https://img.shields.io/badge/Mybatis-black?style=flat-square&logo=apache&logoColor=white"/> |
| **Database** | <img src="https://img.shields.io/badge/Oracle-F80000?style=flat-square&logo=oracle&logoColor=white"/> |
| **Frontend** | <img src="https://img.shields.io/badge/JavaScript-F7DF1E?style=flat-square&logo=javascript&logoColor=black"/> <img src="https://img.shields.io/badge/jQuery-0769AD?style=flat-square&logo=jquery&logoColor=white"/> <img src="https://img.shields.io/badge/JSP-007396?style=flat-square&logo=java&logoColor=white"/> |
| **Tools** | <img src="https://img.shields.io/badge/Git-F05032?style=flat-square&logo=git&logoColor=white"/> <img src="https://img.shields.io/badge/GitHub-181717?style=flat-square&logo=github&logoColor=white"/> |

<br>

## 👤 3. 담당 역할 및 기여도 (My Role)
- **파트:** - **관리자 :** 매출 통계 대시보드 및 수익 관리 시스템 총괄
            - **사용자 :** 마이페이지 구축 및 회원 정보 수정 로직 구현
- **기여도:** 25% (4인 협업)
- **주요 업무:**
  - **데이터 시각화:** `Chart.js`를 연동하여 지점별/기간별 매출 데이터를 한눈에 파악할 수 있는 관리자 대시보드 구현
  - **수익 관리 로직:** Mybatis 집계 함수를 활용하여 복잡한 주문 데이터를 정제하고 실시간 수익 분석 기능 설계
  - **회원 정보 관리:** 사용자 보안을 고려한 회원 정보 수정 로직 및 개인별 주문 이력 조회가 가능한 마이페이지 구축
  - **백엔드 인프라:** 프로젝트 공통 DB 커넥션 풀 설정 및 Mybatis XML/Interface 환경 구성 주도

<br>

## 🏗 4. DB 설계 (ERD)
- **설계 포인트:** 안경/선글라스 등 제품 성격에 따른 동적 속성 관리가 가능하도록 상품 테이블을 설계하고, 관리자 통계 기능을 위해 주문/결제 데이터를 정규화했습니다.

<div align="center">
  <img src="https://via.placeholder.com/800x400.png?text=SISEON+Project+ERD" width="800" alt="SISEON ERD"/>
</div>

<br>

## 🚀 5. 핵심 기능 및 트러블슈팅

### ✅ Mybatis 동적 쿼리를 통한 다중 필터링
- **문제 상황:** 신상품, 안경, 선글라스 등 다양한 카테고리별로 각기 다른 상품 조회 로직이 필요하여 코드 중복 발생 우려.
- **해결 방안:** Mybatis의 `<if>`, `<choose>` 태그를 활용한 **동적 SQL(Dynamic SQL)**을 도입하여 하나의 Mapper 인터페이스로 다중 검색 및 필터링 기능 통합.
- **결과:** 검색 로직의 유지보수 효율을 높이고 데이터베이스 접근 횟수를 최적화함.

### ✅ 관리자 페이지 매출 통계 시각화
- **문제 상황:** 방대한 주문 이력 데이터를 텍스트로만 확인 시 매출 흐름을 한눈에 파악하기 어려움.
- **해결 방안:** Oracle의 `GROUP BY`와 집계 함수를 활용해 기간별 매출 데이터를 정제하고, `Chart.js`를 연동하여 시각화된 통계 대시보드 구축.
- **결과:** 관리자의 운영 의사결정 편의성을 대폭 향상시킴.

<br>

## 📺 6. 실행 화면
| 메인 쇼핑몰 UI | 상품 상세 및 필터 | 관리자 통계 페이지 |
| :---: | :---: | :---: |
| <img src="https://via.placeholder.com/300x200.png?text=Main+Shop" width="300"/> 
| <img src="https://via.placeholder.com/300x200.png?text=Product+Filter" width="300"/>
| <img src="https://via.placeholder.com/300x200.png?text=Admin+Stat" width="300"/> |
| 브랜드 아이덴티티 적용 메인 | Mybatis 기반 다중 필터링 | Chart.js 기반 매출 시각화 |

<br>

## 📂 7. 프로젝트 구조
```예시)
src/main/java
  ├── com.siseon.admin      # 상품 등록 및 매출 대시보드 관리 (담당 파트)
  ├── com.siseon.product    # 카테고리별 상품 조회 및 필터링 로직 (담당 파트)
  ├── com.siseon.order      # 장바구니 및 결제 주문 처리
  └── com.siseon.config     # Mybatis 및 DB 환경 설정 (담당 파트)




