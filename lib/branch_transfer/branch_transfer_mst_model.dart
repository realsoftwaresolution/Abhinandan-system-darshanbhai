import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:real_web_rough_entry_system/branch_transfer/branch_transfer_item_model.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';

/// Represents a Branch Transfer Master record matching Sequelize BranchTransferMst model
class BranchTransferMstModel {
  final int? branchTransferMstID;
  final int? companyCode;
  final int? fromCrId;
  final int? toCrId;
  final String? transferDate;
  final int? totalItems;
  final int? totalStockPc;
  final double? totalStockWt;
  final double? totalRateDollar;
  final double? totalRateRs;
  final double? totalAmtDollar;
  final double? totalAmtRs;
  final int? totalIssuePc;
  final double? totalIssueWt;
  final double? totalIssueRate;
  final double? totalIssueAmt;
  final double? totalDiffWt;
  final double? totalDiffRate;
  final double? totalDiffAmt;
  final List<BranchTransferItemModel> items;

  BranchTransferMstModel({
    this.branchTransferMstID,
    this.companyCode,
    this.fromCrId,
    this.toCrId,
    this.transferDate,
    this.totalItems,
    this.totalStockPc,
    this.totalStockWt,
    this.totalRateDollar,
    this.totalRateRs,
    this.totalAmtDollar,
    this.totalAmtRs,
    this.totalIssuePc,
    this.totalIssueWt,
    this.totalIssueRate,
    this.totalIssueAmt,
    this.totalDiffWt,
    this.totalDiffRate,
    this.totalDiffAmt,
    this.items = const [],
  });

  /// Name of From Manager resolved from DefaultController's userModelList
  String get fromManagerName {
    if (fromCrId == null) return '-';
    if (Get.isRegistered<DefaultController>()) {
      final ctrl = Get.find<DefaultController>();
      final u = ctrl.userModelList.firstWhereOrNull(
        (user) => user.counterMstId == fromCrId,
      );
      if (u != null) return u.userName ?? 'Manager #$fromCrId';
    }
    return 'Manager #$fromCrId';
  }

  /// Name of To Manager resolved from DefaultController's userModelList
  String get toManagerName {
    if (toCrId == null) return '-';
    if (Get.isRegistered<DefaultController>()) {
      final ctrl = Get.find<DefaultController>();
      final u = ctrl.userModelList.firstWhereOrNull(
        (user) => user.counterMstId == toCrId,
      );
      if (u != null) return u.userName ?? 'Manager #$toCrId';
    }
    return 'Manager #$toCrId';
  }

  /// Formatted date string for UI display (dd-MM-yyyy)
  String get displayDate {
    if (transferDate == null || transferDate!.isEmpty) return '-';
    try {
      final dt = DateTime.tryParse(transferDate!);
      if (dt != null) {
        return DateFormat('dd-MM-yyyy').format(dt);
      }
      if (transferDate!.contains('-') &&
          transferDate!.split('-').first.length == 4) {
        final parts = transferDate!.split('-');
        return '${parts[2]}-${parts[1]}-${parts[0]}';
      }
    } catch (_) {}
    return transferDate!;
  }

  factory BranchTransferMstModel.fromJson(Map<String, dynamic> json) {
    double parseD(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    int parseI(dynamic val) {
      if (val == null) return 0;
      if (val is num) return val.toInt();
      return int.tryParse(val.toString()) ?? 0;
    }

    final id = json['BranchTransferMstID'] ??
        json['branchTransferMstID'] ??
        json['id'] ??
        json['Id'] ??
        json['BranchTransferMstId'];

    final rawDate = (json['TransferDate'] ??
            json['transferDate'] ??
            json['Date'] ??
            json['date'])
        ?.toString();

    final rawItems = json['items'] ??
        json['BranchTransferDets'] ??
        json['branchTransferDets'] ??
        json['details'] ??
        json['itemsList'] ??
        json['BranchTransferDet'];

    List<BranchTransferItemModel> parsedItems = [];
    if (rawItems is List) {
      parsedItems = rawItems
          .whereType<Map<String, dynamic>>()
          .map((item) => BranchTransferItemModel.fromJson(item))
          .toList();
    }

    return BranchTransferMstModel(
      branchTransferMstID: id != null ? parseI(id) : null,
      companyCode: json['CompanyCode'] != null
          ? parseI(json['CompanyCode'])
          : (json['companyCode'] != null ? parseI(json['companyCode']) : null),
      fromCrId: json['FromCrId'] != null
          ? parseI(json['FromCrId'])
          : (json['fromCrId'] != null ? parseI(json['fromCrId']) : null),
      toCrId: json['ToCrId'] != null
          ? parseI(json['ToCrId'])
          : (json['toCrId'] != null ? parseI(json['toCrId']) : null),
      transferDate: rawDate,
      totalItems: json['TotalItems'] != null
          ? parseI(json['TotalItems'])
          : (json['totalItems'] != null
              ? parseI(json['totalItems'])
              : parsedItems.length),
      totalStockPc: json['TotalStockPc'] != null
          ? parseI(json['TotalStockPc'])
          : (json['totalStockPc'] != null
              ? parseI(json['totalStockPc'])
              : null),
      totalStockWt: json['TotalStockWt'] != null
          ? parseD(json['TotalStockWt'])
          : (json['totalStockWt'] != null
              ? parseD(json['totalStockWt'])
              : null),
      totalRateDollar: json['TotalRateDollar'] != null
          ? parseD(json['TotalRateDollar'])
          : (json['totalRateDollar'] != null
              ? parseD(json['totalRateDollar'])
              : null),
      totalRateRs: json['TotalRateRs'] != null
          ? parseD(json['TotalRateRs'])
          : (json['totalRateRs'] != null ? parseD(json['totalRateRs']) : null),
      totalAmtDollar: json['TotalAmtDollar'] != null
          ? parseD(json['TotalAmtDollar'])
          : (json['totalAmtDollar'] != null
              ? parseD(json['totalAmtDollar'])
              : null),
      totalAmtRs: json['TotalAmtRs'] != null
          ? parseD(json['TotalAmtRs'])
          : (json['totalAmtRs'] != null ? parseD(json['totalAmtRs']) : null),
      totalIssuePc: json['TotalIssuePc'] != null
          ? parseI(json['TotalIssuePc'])
          : (json['totalIssuePc'] != null
              ? parseI(json['totalIssuePc'])
              : null),
      totalIssueWt: json['TotalIssueWt'] != null
          ? parseD(json['TotalIssueWt'])
          : (json['totalIssueWt'] != null
              ? parseD(json['totalIssueWt'])
              : null),
      totalIssueRate: json['TotalIssueRate'] != null
          ? parseD(json['TotalIssueRate'])
          : (json['totalIssueRate'] != null
              ? parseD(json['totalIssueRate'])
              : null),
      totalIssueAmt: json['TotalIssueAmt'] != null
          ? parseD(json['TotalIssueAmt'])
          : (json['totalIssueAmt'] != null
              ? parseD(json['totalIssueAmt'])
              : null),
      totalDiffWt: json['TotalDiffWt'] != null
          ? parseD(json['TotalDiffWt'])
          : (json['totalDiffWt'] != null ? parseD(json['totalDiffWt']) : null),
      totalDiffRate: json['TotalDiffRate'] != null
          ? parseD(json['TotalDiffRate'])
          : (json['totalDiffRate'] != null
              ? parseD(json['totalDiffRate'])
              : null),
      totalDiffAmt: json['TotalDiffAmt'] != null
          ? parseD(json['TotalDiffAmt'])
          : (json['totalDiffAmt'] != null
              ? parseD(json['totalDiffAmt'])
              : null),
      items: parsedItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BranchTransferMstID': branchTransferMstID,
      'CompanyCode': companyCode,
      'FromCrId': fromCrId,
      'ToCrId': toCrId,
      'TransferDate': transferDate,
      'TotalItems': totalItems,
      'TotalStockPc': totalStockPc,
      'TotalStockWt': totalStockWt,
      'TotalRateDollar': totalRateDollar,
      'TotalRateRs': totalRateRs,
      'TotalAmtDollar': totalAmtDollar,
      'TotalAmtRs': totalAmtRs,
      'TotalIssuePc': totalIssuePc,
      'TotalIssueWt': totalIssueWt,
      'TotalIssueRate': totalIssueRate,
      'TotalIssueAmt': totalIssueAmt,
      'TotalDiffWt': totalDiffWt,
      'TotalDiffRate': totalDiffRate,
      'TotalDiffAmt': totalDiffAmt,
      'items': items.map((e) => e.toSaveJson()).toList(),
    };
  }
}
