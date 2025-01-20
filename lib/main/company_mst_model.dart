class CompanyMst {
  int? companyMstID;
  int? companyCode;
  String? companyName;
  String? address;
  String? mobileno;
  String? emailID;
  String? phone;
  String? fax;
  String? webSite;
  String? gstNo;
  String? cstNo;
  String? tinNo;
  String? bankName;
  String? branchName;
  String? bankAddress;
  String? iFSCCode;
  String? bankAcNo;
  String? fromYear;
  String? toYear;
  String? sflag;
  String? sdate;
  int? logID;
  String? pcID;
  int? ever;
  int? sortID;
  bool? active;
  String? invCode;
  String? qBCCODE;
  String? stateCode;
  String? iecNo;
  String? lutNo;
  String? panNo;
  String? coBank;
  String? coAdd;
  String? remarks;
  String? forCredit1;
  String? forCredit2;
  String? benificiaryName;
  String? city;
  int? pinCode;
  String? state;
  // Null? logo;
  String? adCode;
  String? insurance;
  bool? isDelete;
  int? partyCode;

  CompanyMst(
      {this.companyMstID,
        this.companyCode,
        this.companyName,
        this.address,
        this.mobileno,
        this.emailID,
        this.phone,
        this.fax,
        this.webSite,
        this.gstNo,
        this.cstNo,
        this.tinNo,
        this.bankName,
        this.branchName,
        this.bankAddress,
        this.iFSCCode,
        this.bankAcNo,
        this.fromYear,
        this.toYear,
        this.sflag,
        this.sdate,
        this.logID,
        this.pcID,
        this.ever,
        this.sortID,
        this.active,
        this.invCode,
        this.qBCCODE,
        this.stateCode,
        this.iecNo,
        this.lutNo,
        this.panNo,
        this.coBank,
        this.coAdd,
        this.remarks,
        this.forCredit1,
        this.forCredit2,
        this.benificiaryName,
        this.city,
        this.pinCode,
        this.state,
        // this.logo,
        this.adCode,
        this.insurance,
        this.isDelete,
        this.partyCode});

  CompanyMst.fromJson(Map<String, dynamic> json) {
    companyMstID = json['CompanyMstID'];
    companyCode = json['CompanyCode'];
    companyName = json['CompanyName'];
    address = json['Address'];
    mobileno = json['Mobileno'];
    emailID = json['EmailID'];
    phone = json['Phone'];
    fax = json['Fax'];
    webSite = json['WebSite'];
    gstNo = json['GstNo'];
    cstNo = json['CstNo'];
    tinNo = json['TinNo'];
    bankName = json['BankName'];
    branchName = json['BranchName'];
    bankAddress = json['BankAddress'];
    iFSCCode = json['IFSCCode'];
    bankAcNo = json['BankAcNo'];
    fromYear = json['FromYear'];
    toYear = json['ToYear'];
    sflag = json['Sflag'];
    sdate = json['Sdate'];
    logID = json['LogID'];
    pcID = json['PcID'];
    ever = json['Ever'];
    sortID = json['SortID'];
    active = json['Active'];
    invCode = json['InvCode'];
    qBCCODE = json['QBCCODE'];
    stateCode = json['StateCode'];
    iecNo = json['IecNo'];
    lutNo = json['LutNo'];
    panNo = json['PanNo'];
    coBank = json['CoBank'];
    coAdd = json['CoAdd'];
    remarks = json['Remarks'];
    forCredit1 = json['ForCredit1'];
    forCredit2 = json['ForCredit2'];
    benificiaryName = json['BenificiaryName'];
    city = json['City'];
    pinCode = json['PinCode'];
    state = json['State'];
    // logo = json['Logo'];
    adCode = json['AdCode'];
    insurance = json['Insurance'];
    isDelete = json['IsDelete'];
    partyCode = json['PartyCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CompanyMstID'] = companyMstID;
    data['CompanyCode'] = companyCode;
    data['CompanyName'] = companyName;
    data['Address'] = address;
    data['Mobileno'] = mobileno;
    data['EmailID'] = emailID;
    data['Phone'] = phone;
    data['Fax'] = fax;
    data['WebSite'] = webSite;
    data['GstNo'] = gstNo;
    data['CstNo'] = cstNo;
    data['TinNo'] = tinNo;
    data['BankName'] = bankName;
    data['BranchName'] = branchName;
    data['BankAddress'] = bankAddress;
    data['IFSCCode'] = iFSCCode;
    data['BankAcNo'] = bankAcNo;
    data['FromYear'] = fromYear;
    data['ToYear'] = toYear;
    data['Sflag'] = sflag;
    data['Sdate'] = sdate;
    data['LogID'] = logID;
    data['PcID'] = pcID;
    data['Ever'] = ever;
    data['SortID'] = sortID;
    data['Active'] = active;
    data['InvCode'] = invCode;
    data['QBCCODE'] = qBCCODE;
    data['StateCode'] = stateCode;
    data['IecNo'] = iecNo;
    data['LutNo'] = lutNo;
    data['PanNo'] = panNo;
    data['CoBank'] = coBank;
    data['CoAdd'] = coAdd;
    data['Remarks'] = remarks;
    data['ForCredit1'] = forCredit1;
    data['ForCredit2'] = forCredit2;
    data['BenificiaryName'] = benificiaryName;
    data['City'] = city;
    data['PinCode'] = pinCode;
    data['State'] = state;
    // data['Logo'] = this.logo;
    data['AdCode'] = adCode;
    data['Insurance'] = insurance;
    data['IsDelete'] = isDelete;
    data['PartyCode'] = partyCode;
    return data;
  }
}
