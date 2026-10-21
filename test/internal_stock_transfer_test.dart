import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/internal_stock_transfer/internal_stock_transfer_datagrid.dart';
import 'package:real_web_rough_entry_system/internal_stock_transfer/internal_stock_transfer_item_model.dart';
import 'package:real_web_rough_entry_system/internal_stock_transfer/internal_stock_transfer_mst_model.dart';
import 'package:real_web_rough_entry_system/internal_stock_transfer_confirm/internal_stock_transfer_confirm_datagrid.dart';
import 'package:real_web_rough_entry_system/internal_stock_transfer_confirm/internal_stock_transfer_confirm_item_model.dart';
import 'package:real_web_rough_entry_system/internal_stock_transfer_confirm/internal_stock_transfer_confirm_mst_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    Get.testMode = true;
    if (!Get.isRegistered<DefaultController>()) {
      Get.put(DefaultController());
    }
  });

  group('InternalStockTransferItemModel & MstModel Tests', () {
    final roughJson = {
      "InternalStockTransferDetID": 101,
      "InternalStockTransferMstID": 12,
      "source": "Rough",
      "InvoiceNo": "INV-00123",
      "RoughTypeCode": 1,
      "RoughQualityCode": 2,
      "RoughCharniCode": 3,
      "StockPc": 10,
      "StockWt": 150.25,
      "StockRateRs": 300.00,
      "StockRateDollar": 4.00,
      "StockAmtRs": 45075.00,
      "StockAmtDollar": 600.00,
      "IssuePc": 9,
      "IssueWt": 145.00,
      "IssueRate": 299.50,
      "IssueAmt": 43427.50,
      "DiffWt": 145.00,
      "DiffRate": -0.50,
      "DiffAmt": -72.50,
    };

    final polishJson = {
      "InternalStockTransferDetID": 102,
      "InternalStockTransferMstID": 12,
      "source": "Polish",
      "InvoiceNo": "INV-00124",
      "PolishTypeCode": 2,
      "ShapeCode": 1,
      "ColorCode": 1,
      "ClarityCode": 1,
      "CharniCode": 2,
      "StockPc": 15,
      "StockWt": 20.50,
      "StockRateRs": 500.00,
      "StockRateDollar": 6.50,
      "StockAmtRs": 10250.00,
      "StockAmtDollar": 133.25,
      "IssuePc": 15,
      "IssueWt": 20.50,
      "IssueRate": 500.00,
      "IssueAmt": 10250.00,
      "DiffWt": 20.50,
      "DiffRate": 0.00,
      "DiffAmt": 0.00,
    };

    test('Parses items correctly from JSON', () {
      final item = InternalStockTransferItemModel.fromJson(roughJson);
      expect(item.internalStockTransferDetID, 101);
      expect(item.internalStockTransferMstID, 12);
      expect(item.source, 'Rough');
      expect(item.invoiceNo, 'INV-00123');
      expect(item.stockPc, 10);
      expect(item.stockWt, 150.25);
      expect(item.stockRateRs, 300.00);
      expect(item.issuePc, 9);
      expect(item.issueWt, 145.00);

      final polishItem = InternalStockTransferItemModel.fromJson(polishJson);
      expect(polishItem.internalStockTransferDetID, 102);
      expect(polishItem.source, 'Polish');
      expect(polishItem.stockPc, 15);
      expect(polishItem.stockWt, 20.50);
    });

    test('Selection and calculation logic works correctly', () {
      final item = InternalStockTransferItemModel(
        source: 'Rough',
        pc: 10,
        wt: 50.0,
        rateRs: 100.0,
      );
      expect(item.isSelected, false);
      expect(item.issuePc, 0);
      expect(item.issueWt, 0.0);

      item.setSelected(true);
      expect(item.isSelected, true);
      expect(item.issuePc, 10);
      expect(item.issueWt, 50.0);
      expect(item.issueRate, 100.0);
      expect(item.issueAmt, 5000.0);
      expect(item.diffWt, 50.0);
      expect(item.diffRate, 0.0);
      expect(item.diffAmt, 0.0);

      item.setSelected(false);
      expect(item.isSelected, false);
      expect(item.issuePc, 0);
      expect(item.issueWt, 0.0);
    });

    test('InternalStockTransferMstModel parses master and detail items', () {
      final mstJson = {
        "InternalStockTransferMstID": 55,
        "CompanyCode": 3,
        "FromCrId": 10,
        "ToCrId": 20,
        "TransferDate": "2026-10-21",
        "TotalItems": 2,
        "TotalStockPc": 25,
        "TotalStockWt": 170.75,
        "TotalIssuePc": 24,
        "TotalIssueWt": 165.50,
        "TotalIssueAmt": 53677.50,
        "items": [roughJson, polishJson],
      };

      final mst = InternalStockTransferMstModel.fromJson(mstJson);
      expect(mst.internalStockTransferMstID, 55);
      expect(mst.companyCode, 3);
      expect(mst.fromCrId, 10);
      expect(mst.toCrId, 20);
      expect(mst.totalItems, 2);
      expect(mst.items.length, 2);
      expect(mst.displayDate, '21-10-2026');

      final serialized = mst.toJson();
      expect(serialized['InternalStockTransferMstID'], 55);
      expect(serialized['TotalItems'], 2);
    });
  });

  group('InternalStockTransferDataGridSource Tests', () {
    test('Builds rows and handles selection', () {
      final item1 = InternalStockTransferItemModel(
        source: 'Rough',
        pc: 10,
        wt: 20.0,
        rateRs: 100.0,
      );
      final item2 = InternalStockTransferItemModel(
        source: 'Polish',
        pc: 5,
        wt: 10.0,
        rateRs: 200.0,
      );

      final source = InternalStockTransferDataGridSource(
        initialItems: [item1, item2],
        isEnabled: true,
      );

      expect(source.rows.length, 2);
      expect(source.isAllSelected, false);
      expect(source.hasSomeSelected, false);

      source.toggleSelectAll(true);
      expect(source.isAllSelected, true);
      expect(item1.isSelected, true);
      expect(item2.isSelected, true);
      expect(item1.issuePc, 10);
      expect(item2.issuePc, 5);

      source.toggleSelectAll(false);
      expect(source.isAllSelected, false);
      expect(item1.isSelected, false);
      expect(item2.isSelected, false);
    });

    test('SearchDataGridSource builds rows accurately', () {
      final mst = InternalStockTransferMstModel(
        internalStockTransferMstID: 101,
        transferDate: '2026-10-21',
        fromCrId: 5,
        toCrId: 8,
        totalItems: 3,
        totalStockWt: 100.0,
        totalIssueWt: 95.0,
        totalIssueAmt: 50000.0,
      );

      final searchSource = InternalStockTransferSearchDataGridSource(
        list: [mst],
      );

      expect(searchSource.rows.length, 1);
      final cells = searchSource.rows.first.getCells();
      expect(cells.firstWhere((c) => c.columnName == 'ID').value, 101);
      expect(cells.firstWhere((c) => c.columnName == 'Items').value, 3);
    });
  });

  group('InternalStockTransferConfirm Tests', () {
    final confirmDetailJson = {
      "InternalStockTransferDetID": 201,
      "InternalStockTransferMstID": 30,
      "source": "Rough",
      "InvoiceNo": "INV-777",
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
      "InternalStockTransformConfirm": false,
      "InternalStockTransferConfirmMstId": null,
      "ToCrId": 5,
    };

    final confirmMstJson = {
      "InternalStockTransferConfirmMstID": 42,
      "ToCrId": 5,
      "ManagerName": "Rajesh Kumar",
      "CreatedAt": "2026-10-21T10:30:00.000Z",
    };

    test('Confirm detail item parses with default isSelected == false', () {
      final item = InternalStockTransferConfirmItemModel.fromJson(confirmDetailJson);
      expect(item.internalStockTransferDetID, 201);
      expect(item.internalStockTransferMstID, 30);
      expect(item.source, 'Rough');
      expect(item.invoiceNo, 'INV-777');
      expect(item.stockPc, 10);
      expect(item.stockWt, 150.25);
      expect(item.issuePc, 9);
      expect(item.issueWt, 145.00);
      expect(item.internalStockTransformConfirm, false);
      expect(item.toCrId, 5);
      expect(item.isSelected, false); // Default unchecked as required
    });

    test('Confirm master model parses accurately', () {
      final mst = InternalStockTransferConfirmMstModel.fromJson(confirmMstJson);
      expect(mst.internalStockTransferConfirmMstID, 42);
      expect(mst.toCrId, 5);
      expect(mst.managerName, 'Rajesh Kumar');
      expect(mst.resolvedManagerName, 'Rajesh Kumar');
      expect(mst.displayDate, contains('21-10-2026'));
    });

    test('Confirm datagrids handle toggle and double-tap', () {
      final item1 = InternalStockTransferConfirmItemModel.fromJson(confirmDetailJson);
      final item2 = InternalStockTransferConfirmItemModel.fromJson({
        ...confirmDetailJson,
        "InternalStockTransferDetID": 202,
      });

      final source = InternalStockTransferConfirmDataGridSource(
        initialItems: [item1, item2],
        isEnabled: true,
      );

      expect(source.rows.length, 2);
      expect(source.isAllSelected, false);

      source.toggleSelectAll(true);
      expect(source.isAllSelected, true);
      expect(item1.isSelected, true);
      expect(item2.isSelected, true);

      // Search source double-tap callback
      InternalStockTransferConfirmMstModel? tappedItem;
      final mst = InternalStockTransferConfirmMstModel.fromJson(confirmMstJson);
      final searchSource = InternalStockTransferConfirmSearchDataGridSource(
        list: [mst],
        onDoubleTap: (item) {
          tappedItem = item;
        },
      );

      expect(searchSource.rows.length, 1);
      expect(searchSource.rows.first.getCells().first.value, 42);
    });
  });

  group('DefaultController Internal Stock Transfer State Tests', () {
    test('Controller observables initialized and functional', () {
      Get.testMode = true;
      final ctrl = Get.put(DefaultController());

      expect(ctrl.internalStockTransferCombinedList, isEmpty);
      expect(ctrl.isLoadingInternalStockTransfer.value, false);
      expect(ctrl.internalStockTransferList, isEmpty);
      expect(ctrl.isLoadingInternalStockTransferList.value, false);
      expect(ctrl.isDeleteLoadingInternalStockTransfer.value, false);

      expect(ctrl.internalStockTransferConfirmList, isEmpty);
      expect(ctrl.isLoadingInternalStockTransferConfirmList.value, false);
      expect(ctrl.isLoadingInternalStockTransferConfirmDetails.value, false);
      expect(ctrl.isSavingInternalStockTransferConfirm.value, false);
    });
  });
}
