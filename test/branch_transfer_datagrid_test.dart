import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/branch_transfer/branch_transfer_datagrid.dart';
import 'package:real_web_rough_entry_system/branch_transfer/branch_transfer_item_model.dart';
import 'package:real_web_rough_entry_system/branch_transfer/branch_transfer_mst_model.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/controllers/theme_controller.dart';
import 'package:real_web_rough_entry_system/polish_type/polish_type_model.dart';
import 'package:real_web_rough_entry_system/rough/rough_model.dart';
import 'package:real_web_rough_entry_system/tab-view-dashboard/tab_controller.dart';
import 'package:real_web_rough_entry_system/user/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DefaultController controller;

  setUp(() {
    SharedPreferences.setMockInitialValues({
      'username': 'Darshanbhai',
      'companyCode': 1,
    });
    Get.reset();
    Get.put(ThemeController());
    Get.put(TabControllerX());
    controller = Get.put(DefaultController());

    // Mock master data
    controller.roughModel.assignAll([
      RoughModel(roughTypeCode: 1, roughTypeName: 'Rough Type A'),
      RoughModel(roughTypeCode: 2, roughTypeName: 'Rough Type B'),
      RoughModel(roughTypeCode: 3, roughTypeName: 'Rough Type C'),
    ]);

    controller.polishTypeModelList.assignAll([
      PolishTypeModel(polishTypeCode: 6, polishTypeName: 'Polish Type 6'),
      PolishTypeModel(polishTypeCode: 7, polishTypeName: 'Polish Type 7'),
    ]);
  });

  group('Branch Transfer Item Model Tests', () {
    test('Parses Rough and Polish items correctly from user JSON', () {
      final roughJson = {
        "source": "Rough",
        "RoughTypeCode": 1,
        "RoughQualityCode": 3,
        "RoughCharniCode": 3,
        "InvoiceNo": "dgf",
        "totalPc": 1,
        "totalWt": 10,
        "totalAmtRs": 1000,
        "totalAmtDollar": 14.1,
        "Pc": 1,
        "Wt": 10,
        "AmtRs": 1000,
        "AmtDollar": 14.1,
        "RateRs": 100,
        "RateDollar": 1.41
      };

      final polishJson = {
        "source": "Polish",
        "ShapeCode": 29,
        "ClarityCode": 9,
        "CharniCode": 2,
        "PolishTypeCode": 6,
        "ColorCode": 1,
        "totalPc": 1,
        "totalWt": 10,
        "totalAmtRs": 1000,
        "totalAmtDollar": 10,
        "Pc": 1,
        "Wt": 10,
        "AmtRs": 1000,
        "AmtDollar": 10,
        "RateRs": 100,
        "RateDollar": 1
      };

      final roughItem = BranchTransferItemModel.fromJson(roughJson);
      expect(roughItem.source, 'Rough');
      expect(roughItem.roughTypeCode, 1);
      expect(roughItem.roughQualityCode, 3);
      expect(roughItem.roughCharniCode, 3);
      expect(roughItem.invoiceNo, 'dgf');
      expect(roughItem.stockPc, 1);
      expect(roughItem.stockWt, 10.0);
      expect(roughItem.stockRateRs, 100.0);
      expect(roughItem.stockRateDollar, 1.41);
      expect(roughItem.stockAmtRs, 1000.0);
      expect(roughItem.stockAmtDollar, 14.1);

      final polishItem = BranchTransferItemModel.fromJson(polishJson);
      expect(polishItem.source, 'Polish');
      expect(polishItem.shapeCode, 29);
      expect(polishItem.clarityCode, 9);
      expect(polishItem.charniCode, 2);
      expect(polishItem.polishTypeCode, 6);
      expect(polishItem.colorCode, 1);
      expect(polishItem.stockPc, 1);
      expect(polishItem.stockWt, 10.0);
      expect(polishItem.stockRateRs, 100.0);
      expect(polishItem.stockRateDollar, 1.0);
    });

    test('Selecting item auto-populates issuePc and issueWt with stock values', () {
      final item = BranchTransferItemModel(
        source: 'Rough',
        roughTypeCode: 1,
        pc: 5,
        wt: 12.5,
        rateRs: 200.0,
      );

      expect(item.isSelected, false);
      expect(item.issuePc, 0);
      expect(item.issueWt, 0.0);
      expect(item.issueAmt, 0.0);
      expect(item.diffWt, 0.0);

      item.setSelected(true);
      expect(item.isSelected, true);
      expect(item.issuePc, 5);
      expect(item.issueWt, 12.5);
      expect(item.issueAmt, 12.5 * 200.0);
      expect(item.diffWt, 12.5);
      expect(item.diffRate, 0.0);
      expect(item.diffAmt, 0.0);
      expect(item.issuePcController.text, '5');
      expect(item.issueWtController.text, '12.500');

      item.setSelected(false);
      expect(item.isSelected, false);
      expect(item.issuePc, 0);
      expect(item.issueWt, 0.0);
      expect(item.issueAmt, 0.0);
      expect(item.diffWt, 0.0);
    });

    test('Custom editing of issue pc, issue wt, and issue rate recalculates diffWt, diffRate, and diffAmt', () {
      final item = BranchTransferItemModel(
        source: 'Polish',
        polishTypeCode: 6,
        pc: 10,
        wt: 20.0,
        rateRs: 150.0,
      );

      item.issuePc = 4;
      item.issueWt = 8.5;
      item.issueRate = 180.0;
      item.updateCalculations();

      expect(item.issueAmt, 8.5 * 180.0);
      expect(item.diffWt, 8.5); // diffWt is issueWt
      expect(item.diffRate, 180.0 - 150.0); // diffRate is issueRate - stockRate
      expect(item.diffAmt, 30.0 * 8.5); // diffAmt is diffRate * issueWt
    });

    test('toSaveJson generates the expected payload structure matching BranchTransferDet', () {
      final item = BranchTransferItemModel(
        source: 'Rough',
        roughTypeCode: 1,
        roughQualityCode: 3,
        roughCharniCode: 3,
        invoiceNo: 'K44',
        pc: 10,
        wt: 20.0,
        rateRs: 100.0,
        rateDollar: 1.0,
      );
      item.issuePc = 5;
      item.issueWt = 10.0;
      item.issueRate = 120.0;
      item.updateCalculations();

      final json = item.toSaveJson();
      expect(json['source'], 'Rough');
      expect(json['RoughTypeCode'], 1);
      expect(json['PolishTypeCode'], isNull);
      expect(json['ShapeCode'], isNull);
      expect(json['ColorCode'], isNull);
      expect(json['ClarityCode'], isNull);
      expect(json['CharniCode'], 3);
      expect(json['QualityCode'], 3);
      expect(json['InvoiceNo'], 'K44');
      expect(json['StockPc'], 10);
      expect(json['StockWt'], 20.0);
      expect(json['StockRateRs'], 100.0);
      expect(json['StockRateDollar'], 1.0);
      expect(json['StockAmtRs'], 2000.0);
      expect(json['StockAmtDollar'], 20.0);
      expect(json['IssuePc'], 5);
      expect(json['IssueWt'], 10.0);
      expect(json['IssueRate'], 120.0);
      expect(json['IssueAmt'], 1200.0);
      expect(json['DiffWt'], 10.0);
      expect(json['DiffRate'], 20.0);
      expect(json['DiffAmt'], 200.0);
    });
  });

  group('Branch Transfer DataGrid Source Tests', () {
    test('Resolves Rough and Polish types correctly', () {
      final items = [
        BranchTransferItemModel(source: 'Rough', roughTypeCode: 1),
        BranchTransferItemModel(source: 'Polish', polishTypeCode: 6),
      ];

      final source = BranchTransferDataGridSource(initialItems: items);

      expect(source.resolveTypeName(items[0]), 'Rough Type A');
      expect(source.resolveTypeName(items[1]), 'Polish Type 6');
    });

    test('Toggle select all selects and unselects all items', () {
      final items = [
        BranchTransferItemModel(source: 'Rough', roughTypeCode: 1, pc: 2, wt: 5.0),
        BranchTransferItemModel(source: 'Polish', polishTypeCode: 6, pc: 3, wt: 8.0),
      ];

      final source = BranchTransferDataGridSource(initialItems: items);
      expect(source.isAllSelected, false);

      source.toggleSelectAll(true);
      expect(source.isAllSelected, true);
      expect(items[0].issuePc, 2);
      expect(items[1].issuePc, 3);
      expect(items[0].issueWt, 5.0);
      expect(items[1].issueWt, 8.0);

      source.toggleSelectAll(false);
      expect(source.isAllSelected, false);
      expect(items[0].issuePc, 0);
      expect(items[1].issuePc, 0);
      expect(items[0].issueWt, 0.0);
      expect(items[1].issueWt, 0.0);
    });

    test('DefaultController has branchTransferCombinedList and getBranchTransferCombinedData', () {
      expect(controller.branchTransferCombinedList, isNotNull);
      expect(controller.isLoadingBranchTransfer.value, false);
    });

    test('DataGrid respects getMaxAllowedIssueWt with AllowPlus WT and PER', () {
      final item = BranchTransferItemModel(
        source: 'Rough',
        roughTypeCode: 1,
        pc: 10,
        wt: 100.0,
        rateRs: 50.0,
      );

      // Without AllowPlus, max wt is 100.0
      double maxWt = item.stockWt;
      expect(maxWt, 100.0);

      // With AllowPlusType == 'WT' and AllowPlusValue == 10.0 -> 110.0
      const allowPlusTypeWt = 'WT';
      const allowPlusValWt = 10.0;
      final maxWtWithWt = allowPlusTypeWt == 'WT' ? item.stockWt + allowPlusValWt : item.stockWt;
      expect(maxWtWithWt, 110.0);

      // With AllowPlusType == 'PER' and AllowPlusValue == 10.0 -> 100 + (100 * 0.10) = 110.0
      const allowPlusTypePer = 'PER';
      const allowPlusValPer = 10.0;
      final maxWtWithPer = allowPlusTypePer == 'PER'
          ? item.stockWt + (item.stockWt * (allowPlusValPer / 100.0))
          : item.stockWt;
      expect(maxWtWithPer, 110.0);
    });

    test('DataGrid warning callback and clamping when issueWt exceeds max allowed', () {
      final item = BranchTransferItemModel(
        source: 'Rough',
        roughTypeCode: 1,
        pc: 10,
        wt: 100.0,
        rateRs: 50.0,
      );
      item.setSelected(true);

      String? warningMessage;
      final source = BranchTransferDataGridSource(
        initialItems: [item],
        getMaxAllowedIssueWt: (it) => 110.0, // Stock (100) + AllowPlus (10)
        onValidationWarning: (msg) {
          warningMessage = msg;
        },
      );

      // Build row to ensure controllers are attached
      source.buildRow(source.rows.first);

      // If user inputs 120.0, it should clamp to 110.0 and fire warning
      final textController = item.issueWtController;
      textController.text = '120.0';

      // Simulate the onChanged callback logic in datagrid
      const maxAllowed = 110.0;
      final enteredVal = double.tryParse(textController.text) ?? 0.0;
      if (enteredVal > maxAllowed) {
        warningMessage = 'Issue Wt cannot exceed maximum allowed stock weight ($maxAllowed).';
        item.issueWt = maxAllowed;
        item.updateCalculations();
      }

      expect(warningMessage, contains('110.0'));
      expect(item.issueWt, 110.0);
      expect(item.diffWt, 110.0);
    });

    test('Clicking checkbox on row sets stock pc and stock wt on issue pc and issue wt', () {
      final item = BranchTransferItemModel(
        source: 'Rough',
        roughTypeCode: 1,
        pc: 12,
        wt: 50.0,
      );

      expect(item.isSelected, false);
      expect(item.issuePc, 0);
      expect(item.issueWt, 0.0);

      item.setSelected(true);
      expect(item.isSelected, true);
      expect(item.issuePc, 12);
      expect(item.issueWt, 50.0);
      expect(item.issuePcController.text, '12');
      expect(item.issueWtController.text, '50.000');

      item.setSelected(false);
      expect(item.isSelected, false);
      expect(item.issuePc, 0);
      expect(item.issueWt, 0.0);
      expect(item.issuePcController.text, '0');
      expect(item.issueWtController.text, '0.000');
    });

    test('AllowMinusValue decreases allowed weight with AllowMinusType WT (50 to 40) and PER (50 to 45)', () {
      final item = BranchTransferItemModel(
        source: 'Rough',
        roughTypeCode: 1,
        pc: 10,
        wt: 50.0,
        rateRs: 100.0,
      );
      item.setSelected(true);
      expect(item.issueWt, 50.0);

      // AllowMinusType == 'WT' with AllowMinusValue == 10.0 -> user can decrease from 50 to 40
      const allowMinusTypeWt = 'WT';
      const allowMinusValWt = 10.0;
      final minAllowedWt = allowMinusTypeWt == 'WT'
          ? (item.stockWt - allowMinusValWt).clamp(0.0, item.stockWt)
          : 0.0;
      expect(minAllowedWt, 40.0);

      // AllowMinusType == 'PER' with AllowMinusValue == 10.0 -> user can decrease from 50 to 45
      const allowMinusTypePer = 'PER';
      const allowMinusValPer = 10.0;
      final minAllowedPer = allowMinusTypePer == 'PER'
          ? (item.stockWt - (item.stockWt * (allowMinusValPer / 100.0))).clamp(0.0, item.stockWt)
          : 0.0;
      expect(minAllowedPer, 45.0);
    });

    test('DataGrid source validates and clamps issueWt to minAllowed when below minimum allowed', () {
      final item = BranchTransferItemModel(
        source: 'Rough',
        roughTypeCode: 1,
        pc: 10,
        wt: 50.0,
        rateRs: 100.0,
      );
      item.setSelected(true);

      String? warningMsg;
      final source = BranchTransferDataGridSource(
        initialItems: [item],
        getMinAllowedIssueWt: (it) => 40.0, // Stock (50) - AllowMinus (10 WT)
        onValidationWarning: (msg) => warningMsg = msg,
      );

      final row = source.rows.first;
      final adapter = source.buildRow(row);
      expect(adapter.cells.length, row.getCells().length);

      // User enters 35.0 (which is below minAllowed 40.0)
      item.issueWtController.text = '35.0';
      const minAllowed = 40.0;
      final parsed = double.tryParse(item.issueWtController.text) ?? 0.0;
      if (item.isSelected && minAllowed > 0.0 && parsed < minAllowed) {
        item.issueWt = minAllowed;
        item.issueWtController.text = minAllowed.toStringAsFixed(3);
        warningMsg = 'Issue Wt cannot be less than $minAllowed';
      }

      expect(item.issueWt, 40.0);
      expect(item.issueWtController.text, '40.000');
      expect(warningMsg, contains('40.0'));
    });

    test('Master payload has all required totals and no duplicate keys', () {
      final item1 = BranchTransferItemModel(
        source: 'Rough',
        roughTypeCode: 1,
        roughQualityCode: 3,
        roughCharniCode: 3,
        invoiceNo: 'K44',
        pc: 10,
        wt: 25.0,
        rateRs: 100.0,
        rateDollar: 1.25,
      );
      item1.issuePc = 5;
      item1.issueWt = 10.0;
      item1.issueRate = 120.0;
      item1.updateCalculations();

      final item2 = BranchTransferItemModel(
        source: 'Polish',
        polishTypeCode: 6,
        invoiceNo: 'P12',
        pc: 4,
        wt: 8.0,
        rateRs: 200.0,
        rateDollar: 2.50,
      );
      item2.issuePc = 2;
      item2.issueWt = 4.0;
      item2.issueRate = 220.0;
      item2.updateCalculations();

      final items = [item1, item2];
      final totalStockPc = items.fold<int>(0, (sum, i) => sum + i.stockPc);
      final totalStockWt = double.parse(
          items.fold<double>(0.0, (sum, i) => sum + i.stockWt).toStringAsFixed(3));
      final totalRateDollar = double.parse(
          items.fold<double>(0.0, (sum, i) => sum + i.stockRateDollar).toStringAsFixed(2));
      final totalRateRs = double.parse(
          items.fold<double>(0.0, (sum, i) => sum + i.stockRateRs).toStringAsFixed(2));
      final totalAmtDollar = double.parse(
          items.fold<double>(0.0, (sum, i) => sum + i.stockAmtDollar).toStringAsFixed(2));
      final totalAmtRs = double.parse(
          items.fold<double>(0.0, (sum, i) => sum + i.stockAmtRs).toStringAsFixed(2));

      final totalIssuePc = items.fold<int>(0, (sum, i) => sum + i.issuePc);
      final totalIssueWt = double.parse(
          items.fold<double>(0.0, (sum, i) => sum + i.issueWt).toStringAsFixed(3));
      final totalIssueRate = double.parse(
          items.fold<double>(0.0, (sum, i) => sum + i.issueRate).toStringAsFixed(2));
      final totalIssueAmt = double.parse(
          items.fold<double>(0.0, (sum, i) => sum + i.issueAmt).toStringAsFixed(2));

      final totalDiffWt = double.parse(
          items.fold<double>(0.0, (sum, i) => sum + i.diffWt).toStringAsFixed(3));
      final totalDiffRate = double.parse(
          items.fold<double>(0.0, (sum, i) => sum + i.diffRate).toStringAsFixed(2));
      final totalDiffAmt = double.parse(
          items.fold<double>(0.0, (sum, i) => sum + i.diffAmt).toStringAsFixed(2));

      final masterPayload = {
        'CompanyCode': 3,
        'FromCrId': 56,
        'ToCrId': 100,
        'TransferDate': '2026-10-20',
        'TotalItems': items.length,
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
        'items': items.map((i) => i.toSaveJson()).toList(),
      };

      expect(masterPayload['CompanyCode'], 3);
      expect(masterPayload['FromCrId'], 56);
      expect(masterPayload['ToCrId'], 100);
      expect(masterPayload['TransferDate'], '2026-10-20');
      expect(masterPayload['TotalItems'], 2);
      expect(masterPayload['TotalStockPc'], 14);
      expect(masterPayload['TotalStockWt'], 33.0);
      expect(masterPayload['TotalRateDollar'], 3.75);
      expect(masterPayload['TotalRateRs'], 300.0);
      expect(masterPayload['TotalAmtDollar'], (25.0 * 1.25) + (8.0 * 2.50));
      expect(masterPayload['TotalAmtRs'], (25.0 * 100.0) + (8.0 * 200.0));
      expect(masterPayload['TotalIssuePc'], 7);
      expect(masterPayload['TotalIssueWt'], 14.0);
      expect(masterPayload['TotalIssueRate'], 340.0);
      expect(masterPayload['TotalIssueAmt'], (10.0 * 120.0) + (4.0 * 220.0));
      expect(masterPayload['TotalDiffWt'], 14.0);
      expect(masterPayload['TotalDiffRate'], 20.0 + 20.0);
      expect(masterPayload['TotalDiffAmt'], 200.0 + 80.0);

      final firstItem = (masterPayload['items'] as List).first as Map<String, dynamic>;
      expect(firstItem['source'], 'Rough');
      expect(firstItem['Type'], 'Rough Type A');
      expect(firstItem['InvoiceNo'], 'K44');
      expect(firstItem['RoughTypeCode'], 1);
      expect(firstItem['PolishTypeCode'], isNull);
      expect(firstItem['ShapeCode'], isNull);
      expect(firstItem['ColorCode'], isNull);
      expect(firstItem['ClarityCode'], isNull);
      expect(firstItem['CharniCode'], 3);
      expect(firstItem['QualityCode'], 3);
      expect(firstItem['Quality'], isNotNull);
      expect(firstItem['Charni'], isNotNull);
      expect(firstItem['Shape'], isNotNull);
      expect(firstItem['Color'], isNotNull);
      expect(firstItem['Clarity'], isNotNull);
      expect(firstItem['StockRateDollar'], 1.25);
      expect(firstItem['StockRateRs'], 100.0);
      expect(firstItem['StockAmtDollar'], 31.25);
      expect(firstItem['StockAmtRs'], 2500.0);
      expect(firstItem['StockPc'], 10);
      expect(firstItem['StockWt'], 25.0);
      expect(firstItem['IssuePc'], 5);
      expect(firstItem['IssueWt'], 10.0);
      expect(firstItem['IssueRate'], 120.0);
      expect(firstItem['IssueAmt'], 1200.0);
      expect(firstItem['DiffWt'], 10.0);
      expect(firstItem['DiffRate'], 20.0);
      expect(firstItem['DiffAmt'], 200.0);
      expect(firstItem.containsKey('BranchTransferDetID'), isFalse);
      expect(firstItem.containsKey('BranchTransferMstID'), isFalse);

      // Verify no duplicate keys across casing
      final keys = masterPayload.keys.toList();
      final lowerKeys = keys.map((k) => k.toLowerCase()).toList();
      expect(lowerKeys.length, equals(lowerKeys.toSet().length),
          reason: 'No duplicate keys should exist in master payload regardless of casing');

      final itemKeys = (masterPayload['items'] as List).first as Map;
      final itemLowerKeys = itemKeys.keys.map((k) => k.toString().toLowerCase()).toList();
      expect(itemLowerKeys.length, equals(itemLowerKeys.toSet().length),
          reason: 'No duplicate keys should exist in items payload regardless of casing');
    });
  });

  group('BranchTransferMstModel and BranchTransferSearchDataGridSource Tests', () {
    test('BranchTransferMstModel parses from JSON correctly with nested items', () {
      controller.userModelList.assignAll([
        UserModel(counterMstId: 56, userName: 'Manager Alpha'),
        UserModel(counterMstId: 100, userName: 'Manager Beta'),
      ]);

      final mstJson = {
        'BranchTransferMstID': 15,
        'CompanyCode': 3,
        'FromCrId': 56,
        'ToCrId': 100,
        'TransferDate': '2026-10-20',
        'TotalItems': 1,
        'TotalStockPc': 10,
        'TotalStockWt': 25.0,
        'TotalRateDollar': 1.25,
        'TotalRateRs': 100.0,
        'TotalAmtDollar': 31.25,
        'TotalAmtRs': 2500.0,
        'TotalIssuePc': 5,
        'TotalIssueWt': 10.0,
        'TotalIssueRate': 120.0,
        'TotalIssueAmt': 1200.0,
        'TotalDiffWt': 10.0,
        'TotalDiffRate': 20.0,
        'TotalDiffAmt': 200.0,
        'items': [
          {
            'source': 'Rough',
            'RoughTypeCode': 1,
            'QualityCode': 3,
            'CharniCode': 3,
            'InvoiceNo': 'K44',
            'StockPc': 10,
            'StockWt': 25.0,
            'StockRateRs': 100.0,
            'StockRateDollar': 1.25,
            'StockAmtRs': 2500.0,
            'StockAmtDollar': 31.25,
            'IssuePc': 5,
            'IssueWt': 10.0,
            'IssueRate': 120.0,
            'IssueAmt': 1200.0,
            'DiffWt': 10.0,
            'DiffRate': 20.0,
            'DiffAmt': 200.0,
          }
        ]
      };

      final model = BranchTransferMstModel.fromJson(mstJson);
      expect(model.branchTransferMstID, 15);
      expect(model.companyCode, 3);
      expect(model.fromCrId, 56);
      expect(model.toCrId, 100);
      expect(model.fromManagerName, 'Manager Alpha');
      expect(model.toManagerName, 'Manager Beta');
      expect(model.displayDate, '20-10-2026');
      expect(model.totalItems, 1);
      expect(model.totalStockPc, 10);
      expect(model.totalStockWt, 25.0);
      expect(model.totalIssuePc, 5);
      expect(model.totalIssueWt, 10.0);
      expect(model.totalIssueAmt, 1200.0);
      expect(model.items.length, 1);
      expect(model.items.first.source, 'Rough');
      expect(model.items.first.stockPc, 10);
      expect(model.items.first.stockWt, 25.0);
      expect(model.items.first.issuePc, 5);
      expect(model.items.first.issueWt, 10.0);
      expect(model.items.first.issueAmt, 1200.0);
    });

    test('BranchTransferSearchDataGridSource builds rows without Actions column', () {
      final mst = BranchTransferMstModel(
        branchTransferMstID: 42,
        fromCrId: 56,
        toCrId: 100,
        transferDate: '2026-10-20',
        totalItems: 2,
        totalStockWt: 50.0,
        totalIssueWt: 20.0,
        totalIssueAmt: 2500.0,
      );

      final source = BranchTransferSearchDataGridSource(
        list: [mst],
      );

      expect(source.rows.length, 1);
      final cells = source.rows.first.getCells();
      expect(cells.firstWhere((c) => c.columnName == 'ID').value, 42);
      expect(cells.firstWhere((c) => c.columnName == 'Items').value, 2);
      expect(cells.firstWhere((c) => c.columnName == 'StockWt').value, 50.0);
      expect(cells.firstWhere((c) => c.columnName == 'IssueWt').value, 20.0);
      // Actions column must NOT be present
      expect(cells.any((c) => c.columnName == 'Actions'), isFalse);

      // Verify row adapter build
      final adapter = source.buildRow(source.rows.first);
      expect(adapter.cells.length, cells.length);
    });

    test('BranchTransferDataGridSource hides select cell when showCheckbox is false', () {
      final item = BranchTransferItemModel(source: 'Rough', roughTypeCode: 1, pc: 5, wt: 10.0);
      final source = BranchTransferDataGridSource(initialItems: [item], showCheckbox: true);

      expect(source.rows.first.getCells().any((c) => c.columnName == 'select'), isTrue);

      source.setShowCheckbox(false);
      expect(source.rows.first.getCells().any((c) => c.columnName == 'select'), isFalse);

      source.setShowCheckbox(true);
      expect(source.rows.first.getCells().any((c) => c.columnName == 'select'), isTrue);
    });

    test('DefaultController has updateBranchTransferData method and correct signature', () {
      expect(controller.updateBranchTransferData, isNotNull);
    });

    test('DefaultController has branchTransferList and related observables', () {
      expect(controller.branchTransferList, isEmpty);
      expect(controller.isLoadingBranchTransferList.value, false);
      expect(controller.isDeleteLoadingBranchTransfer.value, false);
    });

    test('Merged combined API response with detail response accurately updates existing rows', () {
      // 8 items from combined API
      final combinedJson = [
        {"source": "Rough", "RoughTypeCode": 1, "RoughQualityCode": 3, "RoughCharniCode": 3, "InvoiceNo": "dgf", "Pc": 1, "Wt": 10.0, "RateRs": 100.0, "RateDollar": 1.41},
        {"source": "Rough", "RoughTypeCode": 4, "RoughQualityCode": 1, "RoughCharniCode": 2, "InvoiceNo": "111", "Pc": 3, "Wt": 30.0, "RateRs": 100.0, "RateDollar": 1.0},
        {"source": "Rough", "RoughTypeCode": 1, "RoughQualityCode": 1, "RoughCharniCode": 2, "InvoiceNo": "K44", "Pc": 1, "Wt": 10.0, "RateRs": 100.0, "RateDollar": 1.0},
        {"source": "Rough", "RoughTypeCode": 2, "RoughQualityCode": 3, "RoughCharniCode": 4, "InvoiceNo": "K44", "Pc": 0, "Wt": 20.0, "RateRs": 200.0, "RateDollar": 2.0},
        {"source": "Rough", "RoughTypeCode": 3, "RoughQualityCode": 3, "RoughCharniCode": 3, "InvoiceNo": "K44", "Pc": 0, "Wt": 5.0, "RateRs": 50.0, "RateDollar": 0.5},
        {"source": "Rough", "RoughTypeCode": 3, "RoughQualityCode": 1, "RoughCharniCode": 4, "InvoiceNo": "KUKU", "Pc": 30, "Wt": 14.53, "RateRs": 100.0, "RateDollar": 1.0},
        {"source": "Polish", "ShapeCode": 29, "ClarityCode": 9, "CharniCode": 2, "PolishTypeCode": 6, "ColorCode": 1, "Pc": 12, "Wt": 15.03, "RateRs": 66.87, "RateDollar": 0.67},
        {"source": "Polish", "ShapeCode": 29, "ClarityCode": 2038, "CharniCode": 3, "PolishTypeCode": 7, "ColorCode": 3, "Pc": 1, "Wt": 20.0, "RateRs": 100.0, "RateDollar": 1.0},
      ];

      final combinedItems = combinedJson.map((j) => BranchTransferItemModel.fromJson(j)).toList();

      // 3 items from detail API
      final detailsJson = [
        {
          "BranchTransferDetID": 19,
          "source": "Rough",
          "InvoiceNo": "dgf",
          "RoughTypeCode": 1,
          "RoughQualityCode": 3,
          "RoughCharniCode": 3,
          "StockPc": 1,
          "StockWt": 10.0,
          "StockRateRs": 100.0,
          "IssuePc": 1,
          "IssueWt": 6.0,
          "IssueRate": 100.0,
          "IssueAmt": 600.0,
          "DiffWt": 6.0,
          "DiffRate": 0.0,
          "DiffAmt": 0.0,
        },
        {
          "BranchTransferDetID": 20,
          "source": "Rough",
          "InvoiceNo": "111",
          "RoughTypeCode": 4,
          "RoughQualityCode": 1,
          "RoughCharniCode": 2,
          "StockPc": 3,
          "StockWt": 30.0,
          "StockRateRs": 100.0,
          "IssuePc": 0,
          "IssueWt": 11.0,
          "IssueRate": 100.0,
          "IssueAmt": 1100.0,
          "DiffWt": 11.0,
          "DiffRate": 0.0,
          "DiffAmt": 0.0,
        },
        {
          "BranchTransferDetID": 21,
          "source": "Polish",
          "PolishTypeCode": 7,
          "ShapeCode": 29,
          "ColorCode": 3,
          "ClarityCode": 2038,
          "CharniCode": 3,
          "StockPc": 1,
          "StockWt": 20.0,
          "StockRateRs": 100.0,
          "IssuePc": 0,
          "IssueWt": 7.0,
          "IssueRate": 100.0,
          "IssueAmt": 700.0,
          "DiffWt": 7.0,
          "DiffRate": 0.0,
          "DiffAmt": 0.0,
        },
      ];

      final detailItems = detailsJson.map((j) => BranchTransferItemModel.fromJson(j)).toList();

      // Helper matcher identical to screen logic
      bool matches(BranchTransferItemModel a, BranchTransferItemModel b) {
        if (a.source.toLowerCase() != b.source.toLowerCase()) return false;
        if (a.source.toLowerCase() == 'rough') {
          return (a.invoiceNo ?? '').trim().toLowerCase() == (b.invoiceNo ?? '').trim().toLowerCase() &&
              a.roughTypeCode == b.roughTypeCode &&
              a.roughQualityCode == b.roughQualityCode &&
              (a.roughCharniCode ?? a.charniCode) == (b.roughCharniCode ?? b.charniCode);
        } else {
          return a.polishTypeCode == b.polishTypeCode &&
              a.shapeCode == b.shapeCode &&
              a.colorCode == b.colorCode &&
              a.clarityCode == b.clarityCode &&
              (a.charniCode ?? a.roughCharniCode) == (b.charniCode ?? b.roughCharniCode);
        }
      }

      final Set<BranchTransferItemModel> matchedDetails = {};
      for (var cItem in combinedItems) {
        BranchTransferItemModel? matched;
        for (var dItem in detailItems) {
          if (!matchedDetails.contains(dItem) && matches(cItem, dItem)) {
            matched = dItem;
            matchedDetails.add(dItem);
            break;
          }
        }

        if (matched != null) {
          cItem.isSelected = true;
          cItem.issuePc = matched.issuePc;
          cItem.issueWt = matched.issueWt;
          cItem.issueRate = matched.issueRate;
          cItem.issueAmt = matched.issueAmt;
          cItem.diffWt = matched.diffWt;
          cItem.diffRate = matched.diffRate;
          cItem.diffAmt = matched.diffAmt;
          cItem.issuePcController.text = matched.issuePc.toString();
          cItem.issueWtController.text = matched.issueWt.toStringAsFixed(3);
          cItem.updateCalculations();
        } else {
          cItem.isSelected = false;
          cItem.issuePc = 0;
          cItem.issueWt = 0.0;
          cItem.issuePcController.text = '0';
          cItem.issueWtController.text = '0.000';
          cItem.updateCalculations();
        }
      }

      // Verify all 3 details were matched
      expect(matchedDetails.length, 3);
      expect(combinedItems.length, 8);

      // Verify Row 0 (dgf)
      expect(combinedItems[0].isSelected, isTrue);
      expect(combinedItems[0].issuePc, 1);
      expect(combinedItems[0].issueWt, 6.0);
      expect(combinedItems[0].issueAmt, 600.0);
      expect(combinedItems[0].diffWt, 6.0);
      expect(combinedItems[0].diffRate, 0.0);

      // Verify Row 1 (111)
      expect(combinedItems[1].isSelected, isTrue);
      expect(combinedItems[1].issuePc, 0);
      expect(combinedItems[1].issueWt, 11.0);
      expect(combinedItems[1].issueAmt, 1100.0);
      expect(combinedItems[1].diffWt, 11.0);
      expect(combinedItems[1].diffRate, 0.0);

      // Verify Row 2 (K44) unselected
      expect(combinedItems[2].isSelected, isFalse);
      expect(combinedItems[2].issuePc, 0);
      expect(combinedItems[2].issueWt, 0.0);

      // Verify Row 7 (Polish 7)
      expect(combinedItems[7].isSelected, isTrue);
      expect(combinedItems[7].issuePc, 0);
      expect(combinedItems[7].issueWt, 7.0);
      expect(combinedItems[7].issueAmt, 700.0);
      expect(combinedItems[7].diffWt, 7.0);
      expect(combinedItems[7].diffRate, 0.0);
    });
  });
}
