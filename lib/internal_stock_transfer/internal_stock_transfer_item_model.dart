import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';

class InternalStockTransferItemModel {
  final int? internalStockTransferDetID;
  final int? internalStockTransferMstID;
  final String source; // "Rough" or "Polish"
  final int? roughTypeCode;
  final int? roughQualityCode;
  final int? roughCharniCode;
  final String? invoiceNo;
  final int? totalPc;
  final double? totalWt;
  final double? totalAmtRs;
  final double? totalAmtDollar;
  final int? pc;
  final double? wt;
  final double? amtRs;
  final double? amtDollar;
  final double? rateRs;
  final double? rateDollar;

  // Polish specific fields
  final int? shapeCode;
  final int? clarityCode;
  final int? charniCode;
  final int? polishTypeCode;
  final int? colorCode;

  // Transfer & Issue state
  bool isSelected;
  int issuePc;
  double issueWt;
  double issueRate;
  double issueAmt;
  double diffWt;
  double diffRate;
  double diffAmt;

  late final TextEditingController issuePcController;
  late final TextEditingController issueWtController;
  late final FocusNode issuePcFocusNode;
  late final FocusNode issueWtFocusNode;

  InternalStockTransferItemModel({
    this.internalStockTransferDetID,
    this.internalStockTransferMstID,
    required this.source,
    this.roughTypeCode,
    this.roughQualityCode,
    this.roughCharniCode,
    this.invoiceNo,
    this.totalPc,
    this.totalWt,
    this.totalAmtRs,
    this.totalAmtDollar,
    this.pc,
    this.wt,
    this.amtRs,
    this.amtDollar,
    this.rateRs,
    this.rateDollar,
    this.shapeCode,
    this.clarityCode,
    this.charniCode,
    this.polishTypeCode,
    this.colorCode,
    this.isSelected = false,
    int? issuePc,
    double? issueWt,
    double? issueRate,
    double? issueAmt,
    double? diffWt,
    double? diffRate,
    double? diffAmt,
  })  : issuePc = issuePc ?? 0,
        issueWt = issueWt ?? 0.0,
        issueRate = issueRate ?? (rateRs ?? 0.0),
        issueAmt = issueAmt ?? 0.0,
        diffWt = diffWt ?? (issueWt ?? 0.0),
        diffRate = diffRate ?? ((issueRate ?? (rateRs ?? 0.0)) - (rateRs ?? 0.0)),
        diffAmt = diffAmt ?? 0.0 {
    issuePcController = TextEditingController(
      text: this.issuePc > 0 ? this.issuePc.toString() : '0',
    );
    issueWtController = TextEditingController(
      text: this.issueWt > 0.0 ? this.issueWt.toStringAsFixed(3) : '0.000',
    );
    issuePcFocusNode = FocusNode();
    issueWtFocusNode = FocusNode();
    updateCalculations();
  }

  int get stockPc => pc ?? totalPc ?? 0;
  double get stockWt => wt ?? totalWt ?? 0.0;
  double get stockRateRs => rateRs ?? 0.0;
  double get stockRateDollar => rateDollar ?? 0.0;
  double get stockAmtRs {
    if (amtRs != null && amtRs! > 0) return amtRs!;
    if (totalAmtRs != null && totalAmtRs! > 0) return totalAmtRs!;
    return stockWt * stockRateRs;
  }
  double get stockAmtDollar {
    if (amtDollar != null && amtDollar! > 0) return amtDollar!;
    if (totalAmtDollar != null && totalAmtDollar! > 0) return totalAmtDollar!;
    return stockWt * stockRateDollar;
  }

  void updateCalculations() {
    issueAmt = issueWt * issueRate;
    diffWt = issueWt;
    diffRate = issueRate - stockRateRs;
    diffAmt = diffRate * issueWt;
  }

  void setSelected(bool selected) {
    isSelected = selected;
    if (selected) {
      issuePc = stockPc;
      issuePcController.text = issuePc.toString();
      issueWt = stockWt;
      issueWtController.text = issueWt.toStringAsFixed(3);
    } else {
      issuePc = 0;
      issueWt = 0.0;
      issuePcController.text = '0';
      issueWtController.text = '0.000';
    }
    updateCalculations();
  }

  void dispose() {
    issuePcController.dispose();
    issueWtController.dispose();
    issuePcFocusNode.dispose();
    issueWtFocusNode.dispose();
  }

  factory InternalStockTransferItemModel.fromJson(Map<String, dynamic> json) {
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

    final detId = json['InternalStockTransferDetID'] ??
        json['internalStockTransferDetID'] ??
        json['InternalStockTransferDetId'] ??
        json['BranchTransferDetID'] ??
        json['branchTransferDetID'] ??
        json['BranchTransferDetId'] ??
        json['id'] ??
        json['Id'];

    final mstId = json['InternalStockTransferMstID'] ??
        json['internalStockTransferMstID'] ??
        json['InternalStockTransferMstId'] ??
        json['BranchTransferMstID'] ??
        json['branchTransferMstID'] ??
        json['BranchTransferMstId'];

    final src = (json['source'] ?? json['Source'] ?? 'Rough').toString();

    final isRough = src.toLowerCase() == 'rough';

    final issuePcVal = json['IssuePc'] != null
        ? parseI(json['IssuePc'])
        : (json['issuePc'] != null ? parseI(json['issuePc']) : 0);

    final issueWtVal = json['IssueWt'] != null
        ? parseD(json['IssueWt'])
        : (json['issueWt'] != null ? parseD(json['issueWt']) : 0.0);

    final issueRateVal = json['IssueRate'] != null
        ? parseD(json['IssueRate'])
        : (json['issueRate'] != null ? parseD(json['issueRate']) : null);

    final issueAmtVal = json['IssueAmt'] != null
        ? parseD(json['IssueAmt'])
        : (json['issueAmt'] != null ? parseD(json['issueAmt']) : null);

    final diffWtVal = json['DiffWt'] != null
        ? parseD(json['DiffWt'])
        : (json['diffWt'] != null ? parseD(json['diffWt']) : null);

    final diffRateVal = json['DiffRate'] != null
        ? parseD(json['DiffRate'])
        : (json['diffRate'] != null ? parseD(json['diffRate']) : null);

    final diffAmtVal = json['DiffAmt'] != null
        ? parseD(json['DiffAmt'])
        : (json['diffAmt'] != null ? parseD(json['diffAmt']) : null);

    final isSelectedVal = json['isSelected'] == true || issueWtVal > 0.0;

    return InternalStockTransferItemModel(
      internalStockTransferDetID: detId != null ? parseI(detId) : null,
      internalStockTransferMstID: mstId != null ? parseI(mstId) : null,
      source: src,
      roughTypeCode: json['RoughTypeCode'] != null
          ? parseI(json['RoughTypeCode'])
          : (json['roughTypeCode'] != null ? parseI(json['roughTypeCode']) : null),
      roughQualityCode: json['RoughQualityCode'] != null
          ? parseI(json['RoughQualityCode'])
          : (isRough && json['QualityCode'] != null
              ? parseI(json['QualityCode'])
              : (json['roughQualityCode'] != null
                  ? parseI(json['roughQualityCode'])
                  : null)),
      roughCharniCode: json['RoughCharniCode'] != null
          ? parseI(json['RoughCharniCode'])
          : (isRough && json['CharniCode'] != null
              ? parseI(json['CharniCode'])
              : (json['roughCharniCode'] != null
                  ? parseI(json['roughCharniCode'])
                  : null)),
      invoiceNo: (json['InvoiceNo'] ?? json['invoiceNo'])?.toString(),
      totalPc: json['totalPc'] != null ? parseI(json['totalPc']) : null,
      totalWt: json['totalWt'] != null ? parseD(json['totalWt']) : null,
      totalAmtRs: json['totalAmtRs'] != null
          ? parseD(json['totalAmtRs'])
          : (json['StockAmtRs'] != null ? parseD(json['StockAmtRs']) : null),
      totalAmtDollar: json['totalAmtDollar'] != null
          ? parseD(json['totalAmtDollar'])
          : (json['StockAmtDollar'] != null
              ? parseD(json['StockAmtDollar'])
              : null),
      pc: json['StockPc'] != null
          ? parseI(json['StockPc'])
          : (json['Pc'] != null
              ? parseI(json['Pc'])
              : (json['pc'] != null ? parseI(json['pc']) : null)),
      wt: json['StockWt'] != null
          ? parseD(json['StockWt'])
          : (json['Wt'] != null
              ? parseD(json['Wt'])
              : (json['wt'] != null ? parseD(json['wt']) : null)),
      amtRs: json['StockAmtRs'] != null
          ? parseD(json['StockAmtRs'])
          : (json['AmtRs'] != null
              ? parseD(json['AmtRs'])
              : (json['amtRs'] != null ? parseD(json['amtRs']) : null)),
      amtDollar: json['StockAmtDollar'] != null
          ? parseD(json['StockAmtDollar'])
          : (json['AmtDollar'] != null
              ? parseD(json['AmtDollar'])
              : (json['amtDollar'] != null ? parseD(json['amtDollar']) : null)),
      rateRs: json['StockRateRs'] != null
          ? parseD(json['StockRateRs'])
          : (json['RateRs'] != null
              ? parseD(json['RateRs'])
              : (json['rateRs'] != null ? parseD(json['rateRs']) : null)),
      rateDollar: json['StockRateDollar'] != null
          ? parseD(json['StockRateDollar'])
          : (json['RateDollar'] != null
              ? parseD(json['RateDollar'])
              : (json['rateDollar'] != null ? parseD(json['rateDollar']) : null)),
      shapeCode: json['ShapeCode'] != null
          ? parseI(json['ShapeCode'])
          : (json['shapeCode'] != null ? parseI(json['shapeCode']) : null),
      clarityCode: json['ClarityCode'] != null
          ? parseI(json['ClarityCode'])
          : (json['clarityCode'] != null ? parseI(json['clarityCode']) : null),
      charniCode: json['CharniCode'] != null
          ? parseI(json['CharniCode'])
          : (json['charniCode'] != null ? parseI(json['charniCode']) : null),
      polishTypeCode: json['PolishTypeCode'] != null
          ? parseI(json['PolishTypeCode'])
          : (json['polishTypeCode'] != null ? parseI(json['polishTypeCode']) : null),
      colorCode: json['ColorCode'] != null
          ? parseI(json['ColorCode'])
          : (json['colorCode'] != null ? parseI(json['colorCode']) : null),
      isSelected: isSelectedVal,
      issuePc: issuePcVal,
      issueWt: issueWtVal,
      issueRate: issueRateVal,
      issueAmt: issueAmtVal,
      diffWt: diffWtVal,
      diffRate: diffRateVal,
      diffAmt: diffAmtVal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'InternalStockTransferDetID': internalStockTransferDetID,
      'InternalStockTransferMstID': internalStockTransferMstID,
      'source': source,
      'RoughTypeCode': roughTypeCode,
      'RoughQualityCode': roughQualityCode,
      'RoughCharniCode': roughCharniCode,
      'InvoiceNo': invoiceNo,
      'totalPc': totalPc,
      'totalWt': totalWt,
      'totalAmtRs': totalAmtRs,
      'totalAmtDollar': totalAmtDollar,
      'Pc': pc,
      'Wt': wt,
      'AmtRs': amtRs,
      'AmtDollar': amtDollar,
      'RateRs': rateRs,
      'RateDollar': rateDollar,
      'ShapeCode': shapeCode,
      'ClarityCode': clarityCode,
      'CharniCode': charniCode,
      'PolishTypeCode': polishTypeCode,
      'ColorCode': colorCode,
      'issuePc': issuePc,
      'issueWt': issueWt,
      'issueRate': issueRate,
      'issueAmt': issueAmt,
      'diffWt': diffWt,
      'diffRate': diffRate,
      'diffAmt': diffAmt,
      'isSelected': isSelected,
    };
  }

  String resolveTypeName() {
    if (source.toLowerCase() == 'rough') {
      if (Get.isRegistered<DefaultController>()) {
        final ctrl = Get.find<DefaultController>();
        final item = ctrl.roughModel.firstWhereOrNull(
          (r) =>
              r.roughTypeCode.toString() == roughTypeCode.toString() ||
              r.roughTypeMstID.toString() == roughTypeCode.toString(),
        );
        return item?.roughTypeName ?? (roughTypeCode != null ? 'Rough #$roughTypeCode' : '-');
      }
      return roughTypeCode != null ? 'Rough #$roughTypeCode' : '-';
    } else if (source.toLowerCase() == 'polish') {
      return getPolishTypeName(polishTypeCode);
    }
    return '-';
  }

  String resolveQualityName() {
    if (source.toLowerCase() == 'rough' && roughQualityCode != null) {
      return getQualityName(roughQualityCode);
    }
    return '-';
  }

  String resolveCharniName() {
    final code = source.toLowerCase() == 'rough' ? roughCharniCode : charniCode;
    if (code != null) {
      return getCharniName(code);
    }
    return '-';
  }

  String resolveShapeName() {
    if (source.toLowerCase() == 'polish' && shapeCode != null) {
      return getShapeName(shapeCode);
    }
    return '-';
  }

  String resolveColorName() {
    if (source.toLowerCase() == 'polish' && colorCode != null) {
      return getColorName(colorCode);
    }
    return '-';
  }

  String resolveClarityName() {
    if (source.toLowerCase() == 'polish' && clarityCode != null) {
      return getClarityName(clarityCode);
    }
    return '-';
  }

  Map<String, dynamic> toSaveJson({
    String? type,
    String? quality,
    String? charni,
    String? shape,
    String? color,
    String? clarity,
  }) {
    final isRough = source.toLowerCase() == 'rough';
    final isPolish = source.toLowerCase() == 'polish';

    return {
      if (internalStockTransferDetID != null)
        'InternalStockTransferDetID': internalStockTransferDetID,
      if (internalStockTransferMstID != null)
        'InternalStockTransferMstID': internalStockTransferMstID,
      'source': source,
      'InvoiceNo': invoiceNo ?? '',
      'RoughTypeCode': isRough ? roughTypeCode : null,
      'PolishTypeCode': isPolish ? polishTypeCode : null,
      'ShapeCode': isPolish ? shapeCode : null,
      'ColorCode': isPolish ? colorCode : null,
      'ClarityCode': isPolish ? clarityCode : null,
      'CharniCode': isRough
          ? (roughCharniCode ?? charniCode)
          : (charniCode ?? roughCharniCode),
      'QualityCode': isRough ? roughQualityCode : null,
      'Type': type ?? resolveTypeName(),
      'Quality': quality ?? resolveQualityName(),
      'Charni': charni ?? resolveCharniName(),
      'Shape': shape ?? resolveShapeName(),
      'Color': color ?? resolveColorName(),
      'Clarity': clarity ?? resolveClarityName(),
      'StockPc': stockPc,
      'StockWt': double.parse(stockWt.toStringAsFixed(3)),
      'StockRateRs': double.parse(stockRateRs.toStringAsFixed(2)),
      'StockRateDollar': double.parse(stockRateDollar.toStringAsFixed(2)),
      'StockAmtRs': double.parse(stockAmtRs.toStringAsFixed(2)),
      'StockAmtDollar': double.parse(stockAmtDollar.toStringAsFixed(2)),
      'IssuePc': issuePc,
      'IssueWt': double.parse(issueWt.toStringAsFixed(3)),
      'IssueRate': double.parse(issueRate.toStringAsFixed(2)),
      'IssueAmt': double.parse(issueAmt.toStringAsFixed(2)),
      'DiffWt': double.parse(diffWt.toStringAsFixed(3)),
      'DiffRate': double.parse(diffRate.toStringAsFixed(2)),
      'DiffAmt': double.parse(diffAmt.toStringAsFixed(2)),
    };
  }
}
