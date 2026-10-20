import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/designation/designation_datagrid.dart';
import 'package:real_web_rough_entry_system/designation/designation_model.dart';
import 'package:real_web_rough_entry_system/main/menu_model.dart';
import 'package:real_web_rough_entry_system/user/user_datagrid.dart';
import 'package:real_web_rough_entry_system/user/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    Get.reset();
  });

  group('DesignationModel Tests', () {
    test('deserializes and serializes exact API curl payload (DesiCode, DesiName, EditDel, Sflag)', () {
      final json = {
        'DesiCode': 1,
        'DesiName': 'EMPLOYEE',
        'EditDel': 'N',
        'Sflag': 'Y',
      };

      final model = DesignationModel.fromJson(json);

      expect(model.desiCode, 1);
      expect(model.desiName, 'EMPLOYEE');
      expect(model.editDel, 'N');
      expect(model.sflag, 'Y');
      expect(model.designationCode, 1);
      expect(model.designationName, 'EMPLOYEE');

      expect(model.canEditOrDelete, isFalse);

      final serialized = model.toJson();
      expect(serialized['DesiCode'], 1);
      expect(serialized['DesiName'], 'EMPLOYEE');
      expect(serialized['EditDel'], 'N');
      expect(serialized['Sflag'], 'Y');
    });

    test('parses user exact API list response array and enforces locked state', () {
      final listJson = [
        {
          "DesiMstID": 1,
          "DesiCode": 1,
          "DesiName": "EMPLOYEE",
          "EditDel": "N",
          "Sflag": "Y",
          "Sdate": null,
          "LogiD": null,
          "PcID": null,
          "Ever": null,
          "ActiveRecord": true,
          "SortNo": null
        },
        {
          "DesiMstID": 2,
          "DesiCode": 2,
          "DesiName": "CHECKER",
          "EditDel": "N",
          "Sflag": "Y",
          "Sdate": null,
          "LogiD": null,
          "PcID": null,
          "Ever": null,
          "ActiveRecord": true,
          "SortNo": null
        },
        {
          "DesiMstID": 3,
          "DesiCode": 3,
          "DesiName": "MANAGER",
          "EditDel": "Y",
          "Sflag": "y",
          "Sdate": null,
          "LogiD": null,
          "PcID": null,
          "Ever": null,
          "ActiveRecord": true,
          "SortNo": null
        },
        {
          "DesiMstID": 4,
          "DesiCode": 4,
          "DesiName": "Branch Manager",
          "EditDel": "N",
          "Sflag": "Y",
          "Sdate": null,
          "LogiD": null,
          "PcID": null,
          "Ever": null,
          "ActiveRecord": null,
          "SortNo": null
        },
        {
          "DesiMstID": 5,
          "DesiCode": 5,
          "DesiName": "Salesman",
          "EditDel": "N",
          "Sflag": "Y",
          "Sdate": null,
          "LogiD": null,
          "PcID": null,
          "Ever": null,
          "ActiveRecord": null,
          "SortNo": null
        }
      ];

      final models = listJson.map((j) => DesignationModel.fromJson(j)).toList();

      expect(models.length, 5);

      // 1. EMPLOYEE: locked
      expect(models[0].desiMstID, 1);
      expect(models[0].desiCode, 1);
      expect(models[0].desiName, 'EMPLOYEE');
      expect(models[0].editDel, 'N');
      expect(models[0].canEditOrDelete, isFalse);
      expect(models[0].active, isTrue);

      // 2. CHECKER: locked
      expect(models[1].desiMstID, 2);
      expect(models[1].desiCode, 2);
      expect(models[1].editDel, 'N');
      expect(models[1].canEditOrDelete, isFalse);

      // 3. MANAGER: editable
      expect(models[2].desiMstID, 3);
      expect(models[2].desiCode, 3);
      expect(models[2].editDel, 'Y');
      expect(models[2].canEditOrDelete, isTrue);

      // 4 & 5: locked
      expect(models[3].canEditOrDelete, isFalse);
      expect(models[4].canEditOrDelete, isFalse);
    });

    test('canEditOrDelete evaluates correctly based on EditDel', () {
      final lockedUpper = DesignationModel(desiCode: 1, editDel: 'N');
      final lockedLower = DesignationModel(desiCode: 2, editDel: 'n');
      final editableUpper = DesignationModel(desiCode: 3, editDel: 'Y');
      final editableDefault = DesignationModel(desiCode: 4);

      expect(lockedUpper.canEditOrDelete, isFalse);
      expect(lockedLower.canEditOrDelete, isFalse);
      expect(editableUpper.canEditOrDelete, isTrue);
      expect(editableDefault.canEditOrDelete, isTrue);
    });

    test('deserializes correctly from standard API json', () {
      final json = {
        'DesignationMstID': 101,
        'DesignationCode': 101,
        'DesignationName': 'Senior Assorter',
        'SortID': 1,
        'Active': true,
        'CompanyCode': 3,
        'Sdate': '2026-10-15',
        'Sflag': 'A',
        'LogID': 5,
        'PcID': 'PC01',
        'Ever': 1,
      };

      final model = DesignationModel.fromJson(json);

      expect(model.designationMstID, 101);
      expect(model.designationCode, 101);
      expect(model.designationName, 'Senior Assorter');
      expect(model.sortID, 1);
      expect(model.active, true);
      expect(model.companyCode, 3);
      expect(model.sdate, '2026-10-15');
      expect(model.sflag, 'A');
      expect(model.logID, 5);
      expect(model.pcID, 'PC01');
      expect(model.ever, 1);
    });

    test('deserializes fallback keys (ID, Name, Designation)', () {
      final json = {
        'ID': 202,
        'Name': 'Diamond Polisher',
        'SortID': 2,
        'Active': false,
        'CompanyCode': 1,
      };

      final model = DesignationModel.fromJson(json);

      expect(model.designationMstID, 202);
      expect(model.designationCode, 202);
      expect(model.designationName, 'Diamond Polisher');
      expect(model.sortID, 2);
      expect(model.active, false);
      expect(model.companyCode, 1);
    });

    test('serializes to JSON correctly', () {
      final model = DesignationModel(
        designationMstID: 303,
        designationCode: 303,
        designationName: 'Manager',
        sortID: 3,
        active: true,
        companyCode: 3,
      );

      final json = model.toJson();

      expect(json['DesignationMstID'], 303);
      expect(json['DesignationCode'], 303);
      expect(json['DesignationName'], 'Manager');
      expect(json['Name'], 'Manager');
      expect(json['SortID'], 3);
      expect(json['Active'], true);
      expect(json['CompanyCode'], 3);
    });
  });

  group('DesignationDataGridSource Tests', () {
    test('maps DesignationModel list to DataGridRows properly', () {
      final controller = Get.put(DefaultController());
      final list = <DesignationModel>[
        DesignationModel(
          designationMstID: 1,
          designationCode: 1,
          designationName: 'Accountant',
          sortID: 1,
          active: true,
        ),
        DesignationModel(
          designationMstID: 2,
          designationCode: 2,
          designationName: 'Supervisor',
          sortID: 2,
          active: false,
        ),
      ].obs;

      final source = DesignationDataGridSource(list);

      expect(source.rows.length, 2);

      final row1Cells = source.rows[0].getCells();
      expect(row1Cells[0].columnName, 'Code');
      expect(row1Cells[0].value, 1);
      expect(row1Cells[1].columnName, 'Name');
      expect(row1Cells[1].value, 'Accountant');
      expect(row1Cells[2].columnName, 'Sort ID');
      expect(row1Cells[2].value, 1);
      expect(row1Cells[3].columnName, 'Active');
      expect(row1Cells[3].value, true);

      final row2Cells = source.rows[1].getCells();
      expect(row2Cells[1].value, 'Supervisor');
      expect(row2Cells[3].value, false);
    });
  });

  group('Menu Model & Icon Helper Tests for Designation', () {
    test('getSubMenuIcon returns badge icon for designation', () {
      expect(getSubMenuIcon('Designation'), Icons.badge_rounded);
      expect(getSubMenuIcon('Designation Master'), Icons.badge_rounded);
      expect(getSubMenuIcon(null, formName: 'FrmDesignationForm'),
          Icons.badge_rounded);
    });
  });

  group('DefaultController EditDel Protection Tests', () {
    test('update and delete are blocked when EditDel is N', () async {
      final controller = Get.put(DefaultController());
      final locked = DesignationModel(
        desiCode: 1,
        desiName: 'EMPLOYEE',
        editDel: 'N',
      );
      controller.designationModelList.value = [locked];

      // Attempting update on locked item is blocked by controller guard
      await controller.updateDesignationData(
        id: 1,
        name: 'MODIFIED',
      );
      expect(controller.designationModelList.first.desiName, 'EMPLOYEE');

      // Attempting delete on locked item is blocked by controller guard
      await controller.deleteDesignationData(id: 1);
      expect(controller.designationModelList.length, 1);
    });
  });

  group('User Master Designation and Tolerance Integration Tests', () {
    test('UserModel deserializes and serializes DesiCode and tolerance fields without duplicates', () {
      final json = {
        'CounterMstID': 10,
        'LoginName': 'john_doe',
        'UserName': 'John Doe',
        'UserGrp': 'USER',
        'BranchCode': 1,
        'DesiCode': 3,
        'DesiName': 'MANAGER',
        'AutoRec': 'Y',
        'AllowPlusType': 'WT',
        'AllowPlusValue': 0.05,
        'AllowMinusType': 'PER',
        'AllowMinusValue': 1.5,
      };

      final user = UserModel.fromJson(json);
      expect(user.desiCode, 3);
      expect(user.desiName, 'MANAGER');
      expect(user.autoRec, 'Y');
      expect(user.allowPlusType, 'WT');
      expect(user.allowPlusValue, 0.05);
      expect(user.allowMinusType, 'PER');
      expect(user.allowMinusValue, 1.5);

      final serialized = user.toJson();
      expect(serialized['DesiCode'], 3);
      // No duplicate columns
      expect(serialized.containsKey('DesignationCode'), isFalse);
      expect(serialized.containsKey('CrName'), isFalse);
      expect(serialized['AutoRec'], 'Y');
      expect(serialized['AllowPlusType'], 'WT');
      expect(serialized['AllowPlusValue'], 0.05);
      expect(serialized['AllowMinusType'], 'PER');
      expect(serialized['AllowMinusValue'], 1.5);
    });

    test('UserModel supports AllowPlusVal and AllowMinusVal fallback keys', () {
      final json = {
        'CounterMstID': 11,
        'LoginName': 'sam',
        'AutoRec': 'N',
        'AllowPlusType': 'PER',
        'AllowPlusVal': 2.5,
        'AllowMinusType': 'WT',
        'AllowMinusVal': 0.10,
      };

      final user = UserModel.fromJson(json);
      expect(user.autoRec, 'N');
      expect(user.allowPlusType, 'PER');
      expect(user.allowPlusValue, 2.5);
      expect(user.allowPlusVal, 2.5);
      expect(user.allowMinusType, 'WT');
      expect(user.allowMinusValue, 0.10);
      expect(user.allowMinusVal, 0.10);
    });

    test('UserDataGridSource includes Designation and Tolerance columns in order', () {
      final controller = Get.put(DefaultController());
      controller.designationModelList.value = [
        DesignationModel(desiCode: 1, desiName: 'EMPLOYEE'),
        DesignationModel(desiCode: 2, desiName: 'CHECKER'),
        DesignationModel(desiCode: 3, desiName: 'MANAGER'),
      ];

      final user = UserModel(
        counterMstId: 101,
        loginName: 'alice',
        userName: 'Alice Smith',
        userGrp: 'USER',
        branchCode: 1,
        desiCode: 2,
        autoRec: 'Y',
        allowPlusType: 'WT',
        allowPlusValue: 0.02,
        allowMinusType: 'PER',
        allowMinusValue: 0.5,
      );

      final source = UserDataGridSource([user]);
      expect(source.rows.length, 1);

      final row = source.rows.first;
      final cells = row.getCells();

      final branchIdx = cells.indexWhere((c) => c.columnName == 'Branch');
      final desiIdx = cells.indexWhere((c) => c.columnName == 'Designation');
      final autoRecIdx = cells.indexWhere((c) => c.columnName == 'Auto Rec');
      final plusTypeIdx = cells.indexWhere((c) => c.columnName == 'Allow Plus Type');
      final plusValIdx = cells.indexWhere((c) => c.columnName == 'Allow Plus Value');
      final minusTypeIdx = cells.indexWhere((c) => c.columnName == 'Allow Minus Type');
      final minusValIdx = cells.indexWhere((c) => c.columnName == 'Allow Minus Value');

      expect(branchIdx, isNonNegative);
      expect(desiIdx, branchIdx + 1,
          reason: 'Designation column must be immediately after Branch');
      expect(autoRecIdx, desiIdx + 1,
          reason: 'Auto Rec column must be immediately after Designation');
      expect(plusTypeIdx, autoRecIdx + 1);
      expect(plusValIdx, plusTypeIdx + 1);
      expect(minusTypeIdx, plusValIdx + 1);
      expect(minusValIdx, minusTypeIdx + 1);

      expect(cells[desiIdx].value, 'CHECKER');
      expect(cells[autoRecIdx].value, 'Y');
      expect(cells[plusTypeIdx].value, 'WT');
      expect(cells[plusValIdx].value, '0.02');
      expect(cells[minusTypeIdx].value, 'PER');
      expect(cells[minusValIdx].value, '0.5');
    });
  });
}
