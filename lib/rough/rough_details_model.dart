class RoughDetailsModel {
  int? roughPurDetID;
  int? roughPurMstID;
  int? srno;
  int? roughTypeCode;
  int? roughQualityCode;
  int? roughCharniCode;
  int? pc;
  dynamic wt;
  dynamic rateRs;
  dynamic amtRs;
  dynamic rateDollar;
  dynamic amtDollar;
  String? site;
  int? rec;
  String? oldInvoiceNo;
  String? oldRoughPurMstID;
  String? description;

  RoughDetailsModel(
      {this.roughPurDetID,
        this.roughPurMstID,
        this.srno,
        this.roughTypeCode,
        this.roughQualityCode,
        this.roughCharniCode,
        this.pc,
        this.wt,
        this.rateRs,
        this.amtRs,
        this.rateDollar,
        this.amtDollar,
        this.site,
        this.rec,
        this.oldInvoiceNo,
        this.oldRoughPurMstID, this.description});

  RoughDetailsModel.fromJson(Map<String, dynamic> json) {
    roughPurDetID = json['RoughPurDetID'];
    roughPurMstID = json['RoughPurMstID'];
    srno = json['Srno'];
    roughTypeCode = json['RoughTypeCode'];
    roughQualityCode = json['RoughQualityCode'];
    roughCharniCode = json['RoughCharniCode'];
    pc = json['Pc'];
    wt = json['Wt'];
    rateRs = json['RateRs'];
    amtRs = json['AmtRs'];
    rateDollar = json['RateDollar'];
    amtDollar = json['AmtDollar'];
    site = json['Site'];
    rec = json['Rec'];
    oldInvoiceNo = json['OldInvoiceNo'];
    oldRoughPurMstID = json['OldRoughPurMstID'];
    description = json['Description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['RoughPurDetID'] = roughPurDetID;
    data['RoughPurMstID'] = roughPurMstID;
    data['Srno'] = srno;
    data['RoughTypeCode'] = roughTypeCode;
    data['RoughQualityCode'] = roughQualityCode;
    data['RoughCharniCode'] = roughCharniCode;
    data['Pc'] = pc;
    data['Wt'] = wt;
    data['RateRs'] = rateRs;
    data['AmtRs'] = amtRs;
    data['RateDollar'] = rateDollar;
    data['AmtDollar'] = amtDollar;
    data['Site'] = site;
    data['Rec'] = rec;
    data['OldInvoiceNo'] = oldInvoiceNo;
    data['OldRoughPurMstID'] = oldRoughPurMstID;
    data['Description'] = description;
    return data;
  }
}
