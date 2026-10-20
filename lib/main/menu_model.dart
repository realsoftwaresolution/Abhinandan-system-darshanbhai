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
  if (name.contains('branch transfer confirm') || form.contains('branchtransferconfirm')) return Icons.check_circle_outline_rounded;
  if (name.contains('branch transfer') || form.contains('branchtransfer')) return Icons.swap_horiz_rounded;
  if (name.contains('stock issue') || form.contains('stockissue')) return Icons.swap_horiz_rounded;
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
  if (name.contains('designation') || form.contains('designation')) return Icons.badge_rounded;
  if (name.contains('report')) return Icons.bar_chart_rounded;

  return Icons.article_rounded;
}
