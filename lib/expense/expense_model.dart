import 'package:real_web_rough_entry_system/expense_group/expense_group_model.dart';

class ExpenseModel {
  int? expMstId;
  int? expCode;
  String? expName;
  int? expGroupCode;
  int? companyCode;
  int? sortID;
  bool? active;
  String? sdate;
  String? sflag;
  String? expGroupName;
  ExpenseGroupModel? expenseGroup;

  ExpenseModel({
    this.expMstId,
    this.expCode,
    this.expName,
    this.expGroupCode,
    this.companyCode,
    this.sortID,
    this.active,
    this.sdate,
    this.sflag,
    this.expGroupName,
    this.expenseGroup,
  });

  ExpenseModel.fromJson(Map<String, dynamic> json) {
    expMstId = json['ExpMstId'] ?? json['ExpMstID'] ?? json['ID'];
    expCode = json['ExpCode'] ?? json['ExpMstId'] ?? json['ExpMstID'];
    expName = json['ExpName'] ?? json['Name'];
    expGroupCode = json['ExpGroupCode'];
    companyCode = json['CompanyCode'];
    sortID = json['SortID'];
    active = json['Active'];
    sdate = json['Sdate'] ?? json['SDate'];
    sflag = json['Sflag'] ?? json['SFlag'];

    if (json['expenseGroup'] != null && json['expenseGroup'] is Map<String, dynamic>) {
      expenseGroup = ExpenseGroupModel.fromJson(json['expenseGroup'] as Map<String, dynamic>);
    }

    expGroupName = json['ExpGroupName'] ??
        json['ExpGrpName'] ??
        expenseGroup?.expGroupName;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ExpMstId'] = expMstId;
    data['ExpCode'] = expCode ?? expMstId;
    data['ExpName'] = expName;
    data['Name'] = expName;
    data['ExpGroupCode'] = expGroupCode;
    data['CompanyCode'] = companyCode;
    data['SortID'] = sortID;
    data['Active'] = active;
    data['Sdate'] = sdate;
    data['Sflag'] = sflag;
    if (expGroupName != null) {
      data['ExpGroupName'] = expGroupName;
      data['ExpGrpName'] = expGroupName;
    }
    if (expenseGroup != null) {
      data['expenseGroup'] = expenseGroup!.toJson();
    }
    return data;
  }
}

typedef ExpenseMstModel = ExpenseModel;
