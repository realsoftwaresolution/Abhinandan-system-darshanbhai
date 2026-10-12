class ShapeModel {
  int? shapeMstId;
  int? shapeCode;
  String? shapeName;
  String? repCode;
  int? companyCode;
  int? sortID;
  bool? active;
  String? sDate;
  String? sflag;

  ShapeModel({
    this.shapeMstId,
    this.shapeCode,
    this.shapeName,
    this.repCode,
    this.companyCode,
    this.sortID,
    this.active,
    this.sDate,
    this.sflag,
  });

  ShapeModel.fromJson(Map<String, dynamic> json) {
    shapeMstId = json['ShapeMstId'] ?? json['ShapeMstID'] ?? json['ShapeCode'] ?? json['ID'];
    shapeCode = json['ShapeCode'] ?? json['ShapeMstId'] ?? json['ShapeMstID'];
    shapeName = json['ShapeName'] ?? json['Name'];
    repCode = json['RepCode'] ?? json['Repcode'] ?? json['repCode'];
    companyCode = json['CompanyCode'];
    sortID = json['SortID'];
    active = json['Active'];
    sDate = json['SDate'] ?? json['Sdate'];
    sflag = json['Sflag'] ?? json['SFlag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ShapeMstId'] = shapeMstId;
    data['ShapeCode'] = shapeCode ?? shapeMstId;
    data['ShapeName'] = shapeName;
    data['Name'] = shapeName;
    data['RepCode'] = repCode;
    data['CompanyCode'] = companyCode;
    data['SortID'] = sortID;
    data['Active'] = active;
    data['SDate'] = sDate;
    data['Sflag'] = sflag;
    return data;
  }
}

typedef ShapeMstModel = ShapeModel;
