class PurchaseDetailsModel {
  int? roughPurMstID;
  String? rPType;
  int? dayBookCode;
  String? invoiceNo;
  String? invoiceDate;
  String? recdate;
  int? partyCode;
  int? brokerCode;
  int? dueDay;
  String? dueDate;
  String? rDType;
  double? exchange;
  int? tPc;
  double? tWeight;
  double? tAmtRs;
  double? tAmtDollar;
  double? tRateRs;
  double? tRateDollar;
  double? invCharge;
  double? invChargePer;
  double? addPer;
  double? addFix;
  double? addPer1;
  double? addFix1;
  double? lessPer;
  double? lessPer1;
  double? lessFix;
  double? lessFix1;
  double? expPer;
  double? expFix;
  double? linPer;
  double? linFix;
  double? comPer;
  double? comFix;
  double? totExpPer;
  double? totExpFix;
  double? broPer;
  double? broFix;
  double? broRs;
  double? intPer;
  double? totAmtDollar;
  double? totNetAmtRs;
  double? totAmtRs;
  int? rec;
  int? logID;
  String? pCID;
  int? ever;
  String? sDate;
  int? companyCode;
  int? vPartyCode;
  int? idBookNo;
  String? chkAdd;
  String? chkLess;
  String? chkExp;
  String? chkLin;
  String? chkCom;
  String? chkBro;
  double? avgRate;
  double? netAmtDollar;
  double? netAmtRs;
  double? totNetAmtDollar;
  String? pSite;
  String? lessType;
  String? remarks;
  String? bIllType;
  double? labAmtRs;
  double? labAmtDollar;
  double? gstPer;
  double? gstAmtRs;
  double? gstAmtDollar;
  String? assRec;
  int? entryForm;
  String? entryType;
  double? invChargeRs;
  double? comFixRs;
  String? chkInv;
  double? expFixRs;
  double? linFixRs;
  double? totExpFixRs;
  double? addFixRs;
  double? lessFixRs;
  double? finalNetAmtDollar;
  double? finalNetAmtRs;

  PurchaseDetailsModel(
      {this.roughPurMstID,
        this.rPType,
        this.dayBookCode,
        this.invoiceNo,
        this.invoiceDate,
        this.recdate,
        this.partyCode,
        this.brokerCode,
        this.dueDay,
        this.dueDate,
        this.rDType,
        this.exchange,
        this.tPc,
        this.tWeight,
        this.tAmtRs,
        this.tAmtDollar,
        this.tRateRs,
        this.tRateDollar,
        this.invCharge,
        this.invChargePer,
        this.addPer,
        this.addFix,
        this.addPer1,
        this.addFix1,
        this.lessPer,
        this.lessPer1,
        this.lessFix,
        this.lessFix1,
        this.expPer,
        this.expFix,
        this.linPer,
        this.linFix,
        this.comPer,
        this.comFix,
        this.totExpPer,
        this.totExpFix,
        this.broPer,
        this.broFix,
        this.broRs,
        this.intPer,
        this.totAmtDollar,
        this.totNetAmtRs,
        this.totAmtRs,
        this.rec,
        this.logID,
        this.pCID,
        this.ever,
        this.sDate,
        this.companyCode,
        this.vPartyCode,
        this.idBookNo,
        this.chkAdd,
        this.chkLess,
        this.chkExp,
        this.chkLin,
        this.chkCom,
        this.chkBro,
        this.avgRate,
        this.netAmtDollar,
        this.netAmtRs,
        this.totNetAmtDollar,
        this.pSite,
        this.lessType,
        this.remarks,
        this.bIllType,
        this.labAmtRs,
        this.labAmtDollar,
        this.gstPer,
        this.gstAmtRs,
        this.gstAmtDollar,
        this.assRec,
        this.entryForm,
        this.entryType,
        this.invChargeRs,
        this.comFixRs,
        this.chkInv,
        this.expFixRs,
        this.linFixRs,
        this.totExpFixRs,
        this.addFixRs,
        this.lessFixRs,
        this.finalNetAmtDollar,
        this.finalNetAmtRs});

  PurchaseDetailsModel.fromJson(Map<String, dynamic> json) {
    roughPurMstID = json['RoughPurMstID'];
    rPType = json['RPType'];
    dayBookCode = json['DayBookCode'];
    invoiceNo = json['InvoiceNo'];
    invoiceDate = json['InvoiceDate'];
    recdate = json['Recdate'];
    partyCode = json['PartyCode'];
    brokerCode = json['BrokerCode'];
    dueDay = json['DueDay'];
    dueDate = json['DueDate'];
    rDType = json['RDType'];
    exchange = json['Exchange'];
    tPc = json['TPc'];
    tWeight = json['TWeight'];
    tAmtRs = json['TAmtRs'];
    tAmtDollar = json['TAmtDollar'];
    tRateRs = json['TRateRs'];
    tRateDollar = json['TRateDollar'];
    invCharge = json['InvCharge'];
    invChargePer = json['InvChargePer'];
    addPer = json['AddPer'];
    addFix = json['AddFix'];
    addPer1 = json['AddPer1'];
    addFix1 = json['AddFix1'];
    lessPer = json['LessPer'];
    lessPer1 = json['LessPer1'];
    lessFix = json['LessFix'];
    lessFix1 = json['LessFix1'];
    expPer = json['ExpPer'];
    expFix = json['ExpFix'];
    linPer = json['LinPer'];
    linFix = json['LinFix'];
    comPer = json['ComPer'];
    comFix = json['ComFix'];
    totExpPer = json['TotExpPer'];
    totExpFix = json['TotExpFix'];
    broPer = json['BroPer'];
    broFix = json['BroFix'];
    broRs = json['BroRs'];
    intPer = json['IntPer'];
    totAmtDollar = json['TotAmtDollar'];
    totNetAmtRs = json['TotNetAmtRs'];
    totAmtRs = json['TotAmtRs'];
    rec = json['Rec'];
    logID = json['LogID'];
    pCID = json['PCID'];
    ever = json['Ever'];
    sDate = json['SDate'];
    companyCode = json['CompanyCode'];
    vPartyCode = json['VPartyCode'];
    idBookNo = json['IdBookNo'];
    chkAdd = json['ChkAdd'];
    chkLess = json['ChkLess'];
    chkExp = json['ChkExp'];
    chkLin = json['ChkLin'];
    chkCom = json['ChkCom'];
    chkBro = json['ChkBro'];
    avgRate = json['AvgRate'];
    netAmtDollar = json['NetAmtDollar'];
    netAmtRs = json['NetAmtRs'];
    totNetAmtDollar = json['TotNetAmtDollar'];
    pSite = json['PSite'];
    lessType = json['LessType'];
    remarks = json['Remarks'];
    bIllType = json['BIllType'];
    labAmtRs = json['LabAmtRs'];
    labAmtDollar = json['LabAmtDollar'];
    gstPer = json['GstPer'];
    gstAmtRs = json['GstAmtRs'];
    gstAmtDollar = json['GstAmtDollar'];
    assRec = json['AssRec'];
    entryForm = json['EntryForm'];
    entryType = json['EntryType'];
    invChargeRs = json['InvChargeRs'];
    comFixRs = json['ComFixRs'];
    chkInv = json['ChkInv'];
    expFixRs = json['ExpFixRs'];
    linFixRs = json['LinFixRs'];
    totExpFixRs = json['TotExpFixRs'];
    addFixRs = json['AddFixRs'];
    lessFixRs = json['LessFixRs'];
    finalNetAmtDollar = json['FinalNetAmtDollar'];
    finalNetAmtRs = json['FinalNetAmtRs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['RoughPurMstID'] = roughPurMstID;
    data['RPType'] = rPType;
    data['DayBookCode'] = dayBookCode;
    data['InvoiceNo'] = invoiceNo;
    data['InvoiceDate'] = invoiceDate;
    data['Recdate'] = recdate;
    data['PartyCode'] = partyCode;
    data['BrokerCode'] = brokerCode;
    data['DueDay'] = dueDay;
    data['DueDate'] = dueDate;
    data['RDType'] = rDType;
    data['Exchange'] = exchange;
    data['TPc'] = tPc;
    data['TWeight'] = tWeight;
    data['TAmtRs'] = tAmtRs;
    data['TAmtDollar'] = tAmtDollar;
    data['TRateRs'] = tRateRs;
    data['TRateDollar'] = tRateDollar;
    data['InvCharge'] = invCharge;
    data['InvChargePer'] = invChargePer;
    data['AddPer'] = addPer;
    data['AddFix'] = addFix;
    data['AddPer1'] = addPer1;
    data['AddFix1'] = addFix1;
    data['LessPer'] = lessPer;
    data['LessPer1'] = lessPer1;
    data['LessFix'] = lessFix;
    data['LessFix1'] = lessFix1;
    data['ExpPer'] = expPer;
    data['ExpFix'] = expFix;
    data['LinPer'] = linPer;
    data['LinFix'] = linFix;
    data['ComPer'] = comPer;
    data['ComFix'] = comFix;
    data['TotExpPer'] = totExpPer;
    data['TotExpFix'] = totExpFix;
    data['BroPer'] = broPer;
    data['BroFix'] = broFix;
    data['BroRs'] = broRs;
    data['IntPer'] = intPer;
    data['TotAmtDollar'] = totAmtDollar;
    data['TotNetAmtRs'] = totNetAmtRs;
    data['TotAmtRs'] = totAmtRs;
    data['Rec'] = rec;
    data['LogID'] = logID;
    data['PCID'] = pCID;
    data['Ever'] = ever;
    data['SDate'] = sDate;
    data['CompanyCode'] = companyCode;
    data['VPartyCode'] = vPartyCode;
    data['IdBookNo'] = idBookNo;
    data['ChkAdd'] = chkAdd;
    data['ChkLess'] = chkLess;
    data['ChkExp'] = chkExp;
    data['ChkLin'] = chkLin;
    data['ChkCom'] = chkCom;
    data['ChkBro'] = chkBro;
    data['AvgRate'] = avgRate;
    data['NetAmtDollar'] = netAmtDollar;
    data['NetAmtRs'] = netAmtRs;
    data['TotNetAmtDollar'] = totNetAmtDollar;
    data['PSite'] = pSite;
    data['LessType'] = lessType;
    data['Remarks'] = remarks;
    data['BIllType'] = bIllType;
    data['LabAmtRs'] = labAmtRs;
    data['LabAmtDollar'] = labAmtDollar;
    data['GstPer'] = gstPer;
    data['GstAmtRs'] = gstAmtRs;
    data['GstAmtDollar'] = gstAmtDollar;
    data['AssRec'] = assRec;
    data['EntryForm'] = entryForm;
    data['EntryType'] = entryType;
    data['InvChargeRs'] = invChargeRs;
    data['ComFixRs'] = comFixRs;
    data['ChkInv'] = chkInv;
    data['ExpFixRs'] = expFixRs;
    data['LinFixRs'] = linFixRs;
    data['TotExpFixRs'] = totExpFixRs;
    data['AddFixRs'] = addFixRs;
    data['LessFixRs'] = lessFixRs;
    data['FinalNetAmtDollar'] = finalNetAmtDollar;
    data['FinalNetAmtRs'] = finalNetAmtRs;
    return data;
  }
}
