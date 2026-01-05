show user;

select *
from tab;

-- 마이페이지 내 주문 조회 확인 위한 더미데이터 삽입
desc tbl_order;
desc tbl_order_detail;

select * from tbl_member;
select * from tbl_order;


select *
from tbl_member
where member_id = 'java';

-- 주소 삽입x
select *
from tbl_address;

SELECT addr_id
FROM tbl_address
WHERE fk_member_id = 'java';

-- 주소 더미 데이터 넣기
INSERT INTO tbl_address
(addr_id, fk_member_id, postcode, address, detailaddress)
VALUES
(seq_addr_id.nextval, 'java', '12345', '서울시 테스트구', '101동');

COMMIT;

-- 주문 더미 데이터 넣기
INSERT INTO tbl_order
(odrcode, fk_member_id, fk_addr_id, odrtotalprice, odrtotalpoint, odrdate, payment_status)
VALUES
(seq_odrcode.nextval, 'java', 2,              -- 위에서 확인한 addr_id
  55000, 0, SYSDATE, 1               -- 1: 결제완료
);

-- 커밋 꼭 하기 !!!!
COMMIT;

select * from tbl_order;

-- 주문번호 (2)
SELECT MAX(odrcode)
FROM tbl_order
WHERE fk_member_id = 'java';

-- 상품 ID (22, 안경 11) - 넣을 거임
SELECT product_id, product_name
FROM tbl_product
WHERE pimage IS NOT NULL;

-- 주문상세 더미 데이터 넣기
INSERT INTO tbl_order_detail
(odrdetailno, fk_odrcode, fk_product_id, odrqty, odrprice, deliverystatus, deliverydate)
VALUES
(seq_odrdetailno.nextval,
  2,      -- 위에서 확인한 ODRCODE
  22,       -- 실제 존재하는 product_id
  1,
  55000,
  1,       -- 1: 주문완료
  NULL
);

select * from tbl_order_detail;

COMMIT;


-- 주문
SELECT *
FROM tbl_order
WHERE fk_member_id = 'java';

-- 주문상세
SELECT *
FROM tbl_order_detail
WHERE fk_odrcode = 2;






select * from tbl_product;

SELECT product_id, pimage
FROM tbl_product
WHERE pimage IS NOT NULL;


------- 회원등급 테이블 --------
create table tbl_grade
(grade_code   varchar2(1)               not null  -- 등급코드 (1:일반, 2:실버, 3:골드 등)
,grade_name   varchar2(30)              not null  -- 등급명
,min_amount   number default 0          not null  -- 최소구매금액 (승급 기준)
,save_rate    number(3,2) default 0.01      -- 적립률 (예: 0.01 은 1%, 0.05 는 5%)
,constraint PK_tbl_grade_code primary key(grade_code)
);
-- Table tbl_grade 이(가) 생성되었습니다.

------- 회원 테이블 --------
create table tbl_member
(member_id          varchar2(40)    not null        -- 회원아이디(PK)
,name               varchar2(30)    not null        -- 성명
,passwd             varchar2(200)   not null        -- 비밀번호 (SHA-256 암호화 대상)
,email              varchar2(200)   not null        -- 이메일 (AES-256 암호화/복호화 대상)
,mobile             varchar2(200)                   -- 연락처 (AES-256 암호화/복호화 대상)
,postcode           varchar2(5)     not null    -- 우편번호
,address            varchar2(200)   not null    -- 주소
,detailaddress      varchar2(200)   not null    -- 상세주소
,extraaddress       varchar2(200)                    -- 주소참고항목
,gender             varchar2(1)                     -- 성별   남자:1  / 여자:2
,birthday           varchar2(10)                    -- 생년월일
,point              number default 0                -- 포인트
,registerday        date default sysdate            -- 가입일자 
,lastpwdchangedate  date default sysdate            -- 마지막으로 암호를 변경한 날짜  
,status             number(1) default 1 not null    -- 회원탈퇴유무   1: 사용가능(가입중) / 0:사용불능(탈퇴)
,grade_code         varchar2(1)dEFAULT '1' NOT NULL -- 등급 코드 1, 2, 3 ....
,constraint PK_tbl_member_userid primary key(member_id)
,constraint UQ_tbl_member_email  unique(email)
,constraint CK_tbl_member_gender check( gender in('1','2') )
,constraint CK_tbl_member_status check( status in(0,1) )
,constraint FK_tbl_member_grade_code foreign key(grade_code) references tbl_grade(grade_code)
);


------- 로그인기록 테이블 --------
create table tbl_loginhistory
(historyno      number
,fk_member_id   varchar2(40)           not null      -- 회원아이디
,logindate      date default sysdate   not null      -- 로그인되어진 접속날짜및시간
,clientip       varchar2(20)           not null
,constraint  PK_tbl_loginhistory primary key(historyno)
,constraint FK_tbl_loginhistory_fk_member_id foreign key (fk_member_id) references tbl_member(member_id)
);
-- Table TBL_LOGINHISTORY이(가) 생성되었습니다.


------- 로그인기록 시퀀스 --------
create sequence seq_historyno
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;
-- Sequence SEQ_HISTORYNO이(가) 생성되었습니다.


------- 배송주소 테이블 --------
create table tbl_address
(addr_id       number               not null    -- 배송주소ID (PK)
,fk_member_id  varchar2(40)         not null    -- 회원아이디 (FK)
,postcode      varchar2(5)          not null    -- 우편번호
,address       varchar2(200)        not null    -- 주소
,detailaddress varchar2(200)        not null    -- 상세주소
,extraaddress  varchar2(200)                    -- 주소참고항목
,constraint PK_tbl_address_id primary key(addr_id)
,constraint FK_tbl_address_member_id foreign key(fk_member_id) references tbl_member(member_id)
);


------- 배송주소 시퀀스 --------
create sequence seq_addr_id
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;


------- 주문 테이블 --------
create table tbl_order
(odrcode         number                     not null    -- 주문코드 (PK)
,fk_member_id    varchar2(40)               not null    -- 회원아이디 (FK)
,fk_addr_id      number                     not null    -- 배송주소ID (FK)
,odrtotalprice   number    default 0        not null    -- 주문총액
,odrtotalpoint   number    default 0        not null    -- 주문총포인트
,odrdate         date      default sysdate              -- 주문일자
,payment_status  number(1) default 0        not null    -- 결제상태 (0:미결제, 1:결제완료)
,constraint PK_tbl_order_odrcode primary key(odrcode)
,constraint FK_tbl_order_member_id foreign key(fk_member_id) references tbl_member(member_id)
,constraint FK_tbl_order_addr_id foreign key(fk_addr_id) references tbl_address(addr_id)
);


------- 주문 시퀀스 --------
create sequence seq_odrcode
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;


------- 주문상세 테이블 --------
create table tbl_order_detail
(odrdetailno    number                  not null    -- 주문상세코드 (PK)
,fk_odrcode     number                  not null    -- 주문코드 (FK)
,fk_product_id  number                  not null    -- 제품번호 (FK)
,odrqty         number                  not null    -- 주문량
,odrprice       number                  not null    -- 주문가격
,deliverystatus number(1)  default 1    not null    -- 배송상태 (1:주문완료, 2:배송중, 3:배송완료 등)
,deliverydate   date                                -- 배송완료일자
,constraint PK_tbl_order_detail_no primary key(odrdetailno)
,constraint FK_tbl_order_detail_odrcode foreign key(fk_odrcode) references tbl_order(odrcode)
,constraint FK_tbl_order_detail_product_id foreign key(fk_product_id) references tbl_product(product_id)
);


------- 주문상세 시퀀스 --------
create sequence seq_odrdetailno
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;


------- 장바구니 테이블 --------
create table tbl_cart
(cart_id       number                           not null    -- 장바구니ID (PK)
,fk_member_id  varchar2(40)                     not null    -- 회원아이디 (FK)
,fk_product_id number                           not null    -- 제품번호 (FK)
,cart_date     date         default sysdate                 -- 담긴 일자
,cart_qty      number       default 1           not null    -- 주문량
,constraint PK_tbl_cart_id primary key(cart_id)
,constraint FK_tbl_cart_member_id foreign key(fk_member_id) references tbl_member(member_id)
,constraint FK_tbl_cart_product_id foreign key(fk_product_id) references tbl_product(product_id) 
);


------- 장바구니 시퀀스 --------
create sequence seq_cart_id
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;


------- 관리자 테이블 --------
create table tbl_admin
(admin_id      varchar2(40)         not null -- 관리자ID (PK)
,passwd        varchar2(200)        not null -- 비밀번호
,email         varchar2(200)        not null -- 이메일
,constraint PK_tbl_admin_id primary key(admin_id)
,constraint UQ_tbl_admin_email  unique(email)
);


------- 공지사항 테이블 --------
create table tbl_notice
(notice_id     number                               not null    -- 공지사항ID (PK)
,fk_admin_id   varchar2(40)                         not null    -- 관리자ID (FK)
,subject       varchar2(200)                        not null    -- 제목
,regdate       date             default sysdate                 -- 작성날짜
,updatedate    date             default sysdate                 -- 수정날짜
,content       Nvarchar2(2000)                      not null    -- 본문
,is_fixed      number(1)        default 0           not null    -- 고정글 여부 (0:일반, 1:고정)
,constraint PK_tbl_notice_id primary key(notice_id)
,constraint FK_tbl_notice_admin_id foreign key(fk_admin_id) references tbl_admin(admin_id)
);


------- 공지사항 시퀀스 --------
create sequence seq_notice_id 
start with 1 
increment by 1 
nomaxvalue
nominvalue
nocycle
nocache;


------- QnA 테이블 --------
create table tbl_qna
(qna_id        number                       not null    -- QnAID (PK)
,fk_member_id  varchar2(40)                 not null    -- 회원아이디 (FK)
,fk_admin_id   varchar2(40)                             -- 관리자ID (FK)
,subject       varchar2(200)                not null    -- 제목
,regdate       date      default sysdate                -- 작성날짜
,updatedate    date      default sysdate                -- 수정날짜
,content       Nvarchar2(2000)              not null    -- 본문
,is_secret     number(1) default 0          not null    -- 비밀글 설정 (0:공개, 1:비밀)
,answer        clob                                     -- 답변
,constraint PK_tbl_qna_id primary key(qna_id)
,constraint FK_tbl_qna_admin_id foreign key(fk_admin_id) references tbl_admin(admin_id)
,constraint FK_tbl_qna_member_id foreign key(fk_member_id) references tbl_member(member_id)
);


------- QnA 시퀀스 --------
create sequence seq_qna_id
start with 1 
increment by 1 
nomaxvalue
nominvalue
nocycle
nocache;

------- 제품 테이블 --------
create Table tbl_product
(product_id     number        not null        -- 제품번호 (PK)
,fk_category_id number        not null        -- 카테고리대분류번호 (FK)
,product_name   varchar2(200) not null        -- 제품명
,sale_price     number        not null        -- 제품판매가
,list_price     number        not null        -- 제품정가
,stock          number        Default 0       -- 제품재고량
,fk_spec_id     number        not null        -- 스펙번호 (FK)
,product_description CLOB                     -- 제품설명
,stock_date     date          not null        -- 제품입고일자
,point          number default 0              -- 포인트점수
,constraint PK_tbl_product_product_id primary key(product_id)
,constraint FK_tbl_product_category_id foreign key(fk_category_id) references tbl_category(category_id)
,constraint FK_tbl_product_spec_id foreign key(fk_spec_id) references tbl_product_spec(spec_id)
);


------- 제품 시퀀스 --------
create sequence seq_product_id
start with 1 
increment by 1 
nomaxvalue
nominvalue
nocycle
nocache;


------- 카테고리 테이블 --------
create table tbl_category 
(category_id     number         not null        -- 카테고리 대분류번호 (PK)
,category_code   varchar2(50)   not null        -- 카테고리 코드 (SUN, GLASS 등)
,category_name   varchar2(100)  not null        -- 카테고리명 (선글라스, 안경 등)
,constraint pk_tbl_category primary key (category_id)
,constraint uq_tbl_category_code unique (category_code)
);


------- 카테고리 시퀀스 --------
create sequence seq_category_id
start with 1 
increment by 1 
nomaxvalue
nominvalue
nocycle
nocache;


------- 제품스펙 테이블 --------
create table tbl_product_spec 
(spec_id     number          not null  -- 스펙번호 (PK)
,spec_name   varchar2(50)    not null  -- 스펙명 (UNIQUE)
,color       varchar2(50)    not null  -- 색상
,constraint pk_tbl_product_spec primary key (spec_id)
,constraint uq_tbl_product_spec_name unique (spec_name)
);


------- 제품스펙 시퀀스 --------
create sequence seq_spec_id
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

------- 제품리뷰 테이블 --------
create table tbl_product_review 
(review_id       number               not null   -- 리뷰작성번호 (PK)
,fk_product_id   number               not null   -- 제품번호 (FK)
,fk_member_id    varchar2(40)         not null   -- 회원아이디 (FK)
,review_date     date default sysdate not null   -- 작성일자
,rating          number(1)            not null   -- 평점 (1~5)
,review_content  varchar2(1000)       not null   -- 리뷰내용
,constraint pk_tbl_product_review primary key (review_id)
,constraint fk_tbl_review_product_id foreign key (fk_product_id) references tbl_product(product_id)
,constraint fk_tbl_review_member_id foreign key (fk_member_id) references tbl_member(member_id)
,constraint CK_tbl_review_rating check (rating between 1 and 5)
,constraint UQ_tbl_review_member_product unique (fk_product_id, fk_member_id)
);

------- 제품리뷰 시퀀스 --------
create sequence seq_review_id
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;


------- 리뷰이미지 테이블 --------
create table tbl_review_image 
(review_image_id   number         not null  -- 리뷰이미지고유번호 (PK)
,fk_review_id      number         not null  -- 리뷰작성번호 (FK)
,image_filename    varchar2(255)             -- 이미지파일명
,constraint pk_tbl_review_image primary key (review_image_id)
,constraint fk_tbl_review_image_review_id foreign key (fk_review_id) references tbl_product_review(review_id)
);


------- 리뷰이미지 시퀀스 --------
create sequence seq_review_image_id 
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

------- 제품좋아요 테이블 --------
create table tbl_product_like 
(fk_product_id   number         not null  -- 제품번호 (FK)
,fk_member_id    varchar2(40)   not null  -- 회원아이디 (FK)
,constraint fk_tbl_product_like_product_id foreign key (fk_product_id) references tbl_product(product_id)
,constraint fk_tbl_product_like_member_id foreign key (fk_member_id) references tbl_member(member_id)
);


------- 제품싫어요 테이블 --------
create table tbl_product_dislike 
(fk_product_id   number         not null   -- 제품번호 (FK)
,fk_member_id    varchar2(40)   not null   -- 회원아이디 (FK)
,constraint fk_tbl_product_dislike_product_id foreign key (fk_product_id) references tbl_product(product_id)
,constraint fk_tbl_product_dislike_member_id foreign key (fk_member_id) references tbl_member(member_id)
);

------- 제품추가이미지 테이블 --------
create table tbl_product_image 
(image_id        number         not null  -- 이미지번호 (PK)
,fk_product_id   number         not null  -- 제품번호 (FK)
,image_filename  varchar2(255)            -- 이미지파일명
,constraint pk_tbl_product_image primary key (image_id)
,constraint fk_tbl_product_image_product_id foreign key (fk_product_id) references tbl_product(product_id)
);


------- 제품추가이미지 시퀀스 --------
create sequence seq_image_id 
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;


------- 매장찾기 테이블 --------
create table tbl_store
(store_id        number             not null    -- 매장아이디 (PK)
,store_name      varchar2(200)      not null    -- 매장명
,store_url       varchar2(500)                  -- 매장 홈페이지 주소
,store_image     varchar2(255)                  -- 매장소개 이미지 파일명
,store_address   varchar2(300)      not null    -- 매장 주소
,store_tel       varchar2(50)                   -- 매장 전화번호
,latitude        number(10,7)       not null    -- 위도
,longitude       number(10,7)       not null    -- 경도
,z_index         number             not null    -- 제트인덱스 (정렬용)
,constraint PK_tbl_store_id primary key(store_id)
,constraint UQ_tbl_store_z_index unique (z_index)
);


------- 매장시퀀스 --------
create sequence seq_store_id
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

-- 찜하기 테이블 --
CREATE TABLE tbl_wishlist (
    wish_id     number NOT NULL,         -- 찜 고유 번호
    member_id      varchar2(20) NOT NULL,   -- 사용자 아이디 (FK)
    product_id  number NOT NULL,         -- 상품 번호 (FK)
    wish_date   date default sysdate,    -- 찜한 날짜
    constraint pk_tbl_wishlist primary key(wish_id),
    constraint fk_wishlist_member_id foreign key(member_id) references tbl_member(member_id),
    constraint fk_wishlist_p_id foreign key(product_id) references tbl_product(product_id)
);

CREATE SEQUENCE seq_wishlist_id
START WITH 1
INCREMENT BY 1
NOMAXVALUE;

commit;

select *
from tab;


select *
from TBL_PRODUCT;

ALTER TABLE tbl_product ADD (pimage varchar2(200)); -- 이미지 파일명 저장용

commit;


select *
from TBL_member;


CREATE SEQUENCE seq_product -- _id가 없는 이름으로 시퀀스 생성
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;


commit;

DROP SEQUENCE seq_product_id;

commit;

INSERT INTO tbl_product_spec (spec_id, spec_name, color) 
VALUES (seq_spec_id.nextval, 'HIT', 'red');

INSERT INTO tbl_product_spec (spec_id, spec_name, color) 
VALUES (seq_spec_id.nextval, 'NEW', 'blue');

INSERT INTO tbl_product_spec (spec_id, spec_name, color) 
VALUES (seq_spec_id.nextval, 'BEST', 'green');

COMMIT;

SELECT * FROM tbl_category;

INSERT INTO tbl_category (category_id, category_code, category_name) 
VALUES (1, '10001', '선글라스');

INSERT INTO tbl_category (category_id, category_code, category_name) 
VALUES (2, '20001', '안경');

INSERT INTO tbl_category (category_id, category_code, category_name) 
VALUES (3, '30001', '악세사리');

INSERT INTO tbl_category (category_id, category_code, category_name) 
VALUES (4, '40001', '콜라보');

COMMIT;

select *
from TBL_PRODUCT
order by stock_date desc;

SELECT pimage FROM tbl_product WHERE product_id = 4;

commit;



select *
from tbl_member;


select *
from tab;

show user;

-- 오늘 데이터
INSERT INTO TBL_ORDER (odrcode, fk_member_id, fk_addr_id, odrtotalprice, payment_status, odrdate)
VALUES (101, 'java', 2, 55000, 1, SYSDATE);

-- 어제 데이터
INSERT INTO TBL_ORDER (odrcode, fk_member_id, fk_addr_id, odrtotalprice, payment_status, odrdate)
VALUES (102, 'java', 2, 32000, 1, SYSDATE - 1);

-- 3일 전 데이터
INSERT INTO TBL_ORDER (odrcode, fk_member_id, fk_addr_id, odrtotalprice, payment_status, odrdate)
VALUES (103, 'java', 2, 78000, 1, SYSDATE - 3);


