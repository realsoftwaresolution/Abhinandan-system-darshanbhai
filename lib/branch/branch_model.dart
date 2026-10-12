/// Model representing Branch from `/rough-entry/branch`
class BranchModel {
  int? branchMstId;
  int? branchCode;
  String? branchName;
  int? companyCode;
  dynamic sortId;
  bool? active;
  String? sdate;
  String? sflag;
  dynamic logId;
  dynamic pcId;
  int? ever;

  BranchModel({
    this.branchMstId,
    this.branchCode,
    this.branchName,
    this.companyCode,
    this.sortId,
    this.active,
    this.sdate,
    this.sflag,
    this.logId,
    this.pcId,
    this.ever,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    final int? mstId = parseInt(json['BranchMstID'] ??
        json['BranchMstId'] ??
        json['branchMstId'] ??
        json['BranchId'] ??
        json['BranchID'] ??
        json['branchId'] ??
        json['ID'] ??
        json['Id'] ??
        json['id']);

    final int? code = parseInt(json['BranchCode'] ??
        json['branchCode'] ??
        json['Code'] ??
        json['code'] ??
        mstId);

    return BranchModel(
      branchMstId: mstId,
      branchCode: code,
      branchName: json['BranchName']?.toString() ??
          json['branchName']?.toString() ??
          json['Name']?.toString() ??
          json['name']?.toString(),
      companyCode: parseInt(json['CompanyCode'] ??
          json['companyCode'] ??
          json['Companycode']),
      sortId: json['SortID'] ?? json['SortId'] ?? json['sortId'] ?? json['sortID'],
      active: json['Active'] is bool
          ? json['Active']
          : (json['Active'] == 1 || json['Active'] == '1' || json['Active'] == 'true'),
      sdate: json['Sdate']?.toString() ??
          json['sdate']?.toString() ??
          json['SDateTime']?.toString() ??
          json['sDateTime']?.toString(),
      sflag: json['Sflag']?.toString() ?? json['sflag']?.toString(),
      logId: json['LogID'] ?? json['logId'] ?? json['LogId'],
      pcId: json['PcId'] ?? json['pcId'] ?? json['PcID'],
      ever: parseInt(json['Ever'] ?? json['ever']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BranchMstID': branchMstId,
      'BranchCode': branchCode,
      'BranchName': branchName,
      'Name': branchName,
      'CompanyCode': companyCode,
      'SortID': sortId,
      'Active': active,
      'Sdate': sdate,
      'Sflag': sflag,
      'LogID': logId,
      'PcId': pcId,
      'Ever': ever,
    };
  }
}
