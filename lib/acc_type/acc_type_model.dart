/// Model representing Type Group from `/rough-entry/type/groups`
class TypeGroupModel {
  int? typeGroupCode;
  String? typeGroupName;
  dynamic sortId;
  bool? active;

  TypeGroupModel({
    this.typeGroupCode,
    this.typeGroupName,
    this.sortId,
    this.active,
  });

  factory TypeGroupModel.fromJson(Map<String, dynamic> json) {
    return TypeGroupModel(
      typeGroupCode: json['TypeGroupCode'] is int
          ? json['TypeGroupCode']
          : int.tryParse(json['TypeGroupCode']?.toString() ?? ''),
      typeGroupName:
          json['TypeGroupName']?.toString() ?? json['Name']?.toString(),
      sortId: json['SortID'] ?? json['SortId'],
      active: json['Active'] is bool
          ? json['Active']
          : (json['Active'] == 1 || json['Active'] == 'true'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TypeGroupCode': typeGroupCode,
      'TypeGroupName': typeGroupName,
      'SortID': sortId,
      'Active': active,
    };
  }
}

/// Model representing Account Type from `/rough-entry/type`
class AccTypeModel {
  int? typeCode;
  String? typeName;
  int? typeGroupCode;
  dynamic sortId;
  bool? active;
  int? companyCode;
  String? group;
  String? typeGroupName;
  TypeGroupModel? typeGroup;
  String? sflag;
  String? sdateTime;
  dynamic logId;
  dynamic pcId;
  int? ever;
  String? delRights;
  bool? bActive;

  AccTypeModel({
    this.typeCode,
    this.typeName,
    this.typeGroupCode,
    this.sortId,
    this.active,
    this.companyCode,
    this.group,
    this.typeGroupName,
    this.typeGroup,
    this.sflag,
    this.sdateTime,
    this.logId,
    this.pcId,
    this.ever,
    this.delRights,
    this.bActive,
  });

  factory AccTypeModel.fromJson(Map<String, dynamic> json) {
    TypeGroupModel? groupModel;
    if (json['typeGroup'] != null && json['typeGroup'] is Map<String, dynamic>) {
      groupModel =
          TypeGroupModel.fromJson(json['typeGroup'] as Map<String, dynamic>);
    }

    return AccTypeModel(
      typeCode: json['TypeCode'] is int
          ? json['TypeCode']
          : int.tryParse(json['TypeCode']?.toString() ?? ''),
      typeName: json['TypeName']?.toString() ?? json['Name']?.toString(),
      typeGroupCode: json['TypeGroupCode'] is int
          ? json['TypeGroupCode']
          : int.tryParse(json['TypeGroupCode']?.toString() ?? ''),
      sortId: json['SortID'] ?? json['SortId'] ?? json['sortId'],
      active: json['Active'] is bool
          ? json['Active']
          : (json['Active'] == 1 || json['Active'] == 'true'),
      companyCode: json['CompanyCode'] is int
          ? json['CompanyCode']
          : int.tryParse(json['CompanyCode']?.toString() ?? ''),
      group: json['Group']?.toString() ??
          json['TypeGroupName']?.toString() ??
          groupModel?.typeGroupName,
      typeGroupName: json['TypeGroupName']?.toString() ??
          json['Group']?.toString() ??
          groupModel?.typeGroupName,
      typeGroup: groupModel,
      sflag: json['Sflag']?.toString(),
      sdateTime: json['SDateTime']?.toString() ?? json['Sdate']?.toString(),
      logId: json['LogID'] ?? json['LogId'],
      pcId: json['PcID'] ?? json['PcId'],
      ever: json['Ever'] is int
          ? json['Ever']
          : int.tryParse(json['Ever']?.toString() ?? ''),
      delRights: json['DelRights']?.toString(),
      bActive: json['BActive'] is bool
          ? json['BActive']
          : (json['BActive'] == 1 || json['BActive'] == 'true'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TypeCode': typeCode,
      'TypeName': typeName,
      'TypeGroupCode': typeGroupCode,
      'SortID': sortId,
      'Active': active,
      'CompanyCode': companyCode,
      'Group': group,
      'TypeGroupName': typeGroupName,
      if (typeGroup != null) 'typeGroup': typeGroup?.toJson(),
      'Sflag': sflag,
      'SDateTime': sdateTime,
      'LogID': logId,
      'PcID': pcId,
      'Ever': ever,
      'DelRights': delRights,
      'BActive': bActive,
    };
  }
}
