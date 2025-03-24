class PendingPaymentModel {
  int? partyCode;
  String? trnType;
  int? mstID;
  String? dueDate;
  String? drCr;
  dynamic amtRs;
  dynamic outAmtRs;
  dynamic amtDollar;
  dynamic bAmtRs;
  dynamic bRDrCr;
  dynamic bAmtDollar;
  String? bDDrCr;
  dynamic jAmtRs;
  dynamic jAmtDollar;
  dynamic uAmtRs;
  dynamic uAmtDollar;
  dynamic oAmtRs;
  dynamic oAmtDollar;
  String? oRDrCr;
  String? oDDrCr;
  int? subRefID;
  String? traType;
  String? orgInvDate;
  int? dueDays;
  String? orgRateType;
  dynamic orgExRate;
  int? orgBrokerCode;
  dynamic orgCt;
  int? companyCode;
  String? partyName;
  String? invNo;

  PendingPaymentModel(
      {this.partyCode,
        this.trnType,
        this.mstID,
        this.dueDate,
        this.drCr,
        this.amtRs,
        this.outAmtRs,
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
        this.oAmtDollar,
        this.oRDrCr,
        this.oDDrCr,
        this.subRefID,
        this.traType,
        this.orgInvDate,
        this.dueDays,
        this.orgRateType,
        this.orgExRate,
        this.orgBrokerCode,
        this.orgCt,
        this.companyCode,
        this.partyName,
        this.invNo});

  PendingPaymentModel.fromJson(Map<String, dynamic> json) {
    partyCode = json['PartyCode'];
    trnType = json['TrnType'];
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
    oAmtDollar = json['OAmtDollar'];
    oRDrCr = json['ORDrCr'];
    oDDrCr = json['ODDrCr'];
    subRefID = json['SubRefID'];
    traType = json['TraType'];
    orgInvDate = json['OrgInvDate'];
    dueDays = json['DueDays'];
    orgRateType = json['OrgRateType'];
    orgExRate = json['OrgExRate'];
    orgBrokerCode = json['OrgBrokerCode'];
    orgCt = json['OrgCt'];
    companyCode = json['CompanyCode'];
    partyName = json['PartyName'];
    invNo = json['InvNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PartyCode'] = partyCode;
    data['TrnType'] = trnType;
    data['MstID'] = mstID;
    data['DueDate'] = dueDate;
    data['DrCr'] = drCr;
    data['AmtRs'] = amtRs;
    // data['OutAmtRs'] = outAmtRs;
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
    data['OAmtDollar'] = oAmtDollar;
    data['ORDrCr'] = oRDrCr;
    data['ODDrCr'] = oDDrCr;
    data['SubRefID'] = subRefID;
    data['TraType'] = traType;
    data['OrgInvDate'] = orgInvDate;
    data['DueDays'] = dueDays;
    data['OrgRateType'] = orgRateType;
    data['OrgExRate'] = orgExRate;
    data['OrgBrokerCode'] = orgBrokerCode;
    data['OrgCt'] = orgCt;
    data['CompanyCode'] = companyCode;
    data['PartyName'] = partyName;
    data['InvNo'] = invNo;
    return data;
  }
}
