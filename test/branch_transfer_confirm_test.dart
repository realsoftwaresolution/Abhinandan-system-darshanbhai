import 'package:flutter_test/flutter_test.dart';
import 'package:real_web_rough_entry_system/branch_transfer_confirm/branch_transfer_confirm_datagrid.dart';
import 'package:real_web_rough_entry_system/branch_transfer_confirm/branch_transfer_confirm_item_model.dart';
import 'package:real_web_rough_entry_system/branch_transfer_confirm/branch_transfer_confirm_mst_model.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:get/get.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BranchTransferConfirmItemModel Tests', () {
    final roughJson = {
      "BranchTransferDetID": 101,
      "BranchTransferMstID": 12,
      "source": "Rough",
      "InvoiceNo": "INV-00123",
      "RoughTypeCode": "RT01",
      "RoughQualityCode": "Q01",
      "RoughCharniCode": "C01",
      "StockPc": 10,
      "StockWt": 150.25,
      "StockRateRs": 300.00,
      "StockRateDollar": 4.00,
      "StockAmtRs": 45075.00,
      "StockAmtDollar": 600.00,
      "IssuePc": 9,
      "IssueWt": 145.00,
      "IssueRate": 299.50,
      "IssueAmt": 43827.50,
      "DiffWt": 5.25,
      "DiffRate": 0.50,
      "DiffAmt": 262.50,
      "BranchTransformConfirm": false,
      "BranchTransferConfirmMstId": null,
      "ToCrId": 5,
    };

    final polishJson = {
      "BranchTransferDetID": 102,
      "BranchTransferMstID": 12,
      "source": "Polish",
      "InvoiceNo": "INV-00123",
      "PolishTypeCode": "PT02",
      "ShapeCode": "SH01",
      "ColorCode": "CL01",
      "ClarityCode": "CLAR01",
      "CharniCode": "CH02",
      "StockPc": 10,
      "StockWt": 150.25,
      "StockRateRs": 300.00,
      "StockRateDollar": 4.00,
      "StockAmtRs": 45075.00,
      "StockAmtDollar": 600.00,
      "IssuePc": 11,
      "IssueWt": 155.00,
      "IssueRate": 300.50,
      "IssueAmt": 46577.50,
      "DiffWt": -4.75,
      "DiffRate": -0.50,
      "DiffAmt": -237.50,
      "BranchTransformConfirm": false,
      "BranchTransferConfirmMstId": null,
      "ToCrId": 5,
    };

    test('Parses Rough and Polish items accurately from user JSON', () {
      final roughItem = BranchTransferConfirmItemModel.fromJson(roughJson);
      expect(roughItem.branchTransferDetID, 101);
      expect(roughItem.branchTransferMstID, 12);
      expect(roughItem.source, 'Rough');
      expect(roughItem.invoiceNo, 'INV-00123');
      expect(roughItem.roughTypeCode, 'RT01');
      expect(roughItem.roughQualityCode, 'Q01');
      expect(roughItem.roughCharniCode, 'C01');
      expect(roughItem.stockPc, 10);
      expect(roughItem.stockWt, 150.25);
      expect(roughItem.stockRateRs, 300.00);
      expect(roughItem.stockRateDollar, 4.00);
      expect(roughItem.stockAmtRs, 45075.00);
      expect(roughItem.stockAmtDollar, 600.00);
      expect(roughItem.issuePc, 9);
      expect(roughItem.issueWt, 145.00);
      expect(roughItem.issueRate, 299.50);
      expect(roughItem.issueAmt, 43827.50);
      expect(roughItem.diffWt, 5.25);
      expect(roughItem.diffRate, 0.50);
      expect(roughItem.diffAmt, 262.50);
      expect(roughItem.branchTransformConfirm, false);
      expect(roughItem.toCrId, 5);
      expect(roughItem.isSelected, false); // items default to unselected

      final polishItem = BranchTransferConfirmItemModel.fromJson(polishJson);
      expect(polishItem.branchTransferDetID, 102);
      expect(polishItem.source, 'Polish');
      expect(polishItem.polishTypeCode, 'PT02');
      expect(polishItem.shapeCode, 'SH01');
      expect(polishItem.colorCode, 'CL01');
      expect(polishItem.clarityCode, 'CLAR01');
      expect(polishItem.charniCode, 'CH02');
      expect(polishItem.issuePc, 11);
      expect(polishItem.issueWt, 155.00);
      expect(polishItem.diffWt, -4.75);
    });

    test('Resolves names falling back to raw codes when not in master cache', () {
      final roughItem = BranchTransferConfirmItemModel.fromJson(roughJson);
      expect(roughItem.resolveTypeName(), 'RT01');
      expect(roughItem.resolveQualityName(), 'Q01');
      expect(roughItem.resolveCharniName(), 'C01');

      final polishItem = BranchTransferConfirmItemModel.fromJson(polishJson);
      expect(polishItem.resolveTypeName(), 'PT02');
      expect(polishItem.resolveShapeName(), 'SH01');
      expect(polishItem.resolveColorName(), 'CL01');
      expect(polishItem.resolveClarityName(), 'CLAR01');
      expect(polishItem.resolveCharniName(), 'CH02');
    });
  });

  group('BranchTransferConfirmMstModel Tests', () {
    final mstJson = {
      "BranchTransferConfirmMstID": 1,
      "ToCrId": 5,
      "ManagerName": "Devang",
      "CreatedAt": "2026-10-20T12:00:00.000Z",
    };

    test('Parses Master JSON correctly', () {
      final model = BranchTransferConfirmMstModel.fromJson(mstJson);
      expect(model.branchTransferConfirmMstID, 1);
      expect(model.toCrId, 5);
      expect(model.managerName, 'Devang');
      expect(model.resolvedManagerName, 'Devang');
      expect(model.createdAt, '2026-10-20T12:00:00.000Z');
      expect(model.displayDate, contains('2026'));
    });
  });

  group('BranchTransferConfirmDataGridSource Tests', () {
    test('Toggle select all selects and deselects items', () {
      final items = [
        BranchTransferConfirmItemModel(
          branchTransferDetID: 101,
          source: 'Rough',
          isSelected: false,
        ),
        BranchTransferConfirmItemModel(
          branchTransferDetID: 102,
          source: 'Polish',
          isSelected: false,
        ),
      ];

      final source = BranchTransferConfirmDataGridSource(
        initialItems: items,
        isEnabled: true,
      );

      expect(source.isAllSelected, false);
      expect(source.hasSomeSelected, false);

      source.toggleSelectAll(true);
      expect(source.isAllSelected, true);
      expect(source.hasSomeSelected, true);
      expect(items.every((i) => i.isSelected), true);

      source.toggleSelectAll(false);
      expect(source.isAllSelected, false);
      expect(source.hasSomeSelected, false);
      expect(items.every((i) => !i.isSelected), true);
    });

    test('Creates expected number of rows and cells', () {
      final items = [
        BranchTransferConfirmItemModel(
          branchTransferDetID: 101,
          source: 'Rough',
          stockPc: 10,
          stockWt: 100.0,
          issuePc: 10,
          issueWt: 100.0,
          isSelected: true,
        ),
      ];

      final source = BranchTransferConfirmDataGridSource(
        initialItems: items,
        isEnabled: true,
        showCheckbox: true,
      );

      expect(source.rows.length, 1);
      final cells = source.rows.first.getCells();
      expect(cells.any((c) => c.columnName == 'select'), true);
      expect(cells.any((c) => c.columnName == 'source'), true);
      expect(cells.any((c) => c.columnName == 'stockPc'), true);
      expect(cells.any((c) => c.columnName == 'stockWt'), true);
      expect(cells.any((c) => c.columnName == 'issuePc'), true);
      expect(cells.any((c) => c.columnName == 'issueWt'), true);
    });

    test('SearchDataGridSource has ToCrId and triggers onDoubleTap', () {
      bool doubleTapped = false;
      BranchTransferConfirmMstModel? tappedItem;

      final mstList = [
        BranchTransferConfirmMstModel(
          branchTransferConfirmMstID: 42,
          toCrId: 5,
          managerName: 'Devang',
          createdAt: '2026-10-20',
        ),
      ];

      final searchSource = BranchTransferConfirmSearchDataGridSource(
        list: mstList,
        onDoubleTap: (item) {
          doubleTapped = true;
          tappedItem = item;
        },
      );

      expect(searchSource.rows.length, 1);
      final cells = searchSource.rows.first.getCells();
      expect(cells.any((c) => c.columnName == 'ID' && c.value == 42), true);
      expect(cells.any((c) => c.columnName == 'ToCrId' && c.value == 5), true);
      expect(cells.any((c) => c.columnName == 'ManagerName'), true);

      searchSource.onDoubleTap!(mstList.first);
      expect(doubleTapped, true);
      expect(tappedItem?.branchTransferConfirmMstID, 42);
    });
  });

  group('DefaultController Confirm API Signatures Tests', () {
    test('DefaultController has confirm observables and methods', () {
      final ctrl = Get.put(DefaultController());
      expect(ctrl.branchTransferConfirmList, isNotNull);
      expect(ctrl.isLoadingBranchTransferConfirmList.value, false);
      expect(ctrl.isLoadingBranchTransferConfirmDetails.value, false);
      expect(ctrl.isSavingBranchTransferConfirm.value, false);
      expect(ctrl.getBranchTransferConfirmDetailsById, isNotNull);
    });
  });
}
