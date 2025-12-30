<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>소개 | ABOUT</title>

  <!-- Bootstrap 5 CDN -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>

  <style>
    /* ===== About page only ===== */
    .about-hero{
      background: linear-gradient(120deg, #f7f7f8, #ffffff);
      border-bottom: 1px solid rgba(0,0,0,.06);
    }
    .about-hero .badge{
      background: rgba(0,0,0,.06);
      color:#111;
      border: 1px solid rgba(0,0,0,.08);
    }
    .section-title{
      letter-spacing: -0.02em;
    }
    .card-soft{
      border: 1px solid rgba(0,0,0,.06);
      box-shadow: 0 10px 30px rgba(0,0,0,.04);
      border-radius: 18px;
    }
    .icon-pill{
      width: 44px; height: 44px;
      border-radius: 14px;
      display:flex; align-items:center; justify-content:center;
      background: rgba(0,0,0,.06);
      border: 1px solid rgba(0,0,0,.08);
      font-weight: 700;
    }
    .divider{
      height: 1px;
      background: rgba(0,0,0,.06);
    }
    .quote{
      border-left: 4px solid rgba(0,0,0,.12);
      padding-left: 14px;
      color:#333;
    }
  </style>
</head>

<body class="bg-white">

  <!-- (선택) 공통 헤더가 있으면 include로 교체 -->
  <%-- <jsp:include page="/WEB-INF/views/common/header.jsp" /> --%>

  <jsp:include page="../header.jsp"/>

  <!-- CONTENT -->
  <main class="py-5">
    <div class="container">

      <!-- Story -->
      <section class="mb-5">
        <h2 class="h4 fw-bold mb-3 section-title">브랜드 스토리</h2>
        <div class="row g-4">
          <div class="col-lg-7">
            <div class="card card-soft p-4">
              <p class="mb-3">
                우리는 <b>과하지 않은 디자인</b>, <b>오래 써도 편안한 착용감</b>,
                그리고 <b>누구에게나 자연스럽게 어울리는 아이웨어</b>를 목표로 시작했습니다.
              </p>
              <p class="mb-0 text-secondary">
                단순히 “보여주기 위한 안경”이 아니라,
                <b>매일 쓰고 싶은 안경</b>을 만드는 것이 우리의 기준입니다.
              </p>
            </div>
          </div>
          <div class="col-lg-5">
            <div class="card card-soft p-4">
              <div class="fw-semibold mb-2">핵심 키워드</div>
              <ul class="mb-0 text-secondary">
                <li>데일리 웨어러블 디자인</li>
                <li>장시간 착용 피로 최소화</li>
                <li>검증된 소재와 공정</li>
              </ul>
            </div>
          </div>
        </div>
      </section>

      <!-- Values -->
      <section class="mb-5">
        <h2 class="h4 fw-bold mb-3 section-title">우리가 중요하게 생각하는 것</h2>
        <div class="row g-4">
          <div class="col-md-4">
            <div class="card card-soft p-4 h-100">
              <div class="d-flex align-items-center gap-3 mb-2">
                <div class="icon-pill">D</div>
                <div class="fw-semibold">Design</div>
              </div>
              <p class="mb-0 text-secondary">
                불필요한 장식을 덜어낸 미니멀 디자인.<br/>
                얼굴형과 스타일을 자연스럽게 살리는 균형을 고민합니다.
              </p>
            </div>
          </div>
          <div class="col-md-4">
            <div class="card card-soft p-4 h-100">
              <div class="d-flex align-items-center gap-3 mb-2">
                <div class="icon-pill">C</div>
                <div class="fw-semibold">Comfort</div>
              </div>
              <p class="mb-0 text-secondary">
                장시간 착용해도 부담 없는 무게감.<br/>
                브릿지와 템플 각도까지 세심하게 설계합니다.
              </p>
            </div>
          </div>
          <div class="col-md-4">
            <div class="card card-soft p-4 h-100">
              <div class="d-flex align-items-center gap-3 mb-2">
                <div class="icon-pill">Q</div>
                <div class="fw-semibold">Quality</div>
              </div>
              <p class="mb-0 text-secondary">
                엄선된 소재와 꼼꼼한 공정/검수.<br/>
                오래 써도 안정적인 품질을 지향합니다.
              </p>
            </div>
          </div>
        </div>
      </section>

      <!-- Philosophy -->
      <section class="mb-5">
        <h2 class="h4 fw-bold mb-3 section-title">제품 철학</h2>
        <div class="row g-4">
          <div class="col-lg-8">
            <div class="card card-soft p-4">
              <p class="mb-3">
                우리의 모든 제품은 <b>실제 착용자의 경험</b>을 기준으로 설계됩니다.
              </p>
              <ul class="text-secondary mb-0">
                <li>데일리 착용이 가능한 디자인</li>
                <li>다양한 얼굴형을 고려한 피팅</li>
                <li>안경사, 디자이너, 제작 파트너의 협업</li>
              </ul>
            </div>
          </div>
          <div class="col-lg-4">
            <div class="card card-soft p-4 h-100">
              <div class="fw-semibold mb-2">우리가 만드는 것</div>
              <p class="mb-0 text-secondary">
                “잘 팔리는 안경”보다<br/>
                <b>오래 함께할 수 있는 안경</b>을 만들고자 합니다.
              </p>
            </div>
          </div>
        </div>
      </section>

      <!-- Promise -->
      <section class="mb-5">
        <h2 class="h4 fw-bold mb-3 section-title">고객에게 드리는 약속</h2>
        <div class="card card-soft p-4">
          <div class="row g-3">
            <div class="col-md-3"><div class="p-3 bg-light rounded-4">✔ 정직한 정보 제공</div></div>
            <div class="col-md-3"><div class="p-3 bg-light rounded-4">✔ 합리적인 가격</div></div>
            <div class="col-md-3"><div class="p-3 bg-light rounded-4">✔ 신뢰할 수 있는 A/S</div></div>
            <div class="col-md-3"><div class="p-3 bg-light rounded-4">✔ 지속 가능한 운영</div></div>
          </div>
        </div>
      </section>

      <!-- Closing -->
      <section>
        <div class="card card-soft p-4">
          <p class="quote mb-3">
            안경은 단순한 액세서리가 아니라<br/>
            <b>당신의 시선과 일상을 함께하는 도구</b>입니다.
          </p>
          <p class="mb-0 text-secondary">
            우리는 당신의 하루가 조금 더 편안해지도록 고민합니다.
          </p>
        </div>
      </section>

    </div>
  </main>

  <jsp:include page="../footer.jsp"/>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
