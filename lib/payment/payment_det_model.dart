class PaymentDetModel {
  int? paymentDetID;
  int? paymentMstID;
  int? partyCode;
  int? subRefID;
  int? srNo;
  String? trnType;
  int? mstID;
  String? dueDate;
  String? drCr;
  dynamic amtRs;
  dynamic amtDollar;
  dynamic bAmtRs;
  dynamic bAmtDollar;
  String? bRDrCr;
  String? bDDrCr;
  dynamic jAmtRs;
  dynamic jAmtDollar;
  dynamic uAmtRs;
  dynamic uAmtDollar;
  dynamic oAmtRs;
  dynamic oAmtDollar;
  String? oRDrCr;
  String? oDDrCr;
  String? traType;
  String? orgInvDate;
  int? dueDays;
  String? orgRateType;
  dynamic orgExRate;
  int? orgBrokerCode;
  dynamic orgCt;
  String? invNo;

  PaymentDetModel(
      {this.paymentDetID,
        this.paymentMstID,
        this.partyCode,
        this.subRefID,
        this.srNo,
        this.trnType,
        this.mstID,
        this.dueDate,
        this.drCr,
        this.amtRs,
        this.amtDollar,
        this.bAmtRs,
        this.bAmtDollar,
        this.bRDrCr,
        this.bDDrCr,
        this.jAmtRs,
        this.jAmtDollar,
        this.uAmtRs,
        this.uAmtDollar,
        this.oAmtRs,
        this.oAmtDollar,
        this.oRDrCr,
        this.oDDrCr,
        this.traType,
        this.orgInvDate,
        this.dueDays,
        this.orgRateType,
        this.orgExRate,
        this.orgBrokerCode,
        this.orgCt,
        this.invNo});

  PaymentDetModel.fromJson(Map<String, dynamic> json) {
    paymentDetID = json['PaymentDetID'];
    paymentMstID = json['PaymentMstID'];
    partyCode = json['PartyCode'];
    subRefID = json['SubRefID'];
    srNo = json['SrNo'];
    trnType = json['TrnType'];
    mstID = json['MstID'];
    dueDate = json['DueDate'];
    drCr = json['DrCr'];
    amtRs = json['AmtRs'];
    amtDollar = json['AmtDollar'];
    bAmtRs = json['BAmtRs'];
    bAmtDollar = json['BAmtDollar'];
    bRDrCr = json['BRDrCr'];
    bDDrCr = json['BDDrCr'];
    jAmtRs = json['JAmtRs'];
    jAmtDollar = json['JAmtDollar'];
    uAmtRs = json['UAmtRs'];
    uAmtDollar = json['UAmtDollar'];
    oAmtRs = json['OAmtRs'];
    oAmtDollar = json['OAmtDollar'];
    oRDrCr = json['ORDrCr'];
    oDDrCr = json['ODDrCr'];
    traType = json['TraType'];
    orgInvDate = json['OrgInvDate'];
    dueDays = json['DueDays'];
    orgRateType = json['OrgRateType'];
    orgExRate = json['OrgExRate'];
    orgBrokerCode = json['OrgBrokerCode'];
    orgCt = json['OrgCt'];
    invNo = json['InvNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PaymentDetID'] = paymentDetID;
    data['PaymentMstID'] = paymentMstID;
    data['PartyCode'] = partyCode;
    data['SubRefID'] = subRefID;
    data['SrNo'] = srNo;
    data['TrnType'] = trnType;
    data['MstID'] = mstID;
    data['DueDate'] = dueDate;
    data['DrCr'] = drCr;
    data['AmtRs'] = amtRs;
    data['AmtDollar'] = amtDollar;
    data['BAmtRs'] = bAmtRs;
    data['BAmtDollar'] = bAmtDollar;
    data['BRDrCr'] = bRDrCr;
    data['BDDrCr'] = bDDrCr;
    data['JAmtRs'] = jAmtRs;
    data['JAmtDollar'] = jAmtDollar;
    data['UAmtRs'] = uAmtRs;
    data['UAmtDollar'] = uAmtDollar;
    data['OAmtRs'] = oAmtRs;
    data['OAmtDollar'] = oAmtDollar;
    data['ORDrCr'] = oRDrCr;
    data['ODDrCr'] = oDDrCr;
    data['TraType'] = traType;
    data['OrgInvDate'] = orgInvDate;
    data['DueDays'] = dueDays;
    data['OrgRateType'] = orgRateType;
    data['OrgExRate'] = orgExRate;
    data['OrgBrokerCode'] = orgBrokerCode;
    data['OrgCt'] = orgCt;
    data['InvNo'] = invNo;
    return data;
  }
}
