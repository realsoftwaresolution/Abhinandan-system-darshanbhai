import 'package:flutter/material.dart';

class BranchTransferItemModel {
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

  BranchTransferItemModel({
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
  double get stockAmtRs => amtRs ?? totalAmtRs ?? 0.0;
  double get stockAmtDollar => amtDollar ?? totalAmtDollar ?? 0.0;

  void updateCalculations() {
    issueAmt = issueWt * issueRate;
    diffWt = issueWt;
    diffRate = issueRate - stockRateRs;
    diffAmt = diffRate * issueWt;
  }

  void setSelected(bool selected) {
    isSelected = selected;
    if (selected) {
      if (issuePc == 0 && stockPc > 0) {
        issuePc = stockPc;
        issuePcController.text = issuePc.toString();
      }
      if (issueWt == 0.0 && stockWt > 0.0) {
        issueWt = stockWt;
        issueWtController.text = issueWt.toStringAsFixed(3);
      }
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

  factory BranchTransferItemModel.fromJson(Map<String, dynamic> json) {
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

    final src = (json['source'] ?? json['Source'] ?? 'Rough').toString();

    return BranchTransferItemModel(
      source: src,
      roughTypeCode: json['RoughTypeCode'] != null
          ? parseI(json['RoughTypeCode'])
          : (json['roughTypeCode'] != null ? parseI(json['roughTypeCode']) : null),
      roughQualityCode: json['RoughQualityCode'] != null
          ? parseI(json['RoughQualityCode'])
          : (json['roughQualityCode'] != null ? parseI(json['roughQualityCode']) : null),
      roughCharniCode: json['RoughCharniCode'] != null
          ? parseI(json['RoughCharniCode'])
          : (json['roughCharniCode'] != null ? parseI(json['roughCharniCode']) : null),
      invoiceNo: (json['InvoiceNo'] ?? json['invoiceNo'])?.toString(),
      totalPc: json['totalPc'] != null ? parseI(json['totalPc']) : null,
      totalWt: json['totalWt'] != null ? parseD(json['totalWt']) : null,
      totalAmtRs: json['totalAmtRs'] != null ? parseD(json['totalAmtRs']) : null,
      totalAmtDollar: json['totalAmtDollar'] != null ? parseD(json['totalAmtDollar']) : null,
      pc: json['Pc'] != null ? parseI(json['Pc']) : (json['pc'] != null ? parseI(json['pc']) : null),
      wt: json['Wt'] != null ? parseD(json['Wt']) : (json['wt'] != null ? parseD(json['wt']) : null),
      amtRs: json['AmtRs'] != null ? parseD(json['AmtRs']) : (json['amtRs'] != null ? parseD(json['amtRs']) : null),
      amtDollar: json['AmtDollar'] != null ? parseD(json['AmtDollar']) : (json['amtDollar'] != null ? parseD(json['amtDollar']) : null),
      rateRs: json['RateRs'] != null ? parseD(json['RateRs']) : (json['rateRs'] != null ? parseD(json['rateRs']) : null),
      rateDollar: json['RateDollar'] != null ? parseD(json['RateDollar']) : (json['rateDollar'] != null ? parseD(json['rateDollar']) : null),
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
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

  Map<String, dynamic> toSaveJson() {
    return {
      'source': source,
      'InvoiceNo': invoiceNo,
      'RoughTypeCode': roughTypeCode,
      'RoughQualityCode': roughQualityCode,
      'RoughCharniCode': roughCharniCode,
      'ShapeCode': shapeCode,
      'ClarityCode': clarityCode,
      'CharniCode': charniCode,
      'PolishTypeCode': polishTypeCode,
      'ColorCode': colorCode,
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
    };
  }
}
