class MemoRecModel {
  int? memoRecMstID;
  String? polishDate;
  String? invoiceNo;
  int? invNo;
  String? invoiceDate;
  int? dueDay;
  String? dueDate;
  String? invCode;
  String? saleType;
  String? insuranceName;
  double? sGstPer;
  double? cGstPer;
  double? iGstPer;
  double? sGstAmont;
  double? cGstAmont;
  double? iGstAmont;
  double? sGstUsdAmont;
  double? cGstUsdAmont;
  double? iGstUsdAmont;
  double? totRsAmt;
  double? totUsdAmt;
  double? roundRs;
  double? roundUsd;
  double? netUsdAmount;
  double? netRsAmount;
  String? rdType;
  double? dollarRate;
  String? paymentRec;
  double? broPer;
  double? broRsAmount;
  double? broUSDAmount;
  int? brokerCode;
  int? bankCode;
  int? partyCode;
  double? finalRsAmount;
  double? finalUsdAmount;
  int? tPcs;
  double? tWeight;
  double? tRate;
  double? tAmount;
  double? tDRate;
  double? tDAmount;
  String? sflag;
  String? sDate;
  int? logID;
  String? pCID;
  int? ever;
  int? companyCode;

  MemoRecModel(
      {this.memoRecMstID,
        this.polishDate,
        this.invoiceNo,
        this.invNo,
        this.invoiceDate,
        this.dueDay,
        this.dueDate,
        this.invCode,
        this.saleType,
        this.insuranceName,
        this.sGstPer,
        this.cGstPer,
        this.iGstPer,
        this.sGstAmont,
        this.cGstAmont,
        this.iGstAmont,
        this.sGstUsdAmont,
        this.cGstUsdAmont,
        this.iGstUsdAmont,
        this.totRsAmt,
        this.totUsdAmt,
        this.roundRs,
        this.roundUsd,
        this.netUsdAmount,
        this.netRsAmount,
        this.rdType,
        this.dollarRate,
        this.paymentRec,
        this.broPer,
        this.broRsAmount,
        this.broUSDAmount,
        this.brokerCode,
        this.bankCode,
        this.partyCode,
        this.finalRsAmount,
        this.finalUsdAmount,
        this.tPcs,
        this.tWeight,
        this.tRate,
        this.tAmount,
        this.tDRate,
        this.tDAmount,
        this.sflag,
        this.sDate,
        this.logID,
        this.pCID,
        this.ever,
        this.companyCode});

  MemoRecModel.fromJson(Map<String, dynamic> json) {
    memoRecMstID = json['MemoRecMstID'];
    polishDate = json['PolishDate'];
    invoiceNo = json['InvoiceNo'];
    invNo = json['InvNo'];
    invoiceDate = json['InvoiceDate'];
    dueDay = json['DueDay'];
    dueDate = json['DueDate'];
    invCode = json['InvCode'];
    saleType = json['SaleType'];
    insuranceName = json['InsuranceName'];
    sGstPer = json['SGstPer'];
    cGstPer = json['CGstPer'];
    iGstPer = json['IGstPer'];
    sGstAmont = json['SGstAmont'];
    cGstAmont = json['CGstAmont'];
    iGstAmont = json['IGstAmont'];
    sGstUsdAmont = json['SGstUsdAmont'];
    cGstUsdAmont = json['CGstUsdAmont'];
    iGstUsdAmont = json['IGstUsdAmont'];
    totRsAmt = json['TotRsAmt'];
    totUsdAmt = json['TotUsdAmt'];
    roundRs = json['RoundRs'];
    roundUsd = json['RoundUsd'];
    netUsdAmount = json['NetUsdAmount'];
    netRsAmount = json['NetRsAmount'];
    rdType = json['RdType'];
    dollarRate = json['DollarRate'];
    paymentRec = json['PaymentRec'];
    broPer = json['BroPer'];
    broRsAmount = json['BroRsAmount'];
    broUSDAmount = json['BroUSDAmount'];
    brokerCode = json['BrokerCode'];
    bankCode = json['BankCode'];
    partyCode = json['PartyCode'];
    finalRsAmount = json['FinalRsAmount'];
    finalUsdAmount = json['FinalUsdAmount'];
    tPcs = json['TPcs'];
    tWeight = json['TWeight'];
    tRate = json['TRate'];
    tAmount = json['TAmount'];
    tDRate = json['TDRate'];
    tDAmount = json['TDAmount'];
    sflag = json['Sflag'];
    sDate = json['SDate'];
    logID = json['LogID'];
    pCID = json['PCID'];
    ever = json['Ever'];
    companyCode = json['CompanyCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['MemoRecMstID'] = memoRecMstID;
    data['PolishDate'] = polishDate;
    data['InvoiceNo'] = invoiceNo;
    data['InvNo'] = invNo;
    data['InvoiceDate'] = invoiceDate;
    data['DueDay'] = dueDay;
    data['DueDate'] = dueDate;
    data['InvCode'] = invCode;
    data['SaleType'] = saleType;
    data['InsuranceName'] = insuranceName;
    data['SGstPer'] = sGstPer;
    data['CGstPer'] = cGstPer;
    data['IGstPer'] = iGstPer;
    data['SGstAmont'] = sGstAmont;
    data['CGstAmont'] = cGstAmont;
    data['IGstAmont'] = iGstAmont;
    data['SGstUsdAmont'] = sGstUsdAmont;
    data['CGstUsdAmont'] = cGstUsdAmont;
    data['IGstUsdAmont'] = iGstUsdAmont;
    data['TotRsAmt'] = totRsAmt;
    data['TotUsdAmt'] = totUsdAmt;
    data['RoundRs'] = roundRs;
    data['RoundUsd'] = roundUsd;
    data['NetUsdAmount'] = netUsdAmount;
    data['NetRsAmount'] = netRsAmount;
    data['RdType'] = rdType;
    data['DollarRate'] = dollarRate;
    data['PaymentRec'] = paymentRec;
    data['BroPer'] = broPer;
    data['BroRsAmount'] = broRsAmount;
    data['BroUSDAmount'] = broUSDAmount;
    data['BrokerCode'] = brokerCode;
    data['BankCode'] = bankCode;
    data['PartyCode'] = partyCode;
    data['FinalRsAmount'] = finalRsAmount;
    data['FinalUsdAmount'] = finalUsdAmount;
    data['TPcs'] = tPcs;
    data['TWeight'] = tWeight;
    data['TRate'] = tRate;
    data['TAmount'] = tAmount;
    data['TDRate'] = tDRate;
    data['TDAmount'] = tDAmount;
    data['Sflag'] = sflag;
    data['SDate'] = sDate;
    data['LogID'] = logID;
    data['PCID'] = pCID;
    data['Ever'] = ever;
    data['CompanyCode'] = companyCode;
    return data;
  }
}
