class DesignationModel {
  int? desiMstID;
  int? desiCode;
  String? desiName;
  String? editDel;
  String? sflag;
  int? sortID;
  int? sortNo;
  bool? active;
  bool? activeRecord;
  int? companyCode;
  String? sdate;
  int? logID;
  String? pcID;
  int? ever;

  DesignationModel({
    this.desiMstID,
    this.desiCode,
    this.desiName,
    this.editDel = 'Y',
    this.sflag = 'Y',
    this.sortID,
    this.sortNo,
    this.active,
    this.activeRecord,
    this.companyCode,
    this.sdate,
    this.logID,
    this.pcID,
    this.ever,
    int? designationCode,
    int? designationMstID,
    String? designationName,
  }) {
    if (desiMstID == null && designationMstID != null) {
      desiMstID = designationMstID;
    }
    if (desiCode == null && designationCode != null) {
      desiCode = designationCode;
    }
    if (desiCode == null && desiMstID != null) {
      desiCode = desiMstID;
    }
    if (desiMstID == null && desiCode != null) {
      desiMstID = desiCode;
    }
    if (desiName == null && designationName != null) {
      desiName = designationName;
    }
    if (sortID == null && sortNo != null) {
      sortID = sortNo;
    }
    if (sortNo == null && sortID != null) {
      sortNo = sortID;
    }
    if (active == null && activeRecord != null) {
      active = activeRecord;
    }
    if (activeRecord == null && active != null) {
      activeRecord = active;
    }
  }

  // Backward compatible aliases
  int? get designationCode => desiCode ?? desiMstID;
  set designationCode(int? value) {
    desiCode = value;
    desiMstID ??= value;
  }

  int? get designationMstID => desiMstID ?? desiCode;
  set designationMstID(int? value) {
    desiMstID = value;
    desiCode ??= value;
  }

  String? get designationName => desiName;
  set designationName(String? value) => desiName = value;

  /// Returns false if EditDel == 'N' (case-insensitive), preventing editing and deleting
  bool get canEditOrDelete {
    final val = (editDel ?? 'Y').toString().toUpperCase().trim();
    return val != 'N';
  }

  DesignationModel.fromJson(Map<String, dynamic> json) {
    desiMstID = int.tryParse(json['DesiMstID']?.toString() ?? '') ??
        json['DesiMstID'] ??
        json['DesignationMstID'] ??
        json['ID'] ??
        json['id'];
    desiCode = int.tryParse(json['DesiCode']?.toString() ?? '') ??
        json['DesiCode'] ??
        json['DesignationCode'] ??
        desiMstID;
    desiMstID ??= desiCode;

    desiName = json['DesiName']?.toString() ??
        json['desiName']?.toString() ??
        json['DesignationName']?.toString() ??
        json['Name']?.toString() ??
        json['name']?.toString() ??
        json['Designation']?.toString();

    editDel = json['EditDel']?.toString().trim() ??
        json['editDel']?.toString().trim() ??
        'Y';
    sflag = json['Sflag']?.toString().trim() ??
        json['sflag']?.toString().trim() ??
        'Y';

    sortID = int.tryParse(json['SortNo']?.toString() ?? '') ??
        int.tryParse(json['SortID']?.toString() ?? '') ??
        json['SortNo'] ??
        json['SortID'] ??
        json['sortID'] ??
        json['sortId'];
    sortNo = sortID;

    active = json['ActiveRecord'] is bool
        ? json['ActiveRecord'] as bool
        : (json['Active'] is bool
            ? json['Active'] as bool
            : (json['active'] is bool ? json['active'] as bool : true));
    activeRecord = active;

    companyCode = int.tryParse(json['CompanyCode']?.toString() ?? '') ??
        json['CompanyCode'] ??
        json['companyCode'];
    sdate = json['Sdate']?.toString() ?? json['sdate']?.toString();
    logID = int.tryParse(json['LogiD']?.toString() ?? '') ??
        int.tryParse(json['LogID']?.toString() ?? '') ??
        json['LogiD'] ??
        json['LogID'] ??
        json['logID'];
    pcID = json['PcID']?.toString() ?? json['pcID']?.toString();
    ever = int.tryParse(json['Ever']?.toString() ?? '') ??
        json['Ever'] ??
        json['ever'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (desiMstID != null) data['DesiMstID'] = desiMstID;
    data['DesiCode'] = desiCode ?? desiMstID;
    data['DesiName'] = desiName;
    data['EditDel'] = editDel ?? 'Y';
    data['Sflag'] = sflag ?? 'Y';
    data['ActiveRecord'] = active;
    data['Active'] = active;
    if (sortID != null) {
      data['SortNo'] = sortID;
      data['SortID'] = sortID;
    }
    if (companyCode != null) data['CompanyCode'] = companyCode;
    if (sdate != null) data['Sdate'] = sdate;
    if (logID != null) data['LogiD'] = logID;
    if (pcID != null) data['PcID'] = pcID;
    if (ever != null) data['Ever'] = ever;
    data['DesignationCode'] = desiCode ?? desiMstID;
    data['DesignationMstID'] = desiMstID ?? desiCode;
    data['DesignationName'] = desiName;
    data['Name'] = desiName;
    return data;
  }
}

typedef DesignationMstModel = DesignationModel;
