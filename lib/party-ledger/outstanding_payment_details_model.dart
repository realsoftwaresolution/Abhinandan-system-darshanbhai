class OutstandingPaymentDetails {
  String? invNo;
  String? orgInvDate;
  int? dueDays;
  String? dueDate;
  String? traType;
  String? drCr;
  double? amtRs;
  double? amtDollar;
  double? bAmtRs;
  String? bRDrCr;
  double? bAmtDollar;
  String? bDDrCr;
  int? subRefID;
  int? mstID;
  String? status;
  double? avgDays;
  double? lateDays;
  int? partyCode;
  String? formType;

  OutstandingPaymentDetails(
      {this.invNo,
        this.orgInvDate,
        this.dueDays,
        this.dueDate,
        this.traType,
        this.drCr,
        this.amtRs,
        this.amtDollar,
        this.bAmtRs,
        this.bRDrCr,
        this.bAmtDollar,
        this.bDDrCr,
        this.subRefID,
        this.mstID,
        this.status,
        this.avgDays,
        this.lateDays,
        this.partyCode,
        this.formType});

  OutstandingPaymentDetails.fromJson(Map<String, dynamic> json) {
    invNo = json['InvNo'];
    orgInvDate = json['OrgInvDate'];
    dueDays = json['DueDays'];
    dueDate = json['DueDate'];
    traType = json['TraType'];
    drCr = json['DrCr'];
    amtRs = json['AmtRs'];
    amtDollar = json['AmtDollar'];
    bAmtRs = json['BAmtRs'];
    bRDrCr = json['BRDrCr'];
    bAmtDollar = json['BAmtDollar'];
    bDDrCr = json['BDDrCr'];
    subRefID = json['SubRefID'];
    mstID = json['MstID'];
    status = json['Status'];
    avgDays = json['AvgDays'];
    lateDays = json['LateDays'];
    partyCode = json['PartyCode'];
    formType = json['FormType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['InvNo'] = invNo;
    data['OrgInvDate'] = orgInvDate;
    data['DueDays'] = dueDays;
    data['DueDate'] = dueDate;
    data['TraType'] = traType;
    data['DrCr'] = drCr;
    data['AmtRs'] = amtRs;
    data['AmtDollar'] = amtDollar;
    data['BAmtRs'] = bAmtRs;
    data['BRDrCr'] = bRDrCr;
    data['BAmtDollar'] = bAmtDollar;
    data['BDDrCr'] = bDDrCr;
    data['SubRefID'] = subRefID;
    data['MstID'] = mstID;
    data['Status'] = status;
    data['AvgDays'] = avgDays;
    data['LateDays'] = lateDays;
    data['PartyCode'] = partyCode;
    data['FormType'] = formType;
    return data;
  }
}
