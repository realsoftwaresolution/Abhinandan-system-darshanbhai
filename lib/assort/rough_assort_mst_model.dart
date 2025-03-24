class RoughAssortMst {
  int? roughAssortMstID;
  String? invoiceNo;
  dynamic wt;
  dynamic assortWt;
  dynamic pendingWt;
  int? logID;
  String? pCID;
  int? ever;
  String? sDate;
  int? companyCode;

  RoughAssortMst(
      {this.roughAssortMstID,
        this.invoiceNo,
        this.wt,
        this.assortWt,
        this.pendingWt,
        this.logID,
        this.pCID,
        this.ever,
        this.sDate,
        this.companyCode});

  RoughAssortMst.fromJson(Map<String, dynamic> json) {
    roughAssortMstID = json['RoughAssortMstID'];
    invoiceNo = json['InvoiceNo'];
    wt = json['Wt'];
    assortWt = json['AssortWt'];
    pendingWt = json['PendingWt'];
    logID = json['LogID'];
    pCID = json['PCID'];
    ever = json['Ever'];
    sDate = json['SDate'];
    companyCode = json['CompanyCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['RoughAssortMstID'] = roughAssortMstID;
    data['InvoiceNo'] = invoiceNo;
    data['Wt'] = wt;
    data['AssortWt'] = assortWt;
    data['PendingWt'] = pendingWt;
    data['LogID'] = logID;
    data['PCID'] = pCID;
    data['Ever'] = ever;
    data['SDate'] = sDate;
    data['CompanyCode'] = companyCode;
    return data;
  }
}
