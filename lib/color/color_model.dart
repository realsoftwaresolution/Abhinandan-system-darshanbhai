class ColorModel {
  int? colorMstID;
  int? colorCode;
  String? colorName;
  int? sortID;
  bool? active;
  int? companyCode;
  String? sdate;
  String? sflag;
  int? logID;
  String? pcID;
  int? ever;

  ColorModel({
    this.colorMstID,
    this.colorCode,
    this.colorName,
    this.sortID,
    this.active,
    this.companyCode,
    this.sdate,
    this.sflag,
    this.logID,
    this.pcID,
    this.ever,
  });

  ColorModel.fromJson(Map<String, dynamic> json) {
    colorMstID = json['ColorMstID'] ?? json['ColorCode'] ?? json['ID'];
    colorCode = json['ColorCode'] ?? json['ColorMstID'];
    colorName = json['ColorName'] ?? json['Name'];
    sortID = json['SortID'];
    active = json['Active'];
    companyCode = json['CompanyCode'];
    sdate = json['Sdate'];
    sflag = json['Sflag'];
    logID = json['LogID'];
    pcID = json['PcID'];
    ever = json['Ever'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ColorMstID'] = colorMstID;
    data['ColorCode'] = colorCode ?? colorMstID;
    data['ColorName'] = colorName;
    data['Name'] = colorName;
    data['SortID'] = sortID;
    data['Active'] = active;
    data['CompanyCode'] = companyCode;
    data['Sdate'] = sdate;
    data['Sflag'] = sflag;
    data['LogID'] = logID;
    data['PcID'] = pcID;
    data['Ever'] = ever;
    return data;
  }
}

typedef ColorMstModel = ColorModel;
