/// Models for User Master and its 4 Modules:
/// 1. Basic User Profile & CRUD
/// 2. Menu Rights Matrix
/// 3. Allow Issue (Transfer Screen Mapping)
/// 4. Report Rights

class UserModel {
  int? counterMstId;
  String? loginName;
  String? password;
  String? userName;
  String? userGrp;
  int? branchCode;
  double? stockLimit;
  String? loginTimeFrom;
  String? loginTimeTo;
  dynamic sortId;
  bool? active;
  String? sflag;
  String? sdate;
  dynamic logId;
  dynamic pcId;
  int? ever;

  UserModel({
    this.counterMstId,
    this.loginName,
    this.password,
    this.userName,
    this.userGrp,
    this.branchCode,
    this.stockLimit,
    this.loginTimeFrom,
    this.loginTimeTo,
    this.sortId,
    this.active,
    this.sflag,
    this.sdate,
    this.logId,
    this.pcId,
    this.ever,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    double? parseDouble(dynamic v) {
      if (v == null) return null;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      return double.tryParse(v.toString());
    }

    final int? id = parseInt(json['CounterMstID'] ??
        json['CounterMstId'] ??
        json['userId'] ??
        json['UserId'] ??
        json['ID'] ??
        json['Id'] ??
        json['id']);

    return UserModel(
      counterMstId: id,
      loginName: json['LoginName']?.toString() ??
          json['loginName']?.toString() ??
          json['CrName']?.toString() ??
          json['crName']?.toString(),
      password: json['Password']?.toString() ??
          json['password']?.toString() ??
          json['CrPass']?.toString() ??
          json['crPass']?.toString(),
      userName: json['UserName']?.toString() ??
          json['userName']?.toString() ??
          json['Name']?.toString() ??
          json['name']?.toString(),
      userGrp: json['UserGrp']?.toString() ??
          json['userGrp']?.toString() ??
          json['Role']?.toString() ??
          json['role']?.toString() ??
          'USER',
      branchCode: parseInt(json['BranchCode'] ??
          json['branchCode'] ??
          json['Branchcode']),
      stockLimit: parseDouble(json['StockLimit'] ?? json['stockLimit']),
      loginTimeFrom: json['LoginTimeFrom']?.toString() ??
          json['loginTimeFrom']?.toString(),
      loginTimeTo: json['LoginTimeTo']?.toString() ??
          json['loginTimeTo']?.toString(),
      sortId: json['SortID'] ?? json['SortId'] ?? json['sortId'] ?? json['sortID'],
      active: json['Active'] is bool
          ? json['Active']
          : (json['Active'] == 1 || json['Active'] == '1' || json['Active'] == 'true'),
      sflag: json['Sflag']?.toString() ?? json['sflag']?.toString(),
      sdate: json['Sdate']?.toString() ?? json['sdate']?.toString(),
      logId: json['LogID'] ?? json['logId'] ?? json['LogId'],
      pcId: json['PcId'] ?? json['pcId'] ?? json['PcID'],
      ever: parseInt(json['Ever'] ?? json['ever']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (counterMstId != null) 'CounterMstID': counterMstId,
      if (loginName != null) 'LoginName': loginName,
      if (loginName != null) 'CrName': loginName,
      if (password != null && password!.isNotEmpty) 'Password': password,
      if (userName != null) 'UserName': userName,
      if (userGrp != null) 'UserGrp': userGrp,
      if (branchCode != null) 'BranchCode': branchCode,
      if (stockLimit != null) 'StockLimit': stockLimit,
      if (loginTimeFrom != null && loginTimeFrom!.isNotEmpty)
        'LoginTimeFrom': loginTimeFrom,
      if (loginTimeTo != null && loginTimeTo!.isNotEmpty)
        'LoginTimeTo': loginTimeTo,
      if (sortId != null) 'SortID': sortId,
      'Active': active ?? true,
      if (sflag != null) 'Sflag': sflag,
      if (sdate != null) 'Sdate': sdate,
      if (logId != null) 'LogID': logId,
      if (pcId != null) 'PcId': pcId,
      if (ever != null) 'Ever': ever,
    };
  }
}

/// ==================== MODULE 2: MENU RIGHTS ====================

class UserMenuRightsResponse {
  int? userId;
  String? userName;
  List<UserMenuCategoryModel> categories;

  UserMenuRightsResponse({
    this.userId,
    this.userName,
    this.categories = const [],
  });

  factory UserMenuRightsResponse.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    List<UserMenuCategoryModel> catList = [];
    if (json['categories'] is List) {
      catList = (json['categories'] as List)
          .map((c) => UserMenuCategoryModel.fromJson(c as Map<String, dynamic>))
          .toList();
    } else if (json['data'] is Map && json['data']['categories'] is List) {
      catList = (json['data']['categories'] as List)
          .map((c) => UserMenuCategoryModel.fromJson(c as Map<String, dynamic>))
          .toList();
    }

    return UserMenuRightsResponse(
      userId: parseInt(json['userId'] ?? json['UserId']),
      userName: json['userName']?.toString() ?? json['UserName']?.toString(),
      categories: catList,
    );
  }
}

class UserMenuCategoryModel {
  int? mainMenuMstId;
  String? mainMenuName;
  List<UserMenuItemRightModel> menus;

  UserMenuCategoryModel({
    this.mainMenuMstId,
    this.mainMenuName,
    this.menus = const [],
  });

  factory UserMenuCategoryModel.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    List<UserMenuItemRightModel> menuList = [];
    if (json['menus'] is List) {
      menuList = (json['menus'] as List)
          .map((m) => UserMenuItemRightModel.fromJson(
                m as Map<String, dynamic>,
                parentMainMenuId: parseInt(json['MainMenuMstID'] ?? json['mainMenuMstId']),
              ))
          .toList();
    }

    return UserMenuCategoryModel(
      mainMenuMstId: parseInt(json['MainMenuMstID'] ?? json['mainMenuMstId']),
      mainMenuName: json['MainMenuName']?.toString() ??
          json['mainMenuName']?.toString() ??
          'GENERAL',
      menus: menuList,
    );
  }
}

class UserMenuItemRightModel {
  int? mainMenuMstId;
  int? menuMstId;
  String? menuName;
  bool canView;
  bool canAdd;
  bool canEdit;
  bool canDel;
  bool isHide;

  UserMenuItemRightModel({
    this.mainMenuMstId,
    this.menuMstId,
    this.menuName,
    this.canView = false,
    this.canAdd = false,
    this.canEdit = false,
    this.canDel = false,
    this.isHide = false,
  });

  factory UserMenuItemRightModel.fromJson(
    Map<String, dynamic> json, {
    int? parentMainMenuId,
  }) {
    int? parseInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    bool parseBool(dynamic v) {
      if (v == null) return false;
      if (v is bool) return v;
      final str = v.toString().trim().toLowerCase();
      return v == 1 || str == '1' || str == 'true' || str == 'yes';
    }

    final bool isHideVal = parseBool(
      json['IsHide'] ??
      json['isHide'] ??
      json['Hide'] ??
      json['hide'] ??
      json['IsHidden'] ??
      json['isHidden']
    );

    return UserMenuItemRightModel(
      mainMenuMstId: parseInt(json['MainMenuMstID'] ?? json['mainMenuMstId']) ??
          parentMainMenuId,
      menuMstId: parseInt(json['MenuMstID'] ?? json['menuMstId']),
      menuName: json['MenuName']?.toString() ?? json['menuName']?.toString() ?? '',
      canView: isHideVal ? false : parseBool(json['CanView'] ?? json['canView']),
      canAdd: isHideVal ? false : parseBool(json['CanAdd'] ?? json['canAdd']),
      canEdit: isHideVal ? false : parseBool(json['CanEdit'] ?? json['canEdit']),
      canDel: isHideVal ? false : parseBool(json['CanDel'] ?? json['canDel']),
      isHide: isHideVal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (mainMenuMstId != null) 'MainMenuMstID': mainMenuMstId,
      if (menuMstId != null) 'MenuMstID': menuMstId,
      'CanView': isHide ? false : canView,
      'CanAdd': isHide ? false : canAdd,
      'CanEdit': isHide ? false : canEdit,
      'CanDel': isHide ? false : canDel,
      'IsHide': isHide,
    };
  }
}

typedef MenuRightItem = UserMenuItemRightModel;

/// ==================== MODULE 3: ALLOW ISSUE ====================

class AllowIssueResponse {
  int? fromUserId;
  String? fromUserName;
  List<AllowIssueUserModel> users;

  AllowIssueResponse({
    this.fromUserId,
    this.fromUserName,
    this.users = const [],
  });

  factory AllowIssueResponse.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    List<AllowIssueUserModel> userList = [];
    if (json['users'] is List) {
      userList = (json['users'] as List)
          .map((u) => AllowIssueUserModel.fromJson(u as Map<String, dynamic>))
          .toList();
    } else if (json['data'] is Map && json['data']['users'] is List) {
      userList = (json['data']['users'] as List)
          .map((u) => AllowIssueUserModel.fromJson(u as Map<String, dynamic>))
          .toList();
    }

    return AllowIssueResponse(
      fromUserId: parseInt(json['fromUserId'] ?? json['FromUserId']),
      fromUserName: json['fromUserName']?.toString() ??
          json['FromUserName']?.toString(),
      users: userList,
    );
  }
}

class AllowIssueUserModel {
  int? userId;
  String? loginName;
  String? userName;
  int? branchCode;
  bool isAllowed;

  AllowIssueUserModel({
    this.userId,
    this.loginName,
    this.userName,
    this.branchCode,
    this.isAllowed = false,
  });

  factory AllowIssueUserModel.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    bool parseBool(dynamic v) {
      if (v == null) return false;
      if (v is bool) return v;
      return v == 1 || v == '1' || v == 'true';
    }

    return AllowIssueUserModel(
      userId: parseInt(json['userId'] ??
          json['UserId'] ??
          json['CounterMstID'] ??
          json['counterMstId']),
      loginName: json['loginName']?.toString() ??
          json['LoginName']?.toString() ??
          json['CrName']?.toString() ??
          json['crName']?.toString(),
      userName: json['userName']?.toString() ??
          json['UserName']?.toString() ??
          json['Name']?.toString(),
      branchCode: parseInt(json['branchCode'] ?? json['BranchCode']),
      isAllowed: parseBool(json['isAllowed'] ?? json['IsAllowed']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'loginName': loginName,
      'userName': userName,
      'branchCode': branchCode,
      'isAllowed': isAllowed,
    };
  }
}

/// ==================== MODULE 4: REPORT RIGHTS ====================

class UserReportRightsResponse {
  int? userId;
  String? userName;
  List<UserReportRightModel> reports;

  UserReportRightsResponse({
    this.userId,
    this.userName,
    this.reports = const [],
  });

  factory UserReportRightsResponse.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    List<UserReportRightModel> reportList = [];
    if (json['reports'] is List) {
      reportList = (json['reports'] as List)
          .map((r) => UserReportRightModel.fromJson(r as Map<String, dynamic>))
          .toList();
    } else if (json['data'] is Map && json['data']['reports'] is List) {
      reportList = (json['data']['reports'] as List)
          .map((r) => UserReportRightModel.fromJson(r as Map<String, dynamic>))
          .toList();
    }

    return UserReportRightsResponse(
      userId: parseInt(json['userId'] ?? json['UserId']),
      userName: json['userName']?.toString() ?? json['UserName']?.toString(),
      reports: reportList,
    );
  }
}

class UserReportRightModel {
  int? reportCode;
  String? reportName;
  String? reportHeading;
  dynamic sortId;
  bool isAllowed;

  UserReportRightModel({
    this.reportCode,
    this.reportName,
    this.reportHeading,
    this.sortId,
    this.isAllowed = false,
  });

  factory UserReportRightModel.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    bool parseBool(dynamic v) {
      if (v == null) return false;
      if (v is bool) return v;
      return v == 1 || v == '1' || v == 'true';
    }

    return UserReportRightModel(
      reportCode: parseInt(json['ReportCode'] ??
          json['reportCode'] ??
          json['Code'] ??
          json['code']),
      reportName: json['ReportName']?.toString() ??
          json['reportName']?.toString() ??
          json['Name']?.toString(),
      reportHeading: json['ReportHeading']?.toString() ??
          json['reportHeading']?.toString() ??
          json['Heading']?.toString(),
      sortId: json['SortID'] ?? json['SortId'] ?? json['sortId'],
      isAllowed: parseBool(json['isAllowed'] ?? json['IsAllowed']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ReportCode': reportCode,
      'ReportName': reportName,
      'ReportHeading': reportHeading,
      'SortID': sortId,
      'isAllowed': isAllowed,
    };
  }
}
