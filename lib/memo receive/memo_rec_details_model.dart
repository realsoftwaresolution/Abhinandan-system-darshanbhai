class MemoRecDetailsModel {
  int? memoRecDetID;
  int? memoRecMstID;
  int? srNo;

  // int clarityCode;
  // int charniCode;
  // int pcs;
  double? carats;
  double? recCarats;
  double? rateRs;
  double? amountRs;
  double? rateD;
  double? amountD;

  // double? penCarats;
  String? type;

  // Null invNo;
  // Null roughPurMstID;
  int? roughTypeCode;
  String? description;

  MemoRecDetailsModel(
      {this.memoRecDetID,
      this.memoRecMstID,
      this.srNo,
      // this.clarityCode,
      // this.charniCode,
      // this.pcs,
      this.carats,
      this.recCarats,
      this.rateRs,
      this.amountRs,
      this.rateD,
      this.amountD,
      // this.penCarats,
      this.type,
      // this.invNo,
      // this.roughPurMstID,
      this.roughTypeCode,
      this.description});

  MemoRecDetailsModel.fromJson(Map<String, dynamic> json) {
    memoRecDetID = json['MemoRecDetID'];
    memoRecMstID = json['MemoRecMstID'];
    srNo = json['SrNo'];
    // clarityCode = json['ClarityCode'];
    // charniCode = json['CharniCode'];
    // pcs = json['Pcs'];
    carats = json['Carats'];
    recCarats = json['RecCarats'];
    rateRs = json['RateRs'];
    amountRs = json['AmountRs'];
    rateD = json['RateD'];
    amountD = json['AmountD'];
    // penCarats = json['PenCarats'];
    type = json['Type'];
    // invNo = json['InvNo'];
    // roughPurMstID = json['RoughPurMstID'];
    roughTypeCode = json['RoughTypeCode'];
    description = json['Description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['MemoRecDetID'] = memoRecDetID;
    data['MemoRecMstID'] = memoRecMstID;
    data['SrNo'] = srNo;
    // data['ClarityCode'] = clarityCode;
    // data['CharniCode'] = charniCode;
    // data['Pcs'] = pcs;
    data['Carats'] = carats;
    data['RecCarats'] = recCarats;
    data['RateRs'] = rateRs;
    data['AmountRs'] = amountRs;
    data['RateD'] = rateD;
    data['AmountD'] = amountD;
    // data['PenCarats'] = penCarats;
    data['Type'] = type;
    // data['InvNo'] = invNo;
    // data['RoughPurMstID'] = roughPurMstID;
    data['RoughTypeCode'] = roughTypeCode;
    data['Description'] = description;
    return data;
  }
}
