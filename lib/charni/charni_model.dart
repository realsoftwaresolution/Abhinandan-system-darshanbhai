class CharniRptGroupModel {
  int? charniRptGroupMstID;
  int? charniRptGroupCode;
  String? charniRptGroupName;
  int? sortID;
  bool? active;

  CharniRptGroupModel({
    this.charniRptGroupMstID,
    this.charniRptGroupCode,
    this.charniRptGroupName,
    this.sortID,
    this.active,
  });

  CharniRptGroupModel.fromJson(Map<String, dynamic> json) {
    charniRptGroupMstID = json['CharniRptGroupMstID'] ?? json['CharniRptGroupCode'];
    charniRptGroupCode = json['CharniRptGroupCode'] ?? json['CharniRptGroupMstID'];
    charniRptGroupName = json['CharniRptGroupName'] ?? json['Name'];
    sortID = json['SortID'];
    active = json['Active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CharniRptGroupMstID'] = charniRptGroupMstID;
    data['CharniRptGroupCode'] = charniRptGroupCode ?? charniRptGroupMstID;
    data['CharniRptGroupName'] = charniRptGroupName;
    data['SortID'] = sortID;
    data['Active'] = active;
    return data;
  }
}

class CharniModel {
  int? charniMstID;
  int? charniCode;
  String? charniName;
  int? charniRptGroupCode;
  double? fromSize;
  double? toSize;
  int? sortID;
  bool? active;
  int? companyCode;
  String? sdate;
  String? sflag;
  int? logID;
  String? pcID;
  int? ever;
  CharniRptGroupModel? rptGroup;

  CharniModel({
    this.charniMstID,
    this.charniCode,
    this.charniName,
    this.charniRptGroupCode,
    this.fromSize,
    this.toSize,
    this.sortID,
    this.active,
    this.companyCode,
    this.sdate,
    this.sflag,
    this.logID,
    this.pcID,
    this.ever,
    this.rptGroup,
  });

  CharniModel.fromJson(Map<String, dynamic> json) {
    charniMstID = json['CharniMstID'] ?? json['CharniCode'];
    charniCode = json['CharniCode'] ?? json['CharniMstID'];
    charniName = json['CharniName'] ?? json['Name'];
    charniRptGroupCode = json['CharniRptGroupCode'] ?? json['RptGroup'];
    fromSize = (json['FromSize'] as num?)?.toDouble();
    toSize = (json['ToSize'] as num?)?.toDouble();
    sortID = json['SortID'];
    active = json['Active'];
    companyCode = json['CompanyCode'];
    sdate = json['Sdate'];
    sflag = json['Sflag'];
    logID = json['LogID'];
    pcID = json['PcID'];
    ever = json['Ever'];
    if (json['rptGroup'] != null && json['rptGroup'] is Map<String, dynamic>) {
      rptGroup = CharniRptGroupModel.fromJson(json['rptGroup'] as Map<String, dynamic>);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CharniMstID'] = charniMstID;
    data['CharniCode'] = charniCode ?? charniMstID;
    data['CharniName'] = charniName;
    data['Name'] = charniName;
    data['CharniRptGroupCode'] = charniRptGroupCode;
    data['RptGroup'] = charniRptGroupCode;
    data['FromSize'] = fromSize;
    data['ToSize'] = toSize;
    data['SortID'] = sortID;
    data['Active'] = active;
    data['CompanyCode'] = companyCode;
    data['Sdate'] = sdate;
    data['Sflag'] = sflag;
    data['LogID'] = logID;
    data['PcID'] = pcID;
    data['Ever'] = ever;
    if (rptGroup != null) {
      data['rptGroup'] = rptGroup!.toJson();
    }
    return data;
  }
}

typedef CharniMstModel = CharniModel;
