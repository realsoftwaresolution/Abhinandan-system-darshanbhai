import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';

/// Represents an Internal Stock Transfer Confirm Master record
/// Matching Sequelize model:
/// InternalStockTransferConfirmMst: {
///   InternalStockTransferConfirmMstID: int,
///   ToCrId: int,
///   ManagerName: string,
///   CreatedAt: date
/// }
class InternalStockTransferConfirmMstModel {
  final int? internalStockTransferConfirmMstID;
  final int? toCrId;
  final String? managerName;
  final String? createdAt;

  InternalStockTransferConfirmMstModel({
    this.internalStockTransferConfirmMstID,
    this.toCrId,
    this.managerName,
    this.createdAt,
  });

  /// Manager name resolved from property or DefaultController's userModelList
  String get resolvedManagerName {
    if (managerName != null && managerName!.trim().isNotEmpty) {
      return managerName!.trim();
    }
    if (toCrId == null) return '-';
    if (Get.isRegistered<DefaultController>()) {
      final ctrl = Get.find<DefaultController>();
      final u = ctrl.userModelList.firstWhereOrNull(
        (user) => user.counterMstId == toCrId,
      );
      if (u != null) {
        return (u.userName != null && u.userName!.trim().isNotEmpty)
            ? u.userName!.trim()
            : (u.loginName ?? 'Manager #$toCrId');
      }
    }
    return 'Manager #$toCrId';
  }

  /// Formatted date string for UI display (dd-MM-yyyy HH:mm)
  String get displayDate {
    if (createdAt == null || createdAt!.isEmpty) return '-';
    try {
      final dt = DateTime.tryParse(createdAt!);
      if (dt != null) {
        return DateFormat('dd-MM-yyyy HH:mm').format(dt);
      }
      if (createdAt!.contains('-') && createdAt!.split('-').first.length == 4) {
        final parts = createdAt!.split('T').first.split('-');
        return '${parts[2]}-${parts[1]}-${parts[0]}';
      }
    } catch (_) {}
    return createdAt!;
  }

  /// Date only (dd-MM-yyyy) for filtering
  String get displayDateOnly {
    if (createdAt == null || createdAt!.isEmpty) return '-';
    try {
      final dt = DateTime.tryParse(createdAt!);
      if (dt != null) {
        return DateFormat('dd-MM-yyyy').format(dt);
      }
    } catch (_) {}
    return displayDate;
  }

  factory InternalStockTransferConfirmMstModel.fromJson(Map<String, dynamic> json) {
    int parseI(dynamic val) {
      if (val == null) return 0;
      if (val is num) return val.toInt();
      return int.tryParse(val.toString()) ?? 0;
    }

    final id = json['InternalStockTransferConfirmMstID'] ??
        json['internalStockTransferConfirmMstID'] ??
        json['InternalStockTransferConfirmMstId'] ??
        json['BranchTransferConfirmMstID'] ??
        json['branchTransferConfirmMstID'] ??
        json['BranchTransferConfirmMstId'] ??
        json['id'] ??
        json['Id'];

    final toCr = json['ToCrId'] ??
        json['toCrId'] ??
        json['ManagerId'] ??
        json['managerId'];

    final name = (json['ManagerName'] ?? json['managerName'] ?? json['userName'])
        ?.toString();

    final created = (json['CreatedAt'] ??
            json['createdAt'] ??
            json['CreatedDate'] ??
            json['date'] ??
            json['Date'])
        ?.toString();

    return InternalStockTransferConfirmMstModel(
      internalStockTransferConfirmMstID: id != null ? parseI(id) : null,
      toCrId: toCr != null ? parseI(toCr) : null,
      managerName: name,
      createdAt: created,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'InternalStockTransferConfirmMstID': internalStockTransferConfirmMstID,
      'ToCrId': toCrId,
      'ManagerName': managerName,
      'CreatedAt': createdAt,
    };
  }
}
