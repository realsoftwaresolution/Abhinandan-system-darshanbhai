class PaymentMstModel {
  int? paymentMstID;
  String? paymentDate;
  String? paymentDay;
  String? chequeNo;
  int? partyCode;
  int? accountCode;
  String? rateType;
  double? exRate;
  double? jAmtRs;
  double? jAmtDollar;
  double? uAmtRs;
  double? uAmtDollar;
  String? remarks1;
  String? remarks2;
  double? pAmtRs;
  double? pAmtDollar;
  double? aAmtRs;
  double? aAmtDollar;
  String? sflag;
  String? sDateTime;
  String? logID;
  String? pcID;
  int? ever;
  int? companyCode;

  PaymentMstModel(
      {this.paymentMstID,
        this.paymentDate,
        this.paymentDay,
        this.chequeNo,
        this.partyCode,
        this.accountCode,
        this.rateType,
        this.exRate,
        this.jAmtRs,
        this.jAmtDollar,
        this.uAmtRs,
        this.uAmtDollar,
        this.remarks1,
        this.remarks2,
        this.pAmtRs,
        this.pAmtDollar,
        this.aAmtRs,
        this.aAmtDollar,
        this.sflag,
        this.sDateTime,
        this.logID,
        this.pcID,
        this.ever,
        this.companyCode});

  PaymentMstModel.fromJson(Map<String, dynamic> json) {
    paymentMstID = json['PaymentMstID'];
    paymentDate = json['PaymentDate'];
    paymentDay = json['PaymentDay'];
    chequeNo = json['ChequeNo'];
    partyCode = json['PartyCode'];
    accountCode = json['AccountCode'];
    rateType = json['RateType'];
    exRate = json['ExRate'];
    jAmtRs = json['JAmtRs'];
    jAmtDollar = json['JAmtDollar'];
    uAmtRs = json['UAmtRs'];
    uAmtDollar = json['UAmtDollar'];
    remarks1 = json['Remarks1'];
    remarks2 = json['Remarks2'];
    pAmtRs = json['PAmtRs'];
    pAmtDollar = json['PAmtDollar'];
    aAmtRs = json['AAmtRs'];
    aAmtDollar = json['AAmtDollar'];
    sflag = json['Sflag'];
    sDateTime = json['SDateTime'];
    logID = json['LogID'];
    pcID = json['PcID'];
    ever = json['Ever'];
    companyCode = json['CompanyCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PaymentMstID'] = paymentMstID;
    data['PaymentDate'] = paymentDate;
    data['PaymentDay'] = paymentDay;
    data['ChequeNo'] = chequeNo;
    data['PartyCode'] = partyCode;
    data['AccountCode'] = accountCode;
    data['RateType'] = rateType;
    data['ExRate'] = exRate;
    data['JAmtRs'] = jAmtRs;
    data['JAmtDollar'] = jAmtDollar;
    data['UAmtRs'] = uAmtRs;
    data['UAmtDollar'] = uAmtDollar;
    data['Remarks1'] = remarks1;
    data['Remarks2'] = remarks2;
    data['PAmtRs'] = pAmtRs;
    data['PAmtDollar'] = pAmtDollar;
    data['AAmtRs'] = aAmtRs;
    data['AAmtDollar'] = aAmtDollar;
    data['Sflag'] = sflag;
    data['SDateTime'] = sDateTime;
    data['LogID'] = logID;
    data['PcID'] = pcID;
    data['Ever'] = ever;
    data['CompanyCode'] = companyCode;
    return data;
  }
}
