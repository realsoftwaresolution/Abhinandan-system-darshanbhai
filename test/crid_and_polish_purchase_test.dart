import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/polish_purchase/polish_purchase_model.dart';
import 'package:real_web_rough_entry_system/purchase/purchase_details_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    Get.reset();
    Get.put(DefaultController());
  });

  tearDown(() {
    Get.reset();
  });

  group('CrId and Designation Authorization Tests', () {
    test('effectiveCrId returns user ID only when branch > 0 and desiCode == 4', () async {
      final controller = DefaultController.to;

      // 1. User payload matching user requirement: Branch = 1, DesiCode = 4, CrId = 56
      final validUserData = {
        'CounterMstID': 56,
        'CrId': 56,
        'CrName': 'A',
        'BranchCode': 1,
        'Branch': 1,
        'DesiCode': 4,
        'CompanyCode': 3,
        'UserName': 'A',
        'UserGrp': 'ADMIN',
      };

      await controller.setUserSession(validUserData, outerToken: 'fake-token', outerRefreshToken: 'fake-refresh-token');

      expect(controller.effectiveBranchCode, 1);
      expect(controller.effectiveDesiCode, 4);
      expect(controller.effectiveCrId, '56');
      expect(controller.canAddPurchaseEntry, true);

      // 2. User has branch but designation code is NOT 4 (e.g. DesiCode = 2)
      final wrongDesiUserData = {
        'CounterMstID': 56,
        'CrId': 56,
        'BranchCode': 1,
        'Branch': 1,
        'DesiCode': 2,
        'CompanyCode': 3,
      };

      await controller.setUserSession(wrongDesiUserData, outerToken: 'fake-token', outerRefreshToken: 'fake-refresh-token');

      expect(controller.effectiveBranchCode, 1);
      expect(controller.effectiveDesiCode, 2);
      expect(controller.effectiveCrId, '');
      expect(controller.canAddPurchaseEntry, false);

      // 3. User has DesiCode == 4 but NO branch (BranchCode = 0)
      final noBranchUserData = {
        'CounterMstID': 56,
        'CrId': 56,
        'BranchCode': 0,
        'Branch': 0,
        'DesiCode': 4,
        'CompanyCode': 3,
      };

      await controller.setUserSession(noBranchUserData, outerToken: 'fake-token', outerRefreshToken: 'fake-refresh-token');

      expect(controller.effectiveBranchCode, 0);
      expect(controller.effectiveDesiCode, 4);
      expect(controller.effectiveCrId, '');
      expect(controller.canAddPurchaseEntry, false);
    });

    test('PurchaseDetailsModel and PolishPurchaseModel properly serialize CrId', () {
      // Rough Purchase model CrId serialization
      final roughJson = {
        'PurchaseDetID': 10,
        'CrId': 56,
        'PartyName': 'DIAMOND CORP',
        'Wt': 12.34,
      };
      final roughModel = PurchaseDetailsModel.fromJson(roughJson);
      expect(roughModel.crId, 56);
      expect(roughModel.toJson()['CrId'], 56);

      // Polish Purchase model CrId serialization
      final polishJson = {
        'PolishPurMstID': 20,
        'CrId': 56,
        'InvoiceNo': 'INV-99',
        'PartyName': 'MIRA',
      };
      final polishModel = PolishPurchaseModel.fromJson(polishJson);
      expect(polishModel.crId, 56);
      expect(polishModel.toJson()['CrId'], 56);
      expect(polishModel.toApiMasterJson()['CrId'], 56);
    });

    test('PolishPurchaseDetailModel properly serializes colorCode and detail properties', () {
      final detail = PolishPurchaseDetailModel(
        srNo: 1,
        polishType: 'CVD',
        shape: 'ROUND',
        clarity: 'VS1',
        charni: '+2',
        colorCode: 5,
        pcs: 10,
        wt: 2.5,
        rateRs: 1000.0,
        amountRs: 2500.0,
      );

      final apiJson = detail.toApiDetailJson(isUpdate: false);
      expect(apiJson['ColorCode'], 5);
      expect(apiJson['PolishPurDetID'], 0);
      expect(apiJson['Pc'], 10);
      expect(apiJson['Wt'], 2.5);

      final fullJson = detail.toJson();
      expect(fullJson['ColorCode'], 5);
      expect(fullJson['PolishType'], 'CVD');
      expect(fullJson['Shape'], 'ROUND');
      expect(fullJson['Clarity'], 'VS1');
      expect(fullJson['Charni'], '+2');
    });
  });
}
