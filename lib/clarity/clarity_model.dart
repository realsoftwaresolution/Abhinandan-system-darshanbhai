class ClarityModel {
  int? clarityMstID;
  String? clarityName;
  String? clarityAlias;
  int? sortID;
  bool? active;
  bool? purchase;
  int? companyCode;
  String? sdate;
  String? sflag;
  int? logID;
  String? pcID;
  int? ever;

  ClarityModel({
    this.clarityMstID,
    this.clarityName,
    this.clarityAlias,
    this.sortID,
    this.active,
    this.purchase,
    this.companyCode,
    this.sdate,
    this.sflag,
    this.logID,
    this.pcID,
    this.ever,
  });

  ClarityModel.fromJson(Map<String, dynamic> json) {
    clarityMstID = json['ClarityMstID'] ?? json['ClarityCode'] ?? json['ID'];
    clarityName = json['ClarityName'] ?? json['Name'];
    clarityAlias = json['ClarityAlias'] ?? json['AliasName'] ?? json['Alias'];
    sortID = json['SortID'];
    active = json['Active'];
    purchase = json['Purchase'];
    companyCode = json['CompanyCode'];
    sdate = json['Sdate'];
    sflag = json['Sflag'];
    logID = json['LogID'];
    pcID = json['PcID'];
    ever = json['Ever'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ClarityMstID'] = clarityMstID;
    data['ClarityName'] = clarityName;
    data['Name'] = clarityName;
    data['ClarityAlias'] = clarityAlias;
    data['AliasName'] = clarityAlias;
    data['SortID'] = sortID;
    data['Active'] = active;
    data['Purchase'] = purchase;
    data['CompanyCode'] = companyCode;
    data['Sdate'] = sdate;
    data['Sflag'] = sflag;
    data['LogID'] = logID;
    data['PcID'] = pcID;
    data['Ever'] = ever;
    return data;
  }
}

typedef ClarityMstModel = ClarityModel;
