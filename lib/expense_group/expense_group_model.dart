class ExpenseGroupModel {
  int? expGroupMstId;
  int? expGroupCode;
  String? expGroupName;
  int? companyCode;
  int? sortID;
  bool? active;
  String? sdate;
  String? sflag;

  ExpenseGroupModel({
    this.expGroupMstId,
    this.expGroupCode,
    this.expGroupName,
    this.companyCode,
    this.sortID,
    this.active,
    this.sdate,
    this.sflag,
  });

  ExpenseGroupModel.fromJson(Map<String, dynamic> json) {
    expGroupMstId = json['ExpGroupMstId'] ?? json['ExpGroupMstID'] ?? json['ExpGroupCode'] ?? json['ID'];
    expGroupCode = json['ExpGroupCode'] ?? json['ExpGroupMstId'] ?? json['ExpGroupMstID'];
    expGroupName = json['ExpGroupName'] ?? json['Name'];
    companyCode = json['CompanyCode'];
    sortID = json['SortID'];
    active = json['Active'];
    sdate = json['Sdate'] ?? json['SDate'];
    sflag = json['Sflag'] ?? json['SFlag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ExpGroupMstId'] = expGroupMstId;
    data['ExpGroupCode'] = expGroupCode ?? expGroupMstId;
    data['ExpGroupName'] = expGroupName;
    data['Name'] = expGroupName;
    data['CompanyCode'] = companyCode;
    data['SortID'] = sortID;
    data['Active'] = active;
    data['Sdate'] = sdate;
    data['Sflag'] = sflag;
    return data;
  }
}

typedef ExpenseGroupMstModel = ExpenseGroupModel;
