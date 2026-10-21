import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';

class BranchTransferConfirmItemModel {
  final int? branchTransferDetID;
  final int? branchTransferMstID;
  final String source; // "Rough" or "Polish"
  final String? invoiceNo;

  // Codes can be integer or string (e.g. "RT01", "Q01", "C01", 101)
  final dynamic roughTypeCode;
  final dynamic roughQualityCode;
  final dynamic roughCharniCode;
  final dynamic qualityCode;
  final dynamic charniCode;
  final dynamic polishTypeCode;
  final dynamic shapeCode;
  final dynamic colorCode;
  final dynamic clarityCode;

  // Explicit name strings if provided by backend
  final String? typeName;
  final String? qualityName;
  final String? charniName;
  final String? shapeName;
  final String? colorName;
  final String? clarityName;

  // Stock values
  final int stockPc;
  final double stockWt;
  final double stockRateRs;
  final double stockRateDollar;
  final double stockAmtRs;
  final double stockAmtDollar;

  // Issue values
  final int issuePc;
  final double issueWt;
  final double issueRate;
  final double issueAmt;

  // Diff values
  final double diffWt;
  final double diffRate;
  final double diffAmt;

  // Confirm state
  final bool branchTransformConfirm;
  final int? branchTransferConfirmMstId;
  final int? toCrId;

  // Selection state for checkbox confirmation
  bool isSelected;

  BranchTransferConfirmItemModel({
    this.branchTransferDetID,
    this.branchTransferMstID,
    required this.source,
    this.invoiceNo,
    this.roughTypeCode,
    this.roughQualityCode,
    this.roughCharniCode,
    this.qualityCode,
    this.charniCode,
    this.polishTypeCode,
    this.shapeCode,
    this.colorCode,
    this.clarityCode,
    this.typeName,
    this.qualityName,
    this.charniName,
    this.shapeName,
    this.colorName,
    this.clarityName,
    this.stockPc = 0,
    this.stockWt = 0.0,
    this.stockRateRs = 0.0,
    this.stockRateDollar = 0.0,
    this.stockAmtRs = 0.0,
    this.stockAmtDollar = 0.0,
    this.issuePc = 0,
    this.issueWt = 0.0,
    this.issueRate = 0.0,
    this.issueAmt = 0.0,
    this.diffWt = 0.0,
    this.diffRate = 0.0,
    this.diffAmt = 0.0,
    this.branchTransformConfirm = false,
    this.branchTransferConfirmMstId,
    this.toCrId,
    this.isSelected = false,
  });

  String resolveTypeName() {
    if (typeName != null && typeName!.trim().isNotEmpty) {
      return typeName!.trim();
    }
    final isRough = source.toLowerCase() == 'rough';
    if (isRough) {
      if (roughTypeCode == null) return '-';
      final codeStr = roughTypeCode.toString().trim();
      if (Get.isRegistered<DefaultController>()) {
        final ctrl = Get.find<DefaultController>();
        final item = ctrl.roughModel.firstWhereOrNull(
          (r) =>
              r.roughTypeCode?.toString() == codeStr ||
              r.roughTypeMstID?.toString() == codeStr ||
              (r.roughTypeName != null &&
                  r.roughTypeName!.toLowerCase() == codeStr.toLowerCase()),
        );
        if (item != null && item.roughTypeName != null) {
          return item.roughTypeName!;
        }
      }
      return codeStr;
    } else {
      if (polishTypeCode == null) return '-';
      final codeStr = polishTypeCode.toString().trim();
      final intCode = int.tryParse(codeStr);
      if (intCode != null) {
        final name = getPolishTypeName(intCode);
        if (name != '-') return name;
      }
      if (Get.isRegistered<DefaultController>()) {
        final ctrl = Get.find<DefaultController>();
        final item = ctrl.polishTypeModelList.firstWhereOrNull(
          (p) =>
              p.polishTypeCode?.toString() == codeStr ||
              p.polishTypeMstId?.toString() == codeStr ||
              (p.polishTypeName != null &&
                  p.polishTypeName!.toLowerCase() == codeStr.toLowerCase()),
        );
        if (item != null && item.polishTypeName != null) {
          return item.polishTypeName!;
        }
      }
      return codeStr;
    }
  }

  String resolveQualityName() {
    if (qualityName != null && qualityName!.trim().isNotEmpty) {
      return qualityName!.trim();
    }
    final code = roughQualityCode ?? qualityCode;
    if (code == null) return '-';
    final codeStr = code.toString().trim();
    final intCode = int.tryParse(codeStr);
    if (intCode != null) {
      final name = getQualityName(intCode);
      if (name != '-') return name;
    }
    if (Get.isRegistered<DefaultController>()) {
      final ctrl = Get.find<DefaultController>();
      final item = ctrl.qualityModelList.firstWhereOrNull(
        (q) =>
            q.qualityCode?.toString() == codeStr ||
            q.qualityMstID?.toString() == codeStr ||
            (q.qualityName != null &&
                q.qualityName!.toLowerCase() == codeStr.toLowerCase()),
      );
      if (item != null && item.qualityName != null) {
        return item.qualityName!;
      }
    }
    return codeStr;
  }

  String resolveCharniName() {
    if (charniName != null && charniName!.trim().isNotEmpty) {
      return charniName!.trim();
    }
    final code = roughCharniCode ?? charniCode;
    if (code == null) return '-';
    final codeStr = code.toString().trim();
    final intCode = int.tryParse(codeStr);
    if (intCode != null) {
      final name = getCharniName(intCode);
      if (name != '-') return name;
    }
    if (Get.isRegistered<DefaultController>()) {
      final ctrl = Get.find<DefaultController>();
      final item = ctrl.charniModelList.firstWhereOrNull(
        (c) =>
            c.charniCode?.toString() == codeStr ||
            c.charniMstID?.toString() == codeStr ||
            (c.charniName != null &&
                c.charniName!.toLowerCase() == codeStr.toLowerCase()),
      );
      if (item != null && item.charniName != null) {
        return item.charniName!;
      }
    }
    return codeStr;
  }

  String resolveShapeName() {
    if (shapeName != null && shapeName!.trim().isNotEmpty) {
      return shapeName!.trim();
    }
    if (shapeCode == null) return '-';
    final codeStr = shapeCode.toString().trim();
    final intCode = int.tryParse(codeStr);
    if (intCode != null) {
      final name = getShapeName(intCode);
      if (name != '-') return name;
    }
    if (Get.isRegistered<DefaultController>()) {
      final ctrl = Get.find<DefaultController>();
      final item = ctrl.shapeModelList.firstWhereOrNull(
        (s) =>
            s.shapeCode?.toString() == codeStr ||
            s.shapeMstId?.toString() == codeStr ||
            (s.shapeName != null &&
                s.shapeName!.toLowerCase() == codeStr.toLowerCase()),
      );
      if (item != null && item.shapeName != null) {
        return item.shapeName!;
      }
    }
    return codeStr;
  }

  String resolveColorName() {
    if (colorName != null && colorName!.trim().isNotEmpty) {
      return colorName!.trim();
    }
    if (colorCode == null) return '-';
    final codeStr = colorCode.toString().trim();
    final intCode = int.tryParse(codeStr);
    if (intCode != null) {
      final name = getColorName(intCode);
      if (name != '-') return name;
    }
    if (Get.isRegistered<DefaultController>()) {
      final ctrl = Get.find<DefaultController>();
      final item = ctrl.colorModelList.firstWhereOrNull(
        (c) =>
            c.colorCode?.toString() == codeStr ||
            c.colorMstID?.toString() == codeStr ||
            (c.colorName != null &&
                c.colorName!.toLowerCase() == codeStr.toLowerCase()),
      );
      if (item != null && item.colorName != null) {
        return item.colorName!;
      }
    }
    return codeStr;
  }

  String resolveClarityName() {
    if (clarityName != null && clarityName!.trim().isNotEmpty) {
      return clarityName!.trim();
    }
    if (clarityCode == null) return '-';
    final codeStr = clarityCode.toString().trim();
    final intCode = int.tryParse(codeStr);
    if (intCode != null) {
      final name = getClarityName(intCode);
      if (name != '-') return name;
    }
    if (Get.isRegistered<DefaultController>()) {
      final ctrl = Get.find<DefaultController>();
      final item = ctrl.clarityModelList.firstWhereOrNull(
        (c) =>
            c.clarityMstID?.toString() == codeStr ||
            (c.clarityName != null &&
                c.clarityName!.toLowerCase() == codeStr.toLowerCase()),
      );
      if (item != null && item.clarityName != null) {
        return item.clarityName!;
      }
    }
    return codeStr;
  }

  factory BranchTransferConfirmItemModel.fromJson(Map<String, dynamic> json) {
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

    bool parseB(dynamic val) {
      if (val == null) return false;
      if (val is bool) return val;
      if (val is num) return val == 1;
      final str = val.toString().trim().toLowerCase();
      return str == 'true' || str == '1';
    }

    final detId = json['BranchTransferDetID'] ??
        json['branchTransferDetID'] ??
        json['BranchTransferDetId'] ??
        json['id'] ??
        json['Id'];

    final mstId = json['BranchTransferMstID'] ??
        json['branchTransferMstID'] ??
        json['BranchTransferMstId'];

    final src = (json['source'] ?? json['Source'] ?? 'Rough').toString();

    final isConfirmed = parseB(
      json['BranchTransformConfirm'] ??
          json['branchTransformConfirm'] ??
          json['BranchTransferConfirm'] ??
          json['branchTransferConfirm'] ??
          json['IsConfirmed'],
    );

    final confirmMstId = json['BranchTransferConfirmMstId'] ??
        json['branchTransferConfirmMstId'] ??
        json['BranchTransferConfirmMstID'] ??
        json['branchTransferConfirmMstID'];

    final toCr = json['ToCrId'] ?? json['toCrId'] ?? json['managerId'];

    final stPc = json['StockPc'] != null
        ? parseI(json['StockPc'])
        : (json['pc'] != null ? parseI(json['pc']) : 0);

    final stWt = json['StockWt'] != null
        ? parseD(json['StockWt'])
        : (json['wt'] != null ? parseD(json['wt']) : 0.0);

    final stRateRs = json['StockRateRs'] != null
        ? parseD(json['StockRateRs'])
        : (json['rateRs'] != null ? parseD(json['rateRs']) : 0.0);

    final stRateDollar = json['StockRateDollar'] != null
        ? parseD(json['StockRateDollar'])
        : (json['rateDollar'] != null ? parseD(json['rateDollar']) : 0.0);

    final stAmtRs = json['StockAmtRs'] != null
        ? parseD(json['StockAmtRs'])
        : (json['amtRs'] != null ? parseD(json['amtRs']) : (stWt * stRateRs));

    final stAmtDollar = json['StockAmtDollar'] != null
        ? parseD(json['StockAmtDollar'])
        : (json['amtDollar'] != null
            ? parseD(json['amtDollar'])
            : (stWt * stRateDollar));

    final issPc = json['IssuePc'] != null
        ? parseI(json['IssuePc'])
        : (json['issuePc'] != null ? parseI(json['issuePc']) : 0);

    final issWt = json['IssueWt'] != null
        ? parseD(json['IssueWt'])
        : (json['issueWt'] != null ? parseD(json['issueWt']) : 0.0);

    final issRate = json['IssueRate'] != null
        ? parseD(json['IssueRate'])
        : (json['issueRate'] != null ? parseD(json['issueRate']) : stRateRs);

    final issAmt = json['IssueAmt'] != null
        ? parseD(json['IssueAmt'])
        : (json['issueAmt'] != null ? parseD(json['issueAmt']) : (issWt * issRate));

    final dWt = json['DiffWt'] != null
        ? parseD(json['DiffWt'])
        : (json['diffWt'] != null ? parseD(json['diffWt']) : (issWt - stWt));

    final dRate = json['DiffRate'] != null
        ? parseD(json['DiffRate'])
        : (json['diffRate'] != null
            ? parseD(json['diffRate'])
            : (issRate - stRateRs));

    final dAmt = json['DiffAmt'] != null
        ? parseD(json['DiffAmt'])
        : (json['diffAmt'] != null ? parseD(json['diffAmt']) : (dWt * dRate));

    return BranchTransferConfirmItemModel(
      branchTransferDetID: detId != null ? parseI(detId) : null,
      branchTransferMstID: mstId != null ? parseI(mstId) : null,
      source: src,
      invoiceNo: (json['InvoiceNo'] ?? json['invoiceNo'])?.toString(),
      roughTypeCode: json['RoughTypeCode'] ?? json['roughTypeCode'],
      roughQualityCode: json['RoughQualityCode'] ?? json['roughQualityCode'],
      roughCharniCode: json['RoughCharniCode'] ?? json['roughCharniCode'],
      qualityCode: json['QualityCode'] ?? json['qualityCode'],
      charniCode: json['CharniCode'] ?? json['charniCode'],
      polishTypeCode: json['PolishTypeCode'] ?? json['polishTypeCode'],
      shapeCode: json['ShapeCode'] ?? json['shapeCode'],
      colorCode: json['ColorCode'] ?? json['colorCode'],
      clarityCode: json['ClarityCode'] ?? json['clarityCode'],
      typeName: (json['Type'] ?? json['type'] ?? json['RoughTypeName'] ?? json['PolishTypeName'])?.toString(),
      qualityName: (json['Quality'] ?? json['quality'] ?? json['QualityName'])?.toString(),
      charniName: (json['Charni'] ?? json['charni'] ?? json['CharniName'])?.toString(),
      shapeName: (json['Shape'] ?? json['shape'] ?? json['ShapeName'])?.toString(),
      colorName: (json['Color'] ?? json['color'] ?? json['ColorName'])?.toString(),
      clarityName: (json['Clarity'] ?? json['clarity'] ?? json['ClarityName'])?.toString(),
      stockPc: stPc,
      stockWt: stWt,
      stockRateRs: stRateRs,
      stockRateDollar: stRateDollar,
      stockAmtRs: stAmtRs,
      stockAmtDollar: stAmtDollar,
      issuePc: issPc,
      issueWt: issWt,
      issueRate: issRate,
      issueAmt: issAmt,
      diffWt: dWt,
      diffRate: dRate,
      diffAmt: dAmt,
      branchTransformConfirm: isConfirmed,
      branchTransferConfirmMstId:
          confirmMstId != null ? parseI(confirmMstId) : null,
      toCrId: toCr != null ? parseI(toCr) : null,
      isSelected: json['isSelected'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BranchTransferDetID': branchTransferDetID,
      'BranchTransferMstID': branchTransferMstID,
      'source': source,
      'InvoiceNo': invoiceNo,
      'RoughTypeCode': roughTypeCode,
      'RoughQualityCode': roughQualityCode,
      'RoughCharniCode': roughCharniCode,
      'QualityCode': qualityCode,
      'CharniCode': charniCode,
      'PolishTypeCode': polishTypeCode,
      'ShapeCode': shapeCode,
      'ColorCode': colorCode,
      'ClarityCode': clarityCode,
      'StockPc': stockPc,
      'StockWt': stockWt,
      'StockRateRs': stockRateRs,
      'StockRateDollar': stockRateDollar,
      'StockAmtRs': stockAmtRs,
      'StockAmtDollar': stockAmtDollar,
      'IssuePc': issuePc,
      'IssueWt': issueWt,
      'IssueRate': issueRate,
      'IssueAmt': issueAmt,
      'DiffWt': diffWt,
      'DiffRate': diffRate,
      'DiffAmt': diffAmt,
      'BranchTransformConfirm': branchTransformConfirm,
      'BranchTransferConfirmMstId': branchTransferConfirmMstId,
      'ToCrId': toCrId,
    };
  }
}
