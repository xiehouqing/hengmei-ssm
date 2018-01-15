import { Component, TemplateRef, ViewChild, Output, EventEmitter } from '@angular/core';
import { ActivatedRoute, Params } from '@angular/router';
import { URLSearchParams } from '@angular/http';

import { BsModalService } from 'ngx-bootstrap/modal';
import { BsModalRef } from 'ngx-bootstrap/modal/bs-modal-ref.service';

import { JsonpService } from '../jsonp.service';

@Component({
  selector: 'sectionSearch-modal',
  templateUrl: './sectionSearch.modal.component.html',
  styleUrls: ['./modal.component.css']
})
export class SectionSearchModalComponent {
  @ViewChild('template')
  template;
  modalRef: BsModalRef;

  // モーダルのタイプ　親コンポーネントからの値受け取り
  modalType: any;

  // 営業担当者イベント(親コンポーネントのメソッド呼び出し)
  @Output() salesSectionSelect: EventEmitter<any> = new EventEmitter();

  constructor(private modalService: BsModalService, private jsonpService: JsonpService) { }

  //検索条件
  searchPostCd = "";
  searchSectionNm = "";
  searchCompanyNm = "";

  // ページングの設定
  maxSize: number = 5; // ページングの表示ページ数
  bigTotalItems: number = 0; // 総数
  itemsPerPage: number = 10; // 1ページに表示する件数
  currentPage: number = 0; // 現在表示しているページ
  start: number = 0; // データ表示開始位置

  // ページング処理
  pageChanged(event: any): void {
    this.start = this.itemsPerPage * (this.currentPage - 1);
  }

  // モーダル表示
  openModal(modalTypeFromParent: any) {
    if (modalTypeFromParent) {
      // 親コンポーネントからの値受け取り
      this.modalType = modalTypeFromParent;
    }
    this.clearSectionSearch();
    this.template.show();
    this.search();
  }

  // 検索条件の初期化
  clearSectionSearch() {
    this.searchPostCd = "";
    this.searchSectionNm = "";
    this.searchCompanyNm = "";
  }

  // 検索処理
  search() {
    // 検索パラメータの作成
    let ps = new URLSearchParams();
    ps.set("postCd", this.searchPostCd);
    ps.set("sectionNm", this.searchSectionNm);
    ps.set("companyNm", this.searchCompanyNm);

    // 検索
    this.jsonpService.commonRequestGet('DeptListDataGet.php', ps)
      .subscribe(
      data => {
        // 通信成功時
        console.group("SectionSearchModalComponent.search()");
        console.log(data);
        console.groupEnd();
        if (data[0]) {
          let list = data[0];
          if (list.result !== '' && list.result == true) {
            // 画面表示パラメータのセット処理
            this.setDspParam(data.slice(1)); // 配列1つ目は、サーバ処理成功フラグなので除外
          }
        }
      },
      error => {
        // 通信失敗もしくは、コールバック関数内でエラー
        console.group("SectionSearchModalComponent.search()");
        console.error(error);
        console.log('サーバとのアクセスに失敗しました。');
        console.groupEnd();
        return false;
      }
      );
  }

  // ユーザ検索結果リスト
  deptList = [];
  // 画面表示パラメータのセット処理
  setDspParam(data) {
    // ページングの設定
    this.bigTotalItems = data.length;
    // ユーザリストをセット
    this.deptList = data;
  }

  // 選択ボタンクリック data?.postCd, data?.sectionNm
  onSelect(postCd: any, sectionNm: any) {
    // 営業担当者
    this.salesSectionSelect.emit({"sectionSearchType":this.modalType,"postCd": postCd, "sectionNm": sectionNm });
    // モーダルの非表示
    this.template.hide();
  }

  // TODO 一時表示用　固定部門情報 
  incidentList = [
    {
      "postCd": "65000", "sectionNm": "機器）シス機器）神戸", "companyNm": "FES神戸",
    },
    {
      "postCd": "65100", "sectionNm": "機器）シス機器）神戸）配電盤設計", "companyNm": "FES神戸",
    },
    {
      "postCd": "KOUNO", "sectionNm": "河野設計室", "companyNm": "河野設計室",
    },
    {
      "postCd": "Q1000", "sectionNm": "生産)東京工場", "companyNm": "FES東工",
    },
    {
      "postCd": "Q1100", "sectionNm": "生産)東工)生産部", "companyNm": "FES東工",
    },
    {
      "postCd": "Q110C", "sectionNm": "生産)東工)生産部)資材課", "companyNm": "FES東工",
    },
    {
      "postCd": "Q110D", "sectionNm": "生産)東工)生産部)作業研究課", "companyNm": "FES東工",
    },
    {
      "postCd": "Q110F", "sectionNm": "生産)東工)生産部)技能ソリューC", "companyNm": "FES東工",
    },
    {
      "postCd": "R5005", "sectionNm": "関西）総務部)大阪", "companyNm": "富士電機システムズ（株）",
    },
    {
      "postCd": "R5006", "sectionNm": "関西）総務部)神戸", "companyNm": "富士電機システムズ（株）",
    },
  ];
}