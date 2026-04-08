/* =====================================================================
   semi_project_final.sql  (최종 통합본)
   - SELECT / DESC / 조회용 쿼리 제거
   - ALTER로 구조 바꾼 내용은 최종 CREATE에 "반영" (ALTER 문 제거)
   - DROP 후 재생성된 테이블(tbl_store)은 "재생성된 최종 구조"로 CREATE만 제공
   ===================================================================== */

SHOW USER;

------------------------------------------------------------
-- 0) 회원등급
------------------------------------------------------------
CREATE TABLE tbl_grade
(
  grade_code   VARCHAR2(1)    NOT NULL,  -- 등급코드 (1:일반, 2:실버, 3:골드 등)
  grade_name   VARCHAR2(30)   NOT NULL,  -- 등급명
  min_amount   NUMBER DEFAULT 0 NOT NULL, -- 최소구매금액 (승급 기준)
  save_rate    NUMBER(3,2) DEFAULT 0.01,  -- 적립률 (예: 0.01=1%, 0.05=5%)

  CONSTRAINT pk_tbl_grade_code PRIMARY KEY(grade_code)
);

------------------------------------------------------------
-- 1) 회원
------------------------------------------------------------
CREATE TABLE tbl_member
(
  member_id          VARCHAR2(40)  NOT NULL,  -- 회원아이디(PK)
  name               VARCHAR2(30)  NOT NULL,  -- 성명
  passwd             VARCHAR2(200) NOT NULL,  -- 비밀번호 (SHA-256 암호화 대상)
  email              VARCHAR2(200) NOT NULL,  -- 이메일 (AES-256 암호화/복호화 대상)
  mobile             VARCHAR2(200),           -- 연락처 (AES-256 암호화/복호화 대상)
  postcode           VARCHAR2(5)   NOT NULL,  -- 우편번호
  address            VARCHAR2(200) NOT NULL,  -- 주소
  detailaddress      VARCHAR2(200) NOT NULL,  -- 상세주소
  extraaddress       VARCHAR2(200),           -- 주소참고항목
  gender             VARCHAR2(1),             -- 성별 남:1 / 여:2
  birthday           VARCHAR2(10),            -- 생년월일
  point              NUMBER DEFAULT 0,        -- 포인트
  registerday        DATE DEFAULT SYSDATE,    -- 가입일자
  lastpwdchangedate  DATE DEFAULT SYSDATE,    -- 마지막 암호 변경일
  status             NUMBER(1) DEFAULT 1 NOT NULL, -- 1:사용가능 / 0:탈퇴
  grade_code         VARCHAR2(1) DEFAULT '1' NOT NULL, -- 등급코드

  CONSTRAINT pk_tbl_member_userid PRIMARY KEY(member_id),
  CONSTRAINT uq_tbl_member_email UNIQUE(email),
  CONSTRAINT ck_tbl_member_gender CHECK (gender IN ('1','2')),
  CONSTRAINT ck_tbl_member_status CHECK (status IN (0,1)),
  CONSTRAINT fk_tbl_member_grade_code FOREIGN KEY(grade_code)
    REFERENCES tbl_grade(grade_code)
);

------------------------------------------------------------
-- 2) 로그인 기록 + 시퀀스
------------------------------------------------------------
CREATE TABLE tbl_loginhistory
(
  historyno      NUMBER,
  fk_member_id   VARCHAR2(40) NOT NULL,
  logindate      DATE DEFAULT SYSDATE NOT NULL,
  clientip       VARCHAR2(20) NOT NULL,

  CONSTRAINT pk_tbl_loginhistory PRIMARY KEY(historyno),
  CONSTRAINT fk_tbl_loginhistory_fk_member_id FOREIGN KEY(fk_member_id)
    REFERENCES tbl_member(member_id)
);

CREATE SEQUENCE seq_historyno
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

------------------------------------------------------------
-- 3) 배송주소 + 시퀀스
------------------------------------------------------------
CREATE TABLE tbl_address
(
  addr_id       NUMBER        NOT NULL,  -- 배송주소ID (PK)
  fk_member_id  VARCHAR2(40)  NOT NULL,  -- 회원아이디 (FK)
  postcode      VARCHAR2(5)   NOT NULL,
  address       VARCHAR2(200) NOT NULL,
  detailaddress VARCHAR2(200) NOT NULL,
  extraaddress  VARCHAR2(200),

  CONSTRAINT pk_tbl_address_id PRIMARY KEY(addr_id),
  CONSTRAINT fk_tbl_address_member_id FOREIGN KEY(fk_member_id)
    REFERENCES tbl_member(member_id)
);

CREATE SEQUENCE seq_addr_id
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

------------------------------------------------------------
-- 4) 카테고리 + 시퀀스
------------------------------------------------------------
CREATE TABLE tbl_category
(
  category_id    NUMBER        NOT NULL,
  category_code  VARCHAR2(50)  NOT NULL,
  category_name  VARCHAR2(100) NOT NULL,

  CONSTRAINT pk_tbl_category PRIMARY KEY(category_id),
  CONSTRAINT uq_tbl_category_code UNIQUE(category_code)
);

CREATE SEQUENCE seq_category_id
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

------------------------------------------------------------
-- 5) 제품스펙 + 시퀀스
------------------------------------------------------------
CREATE TABLE tbl_product_spec
(
  spec_id    NUMBER       NOT NULL,
  spec_name  VARCHAR2(50) NOT NULL,
  color      VARCHAR2(50) NOT NULL,

  CONSTRAINT pk_tbl_product_spec PRIMARY KEY(spec_id),
  CONSTRAINT uq_tbl_product_spec_name UNIQUE(spec_name)
);

CREATE SEQUENCE seq_spec_id
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

------------------------------------------------------------
-- 6) 제품 + (pimage 컬럼 최종 반영) + 시퀀스
--    (원문: seq_product_id 생성 후 drop, seq_product 사용)
------------------------------------------------------------
CREATE TABLE tbl_product
(
  product_id          NUMBER        NOT NULL,
  fk_category_id      NUMBER        NOT NULL,
  product_name        VARCHAR2(200) NOT NULL,
  sale_price          NUMBER        NOT NULL,
  list_price          NUMBER        NOT NULL,
  stock               NUMBER DEFAULT 0,
  fk_spec_id          NUMBER        NOT NULL,
  product_description CLOB,
  stock_date          DATE          NOT NULL,
  point               NUMBER DEFAULT 0,
  pimage              VARCHAR2(200),          -- (원문 ALTER 반영)

  CONSTRAINT pk_tbl_product_product_id PRIMARY KEY(product_id),
  CONSTRAINT fk_tbl_product_category_id FOREIGN KEY(fk_category_id)
    REFERENCES tbl_category(category_id),
  CONSTRAINT fk_tbl_product_spec_id FOREIGN KEY(fk_spec_id)
    REFERENCES tbl_product_spec(spec_id)
);

-- 최종 사용 시퀀스(원문: seq_product_id DROP 후 seq_product 사용)
CREATE SEQUENCE seq_product
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

------------------------------------------------------------
-- 7) 주문 + 시퀀스
------------------------------------------------------------
CREATE TABLE tbl_order
(
  odrcode        NUMBER       NOT NULL, -- 주문코드 (PK)
  fk_member_id   VARCHAR2(40) NOT NULL, -- 회원아이디 (FK)
  fk_addr_id     NUMBER       NOT NULL, -- 배송주소ID (FK)
  odrtotalprice  NUMBER DEFAULT 0 NOT NULL,
  odrtotalpoint  NUMBER DEFAULT 0 NOT NULL,
  odrdate        DATE DEFAULT SYSDATE,
  payment_status NUMBER(1) DEFAULT 0 NOT NULL, -- 0:미결제, 1:결제완료

  CONSTRAINT pk_tbl_order_odrcode PRIMARY KEY(odrcode),
  CONSTRAINT fk_tbl_order_member_id FOREIGN KEY(fk_member_id)
    REFERENCES tbl_member(member_id),
  CONSTRAINT fk_tbl_order_addr_id FOREIGN KEY(fk_addr_id)
    REFERENCES tbl_address(addr_id)
);

CREATE SEQUENCE seq_odrcode
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

------------------------------------------------------------
-- 8) 주문상세 + 시퀀스
------------------------------------------------------------
CREATE TABLE tbl_order_detail
(
  odrdetailno    NUMBER      NOT NULL,
  fk_odrcode     NUMBER      NOT NULL,
  fk_product_id  NUMBER      NOT NULL,
  odrqty         NUMBER      NOT NULL,
  odrprice       NUMBER      NOT NULL,
  deliverystatus NUMBER(1) DEFAULT 1 NOT NULL, -- 1:주문완료, 2:배송중, 3:배송완료 등
  deliverydate   DATE,

  CONSTRAINT pk_tbl_order_detail_no PRIMARY KEY(odrdetailno),
  CONSTRAINT fk_tbl_order_detail_odrcode FOREIGN KEY(fk_odrcode)
    REFERENCES tbl_order(odrcode),
  CONSTRAINT fk_tbl_order_detail_product_id FOREIGN KEY(fk_product_id)
    REFERENCES tbl_product(product_id)
);

CREATE SEQUENCE seq_odrdetailno
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

------------------------------------------------------------
-- 9) 장바구니 + 시퀀스
------------------------------------------------------------
CREATE TABLE tbl_cart
(
  cart_id       NUMBER        NOT NULL,
  fk_member_id  VARCHAR2(40)  NOT NULL,
  fk_product_id NUMBER        NOT NULL,
  cart_date     DATE DEFAULT SYSDATE,
  cart_qty      NUMBER DEFAULT 1 NOT NULL,

  CONSTRAINT pk_tbl_cart_id PRIMARY KEY(cart_id),
  CONSTRAINT fk_tbl_cart_member_id FOREIGN KEY(fk_member_id)
    REFERENCES tbl_member(member_id),
  CONSTRAINT fk_tbl_cart_product_id FOREIGN KEY(fk_product_id)
    REFERENCES tbl_product(product_id)
);

CREATE SEQUENCE seq_cart_id
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

------------------------------------------------------------
-- 10) 관리자
------------------------------------------------------------
CREATE TABLE tbl_admin
(
  admin_id  VARCHAR2(40)  NOT NULL,
  passwd    VARCHAR2(200) NOT NULL,
  email     VARCHAR2(200) NOT NULL,

  CONSTRAINT pk_tbl_admin_id PRIMARY KEY(admin_id),
  CONSTRAINT uq_tbl_admin_email UNIQUE(email)
);

------------------------------------------------------------
-- 11) 공지 + 시퀀스
------------------------------------------------------------
CREATE TABLE tbl_notice
(
  notice_id   NUMBER         NOT NULL,
  fk_admin_id VARCHAR2(40)   NOT NULL,
  subject     VARCHAR2(200)  NOT NULL,
  regdate     DATE DEFAULT SYSDATE,
  updatedate  DATE DEFAULT SYSDATE,
  content     NVARCHAR2(2000) NOT NULL,
  is_fixed    NUMBER(1) DEFAULT 0 NOT NULL,

  CONSTRAINT pk_tbl_notice_id PRIMARY KEY(notice_id),
  CONSTRAINT fk_tbl_notice_admin_id FOREIGN KEY(fk_admin_id)
    REFERENCES tbl_admin(admin_id)
);

CREATE SEQUENCE seq_notice_id
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

------------------------------------------------------------
-- 12) QnA + 시퀀스
------------------------------------------------------------
CREATE TABLE tbl_qna
(
  qna_id       NUMBER        NOT NULL,
  fk_member_id VARCHAR2(40)  NOT NULL,
  fk_admin_id  VARCHAR2(40),
  subject      VARCHAR2(200) NOT NULL,
  regdate      DATE DEFAULT SYSDATE,
  updatedate   DATE DEFAULT SYSDATE,
  content      NVARCHAR2(2000) NOT NULL,
  is_secret    NUMBER(1) DEFAULT 0 NOT NULL,
  answer       CLOB,

  CONSTRAINT pk_tbl_qna_id PRIMARY KEY(qna_id),
  CONSTRAINT fk_tbl_qna_admin_id FOREIGN KEY(fk_admin_id)
    REFERENCES tbl_admin(admin_id),
  CONSTRAINT fk_tbl_qna_member_id FOREIGN KEY(fk_member_id)
    REFERENCES tbl_member(member_id)
);

CREATE SEQUENCE seq_qna_id
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

------------------------------------------------------------
-- 13) QnA 첨부파일 + 시퀀스 + FK(ON DELETE CASCADE)
------------------------------------------------------------
CREATE TABLE tbl_qna_file
(
  qna_file_id   NUMBER        NOT NULL,
  fk_qna_id     NUMBER        NOT NULL,
  org_filename  VARCHAR2(255) NOT NULL,
  save_filename VARCHAR2(255) NOT NULL,
  file_size     NUMBER,
  content_type  VARCHAR2(100),
  regdate       DATE DEFAULT SYSDATE NOT NULL,

  CONSTRAINT pk_qna_file PRIMARY KEY(qna_file_id),
  CONSTRAINT fk_qna_file_qna FOREIGN KEY(fk_qna_id)
    REFERENCES tbl_qna(qna_id)
    ON DELETE CASCADE
);

CREATE SEQUENCE seq_qna_file_id
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

------------------------------------------------------------
-- 14) QnA 댓글 + 시퀀스
------------------------------------------------------------
CREATE TABLE qna_comment
(
  comment_id   NUMBER PRIMARY KEY,
  fk_qna_id    NUMBER       NOT NULL,
  fk_member_id VARCHAR2(40) NOT NULL,
  content      NVARCHAR2(1000) NOT NULL,
  regdate      DATE DEFAULT SYSDATE NOT NULL,

  CONSTRAINT fk_qna_comment_qna FOREIGN KEY(fk_qna_id)
    REFERENCES tbl_qna(qna_id)
);

CREATE SEQUENCE seq_qna_comment
START WITH 1
INCREMENT BY 1;

------------------------------------------------------------
-- 15) 제품리뷰 + 시퀀스 (최종: review_title, praise_keywords 포함)
------------------------------------------------------------
CREATE TABLE tbl_product_review
(
  review_id       NUMBER        NOT NULL,
  fk_product_id   NUMBER        NOT NULL,
  fk_member_id    VARCHAR2(40)  NOT NULL,
  review_date     DATE DEFAULT SYSDATE NOT NULL,
  rating          NUMBER(1)     NOT NULL,
  review_content  VARCHAR2(1000) NOT NULL,

  review_title     VARCHAR2(200)  NOT NULL, -- (원문: ADD 후 NOT NULL로 변경 → 최종 NOT NULL 반영)
  praise_keywords  VARCHAR2(400),           -- (원문: ADD)

  CONSTRAINT pk_tbl_product_review PRIMARY KEY(review_id),
  CONSTRAINT fk_tbl_review_product_id FOREIGN KEY(fk_product_id)
    REFERENCES tbl_product(product_id),
  CONSTRAINT fk_tbl_review_member_id FOREIGN KEY(fk_member_id)
    REFERENCES tbl_member(member_id),
  CONSTRAINT ck_tbl_review_rating CHECK (rating BETWEEN 1 AND 5),
  CONSTRAINT uq_tbl_review_member_product UNIQUE (fk_product_id, fk_member_id)
);

CREATE SEQUENCE seq_review_id
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

------------------------------------------------------------
-- 16) 리뷰이미지 + 시퀀스
------------------------------------------------------------
CREATE TABLE tbl_review_image
(
  review_image_id NUMBER NOT NULL,
  fk_review_id    NUMBER NOT NULL,
  image_filename  VARCHAR2(255),

  CONSTRAINT pk_tbl_review_image PRIMARY KEY(review_image_id),
  CONSTRAINT fk_tbl_review_image_review_id FOREIGN KEY(fk_review_id)
    REFERENCES tbl_product_review(review_id)
);

CREATE SEQUENCE seq_review_image_id
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

------------------------------------------------------------
-- 17) 제품 좋아요/싫어요
------------------------------------------------------------
CREATE TABLE tbl_product_like
(
  fk_product_id NUMBER       NOT NULL,
  fk_member_id  VARCHAR2(40) NOT NULL,

  CONSTRAINT fk_tbl_product_like_product_id FOREIGN KEY(fk_product_id)
    REFERENCES tbl_product(product_id),
  CONSTRAINT fk_tbl_product_like_member_id FOREIGN KEY(fk_member_id)
    REFERENCES tbl_member(member_id)
);

CREATE TABLE tbl_product_dislike
(
  fk_product_id NUMBER       NOT NULL,
  fk_member_id  VARCHAR2(40) NOT NULL,

  CONSTRAINT fk_tbl_product_dislike_product_id FOREIGN KEY(fk_product_id)
    REFERENCES tbl_product(product_id),
  CONSTRAINT fk_tbl_product_dislike_member_id FOREIGN KEY(fk_member_id)
    REFERENCES tbl_member(member_id)
);

------------------------------------------------------------
-- 18) 제품추가이미지 + 시퀀스
------------------------------------------------------------
CREATE TABLE tbl_product_image
(
  image_id       NUMBER NOT NULL,
  fk_product_id  NUMBER NOT NULL,
  image_filename VARCHAR2(255),

  CONSTRAINT pk_tbl_product_image PRIMARY KEY(image_id),
  CONSTRAINT fk_tbl_product_image_product_id FOREIGN KEY(fk_product_id)
    REFERENCES tbl_product(product_id)
);

CREATE SEQUENCE seq_image_id
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

------------------------------------------------------------
-- 19) 찜 + 시퀀스
------------------------------------------------------------
CREATE TABLE tbl_wishlist
(
  wish_id    NUMBER        NOT NULL,
  member_id  VARCHAR2(20)  NOT NULL,
  product_id NUMBER        NOT NULL,
  wish_date  DATE DEFAULT SYSDATE,

  CONSTRAINT pk_tbl_wishlist PRIMARY KEY(wish_id),
  CONSTRAINT fk_wishlist_member_id FOREIGN KEY(member_id)
    REFERENCES tbl_member(member_id),
  CONSTRAINT fk_wishlist_p_id FOREIGN KEY(product_id)
    REFERENCES tbl_product(product_id)
);

CREATE SEQUENCE seq_wishlist_id
START WITH 1
INCREMENT BY 1
NOMAXVALUE;

------------------------------------------------------------
-- 20) 리뷰 관리자 댓글 + 시퀀스 (원문 그대로 유지: fk_admin_id → tbl_member 참조)
------------------------------------------------------------
CREATE TABLE tbl_review_comment
(
  review_comment_id NUMBER        NOT NULL,
  fk_review_id      NUMBER        NOT NULL,
  fk_admin_id       VARCHAR2(40)  NOT NULL,
  comment_content   VARCHAR2(1000) NOT NULL,
  comment_date      DATE DEFAULT SYSDATE NOT NULL,
  status            NUMBER(1) DEFAULT 1 NOT NULL,

  CONSTRAINT pk_tbl_review_comment PRIMARY KEY (review_comment_id),
  CONSTRAINT fk_tbl_review_comment_review FOREIGN KEY (fk_review_id)
    REFERENCES tbl_product_review(review_id),
  CONSTRAINT fk_tbl_review_comment_admin FOREIGN KEY (fk_admin_id)
    REFERENCES tbl_member(member_id),
  CONSTRAINT uq_tbl_review_comment_review UNIQUE (fk_review_id),
  CONSTRAINT ck_tbl_review_comment_status CHECK (status IN (0,1))
);

CREATE SEQUENCE seq_review_comment_id
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

------------------------------------------------------------
-- 21) 리뷰 신고 + 시퀀스 + 인덱스
------------------------------------------------------------
CREATE SEQUENCE seq_review_report
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE tbl_review_report
(
  report_id       NUMBER        NOT NULL,
  fk_review_id    NUMBER        NOT NULL,
  fk_member_id    VARCHAR2(40)  NOT NULL,
  report_content  VARCHAR2(500) NOT NULL,
  report_date     DATE DEFAULT SYSDATE NOT NULL,

  CONSTRAINT pk_tbl_review_report PRIMARY KEY(report_id),
  CONSTRAINT fk_report_review FOREIGN KEY(fk_review_id)
    REFERENCES tbl_product_review(review_id),
  CONSTRAINT fk_report_member FOREIGN KEY(fk_member_id)
    REFERENCES tbl_member(member_id)
);

CREATE INDEX idx_report_reviewid ON tbl_review_report(fk_review_id);
CREATE INDEX idx_report_date     ON tbl_review_report(report_date);
CREATE INDEX idx_report_memberid ON tbl_review_report(fk_member_id);

------------------------------------------------------------
-- 22) 방문자 로그 + 시퀀스
------------------------------------------------------------
CREATE TABLE visitor_log
(
  v_idx       NUMBER PRIMARY KEY,
  v_date      DATE DEFAULT SYSDATE,
  v_ip        VARCHAR2(50),
  member_id   VARCHAR2(50) NULL,
  last_access DATE DEFAULT SYSDATE
);

CREATE SEQUENCE seq_visitor_log
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

------------------------------------------------------------
-- 23) (예약) SMS 로그 / 지점 / 예약 / 슬롯막기 / 지도마커 / 지도 시퀀스
--     - tbl_store: DROP 후 재생성된 "최종 구조"만 CREATE 제공
--     - tbl_reservation: DROP/ADD/제약 변경 최종 반영(ALTER 제거)
--     - tbl_map: 원문 UPDATE에서 쓰는 tel/hours/reserveUrl 컬럼을 최종 CREATE에 포함
------------------------------------------------------------

-- 23-1) SMS 로그
CREATE TABLE tbl_sms_log
(
  sms_id            NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,

  fk_store_id        NUMBER NULL,
  fk_reservation_id  NUMBER NULL,

  mobile            VARCHAR2(20) NOT NULL,
  sms_type          VARCHAR2(20) DEFAULT 'ADMIN' NOT NULL,
  content           VARCHAR2(500),
  provider_group_id VARCHAR2(100),
  success_count     NUMBER DEFAULT 0 NOT NULL,
  error_count       NUMBER DEFAULT 0 NOT NULL,
  send_status       VARCHAR2(10) NOT NULL,
  provider_json     CLOB,

  created_at        TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL
);

-- 23-2) 지점(예약용 최종)
CREATE TABLE tbl_store
(
  store_id    NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  store_name  VARCHAR2(50) NOT NULL
);

select * from tbl_map;
select * from tbl_store;

ALTER TABLE tbl_store
DROP COLUMN address;
ALTER TABLE tbl_store
DROP COLUMN phone;
ALTER TABLE tbl_store
DROP COLUMN created_at;

select * from tbl_reservation;
select * from tbl_sms_log;
select * from tbl_block_slot;

-- 23-3) 예약(최종)
CREATE TABLE tbl_reservation
(
  reservation_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,

  fk_store_id       NUMBER       NOT NULL,
  fk_member_userid  VARCHAR2(50) NULL,

  guest_name    VARCHAR2(50)  NOT NULL,
  guest_phone   VARCHAR2(20)  NOT NULL,

  reason_code   VARCHAR2(20)  NOT NULL,         -- VISION / AS / FULLSERVICE
  duration_min  NUMBER(3)     NOT NULL,         -- 30 or 60

  start_at      TIMESTAMP     NOT NULL,
  end_at        TIMESTAMP     NOT NULL,

  message       VARCHAR2(1000),

  status        VARCHAR2(20) DEFAULT 'CONFIRMED' NOT NULL,
  cancelled_at  TIMESTAMP NULL,

  created_at    TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
  updated_at    TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,

  CONSTRAINT fk_res_store FOREIGN KEY (fk_store_id)
    REFERENCES tbl_store(store_id),

  CONSTRAINT fk_tbl_reservation_userid FOREIGN KEY (fk_member_userid)
    REFERENCES tbl_member(member_id),

  CONSTRAINT ck_res_reason   CHECK (reason_code IN ('VISION','AS','FULLSERVICE')),
  CONSTRAINT ck_res_duration CHECK (duration_min IN (30,60)),
  CONSTRAINT ck_res_status   CHECK (status IN ('CONFIRMED','CANCELLED')),
  CONSTRAINT ck_res_time     CHECK (end_at > start_at)
);

-- 23-4) 슬롯막기
CREATE TABLE tbl_block_slot
(
  block_id     NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,

  fk_store_id  NUMBER    NOT NULL,
  start_at     TIMESTAMP NOT NULL,
  end_at       TIMESTAMP NOT NULL,

  memo         VARCHAR2(300),
  created_at   TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,

  CONSTRAINT fk_block_store FOREIGN KEY (fk_store_id)
    REFERENCES tbl_store(store_id),
  CONSTRAINT ck_block_time CHECK (end_at > start_at)
);

-- 23-5) 지도 마커(최종: tel/hours/reserveUrl 포함)
CREATE TABLE tbl_map
(
  storeID       VARCHAR2(20)  NOT NULL,
  storeName     VARCHAR2(100) NOT NULL,
  storeUrl      VARCHAR2(200),
  storeImg      VARCHAR2(200) NOT NULL,
  storeAddress  VARCHAR2(200) NOT NULL,
  lat           NUMBER        NOT NULL,
  lng           NUMBER        NOT NULL,
  zindex        NUMBER        NOT NULL,

  tel           VARCHAR2(30),
  hours         VARCHAR2(100),
  reserveUrl    VARCHAR2(200),

  CONSTRAINT pk_tbl_map PRIMARY KEY(storeID),
  CONSTRAINT uq_tbl_map_zindex UNIQUE(zindex)
);

CREATE SEQUENCE seq_tbl_map_zindex
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

------------------------------------------------------------
-- 24) 더미/시드 데이터 (원문에 있던 INSERT/UPDATE/DELETE/PLSQL만 정리)
------------------------------------------------------------

-- 24-1) 관리자 더미
INSERT INTO tbl_admin VALUES ('jehyung', 'hyung9599', '2134@naver.com');

-- 24-2) 공지 더미
INSERT INTO tbl_notice VALUES (1, 'jehyung', '고정',   SYSDATE, SYSDATE, '공지사항고정글', 1);
INSERT INTO tbl_notice VALUES (2, 'jehyung', '테스트1', SYSDATE, SYSDATE, '공지사항',      0);
INSERT INTO tbl_notice VALUES (3, 'jehyung', '테스트2', SYSDATE, SYSDATE, '공지사항',      0);

COMMIT;

-- 24-3) 제품스펙 더미
INSERT INTO tbl_product_spec (spec_id, spec_name, color) VALUES (seq_spec_id.nextval, 'HIT',  'red');
INSERT INTO tbl_product_spec (spec_id, spec_name, color) VALUES (seq_spec_id.nextval, 'NEW',  'blue');
INSERT INTO tbl_product_spec (spec_id, spec_name, color) VALUES (seq_spec_id.nextval, 'BEST', 'green');
COMMIT;

-- 24-4) 카테고리 더미(원문: ID 고정값 사용)
INSERT INTO tbl_category (category_id, category_code, category_name) VALUES (1, '10001', '선글라스');
INSERT INTO tbl_category (category_id, category_code, category_name) VALUES (2, '20001', '안경');
INSERT INTO tbl_category (category_id, category_code, category_name) VALUES (3, '30001', '악세사리');
INSERT INTO tbl_category (category_id, category_code, category_name) VALUES (4, '40001', '콜라보');
COMMIT;

-- 24-5) 마이페이지 주문조회용 주소/주문/주문상세 더미(원문 흐름 유지)
INSERT INTO tbl_address (addr_id, fk_member_id, postcode, address, detailaddress)
VALUES (seq_addr_id.nextval, 'java', '12345', '서울시 테스트구', '101동');
COMMIT;

INSERT INTO tbl_order
(odrcode, fk_member_id, fk_addr_id, odrtotalprice, odrtotalpoint, odrdate, payment_status)
VALUES
(seq_odrcode.nextval, 'java', 2, 55000, 0, SYSDATE, 1);
COMMIT;

INSERT INTO tbl_order_detail
(odrdetailno, fk_odrcode, fk_product_id, odrqty, odrprice, deliverystatus, deliverydate)
VALUES
(seq_odrdetailno.nextval, 2, 22, 1, 55000, 1, NULL);
COMMIT;

-- 24-6) 주문 더미(오늘/어제/3일전)
INSERT INTO tbl_order (odrcode, fk_member_id, fk_addr_id, odrtotalprice, payment_status, odrdate)
VALUES (101, 'java', 2, 55000, 1, SYSDATE);

INSERT INTO tbl_order (odrcode, fk_member_id, fk_addr_id, odrtotalprice, payment_status, odrdate)
VALUES (102, 'java', 2, 32000, 1, SYSDATE - 1);

INSERT INTO tbl_order (odrcode, fk_member_id, fk_addr_id, odrtotalprice, payment_status, odrdate)
VALUES (103, 'java', 2, 78000, 1, SYSDATE - 3);

COMMIT;

-- 24-7) 방문자 로그 더미(원문 유지)
INSERT INTO visitor_log (v_idx, v_ip, v_date, last_access, member_id)
VALUES (seq_visitor_log.NEXTVAL, '192.168.0.10', SYSDATE-1, SYSDATE-1, 'admin');
INSERT INTO visitor_log (v_idx, v_ip, v_date, last_access, member_id)
VALUES (seq_visitor_log.NEXTVAL, '192.168.0.10', SYSDATE-1, SYSDATE-1, 'admin');
INSERT INTO visitor_log (v_idx, v_ip, v_date, last_access, member_id)
VALUES (seq_visitor_log.NEXTVAL, '192.168.0.10', SYSDATE-1, SYSDATE-1, 'admin');

INSERT INTO visitor_log (v_idx, v_ip, v_date, last_access, member_id)
VALUES (seq_visitor_log.NEXTVAL, '192.168.0.20', SYSDATE-1, SYSDATE-1, NULL);
INSERT INTO visitor_log (v_idx, v_ip, v_date, last_access, member_id)
VALUES (seq_visitor_log.NEXTVAL, '192.168.0.40', SYSDATE-1, SYSDATE-1, NULL);
INSERT INTO visitor_log (v_idx, v_ip, v_date, last_access, member_id)
VALUES (seq_visitor_log.NEXTVAL, '192.168.0.50', SYSDATE-1, SYSDATE-1, NULL);

INSERT INTO visitor_log (v_idx, v_ip, v_date, last_access, member_id)
VALUES (seq_visitor_log.NEXTVAL, '192.168.0.30', SYSDATE-1, SYSDATE-1, 'testuser');

INSERT INTO visitor_log (v_idx, v_ip, v_date, last_access, member_id)
VALUES (seq_visitor_log.NEXTVAL, '192.168.0.51', SYSDATE, SYSDATE, NULL);

COMMIT;

BEGIN
  FOR i IN 1..7 LOOP
    FOR j IN 1..TRUNC(DBMS_RANDOM.VALUE(1, 5)) LOOP
      INSERT INTO visitor_log (v_idx, v_ip, v_date, last_access, member_id)
      VALUES (seq_visitor_log.NEXTVAL,
              '127.0.0.' || i,
              SYSDATE - i,
              SYSDATE - i,
              CASE WHEN MOD(j, 2) = 0 THEN 'admin' ELSE NULL END);
    END LOOP;
  END LOOP;
  COMMIT;
END;
/

-- 24-8) 리뷰/공지 정리용(원문에 있던 delete)
DELETE FROM tbl_notice;
COMMIT;

-- 24-9) 회원등급 코드 일괄 수정(원문에 있던 update)
UPDATE tbl_member
SET grade_code = 1;
COMMIT;

-- 24-10) (예약/지도) 더미(원문 유지)
INSERT INTO tbl_store(store_name) VALUES ('매장1');
INSERT INTO tbl_store(store_name) VALUES ('매장2');
INSERT INTO tbl_store(store_name) VALUES ('매장3');
COMMIT;

INSERT INTO tbl_map(storeID, storeName, storeUrl, storeImg, storeAddress, lat, lng, zindex)
VALUES('store1','SISEON 도산','https://place.map.kakao.com/1883323900','siseon_dosan.png',
       '서울 강남구 압구정로46길 50 하우스도산 1-3층',37.5253703709931,127.035679523304,1);

INSERT INTO tbl_map(storeID, storeName, storeUrl, storeImg, storeAddress, lat, lng, zindex)
VALUES('store2','SISEON 압구정점','https://place.map.kakao.com/26617120','siseon_apgujeong.png',
       '서울 강남구 압구정로 343 갤러리아백화점 WEST관 4층',37.5284754434309,127.040052671773,2);

INSERT INTO tbl_map(storeID, storeName, storeUrl, storeImg, storeAddress, lat, lng, zindex)
VALUES('store3','SISEON 홍대점','https://place.map.kakao.com/1741888863','siseon_hongdae.png',
       '서울 마포구 독막로7길 54',37.5500570559597,126.920123023419,3);

COMMIT;

UPDATE tbl_store
SET store_name='매장1'
WHERE store_id = 1;

UPDATE tbl_map
SET tel='02-0000-0001',
    hours='11:00 - 20:00 (30분 단위 예약)',
    reserveUrl='/reservation.sp?storeId=1'
WHERE storeID = 'store1';

UPDATE tbl_map
SET tel='02-0000-0002',
    hours='11:00 - 20:00 (30분 단위 예약)',
    reserveUrl='/reservation.sp?storeId=2'
WHERE storeID = 'store2';

UPDATE tbl_map
SET tel='02-0000-0003',
    hours='11:00 - 20:00 (30분 단위 예약)',
    reserveUrl='/reservation.sp?storeId=3'
WHERE storeID = 'store3';

UPDATE tbl_map
SET storeName = 'SISEON 도산점'
WHERE storeID = 'store1';

COMMIT;

-- 24-11) 예약 reason_code 보정(원문에 있던 update)
UPDATE tbl_reservation
SET reason_code = 'FULLSERVICE'
WHERE reason_code = 'FITTING';
COMMIT;







-----------------------------------------------------------------------------------------------

























