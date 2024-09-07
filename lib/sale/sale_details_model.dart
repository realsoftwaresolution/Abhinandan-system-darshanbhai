class SaleDetailsModel {
  int? polishSaleDetID;
  int? polishSaleMstID;
  int? srNo;

  // int clarityCode;
  // int charniCode;
  // int pcs;
  double? carats;
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

  SaleDetailsModel(
      {this.polishSaleDetID,
      this.polishSaleMstID,
      this.srNo,
      // this.clarityCode,
      // this.charniCode,
      // this.pcs,
      this.carats,
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

  SaleDetailsModel.fromJson(Map<String, dynamic> json) {
    polishSaleDetID = json['PolishSaleDetID'];
    polishSaleMstID = json['PolishSaleMstID'];
    srNo = json['SrNo'];
    // clarityCode = json['ClarityCode'];
    // charniCode = json['CharniCode'];
    // pcs = json['Pcs'];
    carats = json['Carats'];
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
    data['PolishSaleDetID'] = polishSaleDetID;
    data['PolishSaleMstID'] = polishSaleMstID;
    data['SrNo'] = srNo;
    // data['ClarityCode'] = clarityCode;
    // data['CharniCode'] = charniCode;
    // data['Pcs'] = pcs;
    data['Carats'] = carats;
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
