import 'package:flutter/material.dart';

class MainMenuModel {
  final int? mainMenuMstID;
  final int? mainMenuSrno;
  final String? mainMenuName;
  final int? valid;
  final String? mainMenuImageName;
  final String? mainMenuImage;
  final List<SubMenuModel> subMenus;

  MainMenuModel({
    this.mainMenuMstID,
    this.mainMenuSrno,
    this.mainMenuName,
    this.valid,
    this.mainMenuImageName,
    this.mainMenuImage,
    this.subMenus = const [],
  });

  factory MainMenuModel.fromJson(Map<String, dynamic> json) {
    var subMenusList = <SubMenuModel>[];
    if (json['subMenus'] != null && json['subMenus'] is List) {
      subMenusList = (json['subMenus'] as List)
          .map((e) => SubMenuModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return MainMenuModel(
      mainMenuMstID: json['MainMenuMstID'] as int?,
      mainMenuSrno: json['MainMenuSrno'] as int?,
      mainMenuName: json['MainMenuName'] as String?,
      valid: json['Valid'] is int
          ? json['Valid'] as int
          : (json['Valid'] == true ? 1 : 0),
      mainMenuImageName: json['MainMenuImageName'] as String?,
      mainMenuImage: json['MainMenuImage'] as String?,
      subMenus: subMenusList,
    );
  }

  Map<String, dynamic> toJson() => {
        'MainMenuMstID': mainMenuMstID,
        'MainMenuSrno': mainMenuSrno,
        'MainMenuName': mainMenuName,
        'Valid': valid,
        'MainMenuImageName': mainMenuImageName,
        'MainMenuImage': mainMenuImage,
        'subMenus': subMenus.map((e) => e.toJson()).toList(),
      };
}

class SubMenuModel {
  final int? menuSrno;
  final String? menuName;
  final int? menuMstID;
  final int? mainMenuMstID;
  final int? valid;
  final String? formName;
  final String? menuImageName;
  final String? menuImage;
  final dynamic mainGroupMstID;
  final int? imageSize;
  final int? sortID;
  final String? dashBoard;

  SubMenuModel({
    this.menuSrno,
    this.menuName,
    this.menuMstID,
    this.mainMenuMstID,
    this.valid,
    this.formName,
    this.menuImageName,
    this.menuImage,
    this.mainGroupMstID,
    this.imageSize,
    this.sortID,
    this.dashBoard,
  });

  factory SubMenuModel.fromJson(Map<String, dynamic> json) {
    return SubMenuModel(
      menuSrno: json['MenuSrno'] as int?,
      menuName: json['MenuName'] as String?,
      menuMstID: json['MenuMstID'] as int?,
      mainMenuMstID: json['MainMenuMstID'] as int?,
      valid: json['Valid'] is int
          ? json['Valid'] as int
          : (json['Valid'] == true ? 1 : 0),
      formName: json['FormName'] as String?,
      menuImageName: json['MenuImageName'] as String?,
      menuImage: json['MenuImage'] as String?,
      mainGroupMstID: json['MainGroupMstID'],
      imageSize: json['ImageSize'] as int?,
      sortID: json['SortID'] as int?,
      dashBoard: json['DashBoard'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'MenuSrno': menuSrno,
        'MenuName': menuName,
        'MenuMstID': menuMstID,
        'MainMenuMstID': mainMenuMstID,
        'Valid': valid,
        'FormName': formName,
        'MenuImageName': menuImageName,
        'MenuImage': menuImage,
        'MainGroupMstID': mainGroupMstID,
        'ImageSize': imageSize,
        'SortID': sortID,
        'DashBoard': dashBoard,
      };
}

/// Helper function to get an icon based on MainMenuName
IconData getMainMenuIcon(String? name) {
  final upper = (name ?? '').toUpperCase().trim();
  switch (upper) {
    case 'MASTER':
      return Icons.folder_special_rounded;
    case 'TRANSACTION':
      return Icons.sync_alt_rounded;
    case 'REPORT':
      return Icons.bar_chart_rounded;
    case 'UTILITY':
      return Icons.build_circle_rounded;
    case 'LOGOUT':
      return Icons.logout_rounded;
    case 'EXIT':
      return Icons.exit_to_app_rounded;
    default:
      return Icons.category_rounded;
  }
}

/// Helper function to get an icon based on MenuName or FormName
IconData getSubMenuIcon(String? menuName, {String? formName}) {
  final name = (menuName ?? '').toLowerCase().trim();
  final form = (formName ?? '').toLowerCase().trim();

  if (name.contains('party ledger')) return Icons.account_balance_rounded;
  if (name.contains('party') || form.contains('party')) return Icons.people_alt_rounded;
  if (name.contains('rough purchase') || form.contains('roughpurchase')) return Icons.shopping_bag_rounded;
  if (name.contains('polish purchase') || form.contains('polishpurchase')) return Icons.shopping_cart_rounded;
  if (name.contains('purchase')) return Icons.shopping_bag_rounded;
  if (name.contains('polish sale') || form.contains('polishsale')) return Icons.sell_rounded;
  if (name.contains('sale')) return Icons.sell_rounded;
  if (name.contains('memo issue') || form.contains('memoissue')) return Icons.assignment_turned_in_rounded;
  if (name.contains('memo return') || name.contains('memo rec') || form.contains('memoreturn') || form.contains('memorec')) {
    return Icons.assignment_return_rounded;
  }
  if (name.contains('stock issue') || form.contains('stockissue')) return Icons.outbox_rounded;
  if (name.contains('stock confirm') || form.contains('stockconfirm')) return Icons.check_circle_outline_rounded;
  if (name.contains('payment') || form.contains('payment')) return Icons.payment_rounded;
  if (name.contains('import') || form.contains('import')) return Icons.file_upload_outlined;
  if (name.contains('rough assort') || form.contains('roughassort')) return Icons.category_rounded;
  if (name.contains('assort') || form.contains('assort')) return Icons.sort_rounded;
  if (name.contains('rough type') || form.contains('roughtype')) return Icons.diamond_outlined;
  if (name.contains('quality') || form.contains('quality')) return Icons.verified_rounded;
  if (name.contains('charni') || form.contains('charni')) return Icons.filter_vintage_rounded;
  if (name.contains('clarity') || form.contains('clarity')) return Icons.visibility_rounded;
  if (name.contains('color') || form.contains('color')) return Icons.palette_rounded;
  if (name.contains('shape') || form.contains('shape')) return Icons.crop_square_rounded;
  if (name.contains('acc type') || form.contains('acctype')) return Icons.account_balance_wallet_rounded;
  if (name.contains('expense group') || form.contains('expensegroup')) return Icons.folder_shared_rounded;
  if (name.contains('expense') || form.contains('expense')) return Icons.receipt_long_rounded;
  if (name.contains('company') || form.contains('company')) return Icons.business_rounded;
  if (name.contains('user') || form.contains('user')) return Icons.manage_accounts_rounded;
  if (name.contains('branch') || form.contains('branch')) return Icons.domain_rounded;
  if (name.contains('polish type') || form.contains('polishtype')) return Icons.auto_awesome_rounded;
  if (name.contains('report')) return Icons.bar_chart_rounded;

  return Icons.article_rounded;
}

/// Fallback default menu items matching the API response specification
final List<Map<String, dynamic>> defaultMenuListJson = [
  {
    "MainMenuMstID": 1,
    "MainMenuSrno": 1,
    "MainMenuName": "MASTER",
    "Valid": 1,
    "MainMenuImageName": null,
    "MainMenuImage": null,
    "subMenus": [
      {
        "MenuSrno": 4124,
        "MenuName": "Party",
        "MenuMstID": 1,
        "MainMenuMstID": 1,
        "Valid": 1,
        "FormName": "FrmPartyForm",
        "MenuImageName": null,
        "MenuImage": null,
        "MainGroupMstID": null,
        "ImageSize": 1,
        "SortID": 1,
        "DashBoard": "CLICK"
      },
      {
        "MenuSrno": 7142,
        "MenuName": "Rough Type",
        "MenuMstID": 2,
        "MainMenuMstID": 1,
        "Valid": 1,
        "FormName": "FrmRoughTypeForm",
        "MenuImageName": null,
        "MenuImage": null,
        "MainGroupMstID": null,
        "ImageSize": 1,
        "SortID": 2,
        "DashBoard": "CLICK"
      },
      {
        "MenuSrno": 7143,
        "MenuName": "Quality",
        "MenuMstID": 3,
        "MainMenuMstID": 1,
        "Valid": 1,
        "FormName": "FrmQualityForm",
        "MenuImageName": null,
        "MenuImage": null,
        "MainGroupMstID": null,
        "ImageSize": 1,
        "SortID": 3,
        "DashBoard": "CLICK"
      },
      {
        "MenuSrno": 7144,
        "MenuName": "Charni",
        "MenuMstID": 4,
        "MainMenuMstID": 1,
        "Valid": 1,
        "FormName": "FrmCharniForm",
        "MenuImageName": null,
        "MenuImage": null,
        "MainGroupMstID": null,
        "ImageSize": 1,
        "SortID": 4,
        "DashBoard": "CLICK"
      },
      {
        "MenuSrno": 7145,
        "MenuName": "Clarity",
        "MenuMstID": 5,
        "MainMenuMstID": 1,
        "Valid": 1,
        "FormName": "FrmClarityForm",
        "MenuImageName": null,
        "MenuImage": null,
        "MainGroupMstID": null,
        "ImageSize": 1,
        "SortID": 5,
        "DashBoard": "CLICK"
      },
      {
        "MenuSrno": 7146,
        "MenuName": "Color",
        "MenuMstID": 6,
        "MainMenuMstID": 1,
        "Valid": 1,
        "FormName": "FrmColorForm",
        "MenuImageName": null,
        "MenuImage": null,
        "MainGroupMstID": null,
        "ImageSize": 1,
        "SortID": 6,
        "DashBoard": "CLICK"
      },
      {
        "MenuSrno": 7147,
        "MenuName": "Shape",
        "MenuMstID": 7,
        "MainMenuMstID": 1,
        "Valid": 1,
        "FormName": "FrmShapeForm",
        "MenuImageName": null,
        "MenuImage": null,
        "MainGroupMstID": null,
        "ImageSize": 1,
        "SortID": 7,
        "DashBoard": "CLICK"
      },
      {
        "MenuSrno": 7148,
        "MenuName": "Acc Type",
        "MenuMstID": 8,
        "MainMenuMstID": 1,
        "Valid": 1,
        "FormName": "FrmAccType",
        "MenuImageName": null,
        "MenuImage": null,
        "MainGroupMstID": null,
        "ImageSize": 1,
        "SortID": 8,
        "DashBoard": "CLICK"
      },
      {
        "MenuSrno": 7149,
        "MenuName": "Expense",
        "MenuMstID": 9,
        "MainMenuMstID": 1,
        "Valid": 1,
        "FormName": "FrmExpenseForm",
        "MenuImageName": null,
        "MenuImage": null,
        "MainGroupMstID": null,
        "ImageSize": 1,
        "SortID": 9,
        "DashBoard": "CLICK"
      },
      {
        "MenuSrno": 7150,
        "MenuName": "Expense Group",
        "MenuMstID": 10,
        "MainMenuMstID": 1,
        "Valid": 1,
        "FormName": "FrmExpenseGroupForm",
        "MenuImageName": null,
        "MenuImage": null,
        "MainGroupMstID": null,
        "ImageSize": 1,
        "SortID": 10,
        "DashBoard": "CLICK"
      },
      {
        "MenuSrno": 7151,
        "MenuName": "Company",
        "MenuMstID": 11,
        "MainMenuMstID": 1,
        "Valid": 1,
        "FormName": "FrmCompanyForm",
        "MenuImageName": null,
        "MenuImage": null,
        "MainGroupMstID": null,
        "ImageSize": 1,
        "SortID": 11,
        "DashBoard": "CLICK"
      },
      {
        "MenuSrno": 7152,
        "MenuName": "User",
        "MenuMstID": 12,
        "MainMenuMstID": 1,
        "Valid": 1,
        "FormName": "FrmUserForm",
        "MenuImageName": null,
        "MenuImage": null,
        "MainGroupMstID": null,
        "ImageSize": 1,
        "SortID": 12,
        "DashBoard": "CLICK"
      },
      {
        "MenuSrno": 7153,
        "MenuName": "Branch",
        "MenuMstID": 13,
        "MainMenuMstID": 1,
        "Valid": 1,
        "FormName": "FrmBranchForm",
        "MenuImageName": null,
        "MenuImage": null,
        "MainGroupMstID": null,
        "ImageSize": 1,
        "SortID": 13,
        "DashBoard": "CLICK"
      },
      {
        "MenuSrno": 7154,
        "MenuName": "Polish Type",
        "MenuMstID": 14,
        "MainMenuMstID": 1,
        "Valid": 1,
        "FormName": "FrmPolishType",
        "MenuImageName": null,
        "MenuImage": null,
        "MainGroupMstID": null,
        "ImageSize": 1,
        "SortID": 14,
        "DashBoard": "CLICK"
      }
    ]
  },
  {
    "MainMenuMstID": 2,
    "MainMenuSrno": 2,
    "MainMenuName": "TRANSACTION",
    "Valid": 1,
    "MainMenuImageName": null,
    "MainMenuImage": null,
    "subMenus": [
      {
        "MenuSrno": 7155,
        "MenuName": "Rough Purchase",
        "MenuMstID": 15,
        "MainMenuMstID": 2,
        "Valid": 1,
        "FormName": "FrmRoughPurchaseForm",
        "MenuImageName": null,
        "MenuImage": null,
        "MainGroupMstID": null,
        "ImageSize": 1,
        "SortID": 15,
        "DashBoard": "CLICK"
      },
      {
        "MenuSrno": 7156,
        "MenuName": "Polish Purchase",
        "MenuMstID": 16,
        "MainMenuMstID": 2,
        "Valid": 1,
        "FormName": "FrmPolishPurchaseForm",
        "MenuImageName": null,
        "MenuImage": null,
        "MainGroupMstID": null,
        "ImageSize": 1,
        "SortID": 16,
        "DashBoard": "CLICK"
      },
      {
        "MenuSrno": 7157,
        "MenuName": "Stock Issue",
        "MenuMstID": 17,
        "MainMenuMstID": 2,
        "Valid": 1,
        "FormName": "FrmStockIssueForm",
        "MenuImageName": null,
        "MenuImage": null,
        "MainGroupMstID": null,
        "ImageSize": 1,
        "SortID": 17,
        "DashBoard": "CLICK"
      },
      {
        "MenuSrno": 7158,
        "MenuName": "Stock Confirm",
        "MenuMstID": 18,
        "MainMenuMstID": 2,
        "Valid": 1,
        "FormName": "FrmStockConfirmForm",
        "MenuImageName": null,
        "MenuImage": null,
        "MainGroupMstID": null,
        "ImageSize": 1,
        "SortID": 18,
        "DashBoard": "CLICK"
      },
      {
        "MenuSrno": 7159,
        "MenuName": "Memo Issue",
        "MenuMstID": 19,
        "MainMenuMstID": 2,
        "Valid": 1,
        "FormName": "FrmMemoIssueForm",
        "MenuImageName": null,
        "MenuImage": null,
        "MainGroupMstID": null,
        "ImageSize": 1,
        "SortID": 19,
        "DashBoard": "CLICK"
      },
      {
        "MenuSrno": 7160,
        "MenuName": "Memo Return",
        "MenuMstID": 20,
        "MainMenuMstID": 2,
        "Valid": 1,
        "FormName": "FrmMemoReturnForm",
        "MenuImageName": null,
        "MenuImage": null,
        "MainGroupMstID": null,
        "ImageSize": 1,
        "SortID": 20,
        "DashBoard": "CLICK"
      },
      {
        "MenuSrno": 7161,
        "MenuName": "Polish Sale",
        "MenuMstID": 21,
        "MainMenuMstID": 2,
        "Valid": 1,
        "FormName": "FrmPolishSale",
        "MenuImageName": null,
        "MenuImage": null,
        "MainGroupMstID": null,
        "ImageSize": 1,
        "SortID": 21,
        "DashBoard": "CLICK"
      },
      {
        "MenuSrno": 7162,
        "MenuName": "Payment",
        "MenuMstID": 22,
        "MainMenuMstID": 2,
        "Valid": 1,
        "FormName": "FrmPaymentForm",
        "MenuImageName": null,
        "MenuImage": null,
        "MainGroupMstID": null,
        "ImageSize": 1,
        "SortID": 22,
        "DashBoard": "CLICK"
      },
      {
        "MenuSrno": 7163,
        "MenuName": "Import",
        "MenuMstID": 23,
        "MainMenuMstID": 2,
        "Valid": 1,
        "FormName": "FrmImportForm",
        "MenuImageName": null,
        "MenuImage": null,
        "MainGroupMstID": null,
        "ImageSize": 1,
        "SortID": 23,
        "DashBoard": "CLICK"
      }
    ]
  },
  {
    "MainMenuMstID": 3,
    "MainMenuSrno": 3,
    "MainMenuName": "REPORT",
    "Valid": 1,
    "MainMenuImageName": null,
    "MainMenuImage": null,
    "subMenus": []
  },
  {
    "MainMenuMstID": 4,
    "MainMenuSrno": 5,
    "MainMenuName": "UTILITY",
    "Valid": 1,
    "MainMenuImageName": null,
    "MainMenuImage": null,
    "subMenus": []
  },
  {
    "MainMenuMstID": 5,
    "MainMenuSrno": 6,
    "MainMenuName": "LOGOUT",
    "Valid": 1,
    "MainMenuImageName": null,
    "MainMenuImage": null,
    "subMenus": []
  },
  {
    "MainMenuMstID": 6,
    "MainMenuSrno": 6,
    "MainMenuName": "EXIT",
    "Valid": 1,
    "MainMenuImageName": null,
    "MainMenuImage": null,
    "subMenus": []
  }
];
