class PaymentDetailsModel {
  String? invNo;
  int? subRefID;
  String? trnType;
  String? traType;
  int? mstID;
  String? dueDate;
  String? drCr;
  double? amtRs;
  double? amtDollar;
  double? bAmtRs;
  String? bRDrCr;
  double? bAmtDollar;
  String? bDDrCr;
  double? jAmtRs;
  double? jAmtDollar;
  double? uAmtRs;
  double? uAmtDollar;
  double? oAmtRs;
  String? oRDrCr;
  double? oAmtDollar;
  String? oDDrCr;
  String? orgInvDate;
  int? dueDays;
  String? orgRateType;
  double? orgExRate;
  int? orgBrokerCode;
  double? orgCt;

  PaymentDetailsModel(
      {this.invNo,
        this.subRefID,
        this.trnType,
        this.traType,
        this.mstID,
        this.dueDate,
        this.drCr,
        this.amtRs,
        this.amtDollar,
        this.bAmtRs,
        this.bRDrCr,
        this.bAmtDollar,
        this.bDDrCr,
        this.jAmtRs,
        this.jAmtDollar,
        this.uAmtRs,
        this.uAmtDollar,
        this.oAmtRs,
        this.oRDrCr,
        this.oAmtDollar,
        this.oDDrCr,
        this.orgInvDate,
        this.dueDays,
        this.orgRateType,
        this.orgExRate,
        this.orgBrokerCode,
        this.orgCt});

  PaymentDetailsModel.fromJson(Map<String, dynamic> json) {
    invNo = json['InvNo'];
    subRefID = json['SubRefID'];
    trnType = json['TrnType'];
    traType = json['TraType'];
    mstID = json['MstID'];
    dueDate = json['DueDate'];
    drCr = json['DrCr'];
    amtRs = json['AmtRs'];
    amtDollar = json['AmtDollar'];
    bAmtRs = json['BAmtRs'];
    bRDrCr = json['BRDrCr'];
    bAmtDollar = json['BAmtDollar'];
    bDDrCr = json['BDDrCr'];
    jAmtRs = json['JAmtRs'];
    jAmtDollar = json['JAmtDollar'];
    uAmtRs = json['UAmtRs'];
    uAmtDollar = json['UAmtDollar'];
    oAmtRs = json['OAmtRs'];
    oRDrCr = json['ORDrCr'];
    oAmtDollar = json['OAmtDollar'];
    oDDrCr = json['ODDrCr'];
    orgInvDate = json['OrgInvDate'];
    dueDays = json['DueDays'];
    orgRateType = json['OrgRateType'];
    orgExRate = json['OrgExRate'];
    orgBrokerCode = json['OrgBrokerCode'];
    orgCt = json['OrgCt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['InvNo'] = invNo;
    data['SubRefID'] = subRefID;
    data['TrnType'] = trnType;
    data['TraType'] = traType;
    data['MstID'] = mstID;
    data['DueDate'] = dueDate;
    data['DrCr'] = drCr;
    data['AmtRs'] = amtRs;
    data['AmtDollar'] = amtDollar;
    data['BAmtRs'] = bAmtRs;
    data['BRDrCr'] = bRDrCr;
    data['BAmtDollar'] = bAmtDollar;
    data['BDDrCr'] = bDDrCr;
    data['JAmtRs'] = jAmtRs;
    data['JAmtDollar'] = jAmtDollar;
    data['UAmtRs'] = uAmtRs;
    data['UAmtDollar'] = uAmtDollar;
    data['OAmtRs'] = oAmtRs;
    data['ORDrCr'] = oRDrCr;
    data['OAmtDollar'] = oAmtDollar;
    data['ODDrCr'] = oDDrCr;
    data['OrgInvDate'] = orgInvDate;
    data['DueDays'] = dueDays;
    data['OrgRateType'] = orgRateType;
    data['OrgExRate'] = orgExRate;
    data['OrgBrokerCode'] = orgBrokerCode;
    data['OrgCt'] = orgCt;
    return data;
  }
}
