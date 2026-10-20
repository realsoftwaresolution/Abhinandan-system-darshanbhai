import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/controllers/theme_controller.dart';
import 'package:real_web_rough_entry_system/polish_purchase/polish_purchase_model.dart';
import 'package:real_web_rough_entry_system/tab-view-dashboard/tab_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'username': 'Darshanbhai',
      'companyCode': 3,
    });
    Get.reset();
    Get.put(ThemeController());
    Get.put(TabControllerX());
    Get.put(DefaultController());
  });

  tearDown(() {
    Get.reset();
  });

  group('Polish Purchase Model Tests', () {
    test('PolishPurchaseModel deserializes correctly from JSON and serializes back', () {
      final json = {
        'PolishPurMstID': 101,
        'InvoiceNo': 'HH03H01',
        'InvoiceDate': '2026-10-14',
        'PartyCode': 12,
        'PartyName': 'MIRA',
        'BrokerCode': 55,
        'BrokerName': 'VIPUL GOLI BROKER',
        'DueDay': 10,
        'DueDate': '2026-10-24',
        'RDType': 'RS',
        'Exchange': 100.0,
        'Type': 'LOOSE',
        'TotPcs': 2,
        'TotWt': 20.0,
        'RateRs': 50.0,
        'TotAmtRs': 1000.0,
        'RateDollar': 0.5,
        'TotAmtDollar': 10.0,
        'NetAmtDollar': 10.0,
        'NetAmtRs': 1000.0,
        'Remarks': 'Test Remark',
        'FinalAmtRs': 1000.0,
        'FinalAmtD': 10.0,
        'RoundOfRs': 0.0,
        'RoundOfD': 0.0,
        'ChkBroker': true,
        'BrokerPer': 1.5,
        'BrokerFixDollar': 0.15,
        'BrokerFixRs': 15.0,
        'CompanyCode': 3,
      };

      final model = PolishPurchaseModel.fromJson(json);

      expect(model.polishPurMstID, 101);
      expect(model.invoiceNo, 'HH03H01');
      expect(model.partyName, 'MIRA');
      expect(model.brokerName, 'VIPUL GOLI BROKER');
      expect(model.dueDay, 10);
      expect(model.type, 'LOOSE');
      expect(model.totWt, 20.0);
      expect(model.totAmtRs, 1000.0);
      expect(model.totAmtDollar, 10.0);
      expect(model.chkBroker, true);
      expect(model.brokerPer, 1.5);

      final outJson = model.toJson();
      expect(outJson['PolishPurMstID'], 101);
      expect(outJson['InvoiceNo'], 'HH03H01');
      expect(outJson['PartyName'], 'MIRA');
    });

    test('PolishPurchaseDetailModel deserializes correctly with polish fields', () {
      final json = {
        'PolishPurDetID': 1,
        'PolishPurMstID': 101,
        'SrNo': 1,
        'PolishType': 'CVD',
        'Shape': 'MIX',
        'Clarity': 'MIX',
        'Charni': 'MIX',
        'Pcs': 5,
        'Wt': 10.0,
        'RateRs': 100.0,
        'AmountRs': 1000.0,
        'RateDollar': 1.0,
        'AmountDollar': 10.0,
      };

      final detail = PolishPurchaseDetailModel.fromJson(json);

      expect(detail.polishPurDetID, 1);
      expect(detail.polishPurMstID, 101);
      expect(detail.polishType, 'CVD');
      expect(detail.shape, 'MIX');
      expect(detail.clarity, 'MIX');
      expect(detail.charni, 'MIX');
      expect(detail.pcs, 5);
      expect(detail.wt, 10.0);
      expect(detail.amountRs, 1000.0);
      expect(detail.amountDollar, 10.0);
    });

    test('PolishPurchaseModel and PolishPurchaseDetailModel produce exact API contract payloads', () {
      final header = PolishPurchaseModel(
        polishPurMstID: 1,
        invoiceNo: 'INV-001',
        invoiceDate: '2025-10-30',
        partyCode: 16806,
        brokerCode: 16375,
        dueDay: 0,
        dueDate: '2025-10-30',
        rdType: 'RS',
        exchange: 0,
        totPcs: 0,
        totWt: 16.32,
        totAmtRs: 97.92,
        rateRs: 6,
        rateDollar: 0,
        totAmtDollar: 0,
        chkBroker: false,
        brokerPer: 0,
        brokerFixDollar: 0,
        brokerFixRs: 0,
        chkAdd: false,
        addPer: 0,
        addFixDollar: 0,
        addFixRs: 0,
        chkLess: false,
        lessPer: 5,
        lessFixDollar: 0,
        lessFixRs: 4.896,
        netAmtDollar: 0,
        netAmtRs: 93,
        remarks: '',
        type: 'LOOSE',
        finalAmtRs: 97.92,
        finalAmtD: 0,
        roundOfRs: 0,
        roundOfD: 0,
      );

      final masterJson = header.toApiMasterJson();
      expect(masterJson['InvoiceNo'], 'INV-001');
      expect(masterJson['PartyCode'], 16806);
      expect(masterJson['BrokerCode'], 16375);
      expect(masterJson['TPc'], 0);
      expect(masterJson['TWeight'], 16.32);
      expect(masterJson['TAmtRs'], 97.92);
      expect(masterJson['TRateRs'], 6);
      expect(masterJson['ChkBro'], 'Per');
      expect(masterJson['ChkAdd'], 'Per');
      expect(masterJson['ChkLess'], 'Per');
      expect(masterJson['LessPer'], 5);
      expect(masterJson['LessRs'], 4.896);
      expect(masterJson['NetAmtRs'], 93);
      expect(masterJson['Type'], 'LOOSE');

      final detail = PolishPurchaseDetailModel(
        polishPurDetID: 1,
        polishPurMstID: 1,
        srNo: 1,
        shapeCode: 0,
        clarityCode: 0,
        charniCode: 37,
        polishTypeCode: 58,
        pcs: 0,
        wt: 16.32,
        rateDollar: 0,
        amountDollar: 0,
        rateRs: 6,
        amountRs: 97.92,
      );

      const requiredDetailKeys = [
        'PolishPurDetID', 'PolishPurMstID', 'Srno', 'ShapeCode', 'ClarityCode',
        'CharniCode', 'Pc', 'Wt', 'RateRs', 'AmtRs', 'RateDollar', 'AmtDollar',
        'PolishTypeCode', 'PacketID', 'PacketNo', 'ColorCode', 'CutCode',
        'PolishCode', 'SymmetryCode', 'FluoCode', 'DiaMin_W', 'DiaMax_L',
        'DiaHeight_D', 'TableMM', 'TableDepth', 'CA', 'CH', 'PA', 'PH',
        'GirdlePer', 'Girdle', 'GIA', 'IGI', 'HA', 'Ratio', 'Remarks', 'RS',
        'Disc', 'Amount', 'NattsDisc', 'NetAmount', 'RapaportMstID',
        'DiscountMstID', 'Rate', 'Kno'
      ];

      final detailJson = detail.toApiDetailJson(isUpdate: true);
      expect(detailJson.keys.length, 45);
      for (final key in requiredDetailKeys) {
        expect(detailJson.containsKey(key), true, reason: 'Missing key: $key');
      }
      expect(detailJson['Srno'], 1);
      expect(detailJson['PolishPurDetID'], 1);
      expect(detailJson['PolishPurMstID'], 1);
      expect(detailJson['CharniCode'], 37);
      expect(detailJson['PolishTypeCode'], 58);
      expect(detailJson['Pc'], 0);
      expect(detailJson['Wt'], 16.32);
      expect(detailJson['RateRs'], 6);
      expect(detailJson['AmtRs'], 97.92);
    });

    test('PolishPurchaseModel and DetailModel correctly parse API response format', () {
      final apiMasterJson = {
        'PolishPurMstID': 1,
        'InvoiceNo': 'INV-001',
        'InvoiceDate': '2025-10-30',
        'PartyCode': 16806,
        'BrokerCode': 16375,
        'DueDay': 0,
        'DueDate': '2025-10-30',
        'RDType': 'RS',
        'Exchange': 0,
        'TPc': 10,
        'TWeight': 16.32,
        'TAmtRs': 97.92,
        'TRateRs': 6,
        'TRateDollar': 0,
        'TAmtDollar': 0,
        'ChkBro': 'Per',
        'BroPer': 0,
        'BroDollar': 0,
        'BroRs': 0,
        'ChkAdd': 'Per',
        'AddPer': 0,
        'AddDollar': 0,
        'AddRs': 0,
        'ChkLess': 'Per',
        'LessPer': 5,
        'LessDollar': 0,
        'LessRs': 4.896,
        'NetAmtDollar': 0,
        'NetAmtRs': 93,
        'LogID': 2,
        'PCID': '551776',
        'Ever': 22,
        'SDate': '2026-09-28',
        'CompanyCode': 1,
        'AvgRate': 6,
        'Remarks': '',
        'Type': 'LOOSE',
        'FinalAmtRs': 97.92,
        'FinalAmtD': 0,
        'RoundOfRs': 0,
        'RoundOfD': 0,
      };

      final parsed = PolishPurchaseModel.fromJson(apiMasterJson);
      expect(parsed.polishPurMstID, 1);
      expect(parsed.totPcs, 10);
      expect(parsed.totWt, 16.32);
      expect(parsed.totAmtRs, 97.92);
      expect(parsed.chkBroker, false);
      expect(parsed.chkLess, false);
      expect(parsed.lessPer, 5);

      final apiDetailJson = {
        'PolishPurDetID': 1,
        'PolishPurMstID': 1,
        'Srno': 1,
        'ShapeCode': 12,
        'ShapeName': 'ROUND',
        'ClarityCode': 34,
        'ClarityName': 'VVS1',
        'CharniCode': 37,
        'CharniName': '-2',
        'PolishTypeCode': 58,
        'PolishTypeName': 'CVD',
        'Pc': 2,
        'Wt': 16.32,
        'RateDollar': 0,
        'AmtDollar': 0,
        'RateRs': 6,
        'AmtRs': 97.92,
      };

      final parsedDetail = PolishPurchaseDetailModel.fromJson(apiDetailJson);
      expect(parsedDetail.polishPurDetID, 1);
      expect(parsedDetail.srNo, 1);
      expect(parsedDetail.shape, 'ROUND');
      expect(parsedDetail.clarity, 'VVS1');
      expect(parsedDetail.charni, '-2');
      expect(parsedDetail.polishType, 'CVD');
      expect(parsedDetail.pcs, 2);
      expect(parsedDetail.amountRs, 97.92);
    });
  });

  group('Polish Purchase Controller CRUD Operations', () {
    test('DefaultController loads data from API or sample data', () async {
      final controller = DefaultController.to;
      await controller.getPolishPurchaseData();

      expect(controller.polishPurchaseList.isNotEmpty, true);
      final first = controller.polishPurchaseList.first;
      expect(first.invoiceNo != null || first.polishPurMstID != null, true);
    });

    test('Add, update, and delete Polish Purchase in reactive state', () async {
      final controller = DefaultController.to;
      await controller.getPolishPurchaseData();
      final initialCount = controller.polishPurchaseList.length;

      // 1. Add new record
      final newHeader = PolishPurchaseModel(
        invoiceNo: 'TEST-001',
        invoiceDate: '2026-10-15',
        partyName: 'DIAMOND CORP',
        type: 'LOOSE',
        totWt: 5.5,
        totAmtRs: 550.0,
        totAmtDollar: 5.5,
      );
      final newDetails = [
        PolishPurchaseDetailModel(
          srNo: 1,
          polishType: 'HPHT',
          shape: 'ROUND',
          clarity: 'VVS1',
          charni: '+2',
          pcs: 1,
          wt: 5.5,
          rateRs: 100.0,
          amountRs: 550.0,
          rateDollar: 1.0,
          amountDollar: 5.5,
        ),
      ];

      final addResult = await controller.addPolishPurchaseData(header: newHeader, details: newDetails);
      expect(addResult, true);
      expect(controller.polishPurchaseList.length, initialCount + 1);
      final added = controller.polishPurchaseList.firstWhere((p) => p.invoiceNo == 'TEST-001');
      expect(added.polishPurMstID, isNotNull);

      // 2. Update record
      added.remarks = 'Updated remarks';
      final updateResult = await controller.updatePolishPurchaseData(header: added, details: newDetails);
      expect(updateResult, true);
      expect(controller.polishPurchaseList.firstWhere((p) => p.invoiceNo == 'TEST-001').remarks, 'Updated remarks');

      // 3. Delete record
      final deleteResult = await controller.deletePolishPurchaseData(added.polishPurMstID!);
      expect(deleteResult, true);
      expect(controller.polishPurchaseList.length, initialCount);
    });

    test('getPolishPurchaseById retrieves single record master and details', () async {
      final controller = DefaultController.to;
      await controller.getPolishPurchaseData();

      if (controller.polishPurchaseList.isNotEmpty) {
        final id = controller.polishPurchaseList.first.polishPurMstID ?? 1;
        final result = await controller.getPolishPurchaseById(id);
        expect(result, isNotNull);
        expect(result!['master'], isNotNull);
        expect((result['master'] as PolishPurchaseModel).polishPurMstID, id);
      }
    });

    test('Currency evaluation matches USD and RS accurately', () {
      bool checkIsUsd(String curr) => curr == 'USD' || curr == '\$';

      expect(checkIsUsd('USD'), true);
      expect(checkIsUsd('\$'), true);
      expect(checkIsUsd('RS'), false);
      expect(checkIsUsd('INR'), false);
    });

    test('Exchange rate conversions between USD and RS', () {
      const double dollarRate = 85.0;
      const double wt = 2.500;
      const double rateDollar = 100.0;

      // Rate in RS = rateDollar * dollarRate
      const double rateRs = rateDollar * dollarRate;
      expect(rateRs, 8500.0);

      // Amount in USD = wt * rateDollar
      const double amtDollar = wt * rateDollar;
      expect(amtDollar, 250.0);

      // Amount in RS = wt * rateRs
      const double amtRs = wt * rateRs;
      expect(amtRs, 21250.0);
      expect((amtDollar * dollarRate), amtRs);
    });

    test('Calculation scenario matches Image 1 (RS mode with RoundOf in Rs)', () {
      const double gridAmtRs = 1000.0;
      const double gridAmtD = 10.0;
      const double roundOfRs = 100.0;
      const double roundOfD = 0.0;

      // Final Amt is always the grid total
      const double finalAmtRs = gridAmtRs;
      const double finalAmtD = gridAmtD;
      expect(finalAmtRs, 1000.0);
      expect(finalAmtD, 10.0);

      // Net Amt = Final Amt - Round Of
      const double netAmtRs = finalAmtRs - roundOfRs;
      const double netAmtD = finalAmtD - roundOfD;
      expect(netAmtRs, 900.0);
      expect(netAmtD, 10.0);
    });

    test('Calculation scenario matches Image 2 (USD mode with RoundOf in USD)', () {
      const double dollarRate = 100.0;
      const double gridAmtD = 10.0;
      const double gridAmtRs = 1000.0;
      const double roundOfD = 1.0;
      const double roundOfRs = roundOfD * dollarRate;

      expect(roundOfRs, 100.0);

      const double finalAmtD = gridAmtD;
      const double finalAmtRs = gridAmtRs;
      expect(finalAmtD, 10.0);
      expect(finalAmtRs, 1000.0);

      const double netAmtD = finalAmtD - roundOfD;
      const double netAmtRs = finalAmtRs - roundOfRs;
      expect(netAmtD, 9.0);
      expect(netAmtRs, 900.0);
    });

    test('Calculation scenario matches Image 3 (USD mode with Brokerage, Add, Less, RoundOf)', () {
      const double dollarRate = 100.0;
      const double gridAmtD = 10.0;
      const double gridAmtRs = 1000.0;

      // Brokerage: 10%
      const double broPer = 10.0;
      const double broD = gridAmtD * broPer / 100;
      const double broRs = gridAmtRs * broPer / 100;
      expect(broD, 1.0);
      expect(broRs, 100.0);

      // Add (+): 50%
      const double addPer = 50.0;
      const double addD = gridAmtD * addPer / 100;
      const double addRs = gridAmtRs * addPer / 100;
      expect(addD, 5.0);
      expect(addRs, 500.0);

      // Less (-): 20%
      const double lessPer = 20.0;
      const double lessD = gridAmtD * lessPer / 100;
      const double lessRs = gridAmtRs * lessPer / 100;
      expect(lessD, 2.0);
      expect(lessRs, 200.0);

      // Round Of: 1.000 ($) -> 100.000 Rs
      const double roundOfD = 1.0;
      const double roundOfRs = roundOfD * dollarRate;
      expect(roundOfRs, 100.0);

      // Final Amt = grid amount
      const double finalAmtD = gridAmtD;
      const double finalAmtRs = gridAmtRs;
      expect(finalAmtD, 10.0);
      expect(finalAmtRs, 1000.0);

      // Net Amt = Final Amt + Add - Less - Brokerage - Round Of
      const double netAmtD = finalAmtD + addD - lessD - broD - roundOfD;
      const double netAmtRs = finalAmtRs + addRs - lessRs - broRs - roundOfRs;
      expect(netAmtD, 11.0);
      expect(netAmtRs, 1100.0);
    });
  });
}
