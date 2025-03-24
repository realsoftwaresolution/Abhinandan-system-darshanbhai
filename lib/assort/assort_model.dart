
class AssortMst {
  int? assortMstID;
  String? name;
  String? assortGroup;
  int? sortID;
  bool? active;

  AssortMst(
      {this.assortMstID,
        this.name,
        this.assortGroup,
        this.sortID,
        this.active});

  AssortMst.fromJson(Map<String, dynamic> json) {
    assortMstID = json['AssortMstID'];
    name = json['Name'];
    assortGroup = json['AssortGroup'];
    sortID = json['SortID'];
    active = json['Active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AssortMstID'] = assortMstID;
    data['Name'] = name;
    data['AssortGroup'] = assortGroup;
    data['SortID'] = sortID;
    data['Active'] = active;
    return data;
  }
}
