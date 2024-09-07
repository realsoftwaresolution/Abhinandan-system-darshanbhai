class RoughModel {
  int? roughTypeMstID;
  int? roughTypeCode;
  String? roughTypeName;
  String? sflag;
  String? sdate;
  int? logID;
  String? pcID;
  int? ever;
  int? companyCode;
  int? sortID;
  bool? active;

  RoughModel(
      {this.roughTypeMstID,
        this.roughTypeCode,
        this.roughTypeName,
        this.sflag,
        this.sdate,
        this.logID,
        this.pcID,
        this.ever,
        this.companyCode,
        this.sortID,
        this.active});

  RoughModel.fromJson(Map<String, dynamic> json) {
    roughTypeMstID = json['RoughTypeMstID'];
    roughTypeCode = json['RoughTypeCode'];
    roughTypeName = json['RoughTypeName'];
    sflag = json['Sflag'];
    sdate = json['Sdate'];
    logID = json['LogID'];
    pcID = json['PcID'];
    ever = json['Ever'];
    companyCode = json['CompanyCode'];
    sortID = json['SortID'];
    active = json['Active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['RoughTypeMstID'] = roughTypeMstID;
    data['RoughTypeCode'] = roughTypeCode;
    data['RoughTypeName'] = roughTypeName;
    data['Sflag'] = sflag;
    data['Sdate'] = sdate;
    data['LogID'] = logID;
    data['PcID'] = pcID;
    data['Ever'] = ever;
    data['CompanyCode'] = companyCode;
    data['SortID'] = sortID;
    data['Active'] = active;
    return data;
  }
}
