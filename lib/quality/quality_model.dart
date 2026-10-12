class QualityModel {
  int? qualityMstID;
  int? qualityCode;
  String? qualityName;
  int? sortID;
  bool? active;
  int? companyCode;
  String? sdate;
  String? sflag;
  int? logID;
  String? pcID;
  int? ever;

  QualityModel({
    this.qualityMstID,
    this.qualityCode,
    this.qualityName,
    this.sortID,
    this.active,
    this.companyCode,
    this.sdate,
    this.sflag,
    this.logID,
    this.pcID,
    this.ever,
  });

  QualityModel.fromJson(Map<String, dynamic> json) {
    qualityMstID = json['QualityMstID'] ?? json['QualityCode'];
    qualityCode = json['QualityCode'] ?? json['QualityMstID'];
    qualityName = json['QualityName'] ?? json['Name'];
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
    data['QualityMstID'] = qualityMstID;
    data['QualityCode'] = qualityCode ?? qualityMstID;
    data['QualityName'] = qualityName;
    data['Name'] = qualityName;
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

typedef QualityMstModel = QualityModel;
