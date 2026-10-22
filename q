<!DOCTYPE html>
<html lang="uk">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="color-scheme" content="light">
<title>Оперативна інформація — талон</title>
<style>
  :root{
    --bg:#F5F5F7; --surface:#FFFFFF;
    --ink:#1D1D1F; --ink-secondary:#55555A; --ink-tertiary:#8E8E93;
    --line:#D1D1D6; --separator:#E3E3E8; --fill:rgba(120,120,128,0.12);
    --accent:#007AFF; --accent-soft:rgba(0,122,255,0.08); --accent-ring:rgba(0,122,255,0.22);
    --success:#248A3D; --success-soft:rgba(36,138,61,0.10);
    --pick:#2DB55D; --pick-soft:#EAF8EF; --pick-ink:#1D7A40;
    --danger:#D70015; --danger-soft:rgba(215,0,21,0.07);
    --font:-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
  }
  *{box-sizing:border-box;}
  html{-webkit-text-size-adjust:100%;}
  body{margin:0; background:var(--bg); color:var(--ink); font-family:var(--font); line-height:1.45; -webkit-font-smoothing:antialiased; -webkit-tap-highlight-color:transparent; overflow-x:hidden;}
  button, input, select, textarea{font:inherit; color:inherit;}
  .hidden{display:none !important;}

  .page{max-width:640px; margin:0 auto; padding:28px 16px 56px;}

  /* --- шапка, як у графіку прийому --- */
  .header-card{display:flex; align-items:center; gap:14px; background:var(--accent); border-radius:16px; padding:14px 18px; margin-bottom:16px;}
  .header-text{flex:1; min-width:0;}
  .header-logo{flex-shrink:0; width:46px; height:46px;}
  .header-logo svg{display:block; width:100%; height:100%;}
  .title{margin:0; font-weight:600; font-size:1.15rem; line-height:1.25; letter-spacing:-0.01em; color:#fff;}
  .title-sub{display:block; margin-top:2px; font-size:0.86rem; color:rgba(255,255,255,0.92); font-weight:500; line-height:1.3; letter-spacing:0;}
  .org{margin:4px 0 0; font-size:0.72rem; color:rgba(255,255,255,0.8); font-weight:500; line-height:1.35;}

  /* --- картки --- */
  .card{background:var(--surface); border:1px solid #E1E1E6; border-radius:16px; padding:18px 18px 2px; margin-bottom:14px; box-shadow:0 1px 2px rgba(0,0,0,0.04), 0 4px 14px rgba(0,0,0,0.04);}
  .card-title{display:flex; align-items:center; gap:10px; margin:0 0 16px; font-size:1.05rem; font-weight:700;}
  .step{display:inline-flex; align-items:center; justify-content:center; width:24px; height:24px; border-radius:50%; background:var(--accent-soft); color:var(--accent); font-size:0.8rem; font-weight:700; flex-shrink:0;}

  /* --- поля --- */
  .field{margin:0 0 16px; padding:0; border:0; min-width:0;}
  .label{display:block; margin:0 0 6px; padding:0; font-size:0.86rem; font-weight:600; color:var(--ink);}
  .optional{font-weight:500; color:var(--ink-tertiary);}
  .hint{margin:6px 0 0; font-size:0.78rem; color:var(--ink-secondary);}
  .field-error{display:none; margin:6px 0 0; font-size:0.8rem; font-weight:500; color:var(--danger);}
  .field.invalid .field-error{display:block;}
  .field.invalid .hint{display:none;}

  .input{display:block; width:100%; min-height:46px; padding:11px 14px; font-size:16px; line-height:1.35; background:#fff; border:1px solid var(--line); border-radius:12px; outline:none; -webkit-appearance:none; appearance:none; transition:border-color .15s ease, box-shadow .15s ease;}
  .input::placeholder{color:#AEAEB2;}
  .input:focus{border-color:var(--accent); box-shadow:0 0 0 3px var(--accent-ring);}
  .field.invalid .input{border-color:var(--danger); box-shadow:0 0 0 3px var(--danger-soft);}
  /* спливаюча підказка під полем «Вік» / «МКХ-10», коли символ не можна ввести */
  .field[data-live]{position:relative;}
  .live-tip{position:absolute; left:8px; z-index:20; max-width:calc(100% - 16px); padding:6px 10px; border-radius:9px; background:var(--danger); color:#fff; font-size:0.8rem; font-weight:600; line-height:1.3; box-shadow:0 6px 18px rgba(215,0,21,0.25); opacity:0; visibility:hidden; transform:translateY(-4px); transition:opacity .15s ease, transform .15s ease, visibility .15s; pointer-events:none;}
  .live-tip::before{content:''; position:absolute; top:-4px; left:16px; width:9px; height:9px; background:var(--danger); transform:rotate(45deg); border-radius:2px;}
  .tip-on .live-tip{opacity:1; visibility:visible; transform:none;}
  .tip-on .input, .tip-on .input:focus{border-color:var(--danger); box-shadow:0 0 0 3px var(--danger-soft);}
  select.input{padding-right:40px; cursor:pointer; background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='8' viewBox='0 0 12 8'%3E%3Cpath d='M1 1.5l5 5 5-5' fill='none' stroke='%238E8E93' stroke-width='1.8' stroke-linecap='round' stroke-linejoin='round'/%3E%3C/svg%3E"); background-repeat:no-repeat; background-position:right 15px center;}
  /* список лікарів: справжній список прозорий поверх «обличчя», яке показує ПІБ повністю (з переносом) */
  /* список лікарів — власний, з пошуком (не залежить від вбудованого списку браузера) */
  .dd{position:relative;}
  .dd-face{display:flex; align-items:center; width:100%; text-align:left; white-space:normal; cursor:pointer; padding-right:40px; line-height:1.3; background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='8' viewBox='0 0 12 8'%3E%3Cpath d='M1 1.5l5 5 5-5' fill='none' stroke='%238E8E93' stroke-width='1.8' stroke-linecap='round' stroke-linejoin='round'/%3E%3C/svg%3E"); background-repeat:no-repeat; background-position:right 15px center;}
  .dd-face.is-empty{color:#AEAEB2;}
  .dd-face[aria-expanded="true"]{border-color:var(--accent); box-shadow:0 0 0 3px var(--accent-ring);}
  .dd-panel{position:absolute; left:0; right:0; top:calc(100% + 6px); z-index:30; padding:8px; background:#fff; border:1px solid var(--line); border-radius:14px; box-shadow:0 14px 34px rgba(0,0,0,0.16);}
  .dd-panel.dd-up{top:auto; bottom:calc(100% + 6px);}
  .dd-search{display:block; width:100%; min-height:40px; margin:0 0 6px; padding:8px 12px; font-size:16px; background:#fff; border:1px solid var(--line); border-radius:10px; outline:none;}
  .dd-search:focus{border-color:var(--accent); box-shadow:0 0 0 3px var(--accent-ring);}
  .dd-list{list-style:none; margin:0; padding:0; max-height:264px; overflow-y:auto; overscroll-behavior:contain;}
  .dd-opt{display:flex; align-items:center; gap:8px; padding:9px 12px; border-radius:9px; font-size:0.95rem; line-height:1.3; cursor:pointer;}
  .dd-opt::after{content:''; margin-left:auto; flex-shrink:0; width:16px; height:16px;}
  .dd-opt.active{background:var(--accent-soft); color:var(--accent);}
  .dd-opt[aria-selected="true"]{font-weight:600;}
  .dd-opt[aria-selected="true"]::after{background:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%232DB55D' stroke-width='3' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='M5 12.5l4.5 4.5L19 7.5'/%3E%3C/svg%3E") center/16px no-repeat;}
  .dd-empty{margin:8px 6px 4px; font-size:0.88rem; color:var(--ink-secondary);}

  /* «Очистити все» — у самому низу; спрацьовує з другого натискання, щоб не стерти талон випадково */
  /* «Очистити все» і «Надіслати» — однакового розміру; на телефоні — по краях, на комп’ютері — разом праворуч */
  .actions{display:flex; justify-content:space-between; gap:10px; align-items:stretch;}
  .actions .btn-primary{flex:0 1 164px; width:auto; min-width:0; padding-left:10px; padding-right:10px;}
  .btn-clear{flex:0 1 164px; display:inline-flex; align-items:center; justify-content:center; gap:7px; width:auto; min-height:52px; padding:10px 12px; border:1.5px solid rgba(215,0,21,0.35); border-radius:14px; background:#fff; color:var(--danger); font-size:0.92rem; font-weight:600; white-space:nowrap; cursor:pointer; transition:background-color .15s ease, color .15s ease;}
  .btn-clear svg{width:17px; height:17px; flex-shrink:0;}
  .btn-clear:hover{background:var(--danger-soft);}
  .btn-clear:focus-visible{outline:2px solid var(--danger); outline-offset:2px;}
  .btn-clear.armed{background:var(--danger); border-color:var(--danger); color:#fff;}
  .btn-clear.armed svg{display:none;}
  @media (max-width:400px){ .btn-clear, .actions .btn-primary{flex-basis:150px;} .btn-clear{padding:10px;} }
  input[type="date"].input{min-height:46px;}
  input[type="date"].input::-webkit-date-and-time-value{text-align:left;}
  .icd-input{letter-spacing:0.04em; font-weight:600;}

  .row{display:grid; gap:0 14px;}
  @media (min-width:560px){
    .row-age{grid-template-columns:130px 1fr;}
    .row-doctor{grid-template-columns:1fr 190px;}
  }

  /* сегментований перемикач (радіокнопки) */
  .seg{display:flex; gap:3px; padding:3px; background:var(--fill); border-radius:12px;}
  .seg-opt{flex:1 1 0; position:relative; margin:0; min-width:0;}
  .seg-opt input{position:absolute; opacity:0; width:1px; height:1px; pointer-events:none;}
  .seg-opt span{display:flex; align-items:center; justify-content:center; gap:6px; min-height:40px; padding:8px 10px; border-radius:9px; font-size:0.93rem; font-weight:500; color:var(--ink-secondary); text-align:center; cursor:pointer; transition:background-color .18s ease, color .18s ease;}
  .seg-opt small{font-size:0.74rem; font-weight:600; opacity:0.7;}
  .seg-opt input:checked + span{background:var(--accent); color:#fff; font-weight:600; box-shadow:0 2px 8px rgba(0,122,255,0.30);}
  .seg-opt input:focus-visible + span{outline:2px solid var(--accent); outline-offset:2px;}
  .field.invalid .seg{box-shadow:0 0 0 2px var(--danger) inset;}

  /* стать: чоловіча — блакитна, жіноча — рожева, зі значками ♂ / ♀ */
  .seg-sex .seg-opt span svg{width:18px; height:18px; flex-shrink:0;}
  .seg-sex .seg-opt.male span{color:#3A6E99;}
  .seg-sex .seg-opt.female span{color:#99456B;}
  .seg-sex .seg-opt.male span svg{color:#3399EB;}
  .seg-sex .seg-opt.female span svg{color:#E8579A;}
  .seg-sex .seg-opt.male input:checked + span{background:#DCEFFF; color:#075FA8; box-shadow:inset 0 0 0 1.5px #5FB2F4, 0 2px 8px rgba(51,153,235,0.22);}
  .seg-sex .seg-opt.female input:checked + span{background:#FFE1EE; color:#B01E5E; box-shadow:inset 0 0 0 1.5px #F286B6, 0 2px 8px rgba(232,87,154,0.22);}
  .seg-sex .seg-opt.male input:checked + span svg{color:#1E88E5;}
  .seg-sex .seg-opt.female input:checked + span svg{color:#E0397F;}

  /* список варіантів (місце проживання) */
  .choices{display:flex; flex-direction:column; gap:8px;}
  .choice{position:relative; margin:0;}
  .choice input{position:absolute; opacity:0; width:1px; height:1px; pointer-events:none;}
  .choice > span{display:flex; align-items:center; gap:12px; min-height:50px; padding:10px 14px; border:1px solid var(--line); border-radius:12px; background:#fff; cursor:pointer; transition:border-color .15s ease, background-color .15s ease;}
  .choice > span::before{content:''; flex-shrink:0; width:22px; height:22px; border-radius:50%; border:2px solid #C7C7CC; background:#fff center/13px no-repeat; transition:background-color .15s ease, border-color .15s ease;}
  .choice-text{display:block; min-width:0;}
  .choice b{display:block; font-size:0.95rem; font-weight:600;}
  .choice i{display:block; font-style:normal; font-size:0.8rem; color:var(--ink-secondary); line-height:1.35;}
  .choice > input:checked + span{border-color:var(--pick); background:var(--pick-soft);}
  .choice > input:checked + span::before{border-color:var(--pick); background-color:var(--pick); background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='white' stroke-width='3.6' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='M5 12.5l4.5 4.5L19 7.5'/%3E%3C/svg%3E");}
  .choice > input:checked + span b{color:var(--pick-ink);}
  .choice > input:focus-visible + span{outline:2px solid var(--accent); outline-offset:2px;}
  .field.invalid .choice > span{border-color:var(--danger);}

  /* чипи (галочки) */
  .chips{display:flex; flex-wrap:wrap; gap:8px;}
  .chip{position:relative; margin:0;}
  .chip input{position:absolute; opacity:0; width:1px; height:1px; pointer-events:none;}
  .chip span{display:inline-flex; align-items:center; gap:6px; min-height:40px; padding:8px 12px; border:1px solid var(--line); border-radius:999px; background:#fff; font-size:0.92rem; font-weight:500; color:var(--ink); cursor:pointer; transition:background-color .15s ease, border-color .15s ease, color .15s ease;}
  .chip svg{width:15px; height:15px; display:none;}
  .chip input:checked + span{background:var(--pick-soft); border-color:var(--pick); color:var(--pick-ink); font-weight:600;}
  .chip input:checked + span svg{display:block; color:var(--pick);}
  .chip input:focus-visible + span{outline:2px solid var(--accent); outline-offset:2px;}

  /* перемикач «вперше в житті» */
  .switch-row{display:flex; align-items:center; justify-content:space-between; gap:14px; padding:12px 14px; border-radius:12px; background:var(--fill); cursor:pointer;}
  .switch-text{display:flex; flex-direction:column; gap:2px; min-width:0;}
  .switch-title{font-size:0.93rem; font-weight:600;}
  .switch-note{font-size:0.78rem; color:var(--ink-secondary);}
  .switch{flex-shrink:0; position:relative; width:51px; height:31px; margin:0; border-radius:999px; background:#D9D9DE; cursor:pointer; -webkit-appearance:none; appearance:none; outline:none; transition:background-color .2s ease;}
  .switch::after{content:''; position:absolute; top:2px; left:2px; width:27px; height:27px; border-radius:50%; background:#fff; box-shadow:0 2px 4px rgba(0,0,0,0.2); transition:transform .2s ease;}
  .switch:checked{background:var(--accent);}
  .switch:checked::after{transform:translateX(20px);}
  .switch:focus-visible{box-shadow:0 0 0 3px var(--accent-ring);}

  /* кнопки */
  .btn-primary{display:flex; align-items:center; justify-content:center; gap:9px; width:100%; min-height:52px; padding:14px 18px; border:none; border-radius:14px; background:var(--accent); color:#fff; font-size:1rem; font-weight:600; cursor:pointer; box-shadow:0 4px 14px rgba(0,122,255,0.28); transition:opacity .15s ease;}
  .btn-primary:active{opacity:0.75;}
  .btn-primary:disabled{opacity:0.6; cursor:default;}
  .btn-primary:focus-visible{outline:2px solid var(--ink); outline-offset:2px;}
  .spinner{width:18px; height:18px; border:2.5px solid rgba(255,255,255,0.45); border-top-color:#fff; border-radius:50%; animation:spin .8s linear infinite; display:none;}
  .busy .spinner{display:block;}
  @keyframes spin{to{transform:rotate(360deg);}}

  .banner{margin:0 0 14px; padding:12px 14px; border-radius:12px; font-size:0.9rem; font-weight:500; line-height:1.45; white-space:pre-line;}
  .banner-error{background:var(--danger-soft); color:var(--danger);}
  .muted{margin:0; color:var(--ink-secondary); font-size:0.92rem;}

  /* надіслано */
  .done-card{text-align:center; padding:30px 22px 24px;}
  .done-icon{display:inline-flex; align-items:center; justify-content:center; width:64px; height:64px; border-radius:50%; background:var(--success-soft); color:var(--success); margin-bottom:12px;}
  .done-icon svg{width:32px; height:32px;}
  .done-title{margin:0 0 4px; font-size:1.25rem; font-weight:700;}
  .done-card .btn-primary{margin-top:20px;}

  /* історія: усе, що надіслано сьогодні з цього браузера */
  .history{margin-top:22px;}
  .history-title{margin:0 0 8px; padding:0 4px; font-size:0.8rem; font-weight:600; color:var(--ink-secondary); text-transform:uppercase; letter-spacing:0.03em;}
  .history-list{list-style:none; margin:0; padding:0; background:var(--surface); border:1px solid #E1E1E6; border-radius:14px; overflow:hidden;}
  .history-list li{display:flex; align-items:center; gap:10px; padding:11px 14px; font-size:0.9rem; border-top:1px solid var(--separator);}
  .history-list li:first-child{border-top:none;}
  .h-time{color:var(--ink-tertiary); font-variant-numeric:tabular-nums; flex-shrink:0;}
  .h-main{flex:1; min-width:0; display:flex; flex-direction:column; gap:1px;}
  .h-name{font-weight:500; overflow-wrap:anywhere;}
  .h-note{font-size:0.78rem; color:var(--ink-tertiary); line-height:1.3;}
  .h-icd{flex-shrink:0; font-weight:700; color:var(--accent);}


  /* комп’ютер: дві рівні колонки — «Пацієнт» ліворуч на всю висоту, «Діагноз» і «Відмітки» праворуч;
     «Лікар і дата» на всю ширину, кнопка — під правою колонкою */
  @media (min-width:900px){
    /* на 100% масштабу браузера — трохи менше й вужче (як при масштабі ≈90%), а не на весь екран */
    .page{max-width:1000px; padding-top:22px; zoom:0.9;}
    .header-card{padding:12px 22px;}
    .title-sub{display:inline; margin:0 0 0 8px;}
    .header-logo{width:42px; height:42px;}
    #talon:not(.hidden){
      display:grid; grid-template-columns:minmax(0,1fr) minmax(0,1fr); column-gap:18px; align-items:stretch;
      grid-template-areas:
        "patient diag"
        "patient marks"
        "doctor  doctor"
        "banner  banner"
        ".       actions";
    }
    .card-patient{grid-area:patient;}
    .card-diag{grid-area:diag;}
    .card-marks{grid-area:marks;}
    .card-doctor{grid-area:doctor;}
    #formError{grid-area:banner;}
    #talon .actions{grid-area:actions; justify-content:flex-end;}
    /* поля лікаря й дати стоять рівно під колонками вище */
    .card-doctor .row-doctor{grid-template-columns:minmax(0,1fr) minmax(0,1fr); column-gap:54px;}
    .done-card, .history{max-width:560px; margin-left:auto; margin-right:auto;}
  }

  @media (prefers-reduced-motion: reduce){ *{transition:none !important; animation:none !important;} }

  /* --- самоперевірка (#test) --- */
  .selftest{border:2px solid #F5C98B; background:#FFFDF7; padding-bottom:16px;}
  .st-head{display:flex; align-items:center; gap:10px; flex-wrap:wrap;}
  .st-head h2{margin:0; font-size:1.05rem; letter-spacing:-0.01em;}
  .st-badge{background:#A15C00; color:#fff; font-weight:700; font-size:0.7rem; letter-spacing:0.07em; padding:3px 8px; border-radius:6px;}
  .st-intro{margin:8px 0 12px; color:var(--ink-secondary); font-size:0.88rem;}
  .st-sum{display:flex; align-items:center; gap:10px; flex-wrap:wrap; padding:11px 14px; border-radius:12px; background:var(--fill); font-size:1.05rem; font-weight:700;}
  .st-sum.good{background:var(--success-soft); color:var(--success);}
  .st-sum.bad{background:var(--danger-soft); color:var(--danger);}
  .st-time{font-size:0.84rem; font-weight:500; color:var(--ink-secondary);}
  .st-groups{margin-top:8px;}
  .st-group{border-top:1px solid var(--separator);}
  .st-group summary{display:flex; align-items:baseline; gap:8px; padding:10px 2px; cursor:pointer; list-style:none;}
  .st-group summary::-webkit-details-marker{display:none;}
  .st-gt{flex:1; min-width:0; font-weight:600;}
  .st-gc{flex-shrink:0; font-size:0.84rem; color:var(--ink-secondary); white-space:nowrap;}
  .st-group.bad .st-gc{color:var(--danger); font-weight:700;}
  .st-mark{flex-shrink:0; width:1.1em; text-align:center; font-weight:800; color:var(--success);}
  .st-group.bad > summary .st-mark, .st-group li.bad .st-mark{color:var(--danger);}
  .st-note{margin:0 0 6px 26px; font-size:0.82rem; color:var(--ink-secondary);}
  .st-group ul{list-style:none; margin:0 0 12px; padding:0;}
  .st-group li{display:flex; gap:8px; padding:3px 0; font-size:0.86rem; line-height:1.4;}
  .st-group li > span:last-child{min-width:0; overflow-wrap:anywhere;}
  .st-group li small{display:block; margin-top:1px; font-size:0.8rem; color:var(--danger);}
  .st-actions{display:flex; gap:8px; flex-wrap:wrap; margin-top:12px;}
  .st-btn{display:inline-flex; align-items:center; justify-content:center; min-height:40px; padding:8px 14px; border:1px solid var(--line); border-radius:12px; background:#fff; color:var(--ink); font-size:0.9rem; font-weight:600; text-decoration:none; cursor:pointer;}
  .st-btn.st-solid{border-color:var(--accent); background:var(--accent); color:#fff;}
  .st-text{width:100%; min-height:160px; margin-top:10px; font:12px/1.4 ui-monospace, Menlo, Consolas, monospace; border:1px solid var(--line); border-radius:10px; padding:8px;}
</style>
</head>
<body>
<div class="page">
  <header class="header-card">
    <div class="header-text">
      <h1 class="title">Оперативна інформація <span class="title-sub">для реєстрації заключних (уточнених) діагнозів</span></h1>
      <p class="org">КНП «Чорноморський міський центр первинної медико-санітарної допомоги»</p>
    </div>
    <div class="header-logo" aria-hidden="true">
      <svg viewBox="0 0 1701 1701" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="Емблема Чорноморського ЦПМСД"> <path d="M 244 446 L 217 500 L 204 537 L 196 568 L 191 596 L 189 622 L 191 670 L 197 704 L 204 731 L 216 767 L 244 831 L 269 877 L 312 943 L 314 943 L 299 877 L 289 813 L 284 732 L 285 694 L 289 647 L 295 606 L 302 574 L 313 541 L 325 515 L 346 481 L 360 463 L 380 442 L 412 416 L 435 402 L 467 388 L 499 380 L 524 377 L 575 378 L 598 381 L 629 388 L 652 395 L 681 407 L 716 427 L 753 458 L 791 503 L 813 537 L 816 539 L 822 551 L 825 551 L 911 502 L 950 489 L 981 481 L 1014 475 L 1044 472 L 1085 472 L 1111 475 L 1132 480 L 1153 488 L 1170 497 L 1187 508 L 1209 526 L 1233 550 L 1254 575 L 1290 629 L 1311 675 L 1327 731 L 1333 773 L 1332 828 L 1324 875 L 1310 920 L 1285 974 L 1253 1026 L 1221 1069 L 1179 1117 L 1135 1159 L 1097 1191 L 1033 1240 L 959 1293 L 851 1365 L 760 1421 L 757 1425 L 796 1411 L 907 1366 L 1061 1299 L 1149 1259 L 1205 1231 L 1263 1197 L 1327 1151 L 1365 1118 L 1394 1088 L 1418 1059 L 1437 1032 L 1453 1005 L 1471 968 L 1490 917 L 1500 880 L 1508 836 L 1511 801 L 1511 759 L 1507 719 L 1498 677 L 1489 648 L 1470 603 L 1449 566 L 1431 540 L 1405 509 L 1378 483 L 1355 465 L 1332 450 L 1289 429 L 1246 415 L 1201 407 L 1180 405 L 1145 405 L 1103 410 L 1055 422 L 1006 441 L 954 468 L 910 497 L 880 449 L 838 396 L 797 357 L 758 330 L 718 309 L 663 289 L 602 276 L 542 272 L 503 274 L 454 283 L 415 296 L 375 316 L 347 334 L 315 360 L 274 403 Z" fill="#FFFFFF" fill-rule="evenodd"/> <path d="M 820 1089 L 807 1101 L 805 1109 L 806 1117 L 809 1123 L 821 1132 L 836 1131 L 843 1126 L 848 1118 L 848 1103 L 844 1096 L 838 1091 L 830 1088 Z M 795 1073 L 768 1114 L 756 1145 L 749 1187 L 749 1223 L 754 1266 L 760 1293 L 768 1318 L 787 1359 L 805 1386 L 807 1386 L 807 1324 L 809 1296 L 814 1268 L 825 1235 L 844 1197 L 860 1174 L 882 1154 L 901 1142 L 916 1135 L 916 1133 L 868 1151 L 837 1158 L 814 1158 L 802 1153 L 793 1143 L 787 1127 L 787 1104 L 795 1076 L 797 1075 L 797 1073 Z M 617 931 L 609 969 L 603 1021 L 603 1061 L 610 1118 L 624 1173 L 634 1202 L 652 1244 L 685 1304 L 704 1332 L 729 1363 L 767 1402 L 772 1404 L 763 1357 L 749 1307 L 739 1244 L 738 1183 L 742 1142 L 748 1108 L 756 1080 L 765 1059 L 781 1028 L 791 1014 L 820 986 L 839 973 L 862 961 L 862 959 L 834 969 L 811 981 L 734 1036 L 711 1046 L 702 1048 L 686 1048 L 672 1044 L 654 1032 L 644 1021 L 634 1006 L 628 993 L 620 966 L 618 954 L 619 931 Z M 618 927 L 618 929 L 620 929 L 620 927 Z M 693 923 L 679 928 L 667 940 L 661 955 L 661 968 L 666 981 L 677 993 L 690 999 L 700 1000 L 713 997 L 727 987 L 735 973 L 736 954 L 731 941 L 721 930 L 708 924 Z M 431 701 L 412 708 L 403 714 L 390 728 L 384 738 L 379 754 L 379 776 L 387 799 L 395 810 L 405 819 L 426 829 L 435 831 L 452 831 L 471 825 L 482 818 L 493 807 L 505 784 L 507 774 L 507 758 L 504 744 L 500 735 L 492 723 L 477 710 L 458 702 L 447 700 Z M 298 703 L 298 760 L 301 811 L 308 866 L 318 915 L 335 972 L 351 1013 L 376 1064 L 397 1100 L 423 1139 L 456 1182 L 483 1213 L 526 1257 L 583 1307 L 639 1350 L 690 1385 L 733 1412 L 741 1415 L 741 1412 L 711 1367 L 658 1279 L 620 1203 L 603 1159 L 584 1096 L 576 1060 L 568 1002 L 567 939 L 569 913 L 577 863 L 590 816 L 608 772 L 627 738 L 652 703 L 689 663 L 689 661 L 686 661 L 663 680 L 626 716 L 589 762 L 532 838 L 501 873 L 476 892 L 463 898 L 443 903 L 415 902 L 391 893 L 374 881 L 358 865 L 336 832 L 319 795 L 306 752 L 300 717 L 300 703 Z M 694 656 L 692 656 L 691 659 L 693 659 Z M 1025 573 L 1003 581 L 993 592 L 989 600 L 986 614 L 985 660 L 919 661 L 902 668 L 896 674 L 888 690 L 888 735 L 892 742 L 900 750 L 916 758 L 943 761 L 985 760 L 988 816 L 993 829 L 1001 839 L 1014 845 L 1076 845 L 1088 839 L 1099 822 L 1101 810 L 1102 761 L 1158 760 L 1170 757 L 1180 752 L 1188 745 L 1193 736 L 1193 689 L 1187 675 L 1183 670 L 1168 662 L 1158 660 L 1102 659 L 1102 613 L 1100 601 L 1092 587 L 1086 581 L 1066 573 Z" fill="#FFFFFF" fill-rule="evenodd"/> </svg>
    </div>
  </header>

  <!-- ТАЛОН -->
  <form id="talon" novalidate>
    <section class="card card-patient">
      <h2 class="card-title"><span class="step">1</span>Пацієнт</h2>

      <div class="field" data-field="name">
        <label class="label" for="name">ПІБ пацієнта <span class="optional">(повністю)</span></label>
        <input class="input" id="name" type="text" autocomplete="off" autocapitalize="words" spellcheck="false" maxlength="150" placeholder="Прізвище, ім’я та по батькові">
        <p class="field-error"></p>
      </div>

      <div class="row row-age">
        <div class="field" data-field="age">
          <label class="label" for="age">Вік</label>
          <input class="input" id="age" type="text" inputmode="numeric" autocomplete="off" maxlength="6" placeholder="повних років">
          <p class="field-error"></p>
        </div>
        <fieldset class="field" data-field="sex">
          <legend class="label">Стать</legend>
          <div class="seg seg-sex" id="sexOptions"></div>
          <p class="field-error"></p>
        </fieldset>
      </div>

      <fieldset class="field" data-field="residence">
        <legend class="label">Місце проживання</legend>
        <div class="choices" id="residenceOptions"></div>
        <p class="field-error"></p>
      </fieldset>
    </section>

    <section class="card card-diag">
      <h2 class="card-title"><span class="step">2</span>Діагноз</h2>

      <div class="field" data-field="icd">
        <label class="label" for="icd">Діагноз за МКХ-10</label>
        <input class="input icd-input" id="icd" type="text" autocomplete="off" autocapitalize="characters" spellcheck="false" maxlength="12" placeholder="напр. J06.9">
        <p class="field-error"></p>
      </div>

      <div class="field">
        <label class="switch-row" for="firstTime">
          <span class="switch-text">
            <span class="switch-title">Вперше в житті встановлений</span>
            <span class="switch-note">Вимкнено — у таблиці буде «ні»</span>
          </span>
          <input type="checkbox" class="switch" id="firstTime">
        </label>
      </div>
    </section>

    <section class="card card-marks">
      <h2 class="card-title"><span class="step">3</span>Відмітки</h2>

      <fieldset class="field" data-field="disp">
        <legend class="label">Диспансерний облік («Д»)</legend>
        <div class="seg">
          <label class="seg-opt"><input type="radio" name="disp" value="yes"><span>Так</span></label>
          <label class="seg-opt"><input type="radio" name="disp" value="no"><span>Ні</span></label>
        </div>
        <p class="field-error"></p>
      </fieldset>

      <fieldset class="field">
        <legend class="label">Пацієнт належить до категорії <span class="optional">(відмітьте, якщо так)</span></legend>
        <div class="chips">
          <label class="chip"><input type="checkbox" id="catDisability"><span><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M5 12.5l4.5 4.5L19 7.5"/></svg>Особа з інвалідністю</span></label>
          <label class="chip"><input type="checkbox" id="catUbd"><span><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M5 12.5l4.5 4.5L19 7.5"/></svg>УБД</span></label>
          <label class="chip"><input type="checkbox" id="catVpo"><span><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M5 12.5l4.5 4.5L19 7.5"/></svg>ВПО</span></label>
          <label class="chip"><input type="checkbox" id="catChaes"><span><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M5 12.5l4.5 4.5L19 7.5"/></svg>ЧАЕС</span></label>
        </div>
        <p class="hint">Без відмітки в таблицю піде «ні».</p>
      </fieldset>
    </section>

    <section class="card card-doctor">
      <h2 class="card-title"><span class="step">4</span>Лікар і дата</h2>
      <div class="row row-doctor">
        <div class="field" data-field="doctor">
          <label class="label" id="doctorLabel" for="doctorBtn">ПІБ лікаря</label>
          <div class="dd" id="doctorDD">
            <button type="button" class="input dd-face is-empty" id="doctorBtn" data-focus aria-haspopup="listbox" aria-expanded="false" aria-controls="doctorPanel"><span id="doctorFace">Оберіть лікаря…</span></button>
            <div class="dd-panel hidden" id="doctorPanel">
              <input class="dd-search" id="doctorSearch" type="text" autocomplete="off" spellcheck="false" placeholder="Пошук: почніть вводити прізвище" aria-label="Пошук лікаря" aria-controls="doctorList">
              <ul class="dd-list" id="doctorList" role="listbox" aria-labelledby="doctorLabel"></ul>
              <p class="dd-empty hidden" id="doctorEmpty">Нікого не знайдено</p>
            </div>
          </div>
          <input type="hidden" id="doctor" value="">
          <p class="field-error"></p>
        </div>
        <div class="field" data-field="date">
          <label class="label" for="date">Дата прийому</label>
          <input class="input" id="date" type="date">
          <p class="field-error"></p>
        </div>
      </div>
    </section>

    <div id="formError" class="banner banner-error hidden" role="alert"></div>
    <div class="actions">
      <button type="button" class="btn-clear" id="clearBtn"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M4 7h16M9.5 7V4.5h5V7M6.5 7l1 13h9l1-13M10 11v5.5M14 11v5.5"/></svg><span class="btn-text">Очистити все</span></button>
      <button class="btn-primary" id="submitBtn" type="submit"><span class="spinner"></span><span class="btn-text">Надіслати</span></button>
    </div>
  </form>

  <!-- НАДІСЛАНО -->
  <section id="done" class="card done-card hidden" role="status">
    <div class="done-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M5 12.5l4.5 4.5L19 7.5"/></svg></div>
    <h2 class="done-title">Талон надіслано</h2>
    <p class="muted" id="doneText"></p>
    <button class="btn-primary" id="nextBtn" type="button">Заповнити наступний талон</button>
  </section>

  <section id="history" class="history hidden" aria-label="Надіслані талони">
    <h3 class="history-title">Надіслано за сесію<span id="historyWho"></span> · <span id="historyCount">0</span></h3>
    <ul class="history-list" id="historyList"></ul>
  </section>

</div>

<script>
(function(){
  'use strict';

  // ============ НАЛАШТУВАННЯ: зв’язок з Google Формою ============
  // Номери полів (entry.…) узяті з коду самої Google Форми.
  var FORM_ID = '1FAIpQLSfrOndQR0MLnjMX4cILME5mPGwjU18Bn83h-gPAbZX5X-vveg';
  var ENTRY = {
    date:       'entry.1507652961',       // Дата прийому
    doctor:     'entry.970032011',     // ПІБ лікаря
    patient:    'entry.1011731289',    // ПІБ пацієнта
    age:        'entry.931612841',        // Вік
    sex:        'entry.1006773914',        // Стать
    residence:  'entry.659665064',  // Місце проживання
    icd:        'entry.2071646245',        // Діагноз МКХ-10
    firstTime:  'entry.357059091',      // Вперше в житті встановлений
    disp:       'entry.1344933223',       // Диспансерний облік
    disability: 'entry.1030975939', // Особа з інвалідністю
    ubd:        'entry.1543617572',        // УБД
    vpo:        'entry.1186768915',        // ВПО
    chaes:      'entry.418806922'       // ЧАЕС
  };
  // Тексти варіантів — точно як у Google Формі (інакше Google не прийме відповідь).
  var YES = 'так', NO = 'ні';
  var SEX = [ { value: 'Чоловіча', label: 'Чоловіча', kind: 'male' }, { value: 'Жіноча', label: 'Жіноча', kind: 'female' } ];
  // Місце проживання: value — точно як у Google Формі; title / note — як це показано на сторінці.
  var RESIDENCE = [
    { value: 'Місто', title: 'Місто' },
    { value: 'Село (Бурлача Балка, Малодолинське)', title: 'Село', note: 'Бурлача Балка, Малодолинське' },
    { value: 'Село (інше)', title: 'Інше село' }
  ];
  var DOCTORS = ["Алексєєва Олена Василівна", "Андрусенко Світлана Віталіївна", "Барабанова Ольга Михайлівна", "Бардачова Юлія Миколаївна", "Батющенко Людмила Іванівна", "Булкіна Людмила Юріївна", "Даценко Тамара Павлівна", "Денисюк Юлія Олександрівна", "Доценко Дмитро Валерійович", "Емануїлова Олена Євгенівна", "Заславська Олена Володимирівна", "Ковальова Майя Іванівна", "Ковальчук Ірина Віталіївна", "Красовська Євгенія Михайлівна", "Кривцова Ніна Дмитрівна", "Курта Ліна Григорівна", "Лімаренкова Наталя Леонідівна", "Людвік Тетяна Костянтинівна", "Малишкіна Людмила Костянтинівна", "Мальцева Владислава Олегівна", "Мартинюк Данна Володимирівна", "Матюхіна Ірина Анатоліївна", "Мелєхова Ольга Валентинівна", "Мельник Світлана Федорівна", "Мул Галина Олександрівна", "Олейко Олександр Васильович", "Панасюк Світлана Георгіївна", "Полятинчук Ольга Олександрівна", "Пчелінська Оксана Валентинівна", "Романишин Марія Петрівна", "Сачалелі Тамара Василівна", "Татарчук Лариса Миколаївна", "Флоренко Олена Володимирівна", "Царук Лілія Миколаївна", "Цепкова Наталя Вікторівна", "Яремчук Наталія Федорівна"];
  // Таблиця відповідей цієї форми: з неї береться список «Надіслано за сесію»
  // (лише час, дата прийому, пацієнт і діагноз — за сьогодні й для вибраного лікаря).
  var SHEET_ID = '1fjnrTKGQLw1-thwsawwgZY6vO8uKa-yxwfghQIqCsrY', SHEET_GID = '1982044489';
  // Коли таблицю закрито, список береться через скрипт таблиці (Apps Script): він віддає лише сьогоднішні талони
  // вибраного лікаря, ПІБ уже зашифровано. Порожнє посилання — таблиця читається напряму (тоді вона має бути відкрита).
  var SCRIPT_URL = 'https://script.google.com/macros/s/AKfycbxGzTM7bMGVzBqC3IgliHUpBxX7sd_gTDownO_t5m2BVD-E2UzT_jmpJWR6vTPRuSWFtQ/exec';
  var SCRIPT_KEY = 'QlJbNltAL1XVtMGiVGFzuyZdPA22Fi7K';
  // ================================================================

  var FORM_ACTION = 'https://docs.google.com/forms/d/e/' + FORM_ID + '/formResponse';
  var configured = Object.keys(ENTRY).every(function(k){ return /^entry\.\d+$/.test(ENTRY[k]); });

  function $(id){ return document.getElementById(id); }
  function storage(){
    var s = null;
    try { s = window.localStorage; s.getItem('x'); } catch (e) { s = null; }
    return {
      ok: !!s,
      get: function(k){ try { return s ? s.getItem(k) : null; } catch (e) { return null; } },
      set: function(k, v){ try { if (s) s.setItem(k, v); } catch (e) {} },
      remove: function(k){ try { if (s) s.removeItem(k); } catch (e) {} }
    };
  }
  // Самоперевірка: сторінка, відкрита з #test у кінці адреси (або кнопкою у «Самоперевірка.html»). Талони тоді нікуди
  // не надсилаються (запит перехоплюється й перевіряється), а історія й вибраний лікар живуть лише в пам’яті сторінки.
  var TEST = /^#test(?![\w-])/i.test(location.hash);
  function memStorage(){
    var m = {};
    return { ok: true, get: function(k){ return m.hasOwnProperty(k) ? m[k] : null; }, set: function(k, v){ m[k] = String(v); }, remove: function(k){ delete m[k]; } };
  }
  var local = TEST ? memStorage() : storage();
  // Історія надісланих талонів — лише за сьогодні. Зберігається в цьому браузері; наступного дня стирається сама.
  var HISTORY_KEY = 'talonHistory';
  var todayLog = { day: '', items: [] };   // items: найновіші — першими
  var finePointer = window.matchMedia && window.matchMedia('(pointer:fine)').matches;

  // ---- МКХ-10: кирилиця, схожа на латиницю → латиниця; кома → крапка; J069 → J06.9 ----
  var LOOKALIKE = { 'А':'A','В':'B','С':'C','Е':'E','Н':'H','І':'I','К':'K','М':'M','О':'O','Р':'P','Т':'T','Х':'X','У':'Y' };
  // Код: 1 латинська літера, 2 цифри, за потреби крапка й 1–2 цифри (J06.9, I10, K29.70)
  // або 5-й знак після другої крапки (I11.1.7, E11.9.2) — у таблицю йде так, як записано.
  var ICD_RE = /^[A-Z]\d{2}(\.\d{1,2}|\.\d\.\d)?$/;
  function icdLive(s){ return String(s || '').toUpperCase().replace(/,/g, '.').replace(/[АВСЕНІКМОРТХУ]/g, function(ch){ return LOOKALIKE[ch]; }); }
  // крапку після рубрики ставимо самі: J069 → J06.9, J0691 → J06.91, I111.7 → I11.1.7
  function icdFull(s){
    var c = icdLive(s).replace(/\s+/g, '');
    if (/^[A-Z]\d{3,4}$/.test(c) || /^[A-Z]\d{3}\.\d?$/.test(c)) c = c.slice(0, 3) + '.' + c.slice(3);
    return c;
  }
  function hasTwoDots(c){ return c.split('.').length > 2; }        // код із двома крапками
  // чи може це бути початком правильного коду (поки людина ще вводить)
  function icdPrefixOk(c){ return c === '' || /^[A-Z]\d{0,2}$/.test(c) || /^[A-Z]\d{2}\.\d{0,2}$/.test(c) || /^[A-Z]\d{2}\.\d\.\d?$/.test(c); }
  var AGE_MAX = 120;
  var MSG = {
    ageDigits: 'Вік — лише цифри',
    ageMax: 'Вік не може бути більше ' + AGE_MAX,
    icdChars: 'Тільки 1 латинська літера й цифри коду, напр. J06.9',
    icdShort: 'Код неповний — допишіть, напр. J06.9',
    icdDots: 'Код із двома крапками — лише так: I11.1.7',
    icdShortDots: 'Код неповний — допишіть, напр. I11.1.7',
    nameChars: 'Лише українські літери, апостроф і дефіс',
    nameFull: 'Введіть ПІБ повністю: прізвище, ім’я та по батькові'
  };
  // що не так із заповненим полем ('' — усе гаразд)
  function nameError(v){ return !NAME_CHARS.test(v) ? MSG.nameChars : !nameFull(v) ? MSG.nameFull : ''; }
  function icdError(v){ return ICD_RE.test(v) ? '' : icdPrefixOk(v) ? (hasTwoDots(v) ? MSG.icdShortDots : MSG.icdShort) : icdProblem(v); }
  // зайвий символ під час введення: пояснення, чому він не вписується
  function icdProblem(v){ return icdPrefixOk(v) ? '' : hasTwoDots(v) ? MSG.icdDots : MSG.icdChars; }

  // ---- ПІБ: латинські літери, схожі на кириличні, замінюємо на українські; апостроф — на ’ ----
  var NAME_LOOKALIKE = { 'A':'А','B':'В','C':'С','E':'Е','H':'Н','I':'І','K':'К','M':'М','O':'О','P':'Р','T':'Т','X':'Х','Y':'У','Ï':'Ї',
                         'a':'а','c':'с','e':'е','i':'і','k':'к','o':'о','p':'р','x':'х','y':'у','ï':'ї' };
  var NAME_CHARS = /^[А-ЯЁҐЄІЇа-яёґєії’\- ]*$/;
  function nameLive(raw){
    return String(raw || '')
      .replace(/[ABCEHIKMOPTXYÏaceikopxyï]/g, function(ch){ return NAME_LOOKALIKE[ch]; })
      .replace(/['`ʼ‘]/g, '’')
      .replace(/^\s+/, '')
      .replace(/\s{2,}/g, ' ');
  }
  // ПІБ повністю: щонайменше 3 слова, кожне — не менше 2 літер (без ініціалів)
  function nameFull(v){
    var parts = clean(v).split(' ').filter(Boolean);
    return parts.length >= 3 && parts.every(function(p){ return p.replace(/[’\-]/g, '').length >= 2; });
  }

  function clean(s){ return String(s || '').replace(/[\u0000-\u001F\u007F]+/g, ' ').replace(/\s+/g, ' ').trim(); }
  function pad(n){ return (n < 10 ? '0' : '') + n; }
  function ymd(d){ return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate()); }
  function hhmm(d){ return pad(d.getHours()) + ':' + pad(d.getMinutes()); }

  // ---- варіанти з налаштувань ----
  (function renderOptions(){
    var sexBox = $('sexOptions');
    // значки ♂ / ♀ (чоловіча — блакитна, жіноча — рожева)
    var SEX_ICONS = {
      male: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="9.5" cy="14.5" r="5.5"/><path d="M13.5 10.5L20 4M14.5 4H20v5.5"/></svg>',
      female: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="8.5" r="5.5"/><path d="M12 14v8M8.5 18.5h7"/></svg>'
    };
    SEX.forEach(function(o){
      var label = document.createElement('label'); label.className = 'seg-opt ' + o.kind;
      var input = document.createElement('input'); input.type = 'radio'; input.name = 'sex'; input.value = o.value;
      var span = document.createElement('span');
      span.innerHTML = SEX_ICONS[o.kind];
      span.appendChild(document.createTextNode(o.label));
      label.appendChild(input); label.appendChild(span); sexBox.appendChild(label);
    });
    var resBox = $('residenceOptions');
    RESIDENCE.forEach(function(o){
      var label = document.createElement('label'); label.className = 'choice';
      var input = document.createElement('input'); input.type = 'radio'; input.name = 'residence'; input.value = o.value;
      var span = document.createElement('span');
      var wrap = document.createElement('span'); wrap.className = 'choice-text';
      var b = document.createElement('b'); b.textContent = o.title; wrap.appendChild(b);
      if (o.note) { var i = document.createElement('i'); i.textContent = o.note; wrap.appendChild(i); }
      span.appendChild(wrap);
      label.appendChild(input); label.appendChild(span); resBox.appendChild(label);
    });
    var saved = local.get('talonDoctor');
    if (saved && DOCTORS.indexOf(saved) !== -1) $('doctor').value = saved;
  })();

  // ---- список лікарів з пошуком ----
  var dd = { box: $('doctorDD'), btn: $('doctorBtn'), panel: $('doctorPanel'), search: $('doctorSearch'),
             list: $('doctorList'), empty: $('doctorEmpty'), value: $('doctor') };
  var ddItems = [], ddActive = -1;
  DOCTORS.forEach(function(name, i){
    var li = document.createElement('li');
    li.className = 'dd-opt'; li.id = 'doc_' + i; li.setAttribute('role', 'option'); li.textContent = name;
    li.addEventListener('mousedown', function(e){ e.preventDefault(); }); // фокус лишається в пошуку
    li.addEventListener('click', function(){ ddChoose(name); });
    li.addEventListener('mousemove', function(){ if (ddActive !== i) ddSetActive(i, false); });
    dd.list.appendChild(li);
    ddItems.push({ name: name, li: li });
  });
  // показати вибраного лікаря повністю (з переносом рядка, якщо ПІБ довге)
  function syncDoctorFace(){
    var v = dd.value.value;
    $('doctorFace').textContent = v || 'Оберіть лікаря…';
    dd.btn.classList.toggle('is-empty', !v);
    ddItems.forEach(function(it){ it.li.setAttribute('aria-selected', it.name === v ? 'true' : 'false'); });
  }
  // видимі пункти в тому порядку, як вони показані
  function ddVisible(){
    return Array.prototype.filter.call(dd.list.children, function(li){ return !li.classList.contains('hidden'); })
      .map(function(li){ return Number(li.id.slice(4)); });
  }
  // пошук за початком слів (прізвище, ім’я, по батькові); збіги за прізвищем — першими
  function ddRank(name, q){
    if (!q) return 0;
    var words = name.toLowerCase().replace(/['`ʼ‘]/g, '’').split(/[\s\-]+/), tokens = q.split(/\s+/).filter(Boolean);
    var ok = tokens.every(function(t){ return words.some(function(w){ return w.indexOf(t) === 0; }); });
    if (!ok) return -1;
    return words[0].indexOf(tokens[0]) === 0 ? 0 : 1;
  }
  function ddSetActive(i, scroll){
    if (ddActive >= 0 && ddItems[ddActive]) ddItems[ddActive].li.classList.remove('active');
    ddActive = i;
    if (i >= 0) {
      ddItems[i].li.classList.add('active');
      dd.search.setAttribute('aria-activedescendant', ddItems[i].li.id);
      if (scroll !== false) ddItems[i].li.scrollIntoView({ block: 'nearest' });
    } else dd.search.removeAttribute('aria-activedescendant');
  }
  function ddFilter(){
    var q = dd.search.value.trim().toLowerCase().replace(/['`ʼ‘]/g, '’');
    var ranked = ddItems.map(function(it, i){ return { i: i, r: ddRank(it.name, q) }; });
    ranked.sort(function(a, b){ return (a.r < 0) - (b.r < 0) || a.r - b.r || a.i - b.i; });
    ranked.forEach(function(x){ var li = ddItems[x.i].li; li.classList.toggle('hidden', x.r < 0); dd.list.appendChild(li); });
    var vis = ddVisible();
    dd.empty.classList.toggle('hidden', vis.length > 0);
    var cur = DOCTORS.indexOf(dd.value.value);
    ddSetActive(vis.indexOf(cur) !== -1 && !q ? cur : (vis.length ? vis[0] : -1));
  }
  function ddOpen(){
    dd.search.value = '';
    dd.panel.classList.remove('hidden', 'dd-up');
    dd.btn.setAttribute('aria-expanded', 'true');
    ddFilter();
    // мало місця знизу екрана — відкриваємо список угору
    var b = dd.btn.getBoundingClientRect(), p = dd.panel.getBoundingClientRect();
    if (p.bottom > window.innerHeight && b.top - (p.bottom - b.bottom) > 0) dd.panel.classList.add('dd-up');
    if (finePointer) dd.search.focus();
  }
  function ddClose(focusBtn){
    dd.panel.classList.add('hidden');
    dd.btn.setAttribute('aria-expanded', 'false');
    if (focusBtn) dd.btn.focus();
  }
  function ddChoose(name){
    var changed = dd.value.value !== name;
    dd.value.value = name;
    syncDoctorFace();
    setError('doctor', '');
    ddClose(true);
    if (changed) onDoctorChange();
  }
  dd.btn.addEventListener('click', function(){ if (dd.panel.classList.contains('hidden')) ddOpen(); else ddClose(false); });
  dd.btn.addEventListener('keydown', function(e){
    if (e.key === 'ArrowDown' || e.key === 'ArrowUp') { e.preventDefault(); if (dd.panel.classList.contains('hidden')) ddOpen(); }
  });
  dd.search.addEventListener('input', ddFilter);
  dd.search.addEventListener('keydown', function(e){
    var vis = ddVisible(), pos = vis.indexOf(ddActive);
    if (e.key === 'ArrowDown' || e.key === 'ArrowUp') {
      e.preventDefault(); e.stopPropagation();
      if (vis.length) ddSetActive(vis[e.key === 'ArrowDown' ? Math.min(vis.length - 1, pos + 1) : Math.max(0, pos - 1)]);
    } else if (e.key === 'Enter') {
      e.preventDefault(); e.stopPropagation();
      if (ddActive >= 0) ddChoose(ddItems[ddActive].name);
    } else if (e.key === 'Escape') {
      e.preventDefault(); e.stopPropagation(); ddClose(true);
    } else if (e.key === 'Tab') {
      ddClose(false);
    }
  });
  document.addEventListener('mousedown', function(e){ if (!dd.panel.classList.contains('hidden') && !dd.box.contains(e.target)) ddClose(false); });
  document.addEventListener('keydown', function(e){ if (e.key === 'Escape' && !dd.panel.classList.contains('hidden')) ddClose(true); });
  syncDoctorFace();

  // ---- дата: сьогодні ----
  // Якщо сторінка лишилася відкритою з учорашнього дня, «сьогоднішня» дата сама стає новою (опівночі, коли до сторінки
  // повертаються або починають новий талон). Дату, вибрану вручну (талони за інший день), і талон, який саме заповнюють, не чіпаємо.
  var dateToday = ymd(new Date());
  function minDate(){ return (new Date().getFullYear() - 1) + '-01-01'; }   // давніше — найімовірніше, помилка в році
  function dateLimits(){ $('date').max = ymd(new Date(Date.now() + 86400000)); $('date').min = minDate(); }
  function rollDate(){
    var t = ymd(new Date());
    if (t === dateToday) return;
    dateLimits();
    if (patientStarted()) return;
    if ($('date').value === dateToday) $('date').value = t;
    dateToday = t;
  }
  $('date').value = dateToday;
  dateLimits();

  // ---- помилки ----
  function fieldBox(name){ return document.querySelector('[data-field="' + name + '"]'); }
  function setError(name, msg){
    var box = fieldBox(name);
    if (!box) return;
    box.classList.toggle('invalid', !!msg);
    var p = box.querySelector('.field-error');
    if (p) p.textContent = msg || '';
    box.querySelectorAll('input:not([type=radio]):not([type=checkbox]), select').forEach(function(el){
      if (msg) el.setAttribute('aria-invalid', 'true'); else el.removeAttribute('aria-invalid');
    });
  }
  function clearErrors(){
    document.querySelectorAll('.field.invalid').forEach(function(b){ setError(b.getAttribute('data-field'), ''); });
    hideBanner();
  }
  function banner(msg){ var b = $('formError'); b.textContent = msg; b.classList.remove('hidden'); }
  function hideBanner(){ $('formError').classList.add('hidden'); }
  var focusTimer = null;
  function focusField(name){
    var box = fieldBox(name);
    if (!box) return;
    var el = box.querySelector('[data-focus]') || box.querySelector('input:not([type=hidden]), select');
    box.scrollIntoView({ block: 'center', behavior: 'smooth' });
    clearTimeout(focusTimer);
    if (el) focusTimer = setTimeout(function(){ try { el.focus({ preventScroll: true }); } catch (e) { el.focus(); } }, 250);
  }
  // якщо людина вже сама перейшла до іншого поля — не «перехоплюємо» фокус
  document.addEventListener('focusin', function(e){ if (e.target.closest && e.target.closest('#talon .field')) clearTimeout(focusTimer); });
  $('talon').addEventListener('input', onEdit);
  $('talon').addEventListener('change', onEdit);
  function onEdit(e){
    var box = e.target.closest('.field');
    if (!box || box.hasAttribute('data-live')) return; // вік і код перевіряються окремо, нижче
    if (box.classList.contains('invalid')) setError(box.getAttribute('data-field'), '');
  }

  // ---- жива перевірка під час введення: зайвий символ не вписується, під полем — пояснення ----
  // Пояснення до заблокованого символу — спливаюча підказка під полем: вона не зсуває сторінку,
  // тож клік по сусідньому полю не «промахується».
  function guard(id, normalize, problem){
    var el = $(id), box = fieldBox(id), prev = el.value, prevSel = 0, tipTimer = null;
    box.setAttribute('data-live', '');
    var tip = document.createElement('div');
    tip.className = 'live-tip'; tip.setAttribute('role', 'alert');
    el.insertAdjacentElement('afterend', tip);
    function showTip(msg){
      tip.textContent = msg;
      tip.style.top = (el.offsetTop + el.offsetHeight + 8) + 'px';
      box.classList.add('tip-on');
      clearTimeout(tipTimer); tipTimer = setTimeout(hideTip, 2800);
    }
    function hideTip(){ box.classList.remove('tip-on'); clearTimeout(tipTimer); }
    function remember(){ prev = el.value; prevSel = el.selectionStart || 0; }
    el.addEventListener('focus', remember);
    el.addEventListener('beforeinput', remember);
    el.addEventListener('blur', hideTip);
    el.addEventListener('input', function(e){
      var raw = el.value, atEnd = el.selectionStart === raw.length;
      var v = normalize(raw), msg = problem(v);
      var deleting = !!(e.inputType && e.inputType.indexOf('delete') === 0);
      if (msg && !deleting) {           // зайвий символ не вписується, а підказка пояснює чому
        el.value = prev;
        try { el.setSelectionRange(prevSel, prevSel); } catch (err) {}
        showTip(msg);
        return;
      }
      if (v !== raw) {
        var pos = el.selectionStart || 0;
        el.value = v;
        var np = atEnd ? v.length : Math.max(0, Math.min(v.length, pos - (raw.length - v.length)));
        try { el.setSelectionRange(np, np); } catch (err) {}
      }
      remember(); hideTip();
      if (msg) setError(id, msg);       // стирати можна завжди; якщо після стирання код неправильний — помилка під полем
      else if (box.classList.contains('invalid')) setError(id, '');
    });
  }
  guard('age',
    function(raw){ return raw.replace(/\s+/g, ''); },
    function(v){ if (/\D/.test(v)) return MSG.ageDigits; if (v !== '' && Number(v) > AGE_MAX) return MSG.ageMax; return ''; });
  guard('icd', icdFull, icdProblem);
  guard('name', nameLive, function(v){ return NAME_CHARS.test(v) ? '' : MSG.nameChars; });
  // Вийшли з поля (Tab, Enter, клік по іншому полю чи розділу) з неповним ПІБ або кодом — помилку видно одразу,
  // а не лише після «Надіслати». Порожнє поле не підсвічуємо, поки не натиснули «Надіслати».
  // Якщо людина просто перемкнулася на інше вікно чи вкладку — це не вихід з поля: нічого не чіпаємо.
  function onLeave(id, fix, problem){
    $(id).addEventListener('blur', function(){
      if (!document.hasFocus()) return;
      this.value = fix(this.value);
      var msg = this.value ? problem(this.value) : '';
      if (msg) setError(id, msg);
    });
  }
  onLeave('age', function(v){ return /^\d+$/.test(v) ? String(parseInt(v, 10)) : v; }, function(){ return ''; });
  onLeave('icd', icdFull, icdError);
  onLeave('name', clean, nameError);

  // Enter у полі — перехід до наступного поля, а не надсилання
  function focusables(){
    var groups = {};
    return Array.prototype.filter.call($('talon').querySelectorAll('input, select, button'), function(el){
      if (el.disabled || el.offsetParent === null) return false;
      if (el.type === 'radio') {
        if (groups[el.name]) return false;
        var checked = document.querySelector('input[name="' + el.name + '"]:checked');
        if (checked && checked !== el) return false;
        groups[el.name] = true;
      }
      return true;
    });
  }
  $('talon').addEventListener('keydown', function(e){
    if (e.key !== 'Enter' || e.target.tagName === 'BUTTON') return;
    e.preventDefault();
    var all = focusables(), i = all.indexOf(e.target);
    if (i > -1 && all[i + 1]) all[i + 1].focus();
  });

  // ---- збирання й перевірка ----
  function radio(name){ var el = document.querySelector('input[name="' + name + '"]:checked'); return el ? el.value : ''; }
  function collect(){
    var flag = function(id){ return $(id).checked ? 'yes' : 'no'; };
    return {
      name: clean($('name').value),
      age: (function(v){ return /^\d+$/.test(v) ? String(parseInt(v, 10)) : v; })($('age').value.replace(/\s+/g, '')),
      sex: radio('sex'),
      residence: radio('residence'),
      icd: icdFull($('icd').value),
      firstTime: flag('firstTime'),
      disp: radio('disp'),
      disability: flag('catDisability'),
      ubd: flag('catUbd'),
      vpo: flag('catVpo'),
      chaes: flag('catChaes'),
      doctor: $('doctor').value,
      date: $('date').value
    };
  }
  function validate(d){
    var e = {};
    if (!d.name) e.name = 'Вкажіть ПІБ пацієнта';
    else if (nameError(d.name)) e.name = nameError(d.name);
    if (d.age === '') e.age = 'Вкажіть вік';
    else if (/\D/.test(d.age)) e.age = MSG.ageDigits;
    else if (Number(d.age) > AGE_MAX) e.age = MSG.ageMax;
    if (!d.sex) e.sex = 'Оберіть стать';
    if (!d.residence) e.residence = 'Оберіть місце проживання';
    if (!d.icd) e.icd = 'Вкажіть код за МКХ-10';
    else if (icdError(d.icd)) e.icd = icdError(d.icd);
    if (!d.disp) e.disp = 'Вкажіть диспансерний облік: так чи ні';
    if (!d.doctor) e.doctor = 'Оберіть лікаря';
    if (!d.date) e.date = 'Вкажіть дату прийому';
    else if (!/^\d{4}-\d{2}-\d{2}$/.test(d.date)) e.date = 'Вкажіть дату прийому повністю';
    else if (d.date > ymd(new Date(Date.now() + 86400000))) e.date = 'Дата не може бути в майбутньому';
    else if (d.date < minDate()) e.date = 'Дата надто давня — перевірте рік';
    return e;
  }
  // Поля — у тому ж вигляді, як їх надсилає сама Google Форма (дата: _year/_month/_day; у варіантів — _sentinel).
  function body(d){
    var yn = function(v){ return v === 'yes' ? YES : NO; };
    var p = new URLSearchParams();
    var ymdParts = d.date.split('-');
    p.append(ENTRY.date + '_year', ymdParts[0]);
    p.append(ENTRY.date + '_month', String(Number(ymdParts[1])));
    p.append(ENTRY.date + '_day', String(Number(ymdParts[2])));
    p.append(ENTRY.doctor, d.doctor);
    p.append(ENTRY.patient, d.name);
    p.append(ENTRY.age, d.age);
    function choice(key, value){ p.append(ENTRY[key], value); p.append(ENTRY[key] + '_sentinel', ''); }
    choice('sex', d.sex);
    choice('residence', d.residence);
    p.append(ENTRY.icd, d.icd);
    choice('firstTime', yn(d.firstTime));
    choice('disp', yn(d.disp));
    choice('disability', yn(d.disability));
    choice('ubd', yn(d.ubd));
    choice('vpo', yn(d.vpo));
    choice('chaes', yn(d.chaes));
    p.append('fvv', '1');
    p.append('pageHistory', '0');
    return p;
  }

  // ---- надсилання ----
  function setBusy(busy){
    var btn = $('submitBtn');
    btn.disabled = busy;
    btn.classList.toggle('busy', busy);
    btn.querySelector('.btn-text').textContent = busy ? 'Надсилаю…' : 'Надіслати';
  }
  function show(name){
    $('talon').classList.toggle('hidden', name !== 'talon');
    $('done').classList.toggle('hidden', name !== 'done');
  }

  $('talon').addEventListener('submit', function(e){
    e.preventDefault();
    clearErrors();
    var d = collect();
    if (d.icd) $('icd').value = d.icd;
    var errs = validate(d), keys = Object.keys(errs);
    if (keys.length) {
      keys.forEach(function(k){ setError(k, errs[k]); });
      focusField(keys[0]);
      return;
    }
    if (!configured) { banner('Сторінку ще не підключено до Google Форми (немає номерів полів).'); return; }
    setBusy(true);
    // Google не повертає відповіді на такий запит (no-cors), тож помилку видно лише тоді, коли немає зв’язку.
    send(FORM_ACTION, { method: 'POST', mode: 'no-cors', body: body(d) })
      .then(function(){ saved(d); })
      .catch(function(){ banner('Не вдалося надіслати талон — перевірте інтернет і спробуйте ще раз. Дані з форми не втрачено.'); })
      .then(function(){ setBusy(false); });
  });

  function send(url, opts){ return TEST ? stSend(url, opts) : fetch(url, opts); }   // у тестовому режимі — перехоплення
  function saved(d){
    local.set('talonDoctor', d.doctor);
    addToHistory(d);
    $('doneText').textContent = maskName(d.name) + ' · ' + d.icd;
    show('done');
    window.scrollTo(0, 0);
    try { $('nextBtn').focus({ preventScroll: true }); } catch (e) {}
  }

  // ---- історія за сьогодні ----
  // Для вибраного лікаря список «Надіслано за сесію» береться з таблиці відповідей Google Форми, тож не залежить
  // від кешу браузера: він є й після перезавантаження, і в приватному вікні, і на іншому комп’ютері чи телефоні.
  // Надіслане з цього браузера ще й зберігається тут — на випадок, коли таблиця недоступна (немає інтернету).
  function loadHistory(){
    var today = ymd(new Date());
    if (!local.ok) { if (todayLog.day !== today) todayLog = { day: today, items: [] }; return; }  // без сховища — до перезавантаження
    var h = null;
    try { h = JSON.parse(local.get(HISTORY_KEY) || 'null'); } catch (e) { h = null; }
    if (h && h.day === today && Array.isArray(h.items)) {
      var changed = false;
      h.items.forEach(function(s){ var m = maskName(s.name); if (m !== s.name) { s.name = m; changed = true; } });
      todayLog = { day: today, items: h.items };
      if (changed) local.set(HISTORY_KEY, JSON.stringify(todayLog));   // записи попередньої версії — теж без повних ПІБ
    } else {
      if (h) local.remove(HISTORY_KEY);   // записи за минулі дні не зберігаємо
      todayLog = { day: today, items: [] };
    }
  }
  function addToHistory(d){
    loadHistory();                        // інша вкладка могла вже додати свої талони, а дата — змінитися
    var now = new Date();
    todayLog.items.unshift({ t: hhmm(now), sec: now.getHours() * 3600 + now.getMinutes() * 60 + now.getSeconds(),
                             name: maskName(d.name), icd: d.icd, doctor: d.doctor, date: d.date });
    if (todayLog.items.length > 500) todayLog.items.length = 500;
    local.set(HISTORY_KEY, JSON.stringify(todayLog));
    renderHistory();
    setTimeout(loadSheet, 3000);          // Google додає рядок у таблицю за кілька секунд — тоді перечитуємо її
    setTimeout(loadSheet, 20000);
  }
  // ПІБ пацієнта на екрані й в історії — зашифроване: у кожному слові перші 2 літери, решта — зірочки
  // (Іваненко Іван Іванович → Ів****** Ів** Ів******). Повне ПІБ іде лише в Google Форму й на комп’ютері не зберігається.
  var LETTER = /[A-Za-zА-ЯЁҐЄІЇа-яёґєії]/;
  function maskName(full){
    return String(full || '').split(' ').filter(Boolean).map(function(word){
      return word.split('-').map(function(part){          // подвійне прізвище: Д’Артаньян-Петренко → Д’А*******-Пе******
        var shown = 0, out = '';
        for (var i = 0; i < part.length; i++) {
          var ch = part.charAt(i);
          if (shown < 2) { out += ch; if (LETTER.test(ch)) shown++; } else out += '*';
        }
        return out;
      }).join('-');
    }).join(' ');
  }
  function make(tag, cls, text){ var x = document.createElement(tag); x.className = cls; x.textContent = text == null ? '' : String(text); return x; }
  function shortName(full){
    var p = String(full || '').split(' ').filter(Boolean);
    return p.length ? p[0] + p.slice(1).map(function(w){ return ' ' + w.charAt(0) + '.'; }).join('') : '';
  }
  function dayMonth(s){ var p = String(s).split('-'); return p[2] + '.' + p[1] + (p[0] !== todayLog.day.slice(0, 4) ? '.' + p[0] : ''); }
  // ---- читання таблиці відповідей (JSONP, як у дашборді) ----
  var sheet = { cols: null, doctor: '', day: '', items: null, turn: 0, last: 0 };
  var gvizSeq = 0;
  function jsonp(urlFor, accept){
    return new Promise(function(resolve, reject){
      var cb = '__talonGviz' + (++gvizSeq) + '_' + Date.now(), s = document.createElement('script'), done = false;
      var timer = setTimeout(function(){ finish(new Error('timeout')); }, 15000);
      function finish(err, value){
        if (done) return;
        done = true; clearTimeout(timer);
        try { delete window[cb]; } catch (e) { window[cb] = undefined; }
        if (s.parentNode) s.parentNode.removeChild(s);
        if (err) reject(err); else resolve(value);
      }
      window[cb] = function(res){ var v = accept(res); if (v) finish(null, v); else finish(new Error('query')); };
      s.onerror = function(){ finish(new Error('network')); };
      s.onload = function(){ setTimeout(function(){ finish(new Error('denied')); }, 0); };   // замість даних — сторінка входу
      s.src = urlFor(cb);
      document.head.appendChild(s);
    });
  }
  function gviz(tq){
    return jsonp(function(cb){
      return 'https://docs.google.com/spreadsheets/d/' + SHEET_ID + '/gviz/tq?tqx=out:json;responseHandler:' + cb +
             '&headers=1&gid=' + SHEET_GID + '&tq=' + encodeURIComponent(tq);
    }, function(res){ return res && res.status === 'ok' && res.table ? res.table : null; });
  }
  // скрипт таблиці: сьогоднішні талони лікаря, ПІБ уже зашифровано
  function fromScript(doctor){
    return jsonp(function(cb){
      return SCRIPT_URL + (SCRIPT_URL.indexOf('?') === -1 ? '?' : '&') + 'what=today&key=' + encodeURIComponent(SCRIPT_KEY) +
             '&doctor=' + encodeURIComponent(doctor) + '&callback=' + cb + '&_=' + Date.now();
    }, function(res){ return res && res.status === 'ok' && Array.isArray(res.items) ? res : null; });
  }
  // колонки шукаємо за назвами питань (якщо в Google Формі змінять порядок питань — усе одно знайдуться)
  function sheetColumns(table){
    function find(re){ var c = (table.cols || []).filter(function(c){ return re.test(String(c.label || '').toLowerCase()); })[0]; return c ? c.id : ''; }
    var c = { ts: find(/позначка часу|timestamp/) || 'A', date: find(/дата прийому/), doctor: find(/лікар/), patient: find(/пацієнт/), icd: find(/мкх|діагноз/) };
    return c.doctor && c.patient && c.icd ? c : null;
  }
  function lit(s){ return s.indexOf("'") === -1 ? "'" + s + "'" : '"' + s.replace(/"/g, '') + '"'; }
  function gDate(cell){
    var m = cell && typeof cell.v === 'string' ? /^Date\((\d+),(\d+),(\d+)(?:,(\d+),(\d+)(?:,(\d+))?)?/.exec(cell.v) : null;
    return m ? { ymd: m[1] + '-' + pad(+m[2] + 1) + '-' + pad(+m[3]), hm: pad(+(m[4] || 0)) + ':' + pad(+(m[5] || 0)),
                 sec: (+(m[4] || 0)) * 3600 + (+(m[5] || 0)) * 60 + (+(m[6] || 0)) } : null;
  }
  function loadSheet(){
    if (TEST) return;                                  // тестовий режим: таблицю не читаємо
    var doctor = dd.value.value, day = ymd(new Date()), turn = ++sheet.turn;
    if (!doctor) return;
    sheet.last = Date.now();
    var got = SCRIPT_URL ? fromScript(doctor).then(function(res){
      if (res.day !== day) throw new Error('day');   // у скрипта вже інший день (опівночі) — візьмемо наступного разу
      return res.items.map(function(it, i){
        return { t: String(it.t || ''), sec: +it.sec || 0, name: maskName(clean(it.name)), icd: clean(it.icd).toUpperCase(),
                 doctor: doctor, date: String(it.date || ''), sheet: true, row: i };
      });
    }) : (sheet.cols ? Promise.resolve(sheet.cols) : gviz('limit 0').then(function(t){
      sheet.cols = sheetColumns(t);
      if (!sheet.cols) throw new Error('columns');
      return sheet.cols;
    })).then(function(c){
      var pick = [c.ts, c.patient, c.icd].concat(c.date ? [c.date] : []);
      // без «order by»: рядки йдуть у порядку таблиці (нижчий — новіший), це розставляє й талони з однаковою секундою
      return gviz('select ' + pick.join(', ') + ' where ' + c.ts + " >= datetime '" + day + " 00:00:00' and " +
                  c.doctor + ' = ' + lit(doctor));
    }).then(function(t){
      return (t.rows || []).map(function(r, i){
        var c = r.c || [], ts = gDate(c[0]), ap = gDate(c[3]);
        if (!ts || ts.ymd !== day) return null;
        return { t: ts.hm, sec: ts.sec, name: maskName(clean(c[1] && c[1].v)), icd: String(c[2] && c[2].v != null ? c[2].v : '').trim().toUpperCase(),
                 doctor: doctor, date: ap ? ap.ymd : '', sheet: true, row: i };
      }).filter(Boolean);
    });
    got.then(function(items){
      if (turn !== sheet.turn) return;                 // тим часом обрали іншого лікаря — ця відповідь уже не потрібна
      sheet.doctor = doctor; sheet.day = day; sheet.items = items;
      renderHistory();
    }).catch(function(){ /* немає інтернету чи доступу до таблиці — лишається список із цього браузера */ });
  }
  // секунди від півночі — щоб розставити талони від найновішого (у записів попередньої версії є лише «гг:хх»)
  function secOf(s){ if (s.sec != null) return s.sec; var p = String(s.t).split(':'); return ((+p[0]) * 60 + (+p[1] || 0)) * 60; }
  // список для показу: з таблиці (для вибраного лікаря) + надіслане звідси, чого в таблиці ще немає
  function historyItems(doctor){
    var mine = todayLog.items.filter(function(s){ return !doctor || s.doctor === doctor; });
    if (!doctor || !sheet.items || sheet.doctor !== doctor || sheet.day !== todayLog.day) return mine;
    var out = sheet.items.slice(), used = {};
    mine.forEach(function(l){
      for (var i = 0; i < sheet.items.length; i++) {
        var r = sheet.items[i];
        if (!used[i] && r.name === l.name && r.icd === l.icd && Math.abs(secOf(r) - secOf(l)) <= 600) { used[i] = true; return; }
      }
      out.push(l);                                     // щойно надіслане — у таблиці з’явиться за кілька секунд
    });
    // найновіші — першими; за однакового часу — спершу щойно надіслане звідси, далі нижчі рядки таблиці
    return out.sort(function(a, b){ return secOf(b) - secOf(a) || (a.sheet ? 1 : 0) - (b.sheet ? 1 : 0) || (b.row || 0) - (a.row || 0); });
  }
  function renderHistory(){
    var doctor = dd.value.value, list = $('historyList'), items = historyItems(doctor), docs = {};
    items.forEach(function(s){ if (s.doctor) docs[s.doctor] = true; });
    var manyDoctors = !doctor && Object.keys(docs).length > 1;   // лікаря не вибрано, а звідси вносили кілька — підписуємо, чий талон
    list.innerHTML = '';
    items.forEach(function(s){
      var li = document.createElement('li'), main = make('span', 'h-main');
      main.appendChild(make('span', 'h-name', s.name));
      var notes = [];
      if (manyDoctors && s.doctor) notes.push(shortName(s.doctor));
      if (s.date && s.date !== todayLog.day) notes.push('прийом ' + dayMonth(s.date));   // талон за інший день
      if (notes.length) main.appendChild(make('span', 'h-note', notes.join(' · ')));
      li.appendChild(make('span', 'h-time', s.t));
      li.appendChild(main);
      li.appendChild(make('span', 'h-icd', s.icd));
      list.appendChild(li);
    });
    $('historyWho').textContent = doctor ? ' · ' + shortName(doctor) : '';
    $('historyCount').textContent = items.length;
    $('history').classList.toggle('hidden', items.length === 0);
  }
  function refreshHistory(){ loadHistory(); renderHistory(); }
  function onDoctorChange(){ renderHistory(); loadSheet(); }
  // талон надіслали з іншої вкладки, повернулися до сторінки або настав новий день — список оновлюється сам
  window.addEventListener('storage', function(e){ if (e.key === HISTORY_KEY || e.key === null) refreshHistory(); });
  document.addEventListener('visibilitychange', function(){
    if (document.hidden) return;
    rollDate();
    refreshHistory();
    if (Date.now() - sheet.last > 20000) loadSheet();
  });
  window.addEventListener('focus', rollDate);
  $('talon').addEventListener('focusin', rollDate);   // почали новий талон наступного дня
  (function atMidnight(){
    var n = new Date(), next = new Date(n.getFullYear(), n.getMonth(), n.getDate() + 1, 0, 0, 5);
    setTimeout(function(){ rollDate(); refreshHistory(); loadSheet(); atMidnight(); }, next - n);
  })();
  refreshHistory();
  loadSheet();

  // чи почали вносити пацієнта (лікар і дата — не в рахунок)
  function patientStarted(){
    return !!($('name').value || $('age').value || $('icd').value || radio('sex') || radio('residence') || radio('disp') ||
      ['firstTime', 'catDisability', 'catUbd', 'catVpo', 'catChaes'].some(function(id){ return $(id).checked; }));
  }
  function resetPatient(){
    ['name', 'age', 'icd'].forEach(function(id){ $(id).value = ''; });
    document.querySelectorAll('input[name="sex"], input[name="residence"], input[name="disp"]').forEach(function(r){ r.checked = false; });
    ['firstTime', 'catDisability', 'catUbd', 'catVpo', 'catChaes'].forEach(function(id){ $(id).checked = false; });
    clearErrors();
  }

  $('nextBtn').addEventListener('click', function(){
    resetPatient();
    rollDate();
    show('talon');
    window.scrollTo(0, 0);
    if (finePointer) $('name').focus();
  });

  // ---- «Очистити все»: усі поля, разом із лікарем; дата — сьогоднішня ----
  function formHasData(){
    return patientStarted() || !!dd.value.value || $('date').value !== ymd(new Date());
  }
  function clearAll(){
    resetPatient();
    var hadDoctor = !!dd.value.value;
    dd.value.value = '';
    syncDoctorFace();
    if (hadDoctor) onDoctorChange();
    if (!dd.panel.classList.contains('hidden')) ddClose(false);
    dateToday = ymd(new Date());
    dateLimits();
    $('date').value = dateToday;
    window.scrollTo(0, 0);
    if (finePointer) $('name').focus();
  }
  var clearArmed = false, clearTimer = null;
  function disarmClear(){
    clearArmed = false; clearTimeout(clearTimer);
    $('clearBtn').classList.remove('armed');
    $('clearBtn').querySelector('.btn-text').textContent = 'Очистити все';
  }
  $('clearBtn').addEventListener('click', function(){
    if (clearArmed || !formHasData()) { disarmClear(); clearAll(); return; }
    clearArmed = true;                       // перше натискання — лише попередження
    this.classList.add('armed');
    this.querySelector('.btn-text').textContent = 'Натисніть ще раз';
    clearTimer = setTimeout(disarmClear, 3500);
  });
  $('clearBtn').addEventListener('blur', function(){ if (clearArmed) setTimeout(disarmClear, 200); });

  // ================= самоперевірка (#test) =================
  // Звіт згори сторінки: зв’язок із формою, код МКХ-10, ПІБ, перевірка полів, що саме надсилається, шифрування ПІБ,
  // список «Надіслано за сесію», дата прийому, вибір лікаря, надсилання й «Очистити все» на самій сторінці.
  var ST = { groups: [], cur: null, t0: 0, running: false, sent: [], fail: false };
  function stCanon(v){
    if (Object.prototype.toString.call(v) === '[object Array]') return v.map(stCanon);
    if (v && typeof v === 'object'){ var o = {}; Object.keys(v).sort().forEach(function(k){ o[k] = stCanon(v[k]); }); return o; }
    return v;
  }
  function stSame(a, b){ return JSON.stringify(stCanon(a)) === JSON.stringify(stCanon(b)); }
  function stShow(v){ var s = JSON.stringify(v); return s === undefined ? String(v) : s.length > 260 ? s.slice(0, 260) + '…' : s; }
  function stEsc(s){ return String(s == null ? '' : s).replace(/[&<>"']/g, function(c){ return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]; }); }
  function stGroup(title, note){ ST.cur = { title: title, note: note || '', items: [] }; ST.groups.push(ST.cur); }
  function stCheck(name, ok, detail){ ST.cur.items.push({ name: name, ok: !!ok, detail: ok ? '' : String(detail == null ? '' : detail) }); return !!ok; }
  function stEq(name, got, want){ return stCheck(name, stSame(got, want), 'отримано ' + stShow(got) + ', очікувалося ' + stShow(want)); }
  function stWait(ms){ return new Promise(function(r){ setTimeout(r, ms); }); }
  // «надсилання» в тестовому режимі: запит записується для перевірки, у Google нічого не йде
  function stSend(url, opts){
    ST.sent.push({ url: url, method: opts.method, body: String(opts.body) });
    return ST.fail ? Promise.reject(new Error('offline')) : Promise.resolve({});
  }
  function stReal(k){ try { return window.localStorage.getItem(k); } catch (e) { return null; } }

  // ---- звіт ----
  function stCounts(){ var n = 0, bad = 0; ST.groups.forEach(function(g){ g.items.forEach(function(it){ n++; if (!it.ok) bad++; }); }); return { n: n, bad: bad }; }
  function stBox(){
    var box = $('selfTest');
    if (box) return box;
    box = document.createElement('section');
    box.id = 'selfTest'; box.className = 'card selftest'; box.setAttribute('aria-live', 'polite');
    box.innerHTML = '<div class="st-head"><span class="st-badge">ТЕСТОВИЙ РЕЖИМ</span><h2>Самоперевірка талона</h2></div>' +
      '<p class="st-intro">Талони нікуди не надсилаються: перевірка заповнює талон вигаданим пацієнтом, а «надсилання» перехоплює й перевіряє. ' +
      'Список «Надіслано за сесію» й вибраний лікар у цьому браузері не змінюються.</p>' +
      '<div class="st-sum"></div><div class="st-groups"></div>' +
      '<div class="st-actions"><button type="button" class="st-btn" id="stAgain">Перевірити ще раз</button>' +
      '<button type="button" class="st-btn" id="stCopy">Скопіювати звіт</button>' +
      '<a class="st-btn st-solid" id="stExit" href="' + stEsc(location.href.split('#')[0]) + '">Вийти з тестового режиму</a></div>';
    document.querySelector('.page').insertBefore(box, $('talon'));
    $('stAgain').addEventListener('click', function(){ if (!ST.running) runSelfTest(); });
    $('stCopy').addEventListener('click', stCopy);
    return box;
  }
  function stRender(){
    var box = stBox(), c = stCounts(), sum = box.querySelector('.st-sum');
    var secs = ((Date.now() - ST.t0) / 1000).toFixed(1).replace('.', ',');
    sum.className = 'st-sum' + (ST.running ? '' : c.bad ? ' bad' : ' good');
    sum.innerHTML = ST.running ? '<span>Перевіряю… ' + c.n + '</span>'
      : '<span>' + (c.bad ? '✗ Не пройдено: ' + c.bad + ' з ' + c.n : '✓ Пройдено всі перевірки: ' + c.n) + '</span><span class="st-time">за ' + secs + ' с</span>';
    box.querySelector('.st-groups').innerHTML = ST.groups.map(function(g){
      var n = g.items.length, bad = g.items.filter(function(i){ return !i.ok; }).length;
      return '<details class="st-group' + (bad ? ' bad' : '') + '"' + (bad ? ' open' : '') + '><summary><span class="st-mark">' + (bad ? '✗' : '✓') + '</span>' +
        '<span class="st-gt">' + stEsc(g.title) + '</span><span class="st-gc">' + (bad ? 'не пройдено ' + bad + ' з ' + n : n + ' ✓') + '</span></summary>' +
        (g.note ? '<p class="st-note">' + stEsc(g.note) + '</p>' : '') +
        '<ul>' + g.items.map(function(it){
          return '<li class="' + (it.ok ? 'ok' : 'bad') + '"><span class="st-mark">' + (it.ok ? '✓' : '✗') + '</span><span>' + stEsc(it.name) +
            (it.detail ? '<small>' + stEsc(it.detail) + '</small>' : '') + '</span></li>';
        }).join('') + '</ul></details>';
    }).join('');
  }
  function stText(){
    var c = stCounts(), lines = ['Самоперевірка талона, ' + new Date().toLocaleString('uk-UA'), c.bad ? 'НЕ ПРОЙДЕНО: ' + c.bad + ' з ' + c.n : 'ПРОЙДЕНО: усі ' + c.n];
    ST.groups.forEach(function(g){
      lines.push('', '== ' + g.title);
      g.items.forEach(function(it){ lines.push((it.ok ? '✓ ' : '✗ ') + it.name + (it.detail ? ' — ' + it.detail : '')); });
    });
    return lines.join('\n');
  }
  function stCopy(){
    var text = stText(), box = stBox();
    function fallback(){
      var ta = box.querySelector('.st-text');
      if (!ta){ ta = document.createElement('textarea'); ta.className = 'st-text'; ta.readOnly = true; box.appendChild(ta); }
      ta.value = text; ta.focus(); ta.select();
    }
    if (navigator.clipboard && navigator.clipboard.writeText) navigator.clipboard.writeText(text).then(function(){ $('stCopy').textContent = 'Звіт скопійовано'; }, fallback);
    else fallback();
  }

  // ---- допоміжне ----
  function stSample(){
    return { name: 'Ярошенко Ганна Андріївна', age: '45', sex: 'Жіноча', residence: 'Місто', icd: 'J06.9', firstTime: 'yes', disp: 'no',
             disability: 'no', ubd: 'no', vpo: 'yes', chaes: 'no', doctor: DOCTORS[0], date: ymd(new Date()) };
  }
  function stRadio(name, value){ var el = document.querySelector('input[name="' + name + '"][value="' + value + '"]'); if (el) el.checked = true; }
  function stFill(d){
    resetPatient();
    $('name').value = d.name; $('age').value = d.age; $('icd').value = d.icd;
    stRadio('sex', d.sex); stRadio('residence', d.residence); stRadio('disp', d.disp);
    $('firstTime').checked = d.firstTime === 'yes'; $('catDisability').checked = d.disability === 'yes'; $('catUbd').checked = d.ubd === 'yes';
    $('catVpo').checked = d.vpo === 'yes'; $('catChaes').checked = d.chaes === 'yes';
    if (d.doctor && dd.value.value !== d.doctor) ddChoose(d.doctor);
    $('date').value = d.date;
  }
  function stSubmit(){
    var ev;
    try { ev = new Event('submit', { bubbles: true, cancelable: true }); } catch (e) { ev = document.createEvent('Event'); ev.initEvent('submit', true, true); }
    $('talon').dispatchEvent(ev);
  }
  // введення в поле, як із клавіатури (спрацьовує жива перевірка поля)
  function stType(el, value){
    var ev;
    try { el.dispatchEvent(new InputEvent('beforeinput', { inputType: 'insertText', bubbles: true, cancelable: true })); } catch (e) {}
    el.value = value;
    try { el.setSelectionRange(value.length, value.length); } catch (e) {}
    try { ev = new InputEvent('input', { inputType: 'insertText', bubbles: true }); } catch (e) { ev = document.createEvent('Event'); ev.initEvent('input', true, false); }
    el.dispatchEvent(ev);
  }
  function stParams(p){ var o = {}; p.forEach(function(v, k){ o[k] = v; }); return o; }
  function stDay(n){ var d = new Date(); return ymd(new Date(d.getFullYear(), d.getMonth(), d.getDate() + n)); }

  // ---- групи перевірок ----
  function stGroupConfig(){
    stGroup('Зв’язок із Google Формою', 'Номери полів і тексти варіантів — точно як у самій формі, інакше Google не прийме талон.');
    var keys = Object.keys(ENTRY), vals = keys.map(function(k){ return ENTRY[k]; });
    stCheck('Сторінку підключено: усі 13 полів мають номери (entry.…), без повторів', configured && keys.length === 13 &&
      vals.every(function(v, i){ return /^entry\.\d+$/.test(v) && vals.indexOf(v) === i; }), stShow(ENTRY));
    stEq('Відповіді «так» / «ні» — як у формі', [YES, NO], ['так', 'ні']);
    stEq('Стать — як у формі', SEX.map(function(o){ return o.value; }), ['Чоловіча', 'Жіноча']);
    stEq('Місце проживання — три варіанти, як у формі', RESIDENCE.map(function(o){ return o.value; }), ['Місто', 'Село (Бурлача Балка, Малодолинське)', 'Село (інше)']);
    var uniq = DOCTORS.filter(function(d, i){ return DOCTORS.indexOf(d) === i; });
    stCheck('Список лікарів: ' + DOCTORS.length + ', без повторів, у кожного — прізвище, ім’я та по батькові', DOCTORS.length >= 30 && uniq.length === DOCTORS.length &&
      DOCTORS.every(function(d){ return d.split(' ').length === 3; }), DOCTORS.filter(function(d){ return d.split(' ').length !== 3; }).join('; '));
    stCheck('Адреса надсилання — відповіді саме цієї Google Форми', FORM_ACTION === 'https://docs.google.com/forms/d/e/' + FORM_ID + '/formResponse', FORM_ACTION);
    stEq('На сторінці: 2 варіанти статі, 3 — місця проживання, ' + DOCTORS.length + ' лікарів у списку',
      [document.querySelectorAll('input[name=sex]').length, document.querySelectorAll('input[name=residence]').length, document.querySelectorAll('#doctorList li').length],
      [2, 3, DOCTORS.length]);
  }
  function stGroupIcd(){
    stGroup('Код МКХ-10', 'Виправлення під час введення (кирилиця → латиниця, кома → крапка, J069 → J06.9), код із двома крапками (I11.1.7) і перевірка повноти коду.');
    var cases = [['j069', 'J06.9'], ['е11.9', 'E11.9'], ['К29,70', 'K29.70'], [' i10 ', 'I10'], ['J0691', 'J06.91'], ['А09', 'A09'], ['т14.9', 'T14.9'], ['J0', 'J0'],
      ['і11,1,7', 'I11.1.7'], ['I111.7', 'I11.1.7'], ['е11.9.2', 'E11.9.2']];
    stEq('Виправлення коду (' + cases.length + ' записів)', cases.map(function(c){ return icdFull(c[0]); }), cases.map(function(c){ return c[1]; }));
    var errs = [['J06.9', ''], ['I10', ''], ['K29.70', ''], ['J0', MSG.icdShort], ['J06.', MSG.icdShort], ['JJ6', MSG.icdChars], ['06.9', MSG.icdChars], ['J06.999', MSG.icdChars],
      ['I11.1.7', ''], ['E11.9.2', ''], ['I11.1.', MSG.icdShortDots], ['I11.1.77', MSG.icdDots], ['I11.17.1', MSG.icdDots], ['I11.1.7.1', MSG.icdDots]];
    stEq('Повний код (і з двома крапками, I11.1.7) — без помилки; неповний — «допишіть»; зайві символи — пояснення', errs.map(function(c){ return icdError(c[0]); }), errs.map(function(c){ return c[1]; }));
    var el = $('icd'), box = fieldBox('icd');
    resetPatient();
    el.focus();
    stType(el, 'J0');
    stType(el, 'J0X');
    var blocked = el.value === 'J0' && box.classList.contains('tip-on');
    stType(el, 'J069');
    stCheck('У полі коду зайвий символ не вписується (з’являється підказка), а J069 одразу стає J06.9', blocked && el.value === 'J06.9', 'у полі: ' + el.value);
    stType(el, '');
    ['I', 'I1', 'I11', 'I111', 'I11.1.', 'I11.1.7'].forEach(function(v){ stType(el, v); });
    var typed = el.value, tipOff = !box.classList.contains('tip-on');
    stType(el, 'I11.1.7.');
    stCheck('Код із двома крапками вводиться (I111 → I11.1, далі «.7» → I11.1.7); третя крапка не вписується',
      typed === 'I11.1.7' && tipOff && el.value === 'I11.1.7' && box.classList.contains('tip-on') && box.querySelector('.live-tip').textContent === MSG.icdDots, 'у полі: ' + typed + ' → ' + el.value);
    el.blur();
    resetPatient();
  }
  function stGroupName(){
    stGroup('ПІБ пацієнта', 'Латинські «двійники» літер → українські, апостроф → ’, лише українські літери, ПІБ повністю.');
    var live = [['Kовальчук', 'Ковальчук'], ['Дем\'ян', 'Дем’ян'], ['  Іваненко   Іван', 'Іваненко Іван'], ['Петрeнко', 'Петренко']];
    stEq('Виправлення під час введення', live.map(function(c){ return nameLive(c[0]); }), live.map(function(c){ return c[1]; }));
    stEq('Дозволені символи: українські літери, апостроф, дефіс', ['Іваненко Іван', 'Д’Артаньян-Петренко', 'Smith', 'Іван2'].map(function(v){ return NAME_CHARS.test(nameLive(v)); }),
      [true, true, false, false]);
    var full = [['Іваненко Іван Іванович', ''], ['Іваненко Іван', MSG.nameFull], ['Іваненко І. І.', MSG.nameChars], ['Іваненко І І', MSG.nameFull], ['Д’Артаньян-Петренко Анна Петрівна', '']];
    stEq('ПІБ повністю: три слова, без ініціалів', full.map(function(c){ return nameError(c[0]); }), full.map(function(c){ return c[1]; }));
  }
  function stGroupValidate(){
    stGroup('Перевірка перед надсиланням', 'Обов’язкові поля, вік, дата прийому.');
    stEq('Правильно заповнений талон — без помилок', validate(stSample()), {});
    var need = ['name', 'age', 'sex', 'residence', 'icd', 'disp', 'doctor', 'date'];
    var missed = need.filter(function(k){ var d = stSample(); d[k] = ''; return !validate(d)[k]; });
    stCheck('Кожне з ' + need.length + ' обов’язкових полів без значення — помилка під цим полем', !missed.length, 'не помічено: ' + missed.join(', '));
    var a = stSample(), b = stSample(), c = stSample();
    a.age = '121'; b.age = 'абв'; c.age = '0';
    stEq('Вік: більше 120 чи не цифри — помилка; 0 (немовля) — можна', [validate(a).age, validate(b).age, validate(c).age || ''], [MSG.ageMax, MSG.ageDigits, '']);
    var y = new Date().getFullYear(), dd2 = function(v){ var d = stSample(); d.date = v; return validate(d).date || ''; };
    stEq('Дата: сьогодні й учора — так; післязавтра — «у майбутньому»; позаминулий рік — «перевірте рік»; 1 січня минулого року — так',
      [dd2(stDay(0)), dd2(stDay(-1)), dd2(stDay(2)), dd2((y - 2) + '-12-31'), dd2((y - 1) + '-01-01')],
      ['', '', 'Дата не може бути в майбутньому', 'Дата надто давня — перевірте рік', '']);
    stEq('Календар у полі дати: з 1 січня минулого року до завтра', [$('date').min, $('date').max], [(y - 1) + '-01-01', ymd(new Date(Date.now() + 86400000))]);
  }
  function stGroupPayload(){
    stGroup('Що надсилається у форму', 'Поля й значення запиту — так, як їх надсилає сама Google Форма.');
    var d = stSample();
    d.date = '2026-03-07';
    var p = body(d), want = {};
    want[ENTRY.date + '_year'] = '2026'; want[ENTRY.date + '_month'] = '3'; want[ENTRY.date + '_day'] = '7';
    want[ENTRY.doctor] = DOCTORS[0]; want[ENTRY.patient] = 'Ярошенко Ганна Андріївна'; want[ENTRY.age] = '45'; want[ENTRY.icd] = 'J06.9';
    [['sex', 'Жіноча'], ['residence', 'Місто'], ['firstTime', YES], ['disp', NO], ['disability', NO], ['ubd', NO], ['vpo', YES], ['chaes', NO]].forEach(function(x){
      want[ENTRY[x[0]]] = x[1]; want[ENTRY[x[0]] + '_sentinel'] = '';
    });
    want.fvv = '1'; want.pageHistory = '0';
    stEq('Усі ' + Object.keys(want).length + ' полів запиту з правильними значеннями (дата — окремо рік, місяць, день)', stParams(p), want);
    var d2 = stSample();
    d2.icd = icdFull('і11,1,7');
    stEq('Код із двома крапками — без помилки й надсилається так, як записано (I11.1.7)', [validate(d2).icd || '', body(d2).get(ENTRY.icd)], ['', 'I11.1.7']);
    var opts = SEX.map(function(o){ return o.value; }).concat(RESIDENCE.map(function(o){ return o.value; }), [YES, NO]);
    var bad = ['sex', 'residence', 'firstTime', 'disp', 'disability', 'ubd', 'vpo', 'chaes'].filter(function(k){ return opts.indexOf(p.get(ENTRY[k])) === -1; });
    stCheck('Кожна відповідь-варіант — точно один із варіантів форми', !bad.length, bad.join(', '));
  }
  function stGroupMask(){
    stGroup('Шифрування ПІБ', 'На екрані й у браузері — лише перші 2 літери кожного слова, решта — зірочки. Повне ПІБ іде тільки у форму.');
    stEq('Іваненко Іван Іванович, подвійне прізвище з апострофом, короткі слова',
      [maskName('Іваненко Іван Іванович'), maskName('Д’Артаньян-Петренко Анна Петрівна'), maskName('Ли Ян Ок')],
      ['Ів****** Ів** Ів******', 'Д’А*******-Пе****** Ан** Пе******', 'Ли Ян Ок']);
    stCheck('Повторне шифрування нічого не змінює', maskName(maskName('Іваненко Іван Іванович')) === 'Ів****** Ів** Ів******');
  }
  function stGroupHistory(){
    stGroup('Список «Надіслано за сесію»', 'Таблиця + надіслане з цього браузера без повторів; учорашнє не зберігається; повних ПІБ у браузері немає.');
    var keepLog = todayLog, keepSheet = sheet, D = DOCTORS[0], today = ymd(new Date());
    try {
      todayLog = { day: today, items: [
        { t: '10:30', sec: 37800, name: 'Пе****** Пе** Пе******', icd: 'I10', doctor: D, date: today },
        { t: '10:00', sec: 36000, name: 'Ів****** Ів** Ів******', icd: 'J06.9', doctor: D, date: today }] };
      sheet = { cols: null, doctor: D, day: today, turn: 0, last: 0, items: [
        { t: '09:00', sec: 32400, name: 'Ко****** Ол** Пе******', icd: 'K29.7', doctor: D, date: today, sheet: true, row: 0 },
        { t: '10:00', sec: 36004, name: 'Ів****** Ів** Ів******', icd: 'J06.9', doctor: D, date: today, sheet: true, row: 1 }] };
      var list = historyItems(D).map(function(s){ return s.t + ' ' + s.icd + (s.sheet ? ' (таблиця)' : ''); });
      stEq('Таблиця + щойно надіслане: без повторів, найновіші згори', list, ['10:30 I10', '10:00 J06.9 (таблиця)', '09:00 K29.7 (таблиця)']);
    } finally { todayLog = keepLog; sheet = keepSheet; }
    var yd = stDay(-1);
    local.set(HISTORY_KEY, JSON.stringify({ day: yd, items: [{ t: '09:00', name: 'Ів** Ів** Ів**', icd: 'I10', doctor: D, date: yd }] }));
    loadHistory();
    stCheck('Учорашній список не показується й стирається', todayLog.items.length === 0 && local.get(HISTORY_KEY) === null);
    local.set(HISTORY_KEY, JSON.stringify({ day: today, items: [{ t: '09:00', name: 'Іваненко Іван Іванович', icd: 'I10', doctor: D, date: today }] }));
    loadHistory();
    stCheck('Запис попередньої версії з повним ПІБ шифрується й перезаписується', todayLog.items.length === 1 && todayLog.items[0].name === 'Ів****** Ів** Ів******' &&
      String(local.get(HISTORY_KEY)).indexOf('Іваненко') === -1, local.get(HISTORY_KEY));
    local.remove(HISTORY_KEY);
    loadHistory();
    renderHistory();
  }
  function stGroupDate(){
    stGroup('Дата прийому', 'Сторінка, відкрита з учорашнього дня, сама ставить сьогоднішню дату — але не змінює дату, вибрану вручну, і талон, який саме заповнюють.');
    var today = ymd(new Date()), yd = stDay(-1), d3 = stDay(-3), out = [];
    resetPatient();
    dateToday = yd; $('date').value = yd; rollDate(); out.push($('date').value);
    dateToday = yd; $('date').value = d3; rollDate(); out.push($('date').value);
    dateToday = yd; $('date').value = yd; $('name').value = 'Ярошенко'; rollDate(); out.push($('date').value);
    $('name').value = ''; rollDate(); out.push($('date').value);
    stEq('Учорашня дата → сьогоднішня; вибрана вручну — лишається; посеред талона — не змінюється, після нього — так', out, [today, d3, yd, today]);
    dateToday = today; $('date').value = today;
  }
  function stGroupDoctor(){
    stGroup('Вибір лікаря', 'Пошук за початком прізвища, імені чи по батькові; апостроф будь-який; вибір клавішею Enter.');
    var name = DOCTORS[0], w = name.toLowerCase().split(' ');
    stEq('Пошук: за прізвищем — першим, за ім’ям — теж, за двома словами — так, чуже — ні',
      [ddRank(name, w[0].slice(0, 3)), ddRank(name, w[1].slice(0, 3)), ddRank(name, w[0].slice(0, 2) + ' ' + w[1].slice(0, 2)), ddRank(name, 'щщщ')], [0, 1, 0, -1]);
    stEq('Апостроф у ПІБ лікаря — будь-який (\' чи ’)', [ddRank('Дем\'янчук Олег Іванович', 'дем’ян'), ddRank('Дем’янчук Олег Іванович', 'дем’ян')], [0, 0]);
    var keep = dd.value.value, ev;
    ddOpen();
    dd.search.value = w[0].slice(0, 4);
    ddFilter();
    try { ev = new KeyboardEvent('keydown', { key: 'Enter', bubbles: true, cancelable: true }); } catch (e) { ev = null; }
    if (ev) dd.search.dispatchEvent(ev); else ddChoose(ddItems[ddActive].name);
    stCheck('У списку: набрати «' + w[0].slice(0, 4) + '» й Enter — вибрано «' + name + '»', dd.value.value === name && dd.panel.classList.contains('hidden'), 'вибрано: ' + dd.value.value);
    dd.value.value = keep;
    syncDoctorFace();
  }
  function stGroupSubmit(){
    stGroup('Надсилання талона на сторінці', 'Талон заповнюється й «надсилається»; запит перехоплюється й перевіряється — у Google нічого не йде.');
    var d = stSample();
    show('talon'); clearErrors(); ST.sent = []; ST.fail = false;
    resetPatient();
    dd.value.value = ''; syncDoctorFace();
    stSubmit();
    var invalid = [].slice.call(document.querySelectorAll('#talon .field.invalid')).map(function(b){ return b.getAttribute('data-field'); });
    stCheck('Порожній талон: помилки під обов’язковими полями, нічого не надіслано', ST.sent.length === 0 &&
      ['name', 'age', 'sex', 'residence', 'icd', 'disp', 'doctor'].every(function(k){ return invalid.indexOf(k) !== -1; }), 'помилки: ' + invalid.join(', '));
    stFill(d);
    stSubmit();
    return stWait(40).then(function(){
      var s = ST.sent[0];
      stCheck('Надіслано один запит (POST) на адресу форми', ST.sent.length === 1 && s.url === FORM_ACTION && s.method === 'POST', ST.sent.length + ' запитів');
      stEq('Надіслано саме те, що заповнено на сторінці', s ? stParams(new URLSearchParams(s.body)) : null, stParams(body(d)));
      stCheck('Після надсилання — «Талон надіслано» з зашифрованим ПІБ і кодом', !$('done').classList.contains('hidden') &&
        $('doneText').textContent === 'Яр****** Га*** Ан******* · J06.9', $('doneText').textContent);
      var first = $('historyList').querySelector('li');
      stCheck('Талон — у списку «Надіслано за сесію» з зашифрованим ПІБ', !!first && first.textContent.indexOf('Яр****** Га*** Ан*******') !== -1 && first.textContent.indexOf('J06.9') !== -1,
        first ? first.textContent : 'список порожній');
      stCheck('Повного ПІБ у браузері немає (лише зашифроване)', String(local.get(HISTORY_KEY)).indexOf('Ярошенко') === -1 && String(local.get(HISTORY_KEY)).indexOf('Яр******') !== -1);
      stCheck('Лікар запам’ятався для наступних талонів', local.get('talonDoctor') === d.doctor);
      $('nextBtn').click();
      stCheck('«Заповнити наступний талон»: поля пацієнта порожні, лікар і дата лишилися', !patientStarted() && dd.value.value === d.doctor && $('date').value === d.date &&
        $('done').classList.contains('hidden'));
      // немає зв’язку — помилка, дані не губляться
      ST.fail = true;
      stFill(d);
      stSubmit();
      return stWait(40);
    }).then(function(){
      ST.fail = false;
      stCheck('Немає зв’язку: повідомлення про помилку, заповнений талон лишається', !$('formError').classList.contains('hidden') &&
        $('formError').textContent.indexOf('Не вдалося надіслати') !== -1 && $('name').value === d.name && $('done').classList.contains('hidden'), $('formError').textContent);
      clearErrors();
    });
  }
  function stGroupClear(){
    stGroup('«Очистити все»', 'Перше натискання — лише попередження; друге очищає все, разом із лікарем; дата — сьогоднішня.');
    stFill(stSample());
    $('date').value = stDay(-2);
    $('clearBtn').click();
    var armed = $('clearBtn').classList.contains('armed') && $('name').value !== '';
    $('clearBtn').click();
    stCheck('Перше натискання — попередження, друге — усе очищено (і лікар), дата — сьогодні', armed && !patientStarted() && !dd.value.value && $('date').value === ymd(new Date()));
  }
  function stGroupSafety(before){
    stGroup('Безпека тестового режиму', 'Перевірка нічого не надсилає й не змінює в цьому браузері.');
    stCheck('Жодного звернення до Google: таблиця не читалася, талони перехоплено (' + ST.sent.length + ')', ST.net === 0 && ST.sent.length > 0, 'звернень: ' + ST.net);
    stEq('Справжній список «Надіслано за сесію» й вибраний лікар у браузері не змінилися', [stReal(HISTORY_KEY), stReal('talonDoctor')], before);
  }

  function runSelfTest(){
    if (ST.running) return;
    ST.groups = []; ST.cur = null; ST.t0 = Date.now(); ST.running = true; ST.sent = [];
    window.__selfTest = { done: false };
    var before = [stReal(HISTORY_KEY), stReal('talonDoctor')];
    ST.net = 0;
    if (!ST.watch){
      ST.watch = true;
      window.fetch = function(){ ST.net++; return Promise.reject(new Error('тестовий режим')); };   // справжніх запитів бути не повинно
      if (window.MutationObserver) new MutationObserver(function(ms){
        ms.forEach(function(m){ [].forEach.call(m.addedNodes, function(n){ if (n.tagName === 'SCRIPT' && /google/i.test(n.src || '')) ST.net++; }); });
      }).observe(document.head, { childList: true });
    }
    stBox().scrollIntoView({ block: 'start' });
    stRender();
    var steps = [stGroupConfig, stGroupIcd, stGroupName, stGroupValidate, stGroupPayload, stGroupMask, stGroupHistory, stGroupDate, stGroupDoctor, stGroupSubmit, stGroupClear,
                 function(){ return stGroupSafety(before); }], i = 0;
    function fail(e, n){
      if (ST.groups.length === n) stGroup('Перевірка');
      stCheck('Перевірка не завершилася через помилку', false, (e && e.message) || String(e));
      if (window.console) console.error(e);
    }
    function next(){
      if (i >= steps.length) return finish();
      var step = steps[i++], n = ST.groups.length, r;
      try { r = step(); } catch (e) { fail(e, n); }
      return Promise.resolve(r).then(null, function(e){ fail(e, n); }).then(function(){ stRender(); return stWait(0); }).then(next);
    }
    function finish(){
      try { resetPatient(); dd.value.value = ''; syncDoctorFace(); show('talon'); clearErrors(); $('date').value = ymd(new Date()); dateToday = ymd(new Date()); } catch (e) {}
      ST.running = false;
      stRender();
      var c = stCounts();
      window.__selfTest = { done: true, total: c.n, failed: c.bad, skipped: 0, text: stText(),
        groups: ST.groups.map(function(g){ return { title: g.title, items: g.items.map(function(it){ return { name: it.name, ok: it.ok, detail: it.detail }; }) }; }) };
      window.scrollTo(0, 0);
    }
    next();
  }
  if (TEST) runSelfTest();
})();
</script>
</body>
</html>
