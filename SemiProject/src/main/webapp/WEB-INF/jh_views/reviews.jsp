<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    if (request.getAttribute("heroReviews") == null) {

        // =========================
        // 1) 상단 "인플루언서 리뷰" 캐러셀 데이터 (최대 8개 가능)
        // =========================
        java.util.List<java.util.Map<String,Object>> heroReviews = new java.util.ArrayList<>();
        java.util.Map<String,Object> h;

        // hero: image(큰사진), rating(별점), title(짧은글), code(제품코드)
        h = new java.util.HashMap<>();
        h.put("image","img/review/r1.jpg");
        h.put("rating",5);
        h.put("title","[카린에이트×조은진님 협찬 리뷰] 카키 그레이 컬러가 오묘하면서도 빈티지한 매력");
        h.put("code","RONENN_R_C2");
        heroReviews.add(h);

        h = new java.util.HashMap<>();
        h.put("image","img/review/r2.jpg");
        h.put("rating",5);
        h.put("title","[카린에이트×하율님 협찬 리뷰] 어떤 룩에도 찰떡! 데일리로 손이 자주 가요");
        h.put("code","ARNO_R_C3");
        heroReviews.add(h);

        h = new java.util.HashMap<>();
        h.put("image","img/review/r3.jpg");
        h.put("rating",5);
        h.put("title","[카린에이트×OOO님 협찬 리뷰] 디테일이 예뻐서 포인트 주기 좋아요");
        h.put("code","DENSE_C5");
        heroReviews.add(h);
        
        h = new java.util.HashMap<>();
        h.put("image","img/review/r1.jpg");
        h.put("rating",5);
        h.put("title","[카린에이트×조은진님 협찬 리뷰] 카키 그레이 컬러가 오묘하면서도 빈티지한 매력");
        h.put("code","RONENN_R_C2");
        heroReviews.add(h);

        h = new java.util.HashMap<>();
        h.put("image","img/review/r2.jpg");
        h.put("rating",5);
        h.put("title","[카린에이트×하율님 협찬 리뷰] 어떤 룩에도 찰떡! 데일리로 손이 자주 가요");
        h.put("code","ARNO_R_C3");
        heroReviews.add(h);

        h = new java.util.HashMap<>();
        h.put("image","img/review/r3.jpg");
        h.put("rating",5);
        h.put("title","[카린에이트×OOO님 협찬 리뷰] 디테일이 예뻐서 포인트 주기 좋아요");
        h.put("code","DENSE_C5");
        heroReviews.add(h);
        
        h = new java.util.HashMap<>();
        h.put("image","img/review/r1.jpg");
        h.put("rating",5);
        h.put("title","[카린에이트×조은진님 협찬 리뷰] 카키 그레이 컬러가 오묘하면서도 빈티지한 매력");
        h.put("code","RONENN_R_C2");
        heroReviews.add(h);

        h = new java.util.HashMap<>();
        h.put("image","img/review/r2.jpg");
        h.put("rating",5);
        h.put("title","[카린에이트×하율님 협찬 리뷰] 어떤 룩에도 찰떡! 데일리로 손이 자주 가요");
        h.put("code","ARNO_R_C3");
        heroReviews.add(h);

        h = new java.util.HashMap<>();
        h.put("image","img/review/r3.jpg");
        h.put("rating",5);
        h.put("title","[카린에이트×OOO님 협찬 리뷰] 디테일이 예뻐서 포인트 주기 좋아요");
        h.put("code","DENSE_C5");
        heroReviews.add(h);
        
        h = new java.util.HashMap<>();
        h.put("image","img/review/r1.jpg");
        h.put("rating",5);
        h.put("title","[카린에이트×조은진님 협찬 리뷰] 카키 그레이 컬러가 오묘하면서도 빈티지한 매력");
        h.put("code","RONENN_R_C2");
        heroReviews.add(h);

        h = new java.util.HashMap<>();
        h.put("image","img/review/r2.jpg");
        h.put("rating",5);
        h.put("title","[카린에이트×하율님 협찬 리뷰] 어떤 룩에도 찰떡! 데일리로 손이 자주 가요");
        h.put("code","ARNO_R_C3");
        heroReviews.add(h);

        h = new java.util.HashMap<>();
        h.put("image","img/review/r3.jpg");
        h.put("rating",5);
        h.put("title","[카린에이트×OOO님 협찬 리뷰] 디테일이 예뻐서 포인트 주기 좋아요");
        h.put("code","DENSE_C5");
        heroReviews.add(h);

        request.setAttribute("heroReviews", heroReviews);
        
     	// ✅ 상단 hero 캐러셀 페이지 수 (3개씩)
        request.setAttribute(
            "heroPageCount",
            (heroReviews.size() + 2) / 3
        );
    }

     // 2) rankProducts 더미는 없을 때만
     if (request.getAttribute("rankProducts") == null) {
    	 
	     
	     // =========================
	     // 2) 중단 캐러셀용 카드 데이터 (한 페이지 4개, 총 3페이지 예시 = 12개)
	     // =========================
	     java.util.List<java.util.Map<String,Object>> rankProducts = new java.util.ArrayList<>();
	     java.util.Map<String,Object> rp;
	     java.util.List<java.util.Map<String,Object>> miniReviews;
	     java.util.Map<String,Object> mr;
	
	     // 카드 12개 만들어두면 4개씩 3페이지로 넘어감
	     String[] codes = {"ROY_O_C3","LIKA_O_C4","VIVIR_C4","VIVIR_C3","ARNO_R_C3","RONENN_R_C2","DENSE_C5","AIR_2_R_C2","HEIZE_C2","RONENN_S_C2","RENAR_S_C2","VIVIR_C_C4"};
	     String[] mains = {"img/product/p1.png","img/product/p2.png","img/product/p3.png","img/product/p4.png","img/product/p5.png","img/product/p6.png","img/product/p7.png","img/product/p8.png","img/product/p1.png","img/product/p2.png","img/product/p3.png","img/product/p4.png"};
	     double[] ratings = {5.0,5.0,5.0,5.0,4.9,5.0,5.0,5.0,5.0,5.0,5.0,5.0};
	     int[] counts = {59,14,5,5,200,39,45,8,7,45,6,5};
	
	     for(int idx=0; idx<codes.length; idx++){
	         rp = new java.util.HashMap<>();
	         rp.put("code", codes[idx]);
	         rp.put("main", mains[idx]);
	         rp.put("rating", ratings[idx]);
	         rp.put("count", counts[idx]);
	
	         // 아래쪽 미니 리뷰 3줄(썸네일+텍스트)
	         miniReviews = new java.util.ArrayList<>();
	
	         mr = new java.util.HashMap<>();
	         mr.put("thumb","img/review/r1.jpg");
	         mr.put("text","너무 예뻐요! 포인트로 쓰기에 딱 좋네요.");
	         miniReviews.add(mr);
	
	         mr = new java.util.HashMap<>();
	         mr.put("thumb","img/review/r2.jpg");
	         mr.put("text","색감이 은은해서 데일리로 매일 착용중입니다.");
	         miniReviews.add(mr);
	
	         mr = new java.util.HashMap<>();
	         mr.put("thumb","img/review/r3.jpg");
	         mr.put("text","가볍고 착용감 좋아요. 포장도 꼼꼼했습니다.");
	         miniReviews.add(mr);
	
	         rp.put("reviews", miniReviews);
	         rankProducts.add(rp);
	     }
	
	     request.setAttribute("rankProducts", rankProducts);
	  	// ✅ EL 호환성 최강: size() 호출/복잡한 산술을 EL에서 안 하도록 숫자를 미리 세팅
	     request.setAttribute("rankSize", rankProducts.size());
	     request.setAttribute("rankPageCount", (rankProducts.size() + 3) / 4);  // 4개씩 페이지 수
     }

  	 // 3) allReviews 더미는 "컨트롤러가 안 넣어준 경우에만" (보호)
     if (request.getAttribute("allReviews") == null) {
        // =========================
        // 3) 하단 "모든 리뷰" 리스트 (3개만)
        // =========================
        java.util.List<java.util.Map<String,Object>> allReviews = new java.util.ArrayList<>();
        java.util.Map<String,Object> r;

        java.util.List<String> photos;
        java.util.List<String> tags;

        r = new java.util.HashMap<>();
        r.put("writer","김**");
        r.put("verified", true);
        r.put("date","오늘 작성");
        r.put("rating", 5);
        r.put("badge", "NEW");
        r.put("productCode","DENSE_C5");
        r.put("content","이번겨울에 추운날 안경하다가 픽 부러졌어요...\n2년가량 매일 잘 쓰고 다녔던 터라 아쉽지만 재구매 합니다.");
        photos = new java.util.ArrayList<>();
        photos.add("img/review/r3.jpg");
        photos.add("img/review/r4.jpg");
        r.put("photos", photos);
        tags = new java.util.ArrayList<>();
        tags.add("배송이 빨라요");
        tags.add("포장이 꼼꼼해요");
        tags.add("유니크한 디테일이 있어요");
        tags.add("데일리로 착용하기 좋아요");
        r.put("tags", tags);
        r.put("adminReply","소중한 후기 정말 감사드립니다~!!\n항상 고객님께 만족을 드릴 수 있도록 노력하겠습니다!\n고객님의 목소리로 더 발전하는 카린이 되겠습니다 :-)"); // 관리자답글
        allReviews.add(r);

        r = new java.util.HashMap<>();
        r.put("writer","김**");
        r.put("verified", true);
        r.put("date","1일 전 작성");
        r.put("rating", 5);
        r.put("badge", "NEW");
        r.put("productCode","AIR 2 R_C2");
        r.put("content","너무 예뻐요. 역시 카린은 믿고 삽니다! 🌿 감사합니다!");
        photos = new java.util.ArrayList<>(); // 사진 없는 케이스도 가능
        r.put("photos", photos);
        tags = new java.util.ArrayList<>();
        tags.add("배송이 빨라요");
        tags.add("포장이 꼼꼼해요");
        tags.add("데일리로 착용하기 좋아요");
        tags.add("가벼워요");
        r.put("tags", tags);
        r.put("adminReply","소중한 후기 정말 감사드립니다~!!\n항상 고객님께 만족을 드릴 수 있도록 노력하겠습니다!\n고객님의 목소리로 더 발전하는 카린이 되겠습니다 :-)"); 
        allReviews.add(r);

        r = new java.util.HashMap<>();
        r.put("writer","송**");
        r.put("verified", false);
        r.put("date","25.12.24 작성");
        r.put("rating", 5);
        r.put("badge", "");
        r.put("productCode","RONENN_R_C4");
        r.put("content","컬러가 묘~하게 빈티지하고 포인트 돼요.\n블루라이트 렌즈 덕분에 눈도 편합니다.");
        photos = new java.util.ArrayList<>();
        photos.add("img/review/r5.jpg");
        photos.add("img/review/r1.jpg");
        r.put("photos", photos);
        tags = new java.util.ArrayList<>();
        tags.add("컬러가 예뻐요");
        tags.add("착용감이 좋아요");
        r.put("tags", tags);
        r.put("adminReply","감사합니다. 더 좋은 상품으로 만족 드리겠습니다!");
        allReviews.add(r);

        request.setAttribute("allReviews", allReviews);
     }
  	 
  	// 4) totalReviews도 컨트롤러 우선
     if (request.getAttribute("totalReviews") == null) {
         request.setAttribute("totalReviews", 0);
     }

%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<!-- 상단 타이틀 -->
<title>Review</title>

<style>
    /* =========================
	   기본
	========================= */
	*{ box-sizing:border-box; }
	body{
	  margin:0;
	  font-family: Arial, "Noto Sans KR", sans-serif;
	  color:#111;
	  background:#fff;
	}
	a{ color:inherit; text-decoration:none; }
	a:hover{ text-decoration:none; }
	
	.wrap{ width:100%; padding:24px 0 80px; }
	.inner{ width:92%; max-width:1500px; margin:0 auto; }
	
	/* =========================
	   공통 별
	========================= */
	.stars{ display:inline-flex; gap:1px; font-size:12px; }
	.star{ color:#111; }
	.star.off{ color:#ddd; }
	
	/* =========================
	   상단 인플루언서 캐러셀
	   데스크탑 3 / 모바일 1
	========================= */
	.hero-wrap{ padding:18px 0 24px; }
	
	.hero-card{
	  border:1px solid #f2f2f2;
	  border-radius:14px;
	  overflow:hidden;
	  background:#fff;
	  height:100%;
	}
	.hero-img{
	  aspect-ratio:1/1;
	  background:#fafafa;
	  overflow:hidden;
	}
	.hero-img img{
	  width:100%;
	  height:100%;
	  object-fit:cover;
	}
	.hero-body{ padding:10px 12px 14px; }
	.hero-title{
	  margin-top:8px;
	  font-size:12px;
	  line-height:1.35;
	  height:34px;
	  overflow:hidden;
	}
	.hero-code{
	  margin-top:8px;
	  font-size:12px;
	  color:#666;
	}
	
	.hero-nav{
	  position:absolute;
	  top:50%;
	  transform:translateY(-50%);
	  width:44px;
	  height:44px;
	  border-radius:50%;
	  border:1px solid #ddd;
	  background:#fff;
	  z-index:20;
	}
	.hero-nav::before{
	  content:'‹';
	  font-size:26px;
	  color:#111;
	  position:absolute;
	  inset:0;
	  display:flex;
	  align-items:center;
	  justify-content:center;
	}
	.hero-nav.next::before{ content:'›'; }
	.hero-nav.prev{ left:10px; }
	.hero-nav.next{ right:10px; }
	
	
	/* =========================
	   캐러셀 화살표 (눈에 띄게)
	========================= */
	.carousel-nav{
	  position:absolute;
	  top:50%;
	  transform:translateY(-50%);
	  width:54px;
	  height:120px;
	  background:rgba(0,0,0,.75);
	  color:#fff;
	  border-radius:10px;
	  display:flex;
	  align-items:center;
	  justify-content:center;
	  font-size:34px;
	  z-index:50;
	}
	.carousel-nav:hover{ background:rgba(0,0,0,.85); }
	.carousel-nav.prev{ left:10px; }
	.carousel-nav.next{ right:10px; }
	
	@media (max-width:576px){
	  .carousel-nav{
	    width:44px;
	    height:90px;
	    font-size:28px;
	  }
	}
	
	/* =========================
	   중단 탭
	========================= */
	.mid-tabs{
	  display:flex;
	  justify-content:center;
	  align-items:center;
	  gap:14px;
	  margin:30px 0 14px;
	  font-size:13px;
	}
	.mid-tabs a{
	  color:#999;
	  font-weight:500;
	}
	.mid-tabs a.active{
	  color:#111;
	  font-weight:700;
	}
	.mid-tabs .divider{
	  width:1px;
	  height:12px;
	  background:#e2e2e2;
	}
	
	/* =========================
	   중단 제품 카드
	   데스크탑: 4개
	   모바일: 2x2 (비율 유지)
	========================= */
	.mid-card{
	  border:1px solid #f0f0f0;
	  border-radius:16px;
	  background:#fff;
	  padding:14px;
	  height:100%;
	}
	.mid-main{
	  background:#f6f6f6;
	  border-radius:16px;
	  aspect-ratio:1/1.15;
	  display:flex;
	  align-items:center;
	  justify-content:center;
	  overflow:hidden;
	}
	.mid-main img{
	  width:100%;
	  height:100%;
	  object-fit:contain;
	}
	.mid-code{
	  margin-top:12px;
	  font-size:12px;
	  font-weight:700;
	}
	.mid-sub{
	  font-size:12px;
	  color:#666;
	  margin-top:4px;
	}
	.mid-review{
	  margin-top:12px;
	  padding-top:12px;
	  border-top:1px solid #eee;
	  font-size:12px;
	  color:#333;
	}
	.mid-review-row{
	  display:flex;
	  gap:10px;
	  margin-bottom:8px;
	}
	.mid-review-thumb{
	  width:42px;
	  height:42px;
	  border-radius:10px;
	  overflow:hidden;
	  background:#eee;
	  flex:0 0 auto;
	}
	.mid-review-thumb img{
	  width:100%;
	  height:100%;
	  object-fit:cover;
	}
	
	/* 모바일 2x2 */
	@media (max-width:768px){
	  .mid-col{ flex:0 0 50%; max-width:50%; }
	}

	
	
	/* =========================
	   ✅ 하단부(allReviews) 상단 바: 캡처 스타일
	   ========================= */
	.bottom-bar{
	  display:flex;
	  align-items:center;
	  justify-content:space-between;
	  padding: 10px 0 12px;
	  border-top: 1px solid #ededed;     /* 캡처처럼 위/아래 선 느낌 */
	  border-bottom: 1px solid #ededed;
	  margin-top: 18px;                  /* 필요하면 조절 */
	}
	
	.bottom-bar-left{
	  display:flex;
	  align-items:center;
	  gap:10px;
	}
	
	/* 좌측 pill */
	.bottom-pill{
	  display:inline-flex;
	  align-items:center;
	  gap:6px;
	  height: 22px;
	  padding: 0 10px;
	  border:1px solid #eaeaea;
	  border-radius:999px;
	  font-size:12px;
	  color:#111;
	  background:#fff;
	}
	
	/* 우측 정렬/링크 */
	.bottom-bar-right{
	  display:flex;
	  align-items:center;
	  gap:14px;
	  font-size:12px;
	  color:#666;
	}
	
	.bottom-bar-right a{
	  color:#666;
	  text-decoration:none;
	}
	
	.bottom-bar-right a.active{
	  color:#111;
	  font-weight:600;
	}
	
	.bottom-bar-right .divider{
	  color:#cfcfcf;
	}
	
	/* 우측 돋보기 버튼 */
	.bottom-search-btn{
	  border:0;
	  background:transparent;
	  padding: 4px;
	  margin-left: 2px;
	  cursor:pointer;
	  color:#9a9a9a;
	  display:inline-flex;
	  align-items:center;
	  justify-content:center;
	}
	
	.bottom-search-btn:hover{
	  color:#111;
	}
	


    /* =========================
       3) 하단 "모든 리뷰" 리스트 (첨부 3/4)
       ========================= */
       
       
    .allreview-wrap{
        margin-top:28px;
        padding-top:18px;
        border-top:1px solid #ededed;
    }
    .allreview-title{
        font-size:14px;
        font-weight:700;
        margin-bottom:12px;
        display:flex;
        align-items:center;
        justify-content:space-between;
    }
    .allreview-title a{
        font-size:12px;
        color:#666;
    }

    .review-item{
        display:grid;
        grid-template-columns: 160px 1fr;
        gap:18px;
        padding:18px 0;
        border-bottom:1px solid #f1f1f1;
    }
    .r-left{
        font-size:12px; color:#666;
        display:flex; flex-direction:column; gap:6px;
    }
    .pill{
        display:inline-flex; align-items:center; justify-content:center;
        height:18px; padding:0 8px;
        border-radius:999px;
        border:1px solid #eaeaea;
        font-size:11px;
        color:#666;
        width:max-content;
        background:#fff;
    }
    .r-right{ min-width:0; }

    .r-top{
        display:flex; align-items:center; gap:10px;
        padding:10px 12px;
        border-radius:12px;
        background:#fafafa;
    }
    .badge{
        display:inline-flex;
        align-items:center; justify-content:center;
        height:18px; padding:0 8px;
        border-radius:999px;
        background:#3b82f6; color:#fff;
        font-size:11px;
    }
    .prodcode{
        font-size:12px;
        font-weight:700;
        color:#111;
        margin-left:6px;
    }
    .r-content{
        padding:12px 0 10px;
        font-size:13px;
        line-height:1.55;
        color:#111;
        white-space:pre-line;
    }

    .r-photos{
        margin-top:6px;
        display:grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap:12px;
        max-width: 420px;
    }
    .r-photo{
        border-radius:12px;
        overflow:hidden;
        background:#f2f2f2;
        aspect-ratio: 1 / 1;
    }
    .r-photo img{
        width:100%; height:100%;
        object-fit:cover;
        display:block;
        transform:scale(1);
        transition:transform .25s ease;
    }
    .r-photo:hover img{ transform:scale(1.06); }

    .r-tags{
        margin-top:12px;
        display:flex; flex-wrap:wrap; gap:8px;
    }
    .tag{
        font-size:11px;
        color:#555;
        border:1px solid #ececec;
        background:#f7f7f7;
        padding:6px 10px;
        border-radius:999px;
    }

    .r-actions{
        margin-top:14px;
        display:flex;
        align-items:center;
        gap:16px;
        color:#666;
        font-size:12px;
    }
    .r-actions a{ color:#666; }
    .r-actions a:hover{ color:#111; text-decoration:none; }

    .admin-reply{
        margin-top:14px;
        border-top:1px solid #eee;
        padding-top:12px;
        color:#444;
        font-size:12px;
        line-height:1.5;
        white-space:pre-line;
    }
    .admin-name{
        margin-top:10px;
        font-size:12px;
        color:#666;
    }

    @media (max-width: 980px){
        .tab-layout{ grid-template-columns: 1fr; }
        .rank-side{ order:2; }
    }
    @media (max-width: 560px){
        .review-item{ grid-template-columns: 1fr; }
        .hero-item{ width:240px; }
        .hero-btn{ display:none; }
        .bottom-bar-right{
		  gap:10px;
		}
		.bottom-bar-right .divider{
		  display:none; /* 공간 부족하면 구분자 숨김 */
		}
    }
    
    /* ====== 하단 페이지네이션 ====== */
	.pager{
	  display:flex; align-items:center; justify-content:center;
	  gap:10px; color:#777; font-size:12px;
	}
	.pager a, .pager span{
	  display:inline-flex; align-items:center; justify-content:center;
	  min-width:30px; height:30px;
	  border-radius:8px;
	  border:1px solid #ececec;
	  padding:0 8px;
	  background:#fff;
	}
	.pager a:hover{ border-color:#ddd; text-decoration:none; }
	.pager .active{
	  border-color:#111;
	  color:#111;
	  font-weight:700;
	}
	.pager .arrow{ color:#666; font-size:14px; }
	
	/* ====== 하단 운영정책/리뷰작성 ====== */
	.bottom-row{
	  display:flex; align-items:center; justify-content:space-between;
	  margin-top:14px;
	  color:#777; font-size:12px;
	}
	.btn-write{
	  border:1px solid #111;
	  background:#111;
	  color:#fff;
	  padding:10px 14px;
	  border-radius:10px;
	  font-size:12px;
	  text-decoration:none;
	}
	.btn-write:hover{ filter:brightness(1.05); }
	
	/* ====== 우측 하단 플로팅 "리뷰 작성" 버튼 ====== */
	.review-float-btn{
	  position: fixed;
	  right: 30px;
	  bottom: 30px;              /* 기본은 바닥에서 30px */
	  z-index: 9999;
	  border-radius: 999px;
	  padding: 12px 16px;
	  font-size: 13px;
	  line-height: 1;
	}
	
	/* footer에 닿으면(겹치면) 위로 밀려 올라간 상태 */
	.review-float-btn.is-stuck{
	  position: absolute;        /* footer 위에 붙는 순간 absolute로 전환 */
	}
	.page-title{ font-size:26px; font-weight:500; letter-spacing:.3px; margin:26px 0 18px; }
	
</style>
</head>

<body>
<jsp:include page="../header.jsp"/>

<div class="wrap">
    <div class="inner">
		<div class="page-title">Reviews</div>
        

        <!-- ========상단부 인플루언서=========== -->
        <div class="hero-wrap">
		  <div id="heroCarousel" class="carousel slide" data-ride="carousel" data-interval="false">
		
		    <div class="carousel-inner">
		
		      <c:forEach var="page" begin="0" end="${heroPageCount - 1}">
		        <div class="carousel-item ${page == 0 ? 'active' : ''}">
		          <div class="row">
		
		            <c:forEach var="i" begin="0" end="2">
		              <c:set var="idx" value="${page*3 + i}" />
		              <c:if test="${idx < heroReviews.size()}">
		                <c:set var="h" value="${heroReviews[idx]}" />
		
		                <!-- 데스크탑 3 / 모바일 1 -->
		                <div class="col-12 col-md-4 px-2">
		                  <a href="#" class="hero-card d-block">
		                    <div class="hero-img">
		                      <img src="${h.image}">
		                    </div>
		                    <div class="hero-body">
		                      <div class="stars">
		                        <c:forEach var="s" begin="1" end="5">
		                          <span class="star ${s > h.rating ? 'off' : ''}">★</span>
		                        </c:forEach>
		                      </div>
		                      <div class="hero-title">${h.title}</div>
		                      <div class="hero-code">${h.code}</div>
		                    </div>
		                  </a>
		                </div>
		
		              </c:if>
		            </c:forEach>
		
		          </div>
		        </div>
		      </c:forEach>
		
		    </div>
		
		    <!-- 화살표 -->
		    <a class="hero-nav prev" href="#heroCarousel" data-slide="prev"></a>
		    <a class="hero-nav next" href="#heroCarousel" data-slide="next"></a>
		
		  </div>
		</div>

        <!-- ========상단부 인플루언서=========== -->

       <!-- =========================
		  ✅ 중단부 제품리뷰 캐러셀 (Bootstrap / 4개씩 한 페이지)
		========================= -->
		<!-- ===== 탭 ===== -->
		<div class="mid-tabs">
		  <a href="#" class="active">리뷰 많은순</a>
		  <div class="divider"></div>
		  <a href="#">리뷰 평점순</a>
		  <div class="divider"></div>
		  <a href="#">최근 판매량순</a>
		  <div class="divider"></div>
		  <a href="#">최근 상품순</a>
		</div>
		
		<!-- ===== 캐러셀 ===== -->
		<div id="midProductCarousel" class="carousel slide" data-ride="carousel" data-interval="false">
		  <div class="carousel-inner">
		
		    <c:forEach var="page" begin="0" end="${(rankSize-1)/4}">
		      <div class="carousel-item ${page == 0 ? 'active' : ''}">
		        <div class="row">
		
		          <c:forEach var="i" begin="0" end="3">
		            <c:set var="idx" value="${page*4+i}" />
		            <c:if test="${idx < rankSize}">
		              <c:set var="rp" value="${rankProducts[idx]}" />
		
		              <div class="col-6 col-md-3 px-2 mid-col">
		                <div class="mid-card">
		                  <div class="mid-main">
		                    <img src="${rp.main}">
		                  </div>
		                  <div class="mid-code">${rp.code}</div>
		                  <div class="mid-sub">리뷰 ${rp.count}개</div>
		
		                  <div class="mid-review">
		                    <c:forEach var="mr" items="${rp.reviews}">
		                      <div class="mid-review-row">
		                        <div class="mid-review-thumb">
		                          <img src="${mr.thumb}">
		                        </div>
		                        <div>${mr.text}</div>
		                      </div>
		                    </c:forEach>
		                  </div>
		                </div>
		              </div>
		
		            </c:if>
		          </c:forEach>
		
		        </div>
		      </div>
		    </c:forEach>
		
		  </div>
		
		  <a class="carousel-nav prev" href="#midProductCarousel" data-slide="prev">‹</a>
		  <a class="carousel-nav next" href="#midProductCarousel" data-slide="next">›</a>
		</div>




        <!-- =========================
        	3) 하단: 모든 리뷰(3개만) - 첨부 3/4 느낌
        ========================= -->
             
        
        <div class="allreview-wrap" id="allReviews">
            <div class="bottom-bar">
			<div class="title">
			All Reviews
			</div>
		    <div class="bottom-bar-right">
			  <a href="${pageContext.request.contextPath}/reviews.sp?sort=recent&searchWord=${fn:escapeXml(searchWord)}#allReviews"
			     class="${sort eq 'recent' ? 'active' : ''}">최신순</a>
			
			  <a href="${pageContext.request.contextPath}/reviews.sp?sort=rating&searchWord=${fn:escapeXml(searchWord)}#allReviews"
			     class="${sort eq 'rating' ? 'active' : ''}">별점 높은순</a>
			
			  <span class="divider">|</span>
			
			  <a href="javascript:void(0);" id="btnToggleSearch">직접검색</a>
			
			  <button type="button" class="bottom-search-btn" aria-label="검색" id="btnSearchIcon">
			    (SVG는 너 기존 그대로)
			  </button>
			</div>

		  </div>   
		  <div id="searchBox" style="display:none; margin-top:10px;">
			  <form method="get" action="${pageContext.request.contextPath}/reviews.sp">
			    <input type="hidden" name="sort" value="${sort}" />
			    <input type="text" name="searchWord" value="${fn:escapeXml(searchWord)}" placeholder="제목/내용 검색" />
			    <button type="submit">검색</button>
			  </form>
		  </div>
		  

            <c:forEach var="r" items="${allReviews}">
                <div class="review-item">

                    <!-- 왼쪽 -->
                    <div class="r-left">
                        <div style="display:flex; gap:8px; align-items:center;">
                            <div style="font-weight:700; color:#111;">${r.writer}</div>
                            <c:if test="${r.verified == 1}">
							    <span class="pill">구매 인증</span>
							</c:if>

                        </div>
                        <div>${r.date}</div>
                    </div>

                    <!-- 오른쪽 -->
                    <div class="r-right">
                        <div class="r-top">
                            <span class="stars">
                                <c:forEach var="i" begin="1" end="5">
                                    <c:choose>
                                        <c:when test="${i <= r.rating}">
                                            <span class="star">★</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="star off">★</span>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </span>

                            <c:if test="${not empty r.badge}">
                                <span class="badge">${r.badge}</span>
                            </c:if>

                            <span class="prodcode">${r.productCode}</span>
                        </div>

                        <div class="r-content">${r.review_content}</div>

                        <c:if test="${not empty r.photos}">
                            <div class="r-photos">
                                <c:forEach var="ph" items="${r.photos}" varStatus="st">
                                    <c:if test="${st.index < 2}">
                                        <div class="r-photo">
                                            <img src="${ph}" alt="review photo">
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </c:if>

                        <c:if test="${not empty r.tags}">
                            <div class="r-tags">
                                <c:forEach var="t" items="${r.tags}">
                                    <span class="tag">${t}</span>
                                </c:forEach>
                            </div>
                        </c:if>

                        <div class="r-actions">
						  <a>💬 댓글 ${r.commentCount}</a>
						  <a href="#">⚑ 신고</a>
						</div>
						
						<c:if test="${not empty r.adminReply}">
						  <div class="admin-reply">
						    ${r.adminReply}
						    <div class="admin-name">카린 올림</div>
						  </div>
						</c:if>

                    </div>

                </div>
            </c:forEach>
        </div>
        <!-- ========= 하단부 ======== -->
        
        <!-- ====== 하단 페이지네이션 + 버튼 ====== -->
		<div class="pager" style="margin-top:26px;">
		
		  <c:choose>
		    <c:when test="${currentShowPageNo > 1}">
		      <a class="arrow"
		         href="${pageContext.request.contextPath}/reviews.sp?sort=${sort}&searchWord=${fn:escapeXml(searchWord)}&currentShowPageNo=${currentShowPageNo-1}#allReviews"
		         aria-label="이전">&lsaquo;</a>
		    </c:when>
		    <c:otherwise>
		      <span class="arrow" aria-label="이전">&lsaquo;</span>
		    </c:otherwise>
		  </c:choose>
		
		  <c:forEach var="p" begin="1" end="${totalPage}">
		    <c:choose>
		      <c:when test="${p == currentShowPageNo}">
		        <span class="active">${p}</span>
		      </c:when>
		      <c:otherwise>
		        <a href="${pageContext.request.contextPath}/reviews.sp?sort=${sort}&searchWord=${fn:escapeXml(searchWord)}&currentShowPageNo=${p}#allReviews">${p}</a>
		      </c:otherwise>
		    </c:choose>
		  </c:forEach>
		
		  <c:choose>
		    <c:when test="${currentShowPageNo < totalPage}">
		      <a class="arrow"
		         href="${pageContext.request.contextPath}/reviews.sp?sort=${sort}&searchWord=${fn:escapeXml(searchWord)}&currentShowPageNo=${currentShowPageNo+1}#allReviews"
		         aria-label="다음">&rsaquo;</a>
		    </c:when>
		    <c:otherwise>
		      <span class="arrow" aria-label="다음">&rsaquo;</span>
		    </c:otherwise>
		  </c:choose>
		
		</div>
		<!-- ====== 하단 페이지네이션 + 버튼 끝 ====== -->
		
		
        <!-- ✅ 우측 하단 플로팅 리뷰 작성 버튼 -->
		<a href="${pageContext.request.contextPath}/reviewWrite.sp"
		   class="btn btn-dark shadow review-float-btn" id="reviewFloatBtn">
		  리뷰 작성
		</a>

        

    </div>
</div>

<script>

// 상단부
(function(){
    // =========================
    // 1) 상단 캐러셀: 자동 슬라이드 + 버튼 + 드래그
    // =========================
    	
    

    const viewport = document.getElementById('heroViewport');
    const track = document.getElementById('heroTrack');
    const prevBtn = document.querySelector('.hero-btn.prev');
    const nextBtn = document.querySelector('.hero-btn.next');

    let x = 0;
    let isDown = false;
    let startX = 0;
    let startTranslate = 0;
    let autoTimer = null;

    const clamp = (val, min, max) => Math.max(min, Math.min(max, val));

    const getBounds = () => {
        const vw = viewport.clientWidth;
        const tw = track.scrollWidth;
        const minX = Math.min(0, vw - tw);
        const maxX = 0;
        return {minX, maxX, vw, tw};
    };

    const step = () => {
        const item = track.querySelector('.hero-item');
        if(!item) return 260;
        const styles = getComputedStyle(track);
        const gap = parseInt(styles.gap || 16, 10) || 16;
        return item.getBoundingClientRect().width + gap;
    };

    const setX = (nx, animate=true) => {
        const {minX, maxX} = getBounds();
        x = clamp(nx, minX, maxX);
        track.style.transition = animate ? 'transform .35s ease' : 'none';
        track.style.transform = `translateX(${x}px)`;
    };

    const slideNext = () => {
        const {minX} = getBounds();
        const nx = x - step();
        // 끝까지 가면 다시 처음으로 (자동으로 "슥" 바뀌는 느낌)
        if(nx < minX + 2) {
            setX(minX, true);
            // 한 번 더 지나면 0으로 복귀 (자연스럽게)
            setTimeout(()=> setX(0, true), 380);
        } else {
            setX(nx, true);
        }
    };

    const slidePrev = () => {
        const {maxX, minX} = getBounds();
        const nx = x + step();
        if(nx > maxX) {
            // 맨 앞에서 prev 누르면 끝쪽으로 점프
            setX(minX, true);
        } else {
            setX(nx, true);
        }
    };
    prevBtn.addEventListener('click', () => { stopAuto(); slidePrev(); startAuto(); });
    nextBtn.addEventListener('click', () => { stopAuto(); slideNext(); startAuto(); });

    // 드래그
    viewport.addEventListener('mousedown', (e) => {
        stopAuto();
        isDown = true;
        viewport.style.cursor = 'grabbing';
        startX = e.clientX;
        startTranslate = x;
        track.style.transition = 'none';
    });

    window.addEventListener('mousemove', (e) => {
        if(!isDown) return;
        const dx = e.clientX - startX;
        setX(startTranslate + dx, false);
    });

    window.addEventListener('mouseup', () => {
        if(!isDown) return;
        isDown = false;
        viewport.style.cursor = 'grab';
        setX(x, true);
        startAuto();
    });

    // 터치
    viewport.addEventListener('touchstart', (e) => {
        stopAuto();
        isDown = true;
        startX = e.touches[0].clientX;
        startTranslate = x;
        track.style.transition = 'none';
    }, {passive:true});

    viewport.addEventListener('touchmove', (e) => {
        if(!isDown) return;
        const dx = e.touches[0].clientX - startX;
        setX(startTranslate + dx, false);
    }, {passive:true});

    viewport.addEventListener('touchend', () => {
        isDown = false;
        setX(x, true);
        startAuto();
    });

    // 자동 슬라이드
    function startAuto(){
        if(autoTimer) return;
        autoTimer = setInterval(slideNext, 3200); // ✅ 몇 초 후 자동으로 "슥"
    }
    function stopAuto(){
        if(!autoTimer) return;
        clearInterval(autoTimer);
        autoTimer = null;
    }

    window.addEventListener('resize', () => setX(x, false));

    // 초기
    setX(0, false);
    startAuto();
})();




    
// 하단 리뷰작성 버튼

// 하단 플로팅 리뷰 작성 버튼 (footer 겹치면 위로 올라가기)
(function(){
  const btn = document.getElementById('reviewFloatBtn');
  if(!btn) return;

  const baseRight = 30;
  const baseBottom = 30;

  function findFooter(){
    // footer.jsp의 최상단 컨테이너(네가 준 코드 기준)
    return document.querySelector('.container-fluid.border-top.mt-5');
  }

  function update(){
    const footer = findFooter();
    if(!footer) return; // 아직 footer가 없으면(초기) 그냥 대기

    const footerRect = footer.getBoundingClientRect();
    const vh = window.innerHeight;

    const overlap = vh - footerRect.top; // footer가 화면으로 올라온 높이

    if(overlap > 0){
      btn.style.bottom = (baseBottom + overlap + 10) + 'px';
    }else{
      btn.style.bottom = baseBottom + 'px';
    }
    btn.style.right = baseRight + 'px';
  }

  // ✅ footer 렌더 완료 이후 보장
  window.addEventListener('load', ()=>{
    update();
    window.addEventListener('scroll', update, {passive:true});
    window.addEventListener('resize', update);
  });
})();


//✅ 직접검색 토글
(function(){
  const toggleBtn = document.getElementById('btnToggleSearch');
  const iconBtn = document.getElementById('btnSearchIcon');
  const box = document.getElementById('searchBox');
  if(!box) return;

  function toggle(){
    box.style.display = (box.style.display === 'none' || box.style.display === '') ? 'block' : 'none';
  }

  if(toggleBtn) toggleBtn.addEventListener('click', toggle);
  if(iconBtn) iconBtn.addEventListener('click', toggle);
})();

</script>
<jsp:include page="../footer.jsp"/>
</body>
</html>
