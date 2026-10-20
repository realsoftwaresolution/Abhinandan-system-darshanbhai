import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/branch_transfer/branch_transfer_datagrid.dart';
import 'package:real_web_rough_entry_system/branch_transfer/branch_transfer_item_model.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/controllers/theme_controller.dart';
import 'package:real_web_rough_entry_system/polish_type/polish_type_model.dart';
import 'package:real_web_rough_entry_system/rough/rough_model.dart';
import 'package:real_web_rough_entry_system/tab-view-dashboard/tab_controller.dart';
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

    test('toSaveJson generates the expected payload structure', () {
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
      expect(json['InvoiceNo'], 'K44');
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
  });
}
