# SemiProject
세미프로젝트1팀

# 👓 SISEON (가상 안경 쇼핑몰)
> **안경 및 선글라스 브랜드 'CARIN'을 모델로 한 사용자 중심 가상 쇼핑몰 서비스**

<br>

## 1. 📅 프로젝트 기간
- 2026.01 - 2026.02 (약 4주)

<br>

## 2. 🛠 기술 스택

| 분류 | 기술 스택 |
| :--- | :--- |
| **Backend** | <img src="https://img.shields.io/badge/Java%2017-007396?style=flat-square&logo=java&logoColor=white"/> <img src="https://img.shields.io/badge/Spring%20Boot-6DB33F?style=flat-square&logo=springboot&logoColor=white"/> <img src="https://img.shields.io/badge/Mybatis-black?style=flat-square&logo=apache&logoColor=white"/> |
| **Database** | <img src="https://img.shields.io/badge/Oracle-F80000?style=flat-square&logo=oracle&logoColor=white"/> |
| **Frontend** | <img src="https://img.shields.io/badge/JavaScript-F7DF1E?style=flat-square&logo=javascript&logoColor=black"/> <img src="https://img.shields.io/badge/jQuery-0769AD?style=flat-square&logo=jquery&logoColor=white"/> <img src="https://img.shields.io/badge/JSP-007396?style=flat-square&logo=java&logoColor=white"/> |
| **Design** | CARIN Brand Identity (Logo, Model Images) 활용 |

<br>

## 3. 🏗 DB 설계 (ERD)
- **핵심 로직:** 브랜드 아이덴티티 유지를 위한 상품 카테고리화와 효율적인 주문 이력 관리.
- **설계 포인트:** 안경/선글라스 등 제품 성격에 따른 동적 속성 관리가 가능하도록 상품 테이블을 설계하고, 관리자 통계 기능을 위해 결제 데이터를 정규화했습니다.

<div align="center">
  <img src="https://via.placeholder.com/800x400.png?text=SISEON+Project+ERD" width="800" alt="SISEON ERD"/>
</div>

<br>

## 🚀 4. 핵심 기능 및 트러블슈팅

### ✅ Mybatis 동적 쿼리를 통한 다중 필터링
- **문제 상황:** 신상품, 안경, 선글라스 등 다양한 카테고리별로 각기 다른 상품 조회 로직이 필요하여 코드 중복 발생 우려.
- **해결 방안:** Mybatis의 `<if>`, `<choose>` 태그를 활용한 **동적 SQL(Dynamic SQL)**을 도입하여 하나의 인터페이스로 다중 검색 및 필터링 기능 구현.
- **결과:** 검색 로직의 유지보수 효율을 높이고 데이터베이스 접근 횟수를 최적화함.

### ✅ 브랜드 아이덴티티를 살린 UI 및 통계 시각화
- **문제 상황:** 단순 텍스트 위주의 리스트로는 브랜드 특유의 세련된 느낌과 판매 현황을 전달하기 부족함.
- **해결 방안:** `CARIN` 브랜드의 실제 모델 컷과 로고를 레이아웃에 반영하고, 관리자 페이지에 `Chart.js`를 연동하여 카테고리별 판매 비중 시각화.
- **결과:** 사용자에게는 일관된 브랜드 경험을 제공하고, 관리자에게는 직관적인 운영 데이터를 제공함.

<br>

## 📺 5. 실행 화면
| 메인 쇼핑몰 UI | 상품 상세 및 필터 | 관리자 통계 페이지 |
| :---: | :---: | :---: |
| <img src="https://via.placeholder.com/300x200.png?text=Main+Shop" width="300"/> | <img src="https://via.placeholder.com/300x200.png?text=Product+Filter" width="300"/> | <img src="https://via.placeholder.com/300x200.png?text=Admin+Stat" width="300"/> |
| 감도 높은 모델 컷 중심 메인 | Mybatis 기반 다중 필터링 | 매출 및 판매 비중 시각화 |

<br>

## 📂 6. 프로젝트 구조
```text
src/main/java
  ├── com.siseon.admin      # 상품 등록 및 매출 대시보드 관리
  ├── com.siseon.product    # 카테고리별 상품 조회 및 필터링 로직
  ├── com.siseon.order      # 장바구니 및 결제 주문 처리
  └── com.siseon.config     # Mybatis 및 DB 커넥션 설정



