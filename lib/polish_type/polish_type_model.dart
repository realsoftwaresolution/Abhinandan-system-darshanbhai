/// Model representing Polish Type from `/rough-entry/polish-type`
class PolishTypeModel {
  int? polishTypeMstId;
  int? polishTypeCode;
  String? polishTypeName;
  int? companyCode;
  dynamic sortId;
  bool? active;
  String? sdate;
  String? sflag;
  dynamic logId;
  dynamic pcId;
  int? ever;

  PolishTypeModel({
    this.polishTypeMstId,
    this.polishTypeCode,
    this.polishTypeName,
    this.companyCode,
    this.sortId,
    this.active,
    this.sdate,
    this.sflag,
    this.logId,
    this.pcId,
    this.ever,
  });

  factory PolishTypeModel.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    final int? mstId = parseInt(json['PolishTypeMstID'] ??
        json['PolishTypeMstId'] ??
        json['polishTypeMstId'] ??
        json['PolishTypeId'] ??
        json['PolishTypeID'] ??
        json['polishTypeId'] ??
        json['ID'] ??
        json['Id'] ??
        json['id']);

    final int? code = parseInt(json['PolishTypeCode'] ??
        json['polishTypeCode'] ??
        json['Code'] ??
        json['code'] ??
        mstId);

    return PolishTypeModel(
      polishTypeMstId: mstId,
      polishTypeCode: code,
      polishTypeName: json['PolishTypeName']?.toString() ??
          json['polishTypeName']?.toString() ??
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
      pcId: json['PcID'] ?? json['pcId'] ?? json['PcId'],
      ever: parseInt(json['Ever'] ?? json['ever']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PolishTypeMstID': polishTypeMstId,
      'PolishTypeCode': polishTypeCode,
      'PolishTypeName': polishTypeName,
      'Name': polishTypeName,
      'CompanyCode': companyCode,
      'SortID': sortId,
      'Active': active,
      'Sdate': sdate,
      'Sflag': sflag,
      'LogID': logId,
      'PcID': pcId,
      'Ever': ever,
    };
  }
}
