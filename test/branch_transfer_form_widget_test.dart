import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/branch_transfer/branch_transfer_form_screen.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/controllers/theme_controller.dart';
import 'package:real_web_rough_entry_system/polish_type/polish_type_model.dart';
import 'package:real_web_rough_entry_system/rough/rough_model.dart';
import 'package:real_web_rough_entry_system/charni/charni_model.dart';
import 'package:real_web_rough_entry_system/clarity/clarity_model.dart';
import 'package:real_web_rough_entry_system/color/color_model.dart';
import 'package:real_web_rough_entry_system/quality/quality_model.dart';
import 'package:real_web_rough_entry_system/shape/shape_model.dart';
import 'package:real_web_rough_entry_system/tab-view-dashboard/tab_controller.dart';
import 'package:real_web_rough_entry_system/user/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DefaultController defaultController;

  setUp(() {
    SharedPreferences.setMockInitialValues({
      'username': 'AdminUser',
      'companyCode': 1,
      'branchCode': 1,
      'desiCode': 4,
      'userGroup': 'ADMIN',
    });
    Get.reset();
    Get.put(ThemeController());
    Get.put(TabControllerX());
    defaultController = Get.put(DefaultController());

    defaultController.currentUserGrp.value = 'ADMIN';
    defaultController.currentUserBranch.value = 1;
    defaultController.currentUserDesiCode.value = 4;

    defaultController.userModelList.assignAll([
      UserModel(counterMstId: 10, userName: 'Manager A', branchCode: 1),
      UserModel(counterMstId: 20, userName: 'Manager B', branchCode: 1),
    ]);

    defaultController.roughModel.assignAll([
      RoughModel(roughTypeCode: 1, roughTypeName: 'Rough A'),
      RoughModel(roughTypeCode: 2, roughTypeName: 'Rough B'),
      RoughModel(roughTypeCode: 3, roughTypeName: 'Rough C'),
    ]);

    defaultController.polishTypeModelList.assignAll([
      PolishTypeModel(polishTypeCode: 6, polishTypeName: 'Polish 6'),
      PolishTypeModel(polishTypeCode: 7, polishTypeName: 'Polish 7'),
    ]);

    defaultController.qualityModelList.assignAll([
      QualityModel(qualityCode: 1, qualityName: 'Q1'),
      QualityModel(qualityCode: 3, qualityName: 'Q3'),
    ]);

    defaultController.charniModelList.assignAll([
      CharniModel(charniCode: 2, charniName: 'Ch2'),
      CharniModel(charniCode: 3, charniName: 'Ch3'),
      CharniModel(charniCode: 4, charniName: 'Ch4'),
    ]);

    defaultController.shapeModelList.assignAll([
      ShapeModel(shapeCode: 29, shapeName: 'ROUND'),
    ]);

    defaultController.colorModelList.assignAll([
      ColorModel(colorCode: 1, colorName: 'D'),
      ColorModel(colorCode: 3, colorName: 'F'),
    ]);

    defaultController.clarityModelList.assignAll([
      ClarityModel(clarityMstID: 9, clarityName: 'VVS1'),
      ClarityModel(clarityMstID: 2038, clarityName: 'VS2'),
    ]);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('BranchTransferFormScreen renders form, buttons, and datatable properly',
      (tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const GetMaterialApp(
        home: BranchTransferFormScreen(showHeader: false),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title & Form Header
    expect(find.text('BRANCH TRANSFER INFORMATION'), findsOneWidget);
    expect(find.text('COMBINED PURCHASE / STOCK ITEMS'), findsOneWidget);

    // Verify Action Buttons
    expect(find.text('Add'), findsOneWidget);
    expect(find.text('Exit'), findsOneWidget);

    // Verify Columns in the Table
    expect(find.text('Source'), findsWidgets);
    expect(find.text('Type'), findsWidgets);
    expect(find.text('Inv No'), findsWidgets);
    expect(find.text('Stock Pc'), findsWidgets);
    expect(find.text('Stock Wt'), findsWidgets);
    expect(find.text('Rate \$'), findsWidgets);
    expect(find.text('Rate ₹'), findsWidgets);
    expect(find.text('Amount \$'), findsWidgets);
    expect(find.text('Amount ₹'), findsWidgets);
    expect(find.text('Quality'), findsWidgets);
    expect(find.text('Charni'), findsWidgets);
    expect(find.text('Shape'), findsWidgets);
    expect(find.text('Color'), findsWidgets);
    expect(find.text('Clarity'), findsWidgets);
    expect(find.text('Iss Pc'), findsWidgets);
    expect(find.text('Iss Wt'), findsWidgets);
    expect(find.text('Iss Rate'), findsWidgets);
    expect(find.text('Iss Amt'), findsWidgets);
    expect(find.text('Diff Wt'), findsWidgets);

    // Click "Add" button to enable editing
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.text('Save'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);

    // Overlay prompt asking user to select From Man
    expect(find.text('Select "From Man" to load stock items'), findsOneWidget);
  });
}
