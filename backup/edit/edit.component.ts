import { Component, OnInit, ViewChild } from '@angular/core';
import { ActivatedRoute, Params } from '@angular/router';
import { URLSearchParams } from '@angular/http';

// datepikerの設定
import { BsDatepickerConfig } from 'ngx-bootstrap/datepicker';
import { listLocales } from 'ngx-bootstrap/bs-moment';
import { defineLocale } from 'ngx-bootstrap/bs-moment';
import { ja } from 'ngx-bootstrap/locale';
defineLocale('ja', ja);

import { JsonpService } from '../jsonp.service';

import { environment } from '../../environments/environment.local';

@Component({
  selector: 'my-app',
  templateUrl: './edit.component.html',
  styleUrls: ['./edit.component.css'],
})
export class EditComponent implements OnInit {

  constructor(private route: ActivatedRoute, private jsonpService: JsonpService) {
    this.bsConfig = Object.assign({}, { locale: this.locale });
  }

  ngOnInit() {
    this.route.data.subscribe(obj => console.log(obj['category']));
    // 画面表示パラメータの取得処理
    this.jsonpService.requestGet('IncidentDataGet.php', new URLSearchParams())
      .subscribe(
      data => {
        // 通信成功時
        if (data[0]) {
          let one = data[0];
          if (one.result !== '' && one.result == true) {
            // 画面表示パラメータのセット処理
            this.setDspParam(one);
          }
        }
      },
      error => {
        // 通信失敗もしくは、コールバック関数内でエラー
        console.log(error);
        console.log('サーバとのアクセスに失敗しました。');
        return false;
      }
      );

  }

  // 事業主体の初期化
  jigyosyutaiClear() {
    this.jigyosyutaiId = ""; //事業主体ID
    this.jigyosyutaiNm = ""; //事業主体名
  }

  // インシデント登録処理
  entryIncident() {

  }

  //新しいウィンドウを開く(パターン1)
  // CMN_openNewWindow1(url,name,sizex,sizey,top,left){
  CMN_openNewWindow1(url, name, sizex, sizey) {
    var style = "toolbar=0,location=0,directories=0,status=yes,menubar=0,scrollbars=1,resizable=1," +
      "width=" + sizex + ",height=" + sizey;
    // if( top ){
    // 	style += ",top="+top;
    // }  
    // if( left ){
    // 	style += ",left="+left;
    // }
    var win = window.open(url, name, style);
    if (win) {
      win.focus();
      return win;
    }
  }

  SUB_WIN = null;
  // 関連MR2表示処理
  showMr2() {
    if (this.SUB_WIN) this.SUB_WIN.close();
    this.SUB_WIN = this.CMN_openNewWindow1("./#/mr2", "sub_mr2", 1000, 760);
  }

  // 関連プロジェクト表示処理
  showPj() {
    if (this.SUB_WIN) this.SUB_WIN.close();
    this.SUB_WIN = this.CMN_openNewWindow1("./#/project", "sub_project", 1000, 760);
  }

  // 関連事故クレーム情報表示処理
  showJiko() {
    if (this.SUB_WIN) this.SUB_WIN.close();
    let url = environment.jikoPath + "jiko171211.html"; // 環境に合わせたURLを作成する TODO:固定値
    this.SUB_WIN = this.CMN_openNewWindow1(url, "sub_jiko", 1200, 800);
  }

  // 関連費用決済申請表示処理 TODO:固定値表示
  showHiyo(status, division, idno, bno, system_id, gougi_answer) {

    if (system_id == "") {
      system_id = "1282";
    }

    // var frm = window.document.fm1;
    var strurl;

    strurl = environment.hiyoPath + "wf_main_input.php";
    strurl += "?user_id=ADF";
    strurl += "&authority=9";
    //	strurl += "&system_id=1282";
    strurl += "&system_id=" + system_id;
    strurl += "&status=" + status;
    strurl += "&division=" + division;
    strurl += "&idno=" + idno;
    strurl += "&win_kbn=1";
    if (gougi_answer) strurl += "&gougi_answer_mode=Y";

    strurl += '&unit_flg=';
    strurl += '&main_system_id=';
    strurl += '&main_idno=';
    strurl += '&param1=';
    strurl += '&param2=';
    strurl += '&param3=';
    //	URLにBNOが含まれているかどうか？
    if (bno != "") {
      strurl = strurl.replace("BNO=&", "BNO=" + bno + "&");
    }

    this.SUB_WIN = this.CMN_openNewWindow1(strurl, "WF_EDIT", 1200, 800);
    return;

  }

  // 関連インシデント表示処理
  showRelateIncident() {

  }

  // 営業担当者選択
  onSalesUserSelected($event: any) {
    if ($event) {
      switch($event["userSearchType"]){
        case 'salesUser':
          this.salesUserId = $event["userId"];
          this.salesUserNm = $event["userNm"];
          this.salesDeptCd = $event["sectionCd"];
          this.salesDeptNm = $event["sectionNm"];
          break;
        case 'skanUser':
          this.skanUserId = $event["userId"];
          this.skanUserNm = $event["userNm"];
          this.skanDeptCd = $event["sectionCd"];
          this.skanDeptNm = $event["sectionNm"];
          break;
        case 'callUser':
          this.callUserId = $event["userId"];
          this.callUserNm = $event["userNm"];
          this.callDeptCd = $event["sectionCd"];
          this.callDeptNm = $event["sectionNm"];
          break;
        case 'taioUser':
          this.taioUserId = $event["userId"];
          this.taioUserNm = $event["userNm"];
          this.taioDeptCd = $event["sectionCd"];
          this.taioDeptNm = $event["sectionNm"];
          break;
        case 'actUser':
          this.actUserId = $event["userId"];
          this.actUserNm = $event["userNm"];
          this.actDeptCd = $event["sectionCd"];
          this.actDeptNm = $event["sectionNm"];
          break;
      }

    }
  }

  // 部門検索
  onSalesSectionSelected($event: any){
    if ($event) {
      switch($event["sectionSearchType"]){
        case 'salesSection':
          this.salesDeptCd = $event["postCd"];
          this.salesDeptNm = $event["sectionNm"];
          break;
        case 'skanSection':
          this.skanDeptCd = $event["postCd"];
          this.skanDeptNm = $event["sectionNm"];
          break;
        case 'callSection':
          this.callDeptCd = $event["postCd"];
          this.callDeptNm = $event["sectionNm"];
          break;
        case 'taioSection':
          this.taioDeptCd = $event["postCd"];
          this.taioDeptNm = $event["sectionNm"];
          break;
        case 'actSection':
          this.actDeptCd = $event["postCd"];
          this.actDeptNm = $event["sectionNm"];
          break;
      }
    }
  }

  minDate = new Date(2017, 5, 10);
  maxDate = new Date(2018, 9, 15);
  bsValue: Date;
  // date pikerの設定
  locale = 'ja';
  locales = listLocales();
  bsConfig: Partial<BsDatepickerConfig>;

  // 画面表示パラメータの初期化
  // １－１．ヘッダー
  incidentNo = ""; // インシデント番号
  incidentStatusCd = ""; // インシデントステータスCD
  incidentStatusNm = ""; // インシデントステータス名
  incidentTypeCd = ""; // インシデント分類CD
  insDate = ""; // 登録日
  insUserNm = ""; // 登録者
  updDate = "" // 更新日
  updUserNm = ""; // 更新者

  // １－２．メイン情報
  parentIncidentId = ""; // 親インシデントID
  parentIncidentNo = ""; // 親インシデント番号
  incidentStartDate: Date; // 発生日
  incidentStartTime: Date; // 発生時刻
  industryTypeCd = ""; // 業種区分CD
  infoSourceCd = ""; // 情報提供元CD
  infoSourceNm = ""; // 情報提供元名
  infoProvider = ""; // 情報提供者
  infoProvidedTel = ""; //情報提供TEL  
  relateList = []; // 関係者
  memo = ""; //注記  
  kijoId = ""; //機場ID
  kijoNm = ""; //機場名
  jigyosyutaiId = ""; //事業主体ID
  jigyosyutaiNm = ""; //事業主体名
  setubiId = ""; //設備ID
  setubiNm = ""; //設備名
  prefId = ""; //都道府県ID
  prefNm = ""; //都道府県名
  custId = ""; //顧客ID 
  custNm = ""; //顧客名
  custTypeCd = ""; //顧客分類CD
  custTypeNm = ""; //顧客分類名
  salesDeptCd = ""; //営業部門CD
  salesDeptNm = ""; //営業部門名
  salesUserId = ""; //営業担当者ID
  salesUserNm = ""; //営業担当者名
  deliveryPjId = ""; //納入プロジェクトID
  deliveryPjNm = ""; //納入プロジェクト名
  custDept = ""; //会社名・所属部署
  requester = ""; //依頼者
  contactTel = ""; //連絡先(TEL)
  contactFax = ""; //連絡先(FAX)
  contactMail = ""; //連絡先(E-mail)  
  skanDeptCd = ""; //主管部門CD
  skanDeptNm = ""; //主管部門名
  skanUserId = ""; //主管担当者ID
  skanUserNm = ""; //主管担当者名

  // １－３．受付情報
  callDate: Date; //受付日
  callStartDate: Date; //受付開始時刻
  callEndDate = ""; //受付終了時刻
  callDeptCd = ""; //受付部署CD
  callDeptNm = ""; //受付部署名
  callUserId = ""; //受付者ID
  callUserNm = ""; //受付者名
  callTel = ""; //受付電話番号
  callMail = ""; //受付メール
  callContent = ""; //受付内容

  // １－４．対応情報
  taioDate: Date; //対応日
  taioStartDate: Date; //対応開始時刻
  taioEndDate: Date; //対応終了時刻
  taioDeptCd = ""; //対応部署CD
  taioDeptNm = ""; //対応部署名
  taioUserId = ""; //対応者ID
  taioUserNm = ""; //対応者名  
  taioTel = ""; //対応電話番号
  taioMail = ""; //対応メール
  taioContent = ""; //対応内容

  // １－５．処置情報
  actDate: Date; //処置予定日
  actTypeCd = ""; //処置区分CD
  actStartDate: Date; //処置開始日
  actStartTime: Date; //処置開始時刻
  actEndDate: Date; //処置終了日
  actEndTime: Date; //処置終了時刻
  actDeptCd = ""; //処置部署CD
  actDeptNm = ""; //処置部署名
  actUserId = ""; //処置者ID
  actUserNm = ""; //処置者名
  actTel = ""; //処置電話番号
  actMail = ""; //処置メール
  actContent = ""; //処置内容

  // １－６．製品情報
  productTypeCd = ""; //機種区分CD
  productTypeNm = ""; //機種区分名
  productTriggerCd = ""; //障害状況トリガーCD
  productTriggerNm = ""; //障害状況トリガー名
  productHindoCd = ""; //障害状況頻度CD
  productHindoNm = ""; //障害状況頻度名
  productGensyoCd = ""; //障害状況現象CD
  productGensyoNm = ""; //障害状況現象名
  productStatusCd = ""; //障害状況状態CD
  productStatusNm = ""; //障害状況状態名

  // 画面表示パラメータのセット処理
  setDspParam(data) {
    // １－１．ヘッダー
    this.incidentNo = data.incidentNo; // インシデント番号
    this.incidentStatusCd = data.incidentStatusCd; // インシデントステータスCD
    this.incidentStatusNm = data.incidentStatusNm; // インシデントステータス名
    this.incidentTypeCd = data.incidentTypeCd // インシデント分類CD
    this.insDate = data.insDate // 登録日
    this.insUserNm = data.insUserNm // 登録者
    this.updDate = data.updDate // 更新日
    this.updUserNm = data.updUserNm // 更新者

    // １－２．メイン情報    
    this.parentIncidentId = data.parentIncidentId; // 親インシデントID
    this.parentIncidentNo = data.parentIncidentNo; // 親インシデント番号
    this.incidentStartDate = new Date(data.incidentStartDate); // 発生日
    this.incidentStartTime = new Date(data.incidentStartTime); // 発生時刻
    this.industryTypeCd = data.industryTypeCd; // 業種区分CD
    this.infoSourceCd = data.infoSourceCd; // 情報提供元CD
    this.infoSourceNm = data.infoSourceNm; // 情報提供元名
    this.infoProvider = data.infoProvider; // 情報提供者
    this.infoProvidedTel = data.infoProvidedTel; //情報提供TEL
    this.relateList = data.relateList; //関係者
    this.memo = data.memo; //注記    
    this.kijoId = data.kijoId; //機場ID
    this.kijoNm = data.kijoNm; //機場名
    this.jigyosyutaiId = data.jigyosyutaiId; //事業主体ID
    this.jigyosyutaiNm = data.jigyosyutaiNm; //事業主体名
    this.setubiId = data.setubiId; //設備ID
    this.setubiNm = data.setubiNm; //設備名
    this.prefId = data.prefId; //都道府県ID
    this.prefNm = data.prefNm; //都道府県名
    this.custId = data.custId; //顧客ID
    this.custNm = data.custNm; //顧客名
    this.custTypeCd = data.custTypeCd; //顧客分類CD
    this.custTypeNm = data.custTypeNm; //顧客分類名
    this.salesDeptCd = data.salesDeptCd; //営業部門CD
    this.salesDeptNm = data.salesDeptNm; //営業部門名
    this.salesUserId = data.salesUserId; //営業担当者ID
    this.salesUserNm = data.salesUserNm; //営業担当者名
    this.deliveryPjId = data.deliveryPjId; //納入プロジェクトID
    this.deliveryPjNm = data.deliveryPjNm; //納入プロジェクト名
    this.custDept = data.custDept; //会社名・所属部署
    this.requester = data.requester; //依頼者
    this.contactTel = data.contactTel; //連絡先(TEL)
    this.contactFax = data.contactFax; //連絡先(FAX)
    this.contactMail = data.contactMail; //連絡先(E-mail)
    this.skanDeptCd = data.skanDeptCd; //主管部門CD
    this.skanDeptNm = data.skanDeptNm; //主管部門名
    this.skanUserId = data.skanUserId; //主管担当者CD
    this.skanUserNm = data.skanUserNm; //主管担当者名

    // １－３．受付情報
    this.callDate = new Date(data.callDate); //受付日
    this.callStartDate = new Date(data.callStartDate); //受付開始時刻
    this.callEndDate = data.callEndDate; //受付終了時刻
    this.callDeptCd = data.callDeptCd; //受付部署CD
    this.callDeptNm = data.callDeptNm; //受付部署名
    this.callUserId = data.callUserId; //受付者ID
    this.callUserNm = data.callUserNm; //受付者名
    this.callTel = data.callTel; //受付電話番号
    this.callMail = data.callMail; //受付メール
    this.callContent = data.callContent; //受付内容

    // １－４．対応情報
    this.taioDate = new Date(data.taioDate); //対応日
    this.taioStartDate = new Date(data.taioStartDate); //対応開始時刻
    this.taioEndDate = new Date(data.taioEndDate); //対応終了時刻
    this.taioDeptCd = data.taioDeptCd; //対応部署CD
    this.taioDeptNm = data.taioDeptNm; //対応部署名
    this.taioUserId = data.taioUserId; //対応者ID
    this.taioUserNm = data.taioUserNm; //対応者名    
    this.taioTel = data.taioTel; //対応電話番号
    this.taioMail = data.taioMail; //対応メール
    this.taioContent = data.taioContent; //対応内容

    // １－５．処置情報
    this.actDate = new Date(data.actDate); //処置予定日
    this.actTypeCd = data.actTypeCd; //処置区分CD
    this.actStartDate = new Date(data.actStartDate); //処置開始日
    this.actStartTime = new Date(data.actStartTime); //処置開始時刻
    this.actEndDate = new Date(data.actEndDate); //処置終了日
    this.actEndTime = new Date(data.actEndTime); //処置終了時刻
    this.actDeptCd = data.actDeptCd; //処置部署CD
    this.actDeptNm = data.actDeptNm; //処置部署名
    this.actUserId = data.actUserId; //処置者ID
    this.actUserNm = data.actUserNm; //処置者名
    this.actTel = data.actTel; //処置電話番号
    this.actMail = data.actMail; //処置メール
    this.actContent = data.actContent; //処置内容

    // １－６．製品情報
    this.productTypeCd = data.productTypeCd; //機種区分CD
    this.productTypeNm = data.productTypeNm; //機種区分名
    this.productTriggerCd = data.productTriggerCd; //障害状況トリガーCD
    this.productTriggerNm = data.productTriggerNm; //障害状況トリガー名
    this.productHindoCd = data.productHindoCd; //障害状況頻度CD
    this.productHindoNm = data.productHindoNm; //障害状況頻度名
    this.productGensyoCd = data.productGensyoCd; //障害状況現象CD
    this.productGensyoNm = data.productGensyoNm; //障害状況現象名
    this.productStatusCd = data.productStatusCd; //障害状況状態CD
    this.productStatusNm = data.productStatusNm; //障害状況状態名
  }

  // インシデント分類セレクト情報
  incidentTypeArray = [
    { label: '障害', value: 1 },
    { label: '事故', value: 2 },
    { label: '問合せ', value: 3 },
    { label: 'クレーム', value: 4 },
    { label: '情報', value: 5 },
    { label: 'その他', value: 6 }
  ];

  // 業種区分セレクト情報
  industryTypeArray = [
    { label: '機械', value: 1 },
    { label: '電機（E）', value: 2 },
    { label: '計装（I）', value: 3 },
    { label: '情報（C）', value: 4 },
    { label: '環境', value: 5 },
    { label: 'WBC', value: 6 },
    { label: 'その他', value: 7 }
  ];

  // 都道府県セレクト情報
  prefArray = [
    { label: '北海道', value: 1 },
    { label: '青森県', value: 2 },
    { label: '秋田県', value: 3 },
    { label: '岩手県', value: 4 }
  ];

  // 顧客分類セレクト情報
  custTypeArray = [
    { label: '年間契約', value: 1 },
    { label: '点検契約', value: 2 },
    { label: '契約なし', value: 3 },
    { label: '瑕疵期間中', value: 4 },
    { label: 'その他', value: 5 },
  ];

  // 情報提供元セレクト情報
  infoSourceArray = [
    { label: '顧客', value: 1 },
    { label: '特約店', value: 2 },
    { label: '営業', value: 3 },
    { label: '技術', value: 4 },
    { label: 'その他', value: 5 },
  ];

  // 機種区分セレクト情報
  productTypeArray = [
    { label: '機種区分１', value: 1 },
    { label: 'etc', value: 2 },
  ];

  // 障害状況トリガーセレクト情報
  productTriggerArray = [
    { label: '通常運用', value: 1 },
    { label: '立上時', value: 2 },
    { label: '立下時', value: 3 },
    { label: '停電', value: 4 },
    { label: '復電', value: 5 },
    { label: 'etc', value: 6 },
  ];

  // 障害状況頻度セレクト情報
  productHindoArray = [
    { label: '常時', value: 1 },
    { label: '不定期', value: 2 },
    { label: '間欠的', value: 3 },
    { label: 'その他', value: 4 },
    { label: 'etc', value: 5 },
  ];

  // 障害状況現象セレクト情報
  productGensyoArray = [
    { label: '運転不能', value: 1 },
    { label: '停止不能', value: 2 },
    { label: '動作異常', value: 3 },
    { label: '操作不能', value: 4 },
    { label: 'etc', value: 5 },
  ];

  // 障害状況状態セレクト情報
  productStatusArray = [
    { label: 'システムダウン', value: 1 },
    { label: '電源断', value: 2 },
    { label: '機器・装置故障', value: 2 },
    { label: '部品故障', value: 2 },
    { label: 'etc', value: 2 },
  ];

  // 処置区分セレクト情報
  actTypeArray = [
    { label: '出動', value: 1 },
    { label: '電話対応', value: 2 },
    { label: 'その他', value: 3 },
  ];

}