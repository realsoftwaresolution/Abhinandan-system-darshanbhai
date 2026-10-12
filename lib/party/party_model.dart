class PartyMstModel {
  int? partyMstID;
  int? partyCode;
  String? partyType;
  String? partyName;
  String? contactPerson;
  String? address;
  String? mobileno;
  String? phNo;
  String? fax;
  String? emailID;
  String? webSite;
  String? panNo;
  String? adharNo;
  String? bankName;
  String? branchName;
  String? bankAdress;
  String? iFSCCode;
  String? bankAcNo;
  String? sflag;
  String? sdate;
  int? logID;
  String? pcID;
  int? ever;
  int? companyCode;
  int? sortID;
  bool? active;
  String? location;
  String? city;
  String? stateCode;
  String? state;
  int? pinCode;
  String? gstNo;
  dynamic cGST;
  dynamic sGST;
  dynamic iGST;
  bool? isDelete;
  int? typeCode;
  dynamic creditOpBalRs;
  dynamic creditOpBalDollar;
  dynamic debitOpBalRs;
  dynamic debitOpBalDollar;
  String? remarks;

  PartyMstModel(
      {this.partyMstID,
        this.partyCode,
        this.partyType,
        this.partyName,
        this.contactPerson,
        this.address,
        this.mobileno,
        this.phNo,
        this.fax,
        this.emailID,
        this.webSite,
        this.panNo,
        this.adharNo,
        this.bankName,
        this.branchName,
        this.bankAdress,
        this.iFSCCode,
        this.bankAcNo,
        this.sflag,
        this.sdate,
        this.logID,
        this.pcID,
        this.ever,
        this.companyCode,
        this.sortID,
        this.active,
        this.location,
        this.city,
        this.stateCode,
        this.state,
        this.pinCode,
        this.gstNo,
        this.cGST,
        this.sGST,
        this.iGST,
        this.isDelete,
        this.typeCode,
        this.creditOpBalRs,
        this.creditOpBalDollar,
        this.debitOpBalRs,
        this.debitOpBalDollar,
        this.remarks});

  PartyMstModel.fromJson(Map<String, dynamic> json) {
    partyMstID = json['PartyMstID'] ?? json['PartyCode'];
    partyCode = json['PartyCode'] ?? json['PartyMstID'];
    partyType = json['PartyType'] ?? json['Type'];
    partyName = json['PartyName'] ?? json['Name'];
    contactPerson = json['ContactPerson'];
    address = json['Address'];
    mobileno = json['Mobileno'] ?? json['MobileNo'];
    phNo = json['PhNo'];
    fax = json['Fax'];
    emailID = json['EmailID'];
    webSite = json['WebSite'];
    panNo = json['PanNo'];
    adharNo = json['AdharNo'];
    bankName = json['BankName'];
    branchName = json['BranchName'];
    bankAdress = json['BankAdress'] ?? json['BankAddress'];
    iFSCCode = json['IFSCCode'];
    bankAcNo = json['BankAcNo'];
    sflag = json['Sflag'];
    sdate = json['Sdate'];
    logID = json['LogID'];
    pcID = json['PcID'];
    ever = json['Ever'];
    companyCode = json['CompanyCode'];
    sortID = json['SortID'];
    active = json['Active'];
    location = json['Location'];
    city = json['City'];
    stateCode = json['StateCode'];
    state = json['State'];
    pinCode = json['PinCode'];
    gstNo = json['GstNo'];
    cGST = json['CGST'];
    sGST = json['SGST'];
    iGST = json['IGST'];
    isDelete = json['IsDelete'];
    typeCode = json['TypeCode'];
    creditOpBalRs = json['CreditOpBalRs'];
    creditOpBalDollar = json['CreditOpBalDollar'];
    debitOpBalRs = json['DebitOpBalRs'];
    debitOpBalDollar = json['DebitOpBalDollar'];
    remarks = json['Remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PartyMstID'] = partyMstID;
    data['PartyCode'] = partyCode ?? partyMstID;
    data['PartyType'] = partyType;
    data['Type'] = partyType;
    data['PartyName'] = partyName;
    data['Name'] = partyName;
    data['ContactPerson'] = contactPerson;
    data['Address'] = address;
    data['Mobileno'] = mobileno;
    data['MobileNo'] = mobileno;
    data['PhNo'] = phNo;
    data['Fax'] = fax;
    data['EmailID'] = emailID;
    data['WebSite'] = webSite;
    data['PanNo'] = panNo;
    data['AdharNo'] = adharNo;
    data['BankName'] = bankName;
    data['BranchName'] = branchName;
    data['BankAdress'] = bankAdress;
    data['BankAddress'] = bankAdress;
    data['IFSCCode'] = iFSCCode;
    data['BankAcNo'] = bankAcNo;
    data['Sflag'] = sflag;
    data['Sdate'] = sdate;
    data['LogID'] = logID;
    data['PcID'] = pcID;
    data['Ever'] = ever;
    data['CompanyCode'] = companyCode;
    data['SortID'] = sortID;
    data['Active'] = active;
    data['Location'] = location;
    data['City'] = city;
    data['StateCode'] = stateCode;
    data['State'] = state;
    data['PinCode'] = pinCode;
    data['GstNo'] = gstNo;
    data['CGST'] = cGST;
    data['SGST'] = sGST;
    data['IGST'] = iGST;
    data['IsDelete'] = isDelete;
    data['TypeCode'] = typeCode;
    data['CreditOpBalRs'] = creditOpBalRs;
    data['CreditOpBalDollar'] = creditOpBalDollar;
    data['DebitOpBalRs'] = debitOpBalRs;
    data['DebitOpBalDollar'] = debitOpBalDollar;
    data['Remarks'] = remarks;
    return data;
  }
}
