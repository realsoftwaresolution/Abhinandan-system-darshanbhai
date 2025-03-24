
class RoughAssortDetMst {
  int? roughAssortDetMstID;
  int? roughAssortMstID;
  String? assortName;
  dynamic wt;
  dynamic rate;
  dynamic ammount;

  RoughAssortDetMst(
      {this.roughAssortDetMstID,
        this.roughAssortMstID,
        this.assortName,
        this.wt,
        this.rate,
        this.ammount});

  RoughAssortDetMst.fromJson(Map<String, dynamic> json) {
    roughAssortDetMstID = json['RoughAssortDetMstID'];
    roughAssortMstID = json['RoughAssortMstID'];
    assortName = json['AssortName'];
    wt = json['Wt'];
    rate = json['Rate'];
    ammount = json['Ammount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['RoughAssortDetMstID'] = roughAssortDetMstID;
    data['RoughAssortMstID'] = roughAssortMstID;
    data['AssortName'] = assortName;
    data['Wt'] = wt;
    data['Rate'] = rate;
    data['Ammount'] = ammount;
    return data;
  }
}
