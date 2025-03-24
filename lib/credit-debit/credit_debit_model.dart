class CreditDebitMstModel {
  int? creditDebitMstID;
  int? mstID;
  int? purchaseMstID;
  int? saleMstID;
  int? polishPurMstID;
  int? polishRecMstID;
  int? paymentMstID;
  String? invDate;
  String? dueDate;
  String? rateType;
  dynamic exRate;
  int? partyCode;
  dynamic creditRs;
  dynamic creditDollar;
  dynamic debitRs;
  dynamic debitDollar;
  dynamic invAmtRs;
  // double? orgAmtRs;
  dynamic invAmtDollar;
  String? drCrType;
  String? formType;
  String? entryType;
  String? sflag;
  String? sDateTime;
  String? logID;
  String? pcID;
  int? ever;
  String? formName;
  int? srNo;
  int? perPartyCode;
  String? remarks1;
  String? remarks2;
  int? companyCode;
  String? traType;
  String? orgInvDate;
  int? dueDays;
  String? orgRateType;
  dynamic orgExRate;
  int? orgBrokerCode;
  dynamic orgCt;
  String? invoiceNo;
  int? polishSaleMstId;
  int? expenseMstID;

  CreditDebitMstModel({
    this.creditDebitMstID,
    this.mstID,
    this.purchaseMstID,
    this.saleMstID,
    this.polishPurMstID,
    this.polishRecMstID,
    this.paymentMstID,
    this.invDate,
    this.dueDate,
    this.rateType,
    this.exRate,
    this.partyCode,
    this.creditRs,
    this.creditDollar,
    this.debitRs,
    this.debitDollar,
    this.invAmtRs,
    // this.orgAmtRs,
    this.invAmtDollar,
    this.drCrType,
    this.formType,
    this.entryType,
    this.sflag,
    this.sDateTime,
    this.logID,
    this.pcID,
    this.ever,
    this.formName,
    this.srNo,
    this.perPartyCode,
    this.remarks1,
    this.remarks2,
    this.companyCode,
    this.traType,
    this.orgInvDate,
    this.dueDays,
    this.orgRateType,
    this.orgExRate,
    this.orgBrokerCode,
    this.orgCt,
    this.invoiceNo,
    this.polishSaleMstId,
    this.expenseMstID,
  });

  // Factory constructor to create an instance from JSON
  factory CreditDebitMstModel.fromJson(Map<String, dynamic> json) {
    return CreditDebitMstModel(
      creditDebitMstID: json['CreditDebitMstID'],
      mstID: json['MstID'],
      purchaseMstID: json['PurchaseMstID'],
      saleMstID: json['SaleMstID'],
      polishPurMstID: json['PolishPurMstID'],
      polishRecMstID: json['PolishRecMstID'],
      paymentMstID: json['PaymentMstID'],
      invDate: json['InvDate'],
      dueDate: json['DueDate'],
      rateType: json['RateType'],
      exRate: json['ExRate'],
      partyCode: json['PartyCode'],
      creditRs: json['CreditRs'],
      creditDollar: json['CreditDollar'],
      debitRs: json['DebitRs'],
      debitDollar: json['DebitDollar'],
      invAmtRs: json['InvAmtRs'],
      // orgAmtRs: json['InvAmtRs'],
      invAmtDollar: json['InvAmtDollar'],
      drCrType: json['DrCrType'],
      formType: json['FormType'],
      entryType: json['EntryType'],
      sflag: json['Sflag'],
      sDateTime: json['SDateTime'],
      logID: json['LogID'],
      pcID: json['PcID'],
      ever: json['Ever'],
      formName: json['FormName'],
      srNo: json['SrNo'],
      perPartyCode: json['PerPartyCode'],
      remarks1: json['Remarks1'],
      remarks2: json['Remarks2'],
      companyCode: json['CompanyCode'],
      traType: json['TraType'],
      orgInvDate: json['OrgInvDate'],
      dueDays: json['DueDays'],
      orgRateType: json['OrgRateType'],
      orgExRate: json['OrgExRate'],
      orgBrokerCode: json['OrgBrokerCode'],
      orgCt: json['OrgCt'],
      invoiceNo: json['InvoiceNo'],
      polishSaleMstId: json['PolishSaleMstId'],
      expenseMstID: json['ExpenseMstID'],
    );
  }

  // Method to copy the instance with modified values
  // CreditDebitMstModel copyWith({
  //   int? creditDebitMstID,
  //   int? mstID,
  //   int? purchaseMstID,
  //   int? saleMstID,
  //   int? polishPurMstID,
  //   int? polishRecMstID,
  //   int? paymentMstID,
  //   String? invDate,
  //   String? dueDate,
  //   String? rateType,
  //   double? exRate,
  //   int? partyCode,
  //   double? creditRs,
  //   double? creditDollar,
  //   double? debitRs,
  //   double? debitDollar,
  //   double? invAmtRs,
  //   double? invAmtDollar,
  //   String? drCrType,
  //   String? formType,
  //   String? entryType,
  //   String? sflag,
  //   String? sDateTime,
  //   String? logID,
  //   String? pcID,
  //   int? ever,
  //   String? formName,
  //   int? srNo,
  //   int? perPartyCode,
  //   String? remarks1,
  //   String? remarks2,
  //   int? companyCode,
  //   String? traType,
  //   String? orgInvDate,
  //   int? dueDays,
  //   String? orgRateType,
  //   double? orgExRate,
  //   int? orgBrokerCode,
  //   double? orgCt,
  //   String? invoiceNo,
  //   int? polishSaleMstId,
  //   int? expenseMstID,
  // }) {
  //   return CreditDebitMstModel(
  //     creditDebitMstID: creditDebitMstID ?? this.creditDebitMstID,
  //     mstID: mstID ?? this.mstID,
  //     purchaseMstID: purchaseMstID ?? this.purchaseMstID,
  //     saleMstID: saleMstID ?? this.saleMstID,
  //     polishPurMstID: polishPurMstID ?? this.polishPurMstID,
  //     polishRecMstID: polishRecMstID ?? this.polishRecMstID,
  //     paymentMstID: paymentMstID ?? this.paymentMstID,
  //     invDate: invDate ?? this.invDate,
  //     dueDate: dueDate ?? this.dueDate,
  //     rateType: rateType ?? this.rateType,
  //     exRate: exRate ?? this.exRate,
  //     partyCode: partyCode ?? this.partyCode,
  //     creditRs: creditRs ?? this.creditRs,
  //     creditDollar: creditDollar ?? this.creditDollar,
  //     debitRs: debitRs ?? this.debitRs,
  //     debitDollar: debitDollar ?? this.debitDollar,
  //     invAmtRs: invAmtRs ?? this.invAmtRs,
  //     invAmtDollar: invAmtDollar ?? this.invAmtDollar,
  //     drCrType: drCrType ?? this.drCrType,
  //     formType: formType ?? this.formType,
  //     entryType: entryType ?? this.entryType,
  //     sflag: sflag ?? this.sflag,
  //     sDateTime: sDateTime ?? this.sDateTime,
  //     logID: logID ?? this.logID,
  //     pcID: pcID ?? this.pcID,
  //     ever: ever ?? this.ever,
  //     formName: formName ?? this.formName,
  //     srNo: srNo ?? this.srNo,
  //     perPartyCode: perPartyCode ?? this.perPartyCode,
  //     remarks1: remarks1 ?? this.remarks1,
  //     remarks2: remarks2 ?? this.remarks2,
  //     companyCode: companyCode ?? this.companyCode,
  //     traType: traType ?? this.traType,
  //     orgInvDate: orgInvDate ?? this.orgInvDate,
  //     dueDays: dueDays ?? this.dueDays,
  //     orgRateType: orgRateType ?? this.orgRateType,
  //     orgExRate: orgExRate ?? this.orgExRate,
  //     orgBrokerCode: orgBrokerCode ?? this.orgBrokerCode,
  //     orgCt: orgCt ?? this.orgCt,
  //     invoiceNo: invoiceNo ?? this.invoiceNo,
  //     polishSaleMstId: polishSaleMstId ?? this.polishSaleMstId,
  //     expenseMstID: expenseMstID ?? this.expenseMstID,
  //   );
  // }

  // Convert the model to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CreditDebitMstID'] = creditDebitMstID;
    data['MstID'] = mstID;
    data['PurchaseMstID'] = purchaseMstID;
    data['SaleMstID'] = saleMstID;
    data['PolishPurMstID'] = polishPurMstID;
    data['PolishRecMstID'] = polishRecMstID;
    data['PaymentMstID'] = paymentMstID;
    data['InvDate'] = invDate;
    data['DueDate'] = dueDate;
    data['RateType'] = rateType;
    data['ExRate'] = exRate;
    data['PartyCode'] = partyCode;
    data['CreditRs'] = creditRs;
    data['CreditDollar'] = creditDollar;
    data['DebitRs'] = debitRs;
    data['DebitDollar'] = debitDollar;
    data['InvAmtRs'] = invAmtRs;
    data['InvAmtDollar'] = invAmtDollar;
    data['DrCrType'] = drCrType;
    data['FormType'] = formType;
    data['EntryType'] = entryType;
    data['Sflag'] = sflag;
    data['SDateTime'] = sDateTime;
    data['LogID'] = logID;
    data['PcID'] = pcID;
    data['Ever'] = ever;
    data['FormName'] = formName;
    data['SrNo'] = srNo;
    data['PerPartyCode'] = perPartyCode;
    data['Remarks1'] = remarks1;
    data['Remarks2'] = remarks2;
    data['CompanyCode'] = companyCode;
    data['TraType'] = traType;
    data['OrgInvDate'] = orgInvDate;
    data['DueDays'] = dueDays;
    data['OrgRateType'] = orgRateType;
    data['OrgExRate'] = orgExRate;
    data['OrgBrokerCode'] = orgBrokerCode;
    data['OrgCt'] = orgCt;
    data['InvoiceNo'] = invoiceNo;
    data['PolishSaleMstId'] = polishSaleMstId;
    data['ExpenseMstID'] = expenseMstID;
    return data;
  }
}
