class AssortGroupMst {
  int? assortGroupMstID;
  String? name;
  int? sortID;
  bool? active;

  AssortGroupMst({this.assortGroupMstID, this.name, this.sortID, this.active});

  AssortGroupMst.fromJson(Map<String, dynamic> json) {
    assortGroupMstID = json['AssortGroupMstID'];
    name = json['Name'];
    sortID = json['SortID'];
    active = json['Active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AssortGroupMstID'] = assortGroupMstID;
    data['Name'] = name;
    data['SortID'] = sortID;
    data['Active'] = active;
    return data;
  }
}
