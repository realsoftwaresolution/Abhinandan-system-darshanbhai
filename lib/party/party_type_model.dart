class PartyTypeMstModel {
  int? typeCode;
  String? typeName;
  int? typeGroupCode;
  int? sortID;
  bool? active;
  String? sflag;
  String? sDateTime;
  String? logID;
  String? pcID;
  int? ever;
  String? delRights;
  bool? bActive;
  int? companyCode;

  PartyTypeMstModel(
      {this.typeCode,
        this.typeName,
        this.typeGroupCode,
        this.sortID,
        this.active,
        this.sflag,
        this.sDateTime,
        this.logID,
        this.pcID,
        this.ever,
        this.delRights,
        this.bActive,
        this.companyCode});

  PartyTypeMstModel.fromJson(Map<String, dynamic> json) {
    typeCode = json['TypeCode'];
    typeName = json['TypeName'];
    typeGroupCode = json['TypeGroupCode'];
    sortID = json['SortID'];
    active = json['Active'];
    sflag = json['Sflag'];
    sDateTime = json['SDateTime'];
    logID = json['LogID'];
    pcID = json['PcID'];
    ever = json['Ever'];
    delRights = json['DelRights'];
    bActive = json['BActive'];
    companyCode = json['CompanyCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TypeCode'] = typeCode;
    data['TypeName'] = typeName;
    data['TypeGroupCode'] = typeGroupCode;
    data['SortID'] = sortID;
    data['Active'] = active;
    data['Sflag'] = sflag;
    data['SDateTime'] = sDateTime;
    data['LogID'] = logID;
    data['PcID'] = pcID;
    data['Ever'] = ever;
    data['DelRights'] = delRights;
    data['BActive'] = bActive;
    data['CompanyCode'] = companyCode;
    return data;
  }
}
