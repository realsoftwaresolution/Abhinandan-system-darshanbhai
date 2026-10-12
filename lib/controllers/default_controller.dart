import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:real_web_rough_entry_system/assort/assort_group_model.dart';
import 'package:real_web_rough_entry_system/assort/assort_model.dart';
import 'package:real_web_rough_entry_system/assort/rough_assort_mst_model.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';
import 'package:real_web_rough_entry_system/credit-debit/credit_debit_model.dart';
import 'package:real_web_rough_entry_system/main/company_mst_model.dart';
import 'package:real_web_rough_entry_system/memo%20issue/invoice_generator.dart';
import 'package:real_web_rough_entry_system/memo%20issue/memo_issue_details_model.dart';
import 'package:real_web_rough_entry_system/memo%20issue/memo_issue_model.dart';
import 'package:real_web_rough_entry_system/memo%20receive/invoice_generator.dart';
import 'package:real_web_rough_entry_system/memo%20receive/memo_rec_details_model.dart';
import 'package:real_web_rough_entry_system/memo%20receive/memo_rec_model.dart';
import 'package:real_web_rough_entry_system/party-ledger/outstanding_payment_details_model.dart';
import 'package:real_web_rough_entry_system/party/party_model.dart';
import 'package:real_web_rough_entry_system/party/party_type_model.dart';
import 'package:real_web_rough_entry_system/charni/charni_model.dart';
import 'package:real_web_rough_entry_system/clarity/clarity_model.dart';
import 'package:real_web_rough_entry_system/color/color_model.dart';
import 'package:real_web_rough_entry_system/quality/quality_model.dart';
import 'package:real_web_rough_entry_system/shape/shape_model.dart';
import 'package:real_web_rough_entry_system/expense_group/expense_group_model.dart';
import 'package:real_web_rough_entry_system/expense/expense_model.dart';
import 'package:real_web_rough_entry_system/acc_type/acc_type_model.dart';
import 'package:real_web_rough_entry_system/polish_type/polish_type_model.dart';
import 'package:real_web_rough_entry_system/company/company_model.dart';
import 'package:real_web_rough_entry_system/branch/branch_model.dart';
import 'package:real_web_rough_entry_system/services/api_service.dart';
import 'package:real_web_rough_entry_system/services/api_client.dart';
import 'package:real_web_rough_entry_system/user/user_model.dart';
import 'package:real_web_rough_entry_system/payment/payment_det_acc.dart';
import 'package:real_web_rough_entry_system/payment/payment_det_model.dart';
import 'package:real_web_rough_entry_system/payment/payment_details_model.dart';
import 'package:real_web_rough_entry_system/payment/payment_mst_model.dart';
import 'package:real_web_rough_entry_system/payment/pending_payment_model.dart';
import 'package:real_web_rough_entry_system/purchase/invoice_generator.dart';
import 'package:real_web_rough_entry_system/purchase/outstanding_purchase_details.dart';
import 'package:real_web_rough_entry_system/purchase/purchase_details_model.dart';
import 'package:real_web_rough_entry_system/rough/rough_details_model.dart';
import 'package:real_web_rough_entry_system/rough/rough_model.dart';
import 'package:real_web_rough_entry_system/sale/invoice_generator.dart';
import 'package:real_web_rough_entry_system/sale/sale_details_model.dart';
import 'package:real_web_rough_entry_system/sale/sale_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../assort/rough_assort_det_mst_model.dart';
import '../main/menu_model.dart';
import 'package:real_web_rough_entry_system/services/master_crud_service.dart';

class DefaultController extends GetxController {
  static DefaultController get to => Get.find<DefaultController>();
  Dio get dio => ApiService.to.dio;
  RxList<MainMenuModel> menuList = <MainMenuModel>[].obs;
  RxBool isLoadingMenuList = false.obs;
  RxString authToken = ''.obs;
  RxString refreshToken = ''.obs;
  RxList<PartyMstModel> partyMstList = <PartyMstModel>[].obs;
  RxList<AssortGroupMst> assortGroupMstList = <AssortGroupMst>[].obs;
  RxList<AssortMst> assortMstList = <AssortMst>[].obs;
  RxList<CompanyMst> companies = <CompanyMst>[].obs;
  RxBool isLoadingCompanies = false.obs;
  RxList<RoughAssortMst> roughAssortMstList = <RoughAssortMst>[].obs;
  RxList<RoughAssortDetMst> roughAssortMstDetList = <RoughAssortDetMst>[].obs;
  RxList<PurchaseDetailsModel> purchaseDataList = <PurchaseDetailsModel>[].obs;
  RxList<CreditDebitMstModel> creditDebitDataList = <CreditDebitMstModel>[].obs;
  RxList<PolishSaleModel> polishSaleList = <PolishSaleModel>[].obs;
  RxList<MemoIssueModel> memoIssueList = <MemoIssueModel>[].obs;
  RxList<MemoRecModel> memoRecList = <MemoRecModel>[].obs;

  // RxList<RoughPurchaseModel> polishSaleList = <RoughPurchaseModel>[].obs;
  RxList<PartyTypeMstModel> partyTypeMstList = <PartyTypeMstModel>[].obs;
  RxList<RoughModel> roughModel = <RoughModel>[].obs;
  RxList<QualityModel> qualityModelList = <QualityModel>[].obs;
  RxList<CharniModel> charniModelList = <CharniModel>[].obs;
  RxList<CharniRptGroupModel> charniRptGroupList = <CharniRptGroupModel>[].obs;
  RxList<ClarityModel> clarityModelList = <ClarityModel>[].obs;
  RxList<ColorModel> colorModelList = <ColorModel>[].obs;
  RxList<ShapeModel> shapeModelList = <ShapeModel>[].obs;
  RxList<ExpenseGroupModel> expenseGroupModelList = <ExpenseGroupModel>[].obs;
  RxList<ExpenseModel> expenseModelList = <ExpenseModel>[].obs;
  RxList<ExpenseGroupModel> expenseGroupDropdownList = <ExpenseGroupModel>[].obs;
  RxList<AccTypeModel> accTypeModelList = <AccTypeModel>[].obs;
  RxList<TypeGroupModel> typeGroupDropdownList = <TypeGroupModel>[].obs;
  RxList<PolishTypeModel> polishTypeModelList = <PolishTypeModel>[].obs;
  RxList<CompanyMstModel> companyModelList = <CompanyMstModel>[].obs;
  RxList<BranchModel> branchModelList = <BranchModel>[].obs;
  RxList<UserModel> userModelList = <UserModel>[].obs;
  Rx<UserModel?> selectedUserForRights = Rx<UserModel?>(null);
  RxList<RoughDetailsModel> roughDetailsModel = <RoughDetailsModel>[].obs;
  RxList<SaleDetailsModel> saleDetailsList = <SaleDetailsModel>[].obs;
  RxList<MemoIssueDetailsModel> memoIssueDetailsList =
      <MemoIssueDetailsModel>[].obs;
  RxList<MemoRecDetailsModel> memoRecDetailsList = <MemoRecDetailsModel>[].obs;
  RxList<MemoIssueDetailsModel> get memoIssueDetailsModel => memoIssueDetailsList;
  RxList<MemoRecDetailsModel> get memoRecDetailsModel => memoRecDetailsList;
  RxList<PaymentMstModel> paymentMstList = <PaymentMstModel>[].obs;
  RxList<PaymentDetModel> paymentDetList = <PaymentDetModel>[].obs;
  RxList<PaymentDetAccModel> paymentDetAccList = <PaymentDetAccModel>[].obs;
  RxList<PendingPaymentModel> pendingPaymentList = <PendingPaymentModel>[].obs;
  RxList<PaymentDetailsModel> bookPartyPaymentDetailsList =
      <PaymentDetailsModel>[].obs;
  RxList<OutstandingPaymentDetails> outstandingPaymentDetailsList =
      <OutstandingPaymentDetails>[].obs;
  RxList<OutstandingPurchaseSaleDetails> outstandingPurchaseSaleDetailsList =
      <OutstandingPurchaseSaleDetails>[].obs;
  RxList<PaymentDetailsModel> accPartyPaymentDetailsList =
      <PaymentDetailsModel>[].obs;

  RxMap groupedData = {}.obs;
  RxBool isLoading = false.obs;
  RxBool isDeleteLoading = false.obs;
  RxInt companyCode = 3.obs;
  RxString companyPartyCode = '21'.obs;
  RxString deviceInfo = 'No IP Found'.obs;
  RxBool enabledAdvancedDashboard = true.obs;
  RxBool isLoadingDashboardData = false.obs;

  // ==================== USER SESSION & SECURITY STATE ====================
  RxInt currentUserId = 0.obs;
  RxString currentUserName = ''.obs;
  RxString currentUserFullName = ''.obs;
  RxString currentUserGrp = ''.obs;
  RxInt currentUserBranch = 0.obs;
  RxBool canUserEdit = true.obs;
  RxBool canUserDelete = true.obs;
  RxInt currentLogId = 0.obs;
  RxString currentPcId = ''.obs;
  RxDouble userStockLimit = 0.0.obs;
  RxString userLoginTimeFrom = ''.obs;
  RxString userLoginTimeTo = ''.obs;
  RxMap<String, dynamic> userAccessMap = <String, dynamic>{}.obs;

  bool get isAdmin =>
      currentUserGrp.value.trim().toUpperCase() == 'ADMIN' ||
      currentUserGrp.value.trim().toUpperCase() == 'SUPERADMIN';

  /// Check permission for a specific menu and action.
  /// Handles category arrays in 'ua' ('0', '1', '2', '3', etc.).
  bool hasMenuPermission(dynamic menuId, {String actionType = '0', dynamic categoryKey}) {
    if (menuId == null) return true;
    final int? mId = int.tryParse(menuId.toString());
    if (mId == null || mId <= 0) return true;

    // Check if menu is in explicit hidden list in userAccessMap ('hidden', 'hide')
    if (userAccessMap.containsKey('hidden')) {
      final hiddenList = userAccessMap['hidden'];
      if (hiddenList is List && hiddenList.any((id) => id.toString() == mId.toString())) {
        return false;
      }
    }
    if (userAccessMap.containsKey('hide')) {
      final hiddenList = userAccessMap['hide'];
      if (hiddenList is List && hiddenList.any((id) => id.toString() == mId.toString())) {
        return false;
      }
    }

    // Granular flags check for edit/delete
    if (actionType == '2' && !canUserEdit.value) return false;
    if (actionType == '3' && !canUserDelete.value) return false;

    // If ua is not configured/empty, fallback to admin or allow
    if (userAccessMap.isEmpty) {
      if (isAdmin) return true;
      return true;
    }

    // 1. If categoryKey is provided, check that specific category list in ua
    if (categoryKey != null) {
      final String catStr = categoryKey.toString();
      final catList = userAccessMap[catStr];
      if (catList is List && catList.any((id) => id.toString() == mId.toString())) {
        return true;
      }
    }

    // 2. Search across ALL category lists in userAccessMap ('0', '1', '2', '3', etc.)
    for (var entry in userAccessMap.entries) {
      if (entry.key == 'hidden' || entry.key == 'hide') continue;
      final dynamic list = entry.value;
      if (list is List && list.any((id) => id.toString() == mId.toString())) {
        return true;
      }
    }

    return false;
  }

  bool canViewMenu(dynamic menuId, {dynamic categoryKey}) =>
      hasMenuPermission(menuId, actionType: '0', categoryKey: categoryKey);
  bool canAddMenu(dynamic menuId, {dynamic categoryKey}) =>
      hasMenuPermission(menuId, actionType: '1', categoryKey: categoryKey);
  bool canEditMenu(dynamic menuId, {dynamic categoryKey}) =>
      hasMenuPermission(menuId, actionType: '2', categoryKey: categoryKey);
  bool canDeleteMenu(dynamic menuId, {dynamic categoryKey}) =>
      hasMenuPermission(menuId, actionType: '3', categoryKey: categoryKey);

  /// Check if a menu is explicitly hidden for the current user session
  bool isMenuHidden(dynamic menuId) {
    if (menuId == null) return false;
    final int? mId = int.tryParse(menuId.toString());
    if (mId == null || mId <= 0) return false;

    if (userAccessMap.containsKey('hidden')) {
      final hiddenList = userAccessMap['hidden'];
      if (hiddenList is List &&
          hiddenList.any((id) => id.toString() == mId.toString())) {
        return true;
      }
    }
    if (userAccessMap.containsKey('hide')) {
      final hiddenList = userAccessMap['hide'];
      if (hiddenList is List &&
          hiddenList.any((id) => id.toString() == mId.toString())) {
        return true;
      }
    }
    return false;
  }

  /// Helper to check if a main category has any allowed menus in ua
  bool canViewCategory(dynamic categoryKey) {
    if (userAccessMap.isEmpty) return true;
    final String key = categoryKey.toString();
    if (userAccessMap.containsKey(key)) {
      final list = userAccessMap[key];
      if (list is List) {
        return list.isNotEmpty;
      }
    }
    return false;
  }

  DataGridController accountDataGridController = DataGridController();
  DataGridController bookDataGridController = DataGridController();

  final RxString selectedTypeAccountParty = ''.obs;
  final RxString selectedTypeBookParty = ''.obs;

  String get baseUrl => ApiService.to.baseUrl;
  set baseUrl(String url) => ApiService.to.updateBaseUrl(url);
  final MasterCrudService _masterService = MasterCrudService();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  /// Sets observable state and persists user session values to SharedPreferences.
  Future<void> setUserSession(Map<String, dynamic> data,
      {String? outerToken, String? outerRefreshToken}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // 1. Extract and persist authentication token
    final String? token = (outerToken != null && outerToken.isNotEmpty)
        ? outerToken
        : (data['Token']?.toString() ??
            data['token']?.toString() ??
            data['accessToken']?.toString() ??
            data['jwt']?.toString());
    if (token != null && token.isNotEmpty) {
      authToken.value = token;
      await prefs.setString('token', token);
    }

    // Extract and persist refresh token
    final String? rToken = (outerRefreshToken != null && outerRefreshToken.isNotEmpty)
        ? outerRefreshToken
        : (data['RefreshToken']?.toString() ??
            data['refreshToken']?.toString());
    if (rToken != null && rToken.isNotEmpty) {
      refreshToken.value = rToken;
      await prefs.setString('refreshToken', rToken);
    }

    // 2. Parse User ID (CounterMstID / CrId)
    int userId = 0;
    if (data['CounterMstID'] != null) {
      userId = int.tryParse(data['CounterMstID'].toString()) ?? 0;
    } else if (data['CrId'] != null) {
      userId = int.tryParse(data['CrId'].toString()) ?? 0;
    }
    currentUserId.value = userId;
    await prefs.setInt('userId', userId);

    // 3. User Login Name & Full Name
    final String uName = data['CrName']?.toString() ??
        data['LoginName']?.toString() ??
        '';
    currentUserName.value = uName;
    if (uName.isNotEmpty) {
      await prefs.setString('username', uName);
    }

    final String fullName = data['UserName']?.toString() ??
        data['Name']?.toString() ??
        '';
    currentUserFullName.value = fullName;
    await prefs.setString('fullName', fullName);

    if (data['CrPass'] != null) {
      await prefs.setString('password', data['CrPass'].toString());
    }

    // 4. User Group / Role
    final String uGrp = data['UserGrp']?.toString() ??
        data['Rights']?.toString() ??
        'USER';
    currentUserGrp.value = uGrp;
    await prefs.setString('userGrp', uGrp);

    // 5. Branch Code
    int branchCode = 0;
    if (data['BranchCode'] != null) {
      branchCode = int.tryParse(data['BranchCode'].toString()) ?? 0;
    }
    currentUserBranch.value = branchCode;
    await prefs.setInt('branchCode', branchCode);

    // 6. Action Rights (CrEdit / CrDel)
    final bool canEdit = data['CrEdit'] == null ||
        data['CrEdit'].toString().toUpperCase() == 'Y' ||
        data['CrEdit'] == true;
    final bool canDel = data['CrDel'] == null ||
        data['CrDel'].toString().toUpperCase() == 'Y' ||
        data['CrDel'] == true;
    canUserEdit.value = canEdit;
    canUserDelete.value = canDel;
    await prefs.setBool('crEdit', canEdit);
    await prefs.setBool('crDel', canDel);

    // 7. Audit fields (LogID / PcID)
    final int logId = int.tryParse(data['LogID']?.toString() ?? '') ?? 0;
    final String pcId = data['PcID']?.toString() ?? '';
    currentLogId.value = logId;
    currentPcId.value = pcId;
    if (logId > 0) await prefs.setInt('logId', logId);
    if (pcId.isNotEmpty) await prefs.setString('pcId', pcId);

    // 8. Stock limit & Login timings
    if (data['StockLimit'] != null) {
      userStockLimit.value =
          double.tryParse(data['StockLimit'].toString()) ?? 0.0;
      await prefs.setDouble('stockLimit', userStockLimit.value);
    }
    if (data['LoginTimeFrom'] != null) {
      userLoginTimeFrom.value = data['LoginTimeFrom'].toString();
      await prefs.setString('loginTimeFrom', userLoginTimeFrom.value);
    }
    if (data['LoginTimeTo'] != null) {
      userLoginTimeTo.value = data['LoginTimeTo'].toString();
      await prefs.setString('loginTimeTo', userLoginTimeTo.value);
    }

    // 9. User Access Matrix ('ua')
    if (data['ua'] is Map) {
      final uaMap = Map<String, dynamic>.from(data['ua'] as Map);
      userAccessMap.value = uaMap;
      await prefs.setString('ua', jsonEncode(uaMap));
    } else {
      userAccessMap.clear();
      await prefs.remove('ua');
    }

    // 10. Auto-assign Company Code if returned in login payload
    if (data['CompanyCode'] != null) {
      final int? compCode = int.tryParse(data['CompanyCode'].toString());
      if (compCode != null && compCode > 0) {
        companyCode.value = compCode;
        await prefs.setInt('companyCode', compCode);
      }
    }

    await prefs.setBool('isLoggedIn', true);
  }

  /// Restores saved session from SharedPreferences on app resume or initialization.
  Future<void> restoreUserSession() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      if (!isLoggedIn) return;

      authToken.value = prefs.getString('token') ?? '';
      refreshToken.value = prefs.getString('refreshToken') ?? '';
      currentUserId.value = prefs.getInt('userId') ?? 0;
      currentUserName.value = prefs.getString('username') ?? '';
      currentUserFullName.value = prefs.getString('fullName') ?? '';
      currentUserGrp.value = prefs.getString('userGrp') ?? '';
      currentUserBranch.value = prefs.getInt('branchCode') ?? 0;
      canUserEdit.value = prefs.getBool('crEdit') ?? true;
      canUserDelete.value = prefs.getBool('crDel') ?? true;
      currentLogId.value = prefs.getInt('logId') ?? 0;
      currentPcId.value = prefs.getString('pcId') ?? '';
      userStockLimit.value = prefs.getDouble('stockLimit') ?? 0.0;
      userLoginTimeFrom.value = prefs.getString('loginTimeFrom') ?? '';
      userLoginTimeTo.value = prefs.getString('loginTimeTo') ?? '';

      final int? savedComp = prefs.getInt('companyCode');
      if (savedComp != null && savedComp > 0) {
        companyCode.value = savedComp;
      }

      final String? uaRaw = prefs.getString('ua');
      if (uaRaw != null && uaRaw.isNotEmpty) {
        try {
          final decoded = jsonDecode(uaRaw);
          if (decoded is Map) {
            userAccessMap.value = Map<String, dynamic>.from(decoded);
          }
        } catch (_) {}
      }
    } catch (e) {
      if (kDebugMode) {
        log('Error restoring user session: $e');
      }
    }
  }

  /// Clears stored user session and resets application state.
  Future<void> logout() async {
    ApiClient().stopAutoRefreshTimer();
    final String currentRefresh = refreshToken.value.isNotEmpty
        ? refreshToken.value
        : ((await SharedPreferences.getInstance()).getString('refreshToken') ?? '');

    if (currentRefresh.isNotEmpty) {
      try {
        final revokeDio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
          headers: {'content-type': 'application/json'},
        ));
        await revokeDio.post(
          ApiService.to.resolvePath('user/revoke-token'),
          data: {'refreshToken': currentRefresh},
        );
      } catch (e) {
        if (kDebugMode) {
          log('Error revoking token on logout: $e');
        }
      }
    }

    authToken.value = '';
    refreshToken.value = '';
    currentUserId.value = 0;
    currentUserName.value = '';
    currentUserFullName.value = '';
    currentUserGrp.value = '';
    currentUserBranch.value = 0;
    canUserEdit.value = true;
    canUserDelete.value = true;
    currentLogId.value = 0;
    currentPcId.value = '';
    userStockLimit.value = 0.0;
    userLoginTimeFrom.value = '';
    userLoginTimeTo.value = '';
    userAccessMap.clear();
    menuList.clear();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed('/');
  }

  Future<void> login(String username, String password) async {
    try {
      isLoading.value = true;
      final dio = Dio(BaseOptions(
        baseUrl: ApiService.to.baseUrl,
        headers: {
          'content-type': 'application/json',
        },
      ));
      var params = <String, dynamic>{"CrName": username, "CrPass": password};
      final response =
          await dio.post('rough-entry/user/login', data: params);

      if (response.data != null && response.data['data'] != null) {
        final Map<String, dynamic> data = (response.data['data'] is Map<String, dynamic>)
            ? response.data['data'] as Map<String, dynamic>
            : Map<String, dynamic>.from(response.data['data'] as Map);

        final bool isActive = data['Active'] == true ||
            data['Active']?.toString() == '1' ||
            data['Active']?.toString().toLowerCase() == 'true';
        if (!isActive) {
          isLoading.value = false;
          infoDialog(messageText: 'User Inactive, Please Contact Your Admin.');
          return;
        }

        final String? outerToken = response.data['token']?.toString() ??
            response.data['Token']?.toString() ??
            response.data['accessToken']?.toString() ??
            response.data['jwt']?.toString();

        final String? outerRefreshToken = response.data['refreshToken']?.toString() ??
            response.data['RefreshToken']?.toString();

        await setUserSession(data,
            outerToken: outerToken, outerRefreshToken: outerRefreshToken);

        // Start the 28-Minute Refresh Timer
        ApiClient().startAutoRefreshTimer();

        // Fetch dynamic menu list right after login success
        await getMenuList();

        isLoading.value = false;
        Get.back();

        // Ensure company data is fetched before showing selection dialog
        if (companies.isEmpty) {
          await getCompanies();
        }
        showCompanySelectionDialog(isFromSwitchCompany: false);
      } else {
        isLoading.value = false;
        final String msg = response.data?['message']?.toString() ?? 'Invalid credentials.';
        infoDialog(messageText: msg);
      }
    } catch (error) {
      isLoading.value = false;
      errorDialog(messageText: 'An unexpected error occurred during login.');
      if (kDebugMode) {
        log('Login error: $error');
      }
    }
  }

  Future<void> getMenuList() async {
    try {
      isLoadingMenuList.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      if (kDebugMode) {
        log('Calling getMenuList: ${baseUrl}rough-entry/menu/getMenuList');
      }

      final response = await ApiService.to.get(
        '${baseUrl}rough-entry/menu/getMenuList',
      );

      if (response.statusCode == 200 && response.data != null) {
        final dynamic raw = response.data;
        List<dynamic> data;
        if (raw is List) {
          data = raw;
        } else if (raw is Map && raw['data'] is List) {
          data = raw['data'];
        } else {
          data = [];
        }

        if (data.isNotEmpty) {
          menuList.value = data
              .map((json) => MainMenuModel.fromJson(json as Map<String, dynamic>))
              .toList();
          await prefs.setString('menuList_cache', jsonEncode(data));
          if (kDebugMode) {
            log('getMenuList loaded: ${menuList.length} menu groups');
          }
        }
      }
    } catch (error) {
      if (kDebugMode) {
        log('getMenuList error: $error');
      }
    } finally {
      if (menuList.isEmpty) {
        try {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final String? cached = prefs.getString('menuList_cache');
          if (cached != null && cached.isNotEmpty) {
            final List<dynamic> cachedData = jsonDecode(cached);
            menuList.value = cachedData
                .map((j) => MainMenuModel.fromJson(j as Map<String, dynamic>))
                .toList();
          }
        } catch (_) {}

        if (menuList.isEmpty) {
          menuList.value = defaultMenuListJson
              .map((j) => MainMenuModel.fromJson(j))
              .toList();
        }
      }
      isLoadingMenuList.value = false;
    }
  }

  Future<void> getCompanies() async {
    try {
      isLoadingCompanies.value = true;

      final response = await ApiService.to.get(
        '${baseUrl}rough-entry/companies',
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data is List ? response.data : [response.data];
        companies.value =
            data.map((json) => CompanyMst.fromJson(json)).toList();
      }
    } catch (error) {
      if (kDebugMode) {
        log('getCompanies error: $error');
      }
    } finally {
      if (companies.isEmpty) {
        companies.value = [
          CompanyMst(
            companyMstID: 1013,
            companyCode: 3,
            companyName: 'Abhinandan Diamond',
            address: '204 Shraddhajyot Building, Mahidharpura, Surat',
            mobileno: '8926555111',
            emailID: 'contact@abhinandandiamond.com',
            fromYear: '2024-10-25',
            toYear: '2025-12-30',
            active: true,
          ),
        ];
      }
      isLoadingCompanies.value = false;
    }
  }

  Future<Map<String, dynamic>> _getAuthHeaders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String tokenToUse = authToken.value.isNotEmpty
        ? authToken.value
        : (prefs.getString('token') ?? '');

    final Map<String, dynamic> headers = {
      'content-type': 'application/json',
    };
    if (tokenToUse.isNotEmpty) {
      headers['Authorization'] = 'Bearer $tokenToUse';
    }
    return headers;
  }

  Future<void> getPartyData({bool force = false}) async {
    if (!force && partyMstList.isNotEmpty) return;
    final data = await _masterService.fetchList<PartyMstModel>(
      endpoint: 'rough-entry/party',
      fromJson: (j) => PartyMstModel.fromJson(j),
      errorContext: 'getPartyData',
      reverse: true,
    );
    if (data != null) partyMstList.value = data;
  }

  Future<PartyMstModel?> getPartyById(dynamic id) =>
      _masterService.fetchById<PartyMstModel>(
        endpoint: 'rough-entry/party',
        id: id,
        fromJson: (j) => PartyMstModel.fromJson(j),
      );
  Future<void> getAssortGroupData({bool force = false}) async {
    if (!force && assortGroupMstList.isNotEmpty) return;
    try {
      final dio = ApiService.to.dio;

      final response = await dio.get(
        '${baseUrl}rough-entry/assort-group',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        assortGroupMstList.value = data
            .map((json) => AssortGroupMst.fromJson(json))
            .toList();
      } else {
        errorDialog(messageText: 'Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.getAssortGroupData');
      if (kDebugMode) {
        log('$error');
      }
    }
  }
  Future<void> getAssortData({bool force = false}) async {
    if (!force && assortMstList.isNotEmpty) return;
    try {
      final dio = ApiService.to.dio;

      final response = await dio.get(
        '${baseUrl}rough-entry/assort',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        assortMstList.value = data
            .map((json) => AssortMst.fromJson(json))
            .toList()
            .reversed
            .toList();
      } else {
        errorDialog(messageText: 'Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.getAssortData');
      if (kDebugMode) {
        log('$error');
      }
    }
  }
  Future<void> getRoughAssortData({bool force = false}) async {
    if (!force && roughAssortMstList.isNotEmpty) return;
    try {
      final dio = ApiService.to.dio;

      final response = await dio.get(
        '${baseUrl}rough-entry/rough-assort',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        roughAssortMstList.value = data
            .map((json) => RoughAssortMst.fromJson(json))
            .toList()
            .reversed
            .toList();
      } else {
        errorDialog(messageText: 'Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.getRoughAssortData');
      if (kDebugMode) {
        log('$error');
      }
    }
  }
  Future<void> getRoughAssortDetailsData({bool force = false}) async {
    if (!force && roughAssortMstDetList.isNotEmpty) return;
    try {
      final dio = ApiService.to.dio;

      final response = await dio.get(
        '${baseUrl}rough-entry/rough-assort-det',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        roughAssortMstDetList.value = data
            .map((json) => RoughAssortDetMst.fromJson(json))
            .toList()
            .reversed
            .toList();
      } else {
        errorDialog(messageText: 'Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.getRoughAssortDetData');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> getCreditDebitData({bool force = false}) async {
    if (!force && creditDebitDataList.isNotEmpty) return;
    try {
      final dio = ApiService.to.dio;

      final response = await dio.get(
        '${baseUrl}rough-entry/credit-debit',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        creditDebitDataList.value =
            data.map((json) => CreditDebitMstModel.fromJson(json)).toList();
      } else {
        errorDialog(messageText: 'Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.getCreditDebitData');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> getPurchaseData({bool force = false}) async {
    if (!force && purchaseDataList.isNotEmpty) return;
    isLoadingDashboardData.value = true;
    try {
      final dio = ApiService.to.dio;

      final response = await dio.get(
        '${baseUrl}rough-entry/purchase',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        purchaseDataList.value = data
            .map((json) => PurchaseDetailsModel.fromJson(json))
            .toList()
            .reversed
            .toList();
        if (kDebugMode) {
          print('FROM API:${purchaseDataList.length}');
        }
        isLoadingDashboardData.value = false;
      } else {
        isLoadingDashboardData.value = false;
        errorDialog(messageText: 'Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      isLoadingDashboardData.value = false;
      errorDialog(messageText: 'An unexpected error occurred.getPurchaseData');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> getPurchaseDetailsData({bool force = false}) async {
    if (!force && roughDetailsModel.isNotEmpty) return;
    try {
      final dio = ApiService.to.dio;

      final response = await dio.get(
        '${baseUrl}rough-entry/rough-details',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a RoughDetailsModel
        roughDetailsModel.value = data
            .map((json) => RoughDetailsModel.fromJson(json))
            .toList()
            .reversed
            .toList();

        // Grouping by roughTypeCode and summing the wt for each group

        for (var detail in roughDetailsModel) {
          if (groupedData.containsKey(detail.roughTypeCode)) {
            groupedData[detail.roughTypeCode!] =
                groupedData[detail.roughTypeCode]! + detail.wt!;
          } else {
            groupedData[detail.roughTypeCode!] = detail.wt!;
          }
        }

        // Printing the grouped data for debugging
        // groupedData.forEach((key, value) {
        //   if (kDebugMode) {
        //     print('RoughTypeCode: $key, Total Weight: $value');
        //   }
        // });

        // You can now use the groupedData map for further processing
      } else {
        errorDialog(messageText: 'Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.getPurchaseDetailsData');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> getSaleData({bool force = false}) async {
    if (!force && polishSaleList.isNotEmpty) return;
    try {
      final dio = ApiService.to.dio;

      final response = await dio.get(
        '${baseUrl}rough-entry/polish-sale',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        polishSaleList.value = data
            .map((json) => PolishSaleModel.fromJson(json))
            .toList()
            .reversed
            .toList();
      } else {
        errorDialog(messageText: 'Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.getSaleData');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> getMemoIssueData({bool force = false}) async {
    if (!force && memoIssueList.isNotEmpty) return;
    try {
      final dio = ApiService.to.dio;

      final response = await dio.get(
        '${baseUrl}rough-entry/memo-issue',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        memoIssueList.value = data
            .map((json) => MemoIssueModel.fromJson(json))
            .toList()
            .reversed
            .toList();
      } else {
        errorDialog(messageText: 'Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.getMemoIssueData');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> getMemoRecData({bool force = false}) async {
    if (!force && memoRecList.isNotEmpty) return;
    try {
      final dio = ApiService.to.dio;

      final response = await dio.get(
        '${baseUrl}rough-entry/memo-rec',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        memoRecList.value = data
            .map((json) => MemoRecModel.fromJson(json))
            .toList()
            .reversed
            .toList();
      } else {
        errorDialog(messageText: 'Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.getMemoRecData');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> getSaleDetailsData({bool force = false}) async {
    if (!force && saleDetailsList.isNotEmpty) return;
    try {
      final dio = ApiService.to.dio;

      final response = await dio.get(
        '${baseUrl}rough-entry/sale-details',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a SaleDetailsModel
        saleDetailsList.value = data
            .map((json) => SaleDetailsModel.fromJson(json))
            .toList()
            .reversed
            .toList();

        // Subtracting the wt from groupedData for each roughTypeCode
        for (var saleDetail in saleDetailsList) {
          final roughTypeCode = saleDetail.roughTypeCode;
          final saleWt = saleDetail.carats ?? 0;

          if (groupedData.containsKey(roughTypeCode)) {
            // Subtract the sale wt from the groupedData wt
            groupedData[roughTypeCode] = groupedData[roughTypeCode]! - saleWt;
          }
        }

        // Printing the updated groupedData for debugging
        // groupedData.forEach((key, value) {
        //   if (kDebugMode) {
        //     print('RoughTypeCode: $key, Total Weight after Sale: $value');
        //   }
        // });
      } else {
        errorDialog(
            messageText: 'Failed to load sale data: ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.getSaleDetailsData');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> getMemoIssueDetailsData({bool force = false}) async {
    if (!force && memoIssueDetailsList.isNotEmpty) return;
    try {
      final dio = ApiService.to.dio;

      final response = await dio.get(
        '${baseUrl}rough-entry/memo-issue-details',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        memoIssueDetailsList.value = data
            .map((json) => MemoIssueDetailsModel.fromJson(json))
            .toList()
            .reversed
            .toList();
      } else {
        errorDialog(messageText: 'Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.getMemoIssueDetailsData');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> getMemoRecDetailsData({bool force = false}) async {
    if (!force && memoRecDetailsList.isNotEmpty) return;
    try {
      final dio = ApiService.to.dio;

      final response = await dio.get(
        '${baseUrl}rough-entry/memo-rec-details',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        memoRecDetailsList.value = data
            .map((json) => MemoRecDetailsModel.fromJson(json))
            .toList()
            .reversed
            .toList();
      } else {
        errorDialog(messageText: 'Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.getMemoRecDetailsData');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  // ==================== PARTY TYPE MASTER APIS ====================
  Future<void> getPartyTypeData({bool force = false}) async {
    if (!force && partyTypeMstList.isNotEmpty) return;
    final data = await _masterService.fetchList<PartyTypeMstModel>(
      endpoint: 'rough-entry/partyType',
      fromJson: (j) => PartyTypeMstModel.fromJson(j),
      errorContext: 'getPartyTypeData',
      reverse: true,
    );
    if (data != null) partyTypeMstList.value = data;
  }

  // ==================== ROUGH TYPE MASTER APIS ====================
  Future<void> getRoughData({bool force = false}) async {
    if (!force && roughModel.isNotEmpty) return;
    final data = await _masterService.fetchList<RoughModel>(
      endpoint: 'rough-entry/rough-type',
      fromJson: (j) => RoughModel.fromJson(j),
      errorContext: 'getRoughData',
    );
    if (data != null) roughModel.value = data;
  }

  Future<RoughModel?> getRoughTypeById(dynamic id) =>
      _masterService.fetchById<RoughModel>(
        endpoint: 'rough-entry/rough-type',
        id: id,
        fromJson: (j) => RoughModel.fromJson(j),
      );

  Future<void> addRoughTypeData({
    required String name,
    int? sortId,
    bool active = true,
    int? companyCodeParam,
  }) async {
    final int codeToUse =
        companyCodeParam ?? (companyCode.value != 0 ? companyCode.value : 3);
    await _masterService.create(
      endpoint: 'rough-entry/rough-type/add',
      payload: {
        'Name': name,
        if (sortId != null) 'SortID': sortId,
        'Active': active,
        'CompanyCode': codeToUse,
      },
      onSuccess: () => getRoughData(),
      defaultSuccessMessage: 'Rough Type Entry Saved Successfully',
      loadingState: isLoading,
    );
  }

  Future<void> updateRoughTypeData({
    required dynamic id,
    required String name,
    int? sortId,
    bool active = true,
    int? companyCodeParam,
  }) async {
    final int codeToUse =
        companyCodeParam ?? (companyCode.value != 0 ? companyCode.value : 3);
    await _masterService.update(
      endpoint: 'rough-entry/rough-type',
      id: id,
      payload: {
        'Name': name,
        if (sortId != null) 'SortID': sortId,
        'Active': active,
        'CompanyCode': codeToUse,
      },
      onSuccess: () => getRoughData(),
      defaultSuccessMessage: 'Rough Type Details Updated Successfully',
      loadingState: isLoading,
    );
  }

  Future<void> deleteRoughTypeData({required dynamic id}) =>
      _masterService.delete(
        endpoint: 'rough-entry/rough-type',
        id: id,
        onSuccess: () => getRoughData(),
        defaultSuccessMessage: 'Rough Type Entry Deleted Successfully',
        deleteLoadingState: isDeleteLoading,
      );

  // ==================== QUALITY MASTER APIS ====================
  Future<void> getQualityData({int? companyCodeParam}) async {
    final data = await _masterService.fetchList<QualityModel>(
      endpoint: 'rough-entry/quality',
      fromJson: (j) => QualityModel.fromJson(j),
      companyCode: companyCodeParam ??
          (companyCode.value != 0 ? companyCode.value : null),
      errorContext: 'getQualityData',
    );
    if (data != null) qualityModelList.value = data;
  }

  Future<QualityModel?> getQualityById(dynamic id) =>
      _masterService.fetchById<QualityModel>(
        endpoint: 'rough-entry/quality',
        id: id,
        fromJson: (j) => QualityModel.fromJson(j),
      );

  Future<Map<String, dynamic>?> getNextQualityCode() =>
      _masterService.fetchNextCode(endpoint: 'rough-entry/quality/nextCode');

  Future<void> addQualityData({
    required String name,
    int? sortId,
    bool active = true,
    int? companyCodeParam,
  }) async {
    final codeToUse = companyCodeParam ??
        (companyCode.value != 0 ? companyCode.value : 1);
    await _masterService.create(
      endpoint: 'rough-entry/quality/add',
      payload: {
        'Name': name,
        if (sortId != null) 'SortID': sortId,
        'CompanyCode': codeToUse,
        'Active': active,
      },
      onSuccess: () => getQualityData(companyCodeParam: codeToUse),
      defaultSuccessMessage: 'Quality Entry Saved Successfully',
      loadingState: isLoading,
    );
  }

  Future<void> updateQualityData({
    required dynamic id,
    required String name,
    int? sortId,
    bool active = true,
    int? companyCodeParam,
  }) async {
    final codeToUse = companyCodeParam ??
        (companyCode.value != 0 ? companyCode.value : 1);
    await _masterService.update(
      endpoint: 'rough-entry/quality',
      id: id,
      payload: {
        'Name': name,
        if (sortId != null) 'SortID': sortId,
        'CompanyCode': codeToUse,
        'Active': active,
      },
      onSuccess: () => getQualityData(companyCodeParam: codeToUse),
      defaultSuccessMessage: 'Quality Details Updated Successfully',
      loadingState: isLoading,
    );
  }

  Future<void> deleteQualityData({required dynamic id}) =>
      _masterService.delete(
        endpoint: 'rough-entry/quality',
        id: id,
        onSuccess: () => getQualityData(),
        defaultSuccessMessage: 'Quality Entry Deleted Successfully',
        deleteLoadingState: isDeleteLoading,
      );

  // ==================== CHARNI MASTER APIS ====================
  Future<void> getCharniRptGroups() async {
    final data = await _masterService.fetchList<CharniRptGroupModel>(
      endpoint: 'rough-entry/charni/rpt-groups',
      fromJson: (j) => CharniRptGroupModel.fromJson(j),
      errorContext: 'getCharniRptGroups',
    );
    if (data != null) charniRptGroupList.value = data;
  }

  Future<void> getCharniData({int? companyCodeParam}) async {
    final data = await _masterService.fetchList<CharniModel>(
      endpoint: 'rough-entry/charni',
      fromJson: (j) => CharniModel.fromJson(j),
      companyCode: companyCodeParam ??
          (companyCode.value != 0 ? companyCode.value : null),
      errorContext: 'getCharniData',
    );
    if (data != null) charniModelList.value = data;
  }

  Future<CharniModel?> getCharniById(dynamic id) async {
    return await _masterService.fetchById<CharniModel>(
      endpoint: 'rough-entry/charni/$id',
      fromJson: (j) => CharniModel.fromJson(j),
      errorContext: 'getCharniById',
    );
  }

  Future<Map<String, dynamic>?> getNextCharniCode() async {
    return await _masterService.fetchNextCode(
      endpoint: 'rough-entry/charni/nextCode',
      errorContext: 'getNextCharniCode',
    );
  }

  Future<void> addCharniData({
    required String name,
    int? rptGroup,
    double? fromSize,
    double? toSize,
    int? sortId,
    bool active = true,
    int? companyCodeParam,
  }) async {
    final codeToUse = companyCodeParam ??
        (companyCode.value != 0 ? companyCode.value : 3);
    await _masterService.create(
      endpoint: 'rough-entry/charni/add',
      payload: {
        'Name': name,
        if (rptGroup != null) 'RptGroup': rptGroup,
        'FromSize': fromSize ?? 0.0,
        'ToSize': toSize ?? 0.0,
        if (sortId != null) 'SortID': sortId,
        'Active': active,
        'CompanyCode': codeToUse,
      },
      isLoading: isLoading,
      defaultSuccessMsg: 'Charni Entry Saved Successfully',
      onSuccess: () => getCharniData(),
      errorContext: 'addCharniData',
    );
  }

  Future<void> updateCharniData({
    required dynamic id,
    required String name,
    int? rptGroup,
    double? fromSize,
    double? toSize,
    int? sortId,
    bool active = true,
    int? companyCodeParam,
  }) async {
    final codeToUse = companyCodeParam ??
        (companyCode.value != 0 ? companyCode.value : 3);
    await _masterService.update(
      endpoint: 'rough-entry/charni/$id',
      payload: {
        'Name': name,
        if (rptGroup != null) 'RptGroup': rptGroup,
        'FromSize': fromSize ?? 0.0,
        'ToSize': toSize ?? 0.0,
        if (sortId != null) 'SortID': sortId,
        'Active': active,
        'CompanyCode': codeToUse,
      },
      isLoading: isLoading,
      defaultSuccessMsg: 'Charni Entry Updated Successfully',
      onSuccess: () => getCharniData(),
      errorContext: 'updateCharniData',
    );
  }

  Future<void> deleteCharniData({required dynamic id}) async {
    await _masterService.delete(
      endpoint: 'rough-entry/charni/$id',
      isDeleteLoading: isDeleteLoading,
      defaultSuccessMsg: 'Charni Entry Deleted Successfully',
      onSuccess: () => getCharniData(),
      errorContext: 'deleteCharniData',
    );
  }

  // ==================== CLARITY MASTER APIS ====================
  Future<void> getClarityData({int? companyCodeParam}) async {
    final data = await _masterService.fetchList<ClarityModel>(
      endpoint: 'rough-entry/clarity',
      fromJson: (j) => ClarityModel.fromJson(j),
      companyCode: companyCodeParam,
      errorContext: 'getClarityData',
    );
    if (data != null) clarityModelList.value = data;
  }

  Future<ClarityModel?> getClarityById(dynamic id) async {
    return await _masterService.fetchById<ClarityModel>(
      endpoint: 'rough-entry/clarity/$id',
      fromJson: (j) => ClarityModel.fromJson(j),
      errorContext: 'getClarityById',
    );
  }

  Future<Map<String, dynamic>?> getNextClaritySort() async {
    return await _masterService.fetchNextCode(
      endpoint: 'rough-entry/clarity/nextSort',
      errorContext: 'getNextClaritySort',
    );
  }

  Future<void> addClarityData({
    required String name,
    String? aliasName,
    int? sortId,
    bool active = true,
    bool purchase = true,
    int? companyCodeParam,
  }) async {
    final codeToUse = companyCodeParam ??
        (companyCode.value != 0 ? companyCode.value : 3);
    await _masterService.create(
      endpoint: 'rough-entry/clarity/add',
      payload: {
        'Name': name,
        if (aliasName != null && aliasName.isNotEmpty) 'AliasName': aliasName,
        if (sortId != null) 'SortID': sortId,
        'Active': active,
        'Purchase': purchase,
        'CompanyCode': codeToUse,
      },
      isLoading: isLoading,
      defaultSuccessMsg: 'Clarity Entry Saved Successfully',
      onSuccess: () => getClarityData(),
      errorContext: 'addClarityData',
    );
  }

  Future<void> updateClarityData({
    required dynamic id,
    required String name,
    String? aliasName,
    int? sortId,
    bool active = true,
    bool purchase = true,
    int? companyCodeParam,
  }) async {
    final codeToUse = companyCodeParam ??
        (companyCode.value != 0 ? companyCode.value : 3);
    await _masterService.update(
      endpoint: 'rough-entry/clarity/$id',
      payload: {
        'Name': name,
        if (aliasName != null && aliasName.isNotEmpty) 'AliasName': aliasName,
        if (sortId != null) 'SortID': sortId,
        'Active': active,
        'Purchase': purchase,
        'CompanyCode': codeToUse,
      },
      isLoading: isLoading,
      defaultSuccessMsg: 'Clarity Entry Updated Successfully',
      onSuccess: () => getClarityData(),
      errorContext: 'updateClarityData',
    );
  }

  Future<void> deleteClarityData({required dynamic id}) async {
    await _masterService.delete(
      endpoint: 'rough-entry/clarity/$id',
      isDeleteLoading: isDeleteLoading,
      defaultSuccessMsg: 'Clarity Entry Deleted Successfully',
      onSuccess: () => getClarityData(),
      errorContext: 'deleteClarityData',
    );
  }

  // ==================== COLOR MASTER APIS ====================
  Future<void> getColorData({int? companyCodeParam}) async {
    final data = await _masterService.fetchList<ColorModel>(
      endpoint: 'rough-entry/color',
      fromJson: (j) => ColorModel.fromJson(j),
      companyCode: companyCodeParam,
      errorContext: 'getColorData',
    );
    if (data != null) colorModelList.value = data;
  }

  Future<ColorModel?> getColorById(dynamic id) async {
    return await _masterService.fetchById<ColorModel>(
      endpoint: 'rough-entry/color/$id',
      fromJson: (j) => ColorModel.fromJson(j),
      errorContext: 'getColorById',
    );
  }

  Future<Map<String, dynamic>?> getNextColorCode() async {
    return await _masterService.fetchNextCode(
      endpoint: 'rough-entry/color/nextCode',
      errorContext: 'getNextColorCode',
    );
  }

  Future<void> addColorData({
    required String name,
    int? sortId,
    bool active = true,
    int? companyCodeParam,
  }) async {
    final codeToUse = companyCodeParam ??
        (companyCode.value != 0 ? companyCode.value : 3);
    await _masterService.create(
      endpoint: 'rough-entry/color/add',
      payload: {
        'Name': name,
        if (sortId != null) 'SortID': sortId,
        'Active': active,
        'CompanyCode': codeToUse,
      },
      isLoading: isLoading,
      defaultSuccessMsg: 'Color Entry Saved Successfully',
      onSuccess: () => getColorData(),
      errorContext: 'addColorData',
    );
  }

  Future<void> updateColorData({
    required dynamic id,
    required String name,
    int? sortId,
    bool active = true,
    int? companyCodeParam,
  }) async {
    final codeToUse = companyCodeParam ??
        (companyCode.value != 0 ? companyCode.value : 3);
    await _masterService.update(
      endpoint: 'rough-entry/color/$id',
      payload: {
        'Name': name,
        if (sortId != null) 'SortID': sortId,
        'Active': active,
        'CompanyCode': codeToUse,
      },
      isLoading: isLoading,
      defaultSuccessMsg: 'Color Entry Updated Successfully',
      onSuccess: () => getColorData(),
      errorContext: 'updateColorData',
    );
  }

  Future<void> deleteColorData({required dynamic id}) async {
    await _masterService.delete(
      endpoint: 'rough-entry/color/$id',
      isDeleteLoading: isDeleteLoading,
      defaultSuccessMsg: 'Color Entry Deleted Successfully',
      onSuccess: () => getColorData(),
      errorContext: 'deleteColorData',
    );
  }

  // ==================== SHAPE MASTER APIS ====================
  Future<void> getShapeData({int? companyCodeParam}) async {
    final data = await _masterService.fetchList<ShapeModel>(
      endpoint: 'rough-entry/shape',
      fromJson: (j) => ShapeModel.fromJson(j),
      companyCode: companyCodeParam ??
          (companyCode.value != 0 ? companyCode.value : null),
      errorContext: 'getShapeData',
    );
    if (data != null) shapeModelList.value = data;
  }

  Future<ShapeModel?> getShapeById(dynamic id) async {
    return await _masterService.fetchById<ShapeModel>(
      endpoint: 'rough-entry/shape/$id',
      fromJson: (j) => ShapeModel.fromJson(j),
      errorContext: 'getShapeById',
    );
  }

  Future<Map<String, dynamic>?> getNextShapeCode() async {
    return await _masterService.fetchNextCode(
      endpoint: 'rough-entry/shape/nextCode',
      errorContext: 'getNextShapeCode',
    );
  }

  Future<void> addShapeData({
    required String name,
    String? repCode,
    int? sortId,
    bool active = true,
    int? companyCodeParam,
  }) async {
    final codeToUse = companyCodeParam ??
        (companyCode.value != 0 ? companyCode.value : 1);
    await _masterService.create(
      endpoint: 'rough-entry/shape/add',
      payload: {
        'Name': name,
        if (repCode != null && repCode.isNotEmpty) 'RepCode': repCode,
        if (sortId != null) 'SortID': sortId,
        'CompanyCode': codeToUse,
        'Active': active,
      },
      isLoading: isLoading,
      defaultSuccessMsg: 'Shape Entry Saved Successfully',
      onSuccess: () => getShapeData(companyCodeParam: codeToUse),
      errorContext: 'addShapeData',
    );
  }

  Future<void> updateShapeData({
    required dynamic id,
    required String name,
    String? repCode,
    int? sortId,
    bool active = true,
    int? companyCodeParam,
  }) async {
    final codeToUse = companyCodeParam ??
        (companyCode.value != 0 ? companyCode.value : 1);
    await _masterService.update(
      endpoint: 'rough-entry/shape/$id',
      payload: {
        'Name': name,
        if (repCode != null && repCode.isNotEmpty) 'RepCode': repCode,
        if (sortId != null) 'SortID': sortId,
        'CompanyCode': codeToUse,
        'Active': active,
      },
      isLoading: isLoading,
      defaultSuccessMsg: 'Shape Entry Updated Successfully',
      onSuccess: () => getShapeData(companyCodeParam: codeToUse),
      errorContext: 'updateShapeData',
    );
  }

  Future<void> deleteShapeData({required dynamic id}) async {
    await _masterService.delete(
      endpoint: 'rough-entry/shape/$id',
      isDeleteLoading: isDeleteLoading,
      defaultSuccessMsg: 'Shape Entry Deleted Successfully',
      onSuccess: () => getShapeData(),
      errorContext: 'deleteShapeData',
    );
  }

  // ==================== EXPENSE GROUP MASTER APIS ====================
  Future<void> getExpenseGroupData({int? companyCodeParam}) async {
    final data = await _masterService.fetchList<ExpenseGroupModel>(
      endpoint: 'rough-entry/expense-group',
      fromJson: (j) => ExpenseGroupModel.fromJson(j),
      companyCode: companyCodeParam ??
          (companyCode.value != 0 ? companyCode.value : null),
      errorContext: 'getExpenseGroupData',
    );
    if (data != null) expenseGroupModelList.value = data;
  }

  Future<ExpenseGroupModel?> getExpenseGroupById(dynamic id) async {
    return await _masterService.fetchById<ExpenseGroupModel>(
      endpoint: 'rough-entry/expense-group/$id',
      fromJson: (j) => ExpenseGroupModel.fromJson(j),
      errorContext: 'getExpenseGroupById',
    );
  }

  Future<Map<String, dynamic>?> getNextExpenseGroupCode() async {
    return await _masterService.fetchNextCode(
      endpoint: 'rough-entry/expense-group/nextCode',
      errorContext: 'getNextExpenseGroupCode',
    );
  }

  Future<void> addExpenseGroupData({
    required String name,
    int? sortId,
    bool active = true,
    int? companyCodeParam,
  }) async {
    final codeToUse = companyCodeParam ??
        (companyCode.value != 0 ? companyCode.value : 1);
    await _masterService.create(
      endpoint: 'rough-entry/expense-group/add',
      payload: {
        'Name': name,
        if (sortId != null) 'SortID': sortId,
        'CompanyCode': codeToUse,
        'Active': active,
      },
      isLoading: isLoading,
      defaultSuccessMsg: 'Expense Group Entry Saved Successfully',
      onSuccess: () => getExpenseGroupData(companyCodeParam: codeToUse),
      errorContext: 'addExpenseGroupData',
    );
  }

  Future<void> updateExpenseGroupData({
    required dynamic id,
    required String name,
    int? sortId,
    bool active = true,
    int? companyCodeParam,
  }) async {
    final codeToUse = companyCodeParam ??
        (companyCode.value != 0 ? companyCode.value : 1);
    await _masterService.update(
      endpoint: 'rough-entry/expense-group/$id',
      payload: {
        'Name': name,
        if (sortId != null) 'SortID': sortId,
        'CompanyCode': codeToUse,
        'Active': active,
      },
      isLoading: isLoading,
      defaultSuccessMsg: 'Expense Group Entry Updated Successfully',
      onSuccess: () => getExpenseGroupData(companyCodeParam: codeToUse),
      errorContext: 'updateExpenseGroupData',
    );
  }

  Future<void> deleteExpenseGroupData({required dynamic id}) async {
    await _masterService.delete(
      endpoint: 'rough-entry/expense-group/$id',
      isDeleteLoading: isDeleteLoading,
      defaultSuccessMsg: 'Expense Group Entry Deleted Successfully',
      onSuccess: () => getExpenseGroupData(),
      errorContext: 'deleteExpenseGroupData',
    );
  }

  // ==================== EXPENSE MASTER APIS ====================
  Future<void> getExpenseGroupsDropdownData({int? companyCodeParam}) async {
    final data = await _masterService.fetchList<ExpenseGroupModel>(
      endpoint: 'rough-entry/expense/groups',
      fromJson: (j) => ExpenseGroupModel.fromJson(j),
      companyCode: companyCodeParam ??
          (companyCode.value != 0 ? companyCode.value : null),
      errorContext: 'getExpenseGroupsDropdownData',
    );
    if (data != null) expenseGroupDropdownList.value = data;
  }

  Future<void> getExpenseData({int? companyCodeParam}) async {
    final data = await _masterService.fetchList<ExpenseModel>(
      endpoint: 'rough-entry/expense',
      fromJson: (j) => ExpenseModel.fromJson(j),
      companyCode: companyCodeParam ??
          (companyCode.value != 0 ? companyCode.value : null),
      errorContext: 'getExpenseData',
    );
    if (data != null) expenseModelList.value = data;
  }

  Future<ExpenseModel?> getExpenseById(dynamic id) async {
    return await _masterService.fetchById<ExpenseModel>(
      endpoint: 'rough-entry/expense/$id',
      fromJson: (j) => ExpenseModel.fromJson(j),
      errorContext: 'getExpenseById',
    );
  }

  Future<Map<String, dynamic>?> getNextExpenseCode() async {
    return await _masterService.fetchNextCode(
      endpoint: 'rough-entry/expense/nextCode',
      errorContext: 'getNextExpenseCode',
    );
  }

  Future<void> addExpenseData({
    required String name,
    required int expGroupCode,
    int? sortId,
    bool active = true,
    int? companyCodeParam,
  }) async {
    final codeToUse = companyCodeParam ??
        (companyCode.value != 0 ? companyCode.value : 1);
    await _masterService.create(
      endpoint: 'rough-entry/expense/add',
      payload: {
        'Name': name,
        'ExpGroupCode': expGroupCode,
        if (sortId != null) 'SortID': sortId,
        'CompanyCode': codeToUse,
        'Active': active,
      },
      isLoading: isLoading,
      defaultSuccessMsg: 'Expense Entry Saved Successfully',
      onSuccess: () => getExpenseData(companyCodeParam: codeToUse),
      errorContext: 'addExpenseData',
    );
  }

  Future<void> updateExpenseData({
    required dynamic id,
    required String name,
    required int expGroupCode,
    int? sortId,
    bool active = true,
    int? companyCodeParam,
  }) async {
    final codeToUse = companyCodeParam ??
        (companyCode.value != 0 ? companyCode.value : 1);
    await _masterService.update(
      endpoint: 'rough-entry/expense/$id',
      payload: {
        'Name': name,
        'ExpGroupCode': expGroupCode,
        if (sortId != null) 'SortID': sortId,
        'CompanyCode': codeToUse,
        'Active': active,
      },
      isLoading: isLoading,
      defaultSuccessMsg: 'Expense Entry Updated Successfully',
      onSuccess: () => getExpenseData(companyCodeParam: codeToUse),
      errorContext: 'updateExpenseData',
    );
  }

  Future<void> deleteExpenseData({required dynamic id}) async {
    await _masterService.delete(
      endpoint: 'rough-entry/expense/$id',
      isDeleteLoading: isDeleteLoading,
      defaultSuccessMsg: 'Expense Entry Deleted Successfully',
      onSuccess: () => getExpenseData(),
      errorContext: 'deleteExpenseData',
    );
  }

  // ==================== ACC TYPE / TYPE MASTER APIS ====================
  Future<void> getTypeGroupsDropdownData() async {
    final data = await _masterService.fetchList<TypeGroupModel>(
      endpoint: 'rough-entry/type/groups',
      fromJson: (j) => TypeGroupModel.fromJson(j),
      errorContext: 'getTypeGroupsDropdownData',
    );
    if (data != null) typeGroupDropdownList.value = data;
  }

  Future<void> getAccTypeData({int? companyCodeParam}) async {
    final data = await _masterService.fetchList<AccTypeModel>(
      endpoint: 'rough-entry/type',
      fromJson: (j) => AccTypeModel.fromJson(j),
      companyCode: companyCodeParam ??
          (companyCode.value != 0 ? companyCode.value : null),
      errorContext: 'getAccTypeData',
    );
    if (data != null) accTypeModelList.value = data;
  }

  Future<AccTypeModel?> getAccTypeById(dynamic id) async {
    return await _masterService.fetchById<AccTypeModel>(
      endpoint: 'rough-entry/type/$id',
      fromJson: (j) => AccTypeModel.fromJson(j),
      errorContext: 'getAccTypeById',
    );
  }

  Future<Map<String, dynamic>?> getNextAccTypeCode() async {
    return await _masterService.fetchNextCode(
      endpoint: 'rough-entry/type/nextCode',
      errorContext: 'getNextAccTypeCode',
    );
  }

  Future<void> addAccTypeData({
    required String name,
    required String group,
    int? typeGroupCode,
    int? sortId,
    bool active = true,
    int? companyCodeParam,
  }) async {
    final codeToUse = companyCodeParam ??
        (companyCode.value != 0 ? companyCode.value : 1);
    await _masterService.create(
      endpoint: 'rough-entry/type/add',
      payload: {
        'Name': name,
        'Group': group,
        if (typeGroupCode != null) 'TypeGroupCode': typeGroupCode,
        if (sortId != null) 'SortID': sortId,
        'CompanyCode': codeToUse,
        'Active': active,
      },
      isLoading: isLoading,
      defaultSuccessMsg: 'Type Entry Saved Successfully',
      onSuccess: () => getAccTypeData(companyCodeParam: codeToUse),
      errorContext: 'addAccTypeData',
    );
  }

  Future<void> updateAccTypeData({
    required dynamic id,
    required String name,
    required String group,
    int? typeGroupCode,
    int? sortId,
    bool active = true,
    int? companyCodeParam,
  }) async {
    final codeToUse = companyCodeParam ??
        (companyCode.value != 0 ? companyCode.value : 1);
    await _masterService.update(
      endpoint: 'rough-entry/type/$id',
      payload: {
        'Name': name,
        'Group': group,
        if (typeGroupCode != null) 'TypeGroupCode': typeGroupCode,
        'CompanyCode': codeToUse,
        if (sortId != null) 'SortID': sortId,
        'Active': active,
      },
      isLoading: isLoading,
      defaultSuccessMsg: 'Type Entry Updated Successfully',
      onSuccess: () => getAccTypeData(companyCodeParam: codeToUse),
      errorContext: 'updateAccTypeData',
    );
  }

  Future<void> deleteAccTypeData({required dynamic id}) async {
    await _masterService.delete(
      endpoint: 'rough-entry/type/$id',
      isDeleteLoading: isDeleteLoading,
      defaultSuccessMsg: 'Type Entry Deleted Successfully',
      onSuccess: () => getAccTypeData(),
      errorContext: 'deleteAccTypeData',
    );
  }

  // ==================== POLISH TYPE MASTER APIS ====================
  Future<void> getPolishTypeData({int? companyCodeParam}) async {
    final data = await _masterService.fetchList<PolishTypeModel>(
      endpoint: 'rough-entry/polish-type',
      fromJson: (j) => PolishTypeModel.fromJson(j),
      companyCode: companyCodeParam ??
          (companyCode.value != 0 ? companyCode.value : null),
      errorContext: 'getPolishTypeData',
    );
    if (data != null) polishTypeModelList.value = data;
  }

  Future<PolishTypeModel?> getPolishTypeById(dynamic id) async {
    return await _masterService.fetchById<PolishTypeModel>(
      endpoint: 'rough-entry/polish-type/$id',
      fromJson: (j) => PolishTypeModel.fromJson(j),
      errorContext: 'getPolishTypeById',
    );
  }

  Future<Map<String, dynamic>?> getNextPolishTypeCode() async {
    return await _masterService.fetchNextCode(
      endpoint: 'rough-entry/polish-type/nextCode',
      errorContext: 'getNextPolishTypeCode',
    );
  }

  Future<void> addPolishTypeData({
    required String name,
    int? sortId,
    bool active = true,
    int? companyCodeParam,
  }) async {
    final codeToUse = companyCodeParam ??
        (companyCode.value != 0 ? companyCode.value : 1);
    await _masterService.create(
      endpoint: 'rough-entry/polish-type/add',
      payload: {
        'Name': name,
        if (sortId != null) 'SortID': sortId,
        'CompanyCode': codeToUse,
        'Active': active,
      },
      isLoading: isLoading,
      defaultSuccessMsg: 'Polish Type Entry Saved Successfully',
      onSuccess: () => getPolishTypeData(companyCodeParam: codeToUse),
      errorContext: 'addPolishTypeData',
    );
  }

  Future<void> updatePolishTypeData({
    required dynamic id,
    required String name,
    int? sortId,
    bool active = true,
    int? companyCodeParam,
  }) async {
    final codeToUse = companyCodeParam ??
        (companyCode.value != 0 ? companyCode.value : 1);
    await _masterService.update(
      endpoint: 'rough-entry/polish-type/$id',
      payload: {
        'Name': name,
        'CompanyCode': codeToUse,
        if (sortId != null) 'SortID': sortId,
        'Active': active,
      },
      isLoading: isLoading,
      defaultSuccessMsg: 'Polish Type Entry Updated Successfully',
      onSuccess: () => getPolishTypeData(companyCodeParam: codeToUse),
      errorContext: 'updatePolishTypeData',
    );
  }

  Future<void> deletePolishTypeData({required dynamic id}) async {
    await _masterService.delete(
      endpoint: 'rough-entry/polish-type/$id',
      isDeleteLoading: isDeleteLoading,
      defaultSuccessMsg: 'Polish Type Entry Deleted Successfully',
      onSuccess: () => getPolishTypeData(),
      errorContext: 'deletePolishTypeData',
    );
  }

  // ==================== COMPANY MASTER APIS ====================
  Future<void> getCompanyData() async {
    final data = await _masterService.fetchList<CompanyMstModel>(
      endpoint: 'rough-entry/company',
      fromJson: (j) => CompanyMstModel.fromJson(j),
      errorContext: 'getCompanyData',
    );
    if (data != null) companyModelList.value = data;
  }

  Future<CompanyMstModel?> getCompanyById(dynamic id) async {
    return await _masterService.fetchById<CompanyMstModel>(
      endpoint: 'rough-entry/company/$id',
      fromJson: (j) => CompanyMstModel.fromJson(j),
      errorContext: 'getCompanyById',
    );
  }

  Future<Map<String, dynamic>?> getNextCompanyCode() async {
    return await _masterService.fetchNextCode(
      endpoint: 'rough-entry/company/nextCode',
      errorContext: 'getNextCompanyCode',
    );
  }

  Future<void> addCompanyData({
    required String name,
    String? address,
    String? mobileNo,
    String? phone,
    String? fax,
    String? email,
    String? web,
    String? gstNo,
    String? cstNo,
    String? tinNo,
    String? bank,
    String? branch,
    String? bankAdd,
    String? ifsc,
    String? accNo,
    String? insurance,
    String? finalAmt,
    String? fromDate,
    String? toDate,
    int? sortId,
    bool active = true,
  }) async {
    await _masterService.create(
      endpoint: 'rough-entry/company/add',
      payload: {
        'Name': name,
        if (address != null && address.isNotEmpty) 'Address': address,
        if (mobileNo != null && mobileNo.isNotEmpty) 'MobileNo': mobileNo,
        if (phone != null && phone.isNotEmpty) 'Phone': phone,
        if (fax != null && fax.isNotEmpty) 'Fax': fax,
        if (email != null && email.isNotEmpty) 'Email': email,
        if (web != null && web.isNotEmpty) 'Web': web,
        if (gstNo != null && gstNo.isNotEmpty) 'GSTNo': gstNo,
        if (cstNo != null && cstNo.isNotEmpty) 'CSTNo': cstNo,
        if (tinNo != null && tinNo.isNotEmpty) 'TINNo': tinNo,
        if (bank != null && bank.isNotEmpty) 'Bank': bank,
        if (branch != null && branch.isNotEmpty) 'Branch': branch,
        if (bankAdd != null && bankAdd.isNotEmpty) 'BankAdd': bankAdd,
        if (ifsc != null && ifsc.isNotEmpty) 'IFSC': ifsc,
        if (accNo != null && accNo.isNotEmpty) 'AccNo': accNo,
        if (insurance != null && insurance.isNotEmpty) 'Insurance': insurance,
        if (finalAmt != null && finalAmt.isNotEmpty) 'FinalAmt': finalAmt,
        if (fromDate != null && fromDate.isNotEmpty) 'FromDate': fromDate,
        if (toDate != null && toDate.isNotEmpty) 'ToDate': toDate,
        if (sortId != null) 'SortID': sortId,
        'Active': active,
      },
      isLoading: isLoading,
      defaultSuccessMsg: 'Company Entry Saved Successfully',
      onSuccess: () => getCompanyData(),
      errorContext: 'addCompanyData',
    );
  }

  Future<void> updateCompanyData({
    required dynamic id,
    required String name,
    String? address,
    String? mobileNo,
    String? phone,
    String? fax,
    String? email,
    String? web,
    String? gstNo,
    String? cstNo,
    String? tinNo,
    String? bank,
    String? branch,
    String? bankAdd,
    String? ifsc,
    String? accNo,
    String? insurance,
    String? finalAmt,
    String? fromDate,
    String? toDate,
    int? sortId,
    bool active = true,
  }) async {
    await _masterService.update(
      endpoint: 'rough-entry/company/$id',
      payload: {
        'Name': name,
        if (address != null && address.isNotEmpty) 'Address': address,
        if (mobileNo != null && mobileNo.isNotEmpty) 'MobileNo': mobileNo,
        if (phone != null && phone.isNotEmpty) 'Phone': phone,
        if (fax != null && fax.isNotEmpty) 'Fax': fax,
        if (email != null && email.isNotEmpty) 'Email': email,
        if (web != null && web.isNotEmpty) 'Web': web,
        if (gstNo != null && gstNo.isNotEmpty) 'GSTNo': gstNo,
        if (cstNo != null && cstNo.isNotEmpty) 'CSTNo': cstNo,
        if (tinNo != null && tinNo.isNotEmpty) 'TINNo': tinNo,
        if (bank != null && bank.isNotEmpty) 'Bank': bank,
        if (branch != null && branch.isNotEmpty) 'Branch': branch,
        if (bankAdd != null && bankAdd.isNotEmpty) 'BankAdd': bankAdd,
        if (ifsc != null && ifsc.isNotEmpty) 'IFSC': ifsc,
        if (accNo != null && accNo.isNotEmpty) 'AccNo': accNo,
        if (insurance != null && insurance.isNotEmpty) 'Insurance': insurance,
        if (finalAmt != null && finalAmt.isNotEmpty) 'FinalAmt': finalAmt,
        if (fromDate != null && fromDate.isNotEmpty) 'FromDate': fromDate,
        if (toDate != null && toDate.isNotEmpty) 'ToDate': toDate,
        if (sortId != null) 'SortID': sortId,
        'Active': active,
      },
      isLoading: isLoading,
      defaultSuccessMsg: 'Company Entry Updated Successfully',
      onSuccess: () => getCompanyData(),
      errorContext: 'updateCompanyData',
    );
  }

  Future<void> deleteCompanyData({required dynamic id}) async {
    await _masterService.delete(
      endpoint: 'rough-entry/company/$id',
      isDeleteLoading: isDeleteLoading,
      defaultSuccessMsg: 'Company Entry Deleted Successfully',
      onSuccess: () => getCompanyData(),
      errorContext: 'deleteCompanyData',
    );
  }

  // ==================== BRANCH MASTER APIS ====================
  Future<void> getBranchData({int? companyCodeParam}) async {
    final code = companyCodeParam ??
        (companyCode.value != 0 ? companyCode.value : null);
    final data = await _masterService.fetchList<BranchModel>(
      endpoint: 'rough-entry/branch',
      fromJson: (j) => BranchModel.fromJson(j),
      companyCode: code,
      errorContext: 'getBranchData',
    );
    if (data != null) branchModelList.value = data;
  }

  Future<BranchModel?> getBranchById(dynamic id) async {
    return await _masterService.fetchById<BranchModel>(
      endpoint: 'rough-entry/branch',
      id: id,
      fromJson: (j) => BranchModel.fromJson(j),
      errorContext: 'getBranchById',
    );
  }

  Future<Map<String, dynamic>?> getNextBranchCode({int? companyCodeParam}) async {
    final code = companyCodeParam ??
        (companyCode.value != 0 ? companyCode.value : 1);
    return await _masterService.fetchNextCode(
      endpoint: 'rough-entry/branch/nextCode?CompanyCode=$code',
      errorContext: 'getNextBranchCode',
    );
  }

  Future<void> addBranchData({
    required String name,
    int? sortId,
    bool active = true,
    int? companyCodeParam,
  }) async {
    final codeToUse = companyCodeParam ??
        (companyCode.value != 0 ? companyCode.value : 1);
    await _masterService.create(
      endpoint: 'rough-entry/branch/add',
      payload: {
        'Name': name,
        'CompanyCode': codeToUse,
        if (sortId != null) 'SortID': sortId,
        'Active': active,
      },
      isLoading: isLoading,
      defaultSuccessMsg: 'Branch Entry Saved Successfully',
      onSuccess: () => getBranchData(companyCodeParam: codeToUse),
      errorContext: 'addBranchData',
    );
  }

  Future<void> updateBranchData({
    required dynamic id,
    required String name,
    int? sortId,
    bool active = true,
    int? companyCodeParam,
  }) async {
    final codeToUse = companyCodeParam ??
        (companyCode.value != 0 ? companyCode.value : 1);
    await _masterService.update(
      endpoint: 'rough-entry/branch/$id',
      payload: {
        'Name': name,
        if (sortId != null) 'SortID': sortId,
        'Active': active,
      },
      isLoading: isLoading,
      defaultSuccessMsg: 'Branch Entry Updated Successfully',
      onSuccess: () => getBranchData(companyCodeParam: codeToUse),
      errorContext: 'updateBranchData',
    );
  }

  Future<void> deleteBranchData({
    required dynamic id,
    int? companyCodeParam,
  }) async {
    final codeToUse = companyCodeParam ??
        (companyCode.value != 0 ? companyCode.value : 1);
    await _masterService.delete(
      endpoint: 'rough-entry/branch/$id',
      isDeleteLoading: isDeleteLoading,
      defaultSuccessMsg: 'Branch Entry Deleted Successfully',
      onSuccess: () => getBranchData(companyCodeParam: codeToUse),
      errorContext: 'deleteBranchData',
    );
  }

  // ==================== USER MASTER & 4 MODULES APIS ====================

  // --- Module 1: Basic Details & User CRUD ---
  Future<void> getUserData({
    int? branchCode,
    bool? active,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (branchCode != null && branchCode != 0) {
        queryParams['BranchCode'] = branchCode;
      }
      if (active != null) {
        queryParams['active'] = active;
      }
      if (search != null && search.trim().isNotEmpty) {
        queryParams['search'] = search.trim();
      }

      final response = await ApiService.to.get(
        'rough-entry/user',
        queryParameters: queryParams.isEmpty ? null : queryParams,
      );

      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> list = [];
        if (response.data is List) {
          list = response.data as List<dynamic>;
        } else if (response.data is Map && response.data['data'] is List) {
          list = response.data['data'] as List<dynamic>;
        }
        userModelList.value = list
            .map((j) => UserModel.fromJson(j as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      log('getUserData error: $e');
    }
  }

  Future<UserModel?> getUserById(dynamic id) async {
    try {
      final response = await ApiService.to.get('rough-entry/user/$id');
      if (response.statusCode == 200 && response.data != null) {
        final raw = response.data;
        if (raw is List && raw.isNotEmpty && raw.first is Map) {
          return UserModel.fromJson(raw.first as Map<String, dynamic>);
        } else if (raw is Map<String, dynamic> &&
            raw['data'] != null &&
            raw['data'] is Map<String, dynamic>) {
          return UserModel.fromJson(raw['data'] as Map<String, dynamic>);
        } else if (raw is Map<String, dynamic>) {
          return UserModel.fromJson(raw);
        }
      }
    } catch (e) {
      log('getUserById error: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> getNextUserCode() async {
    try {
      final response = await ApiService.to.get('rough-entry/user/nextCode');
      if (response.statusCode == 200 && response.data != null) {
        if (response.data is Map<String, dynamic>) {
          return response.data as Map<String, dynamic>;
        }
      }
    } catch (e) {
      log('getNextUserCode error: $e');
    }
    return null;
  }

  Future<bool> addUserData({
    required String loginName,
    required String password,
    required String userName,
    String userGrp = 'USER',
    int? branchCode,
    double? stockLimit,
    String? loginTimeFrom,
    String? loginTimeTo,
    int? sortId,
    bool active = true,
  }) async {
    try {
      isLoading.value = true;
      final payload = <String, dynamic>{
        'LoginName': loginName,
        'Password': password,
        'UserName': userName,
        'UserGrp': userGrp,
        if (branchCode != null) 'BranchCode': branchCode,
        if (stockLimit != null) 'StockLimit': stockLimit,
        if (loginTimeFrom != null && loginTimeFrom.isNotEmpty)
          'LoginTimeFrom': loginTimeFrom,
        if (loginTimeTo != null && loginTimeTo.isNotEmpty)
          'LoginTimeTo': loginTimeTo,
        if (sortId != null) 'SortID': sortId,
        'Active': active,
      };

      final response =
          await ApiService.to.post('rough-entry/user', data: payload);
      isLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final msg = (response.data is Map && response.data['message'] != null)
            ? response.data['message'].toString()
            : 'User Registered Successfully';
        successDialog(messageText: msg);
        await getUserData();
        return true;
      } else {
        final err = (response.data is Map && response.data['message'] != null)
            ? response.data['message'].toString()
            : 'Failed to add user';
        errorDialog(messageText: err);
      }
    } catch (e) {
      isLoading.value = false;
      errorDialog(messageText: 'Error registering user: $e');
    }
    return false;
  }

  Future<bool> updateUserData({
    required dynamic id,
    String? userName,
    String? loginName,
    String? password,
    String? userGrp,
    int? branchCode,
    double? stockLimit,
    String? loginTimeFrom,
    String? loginTimeTo,
    int? sortId,
    bool? active,
  }) async {
    try {
      isLoading.value = true;
      final payload = <String, dynamic>{
        if (userName != null) 'UserName': userName,
        if (loginName != null) 'LoginName': loginName,
        if (password != null && password.isNotEmpty) 'Password': password,
        if (userGrp != null) 'UserGrp': userGrp,
        if (branchCode != null) 'BranchCode': branchCode,
        if (stockLimit != null) 'StockLimit': stockLimit,
        if (loginTimeFrom != null) 'LoginTimeFrom': loginTimeFrom,
        if (loginTimeTo != null) 'LoginTimeTo': loginTimeTo,
        if (sortId != null) 'SortID': sortId,
        if (active != null) 'Active': active,
      };

      final response =
          await ApiService.to.put('rough-entry/user/$id', data: payload);
      isLoading.value = false;

      if (response.statusCode == 200) {
        final msg = (response.data is Map && response.data['message'] != null)
            ? response.data['message'].toString()
            : 'User Updated Successfully';
        successDialog(messageText: msg);
        await getUserData();
        return true;
      } else {
        final err = (response.data is Map && response.data['message'] != null)
            ? response.data['message'].toString()
            : 'Failed to update user';
        errorDialog(messageText: err);
      }
    } catch (e) {
      isLoading.value = false;
      errorDialog(messageText: 'Error updating user: $e');
    }
    return false;
  }

  Future<bool> deleteUserData(dynamic id) async {
    try {
      isDeleteLoading.value = true;
      final response = await ApiService.to.delete('rough-entry/user/$id');
      isDeleteLoading.value = false;

      if (response.statusCode == 200) {
        final msg = (response.data is Map && response.data['message'] != null)
            ? response.data['message'].toString()
            : 'User Deleted Successfully';
        successDialog(messageText: msg);
        await getUserData();
        return true;
      } else {
        final err = (response.data is Map && response.data['message'] != null)
            ? response.data['message'].toString()
            : 'Failed to delete user';
        errorDialog(messageText: err);
      }
    } catch (e) {
      isDeleteLoading.value = false;
      errorDialog(messageText: 'Error deleting user: $e');
    }
    return false;
  }

  // --- Module 2: Menu Rights Matrix ---
  Future<UserMenuRightsResponse?> getUserMenuRights(dynamic userId) async {
    try {
      dynamic response;
      try {
        response = await ApiService.to.get('user/$userId/menu-rights');
      } catch (_) {
        response =
            await ApiService.to.get('rough-entry/user/$userId/menu-rights');
      }
      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        if (response.data is Map<String, dynamic>) {
          return UserMenuRightsResponse.fromJson(
              response.data as Map<String, dynamic>);
        }
      }
    } catch (e) {
      log('getUserMenuRights error: $e');
    }
    return null;
  }

  Future<bool> saveUserMenuRights(
    dynamic userId,
    List<Map<String, dynamic>> menuRights,
  ) async {
    try {
      isLoading.value = true;
      final payload = {'menuRights': menuRights};
      dynamic response;
      try {
        response = await ApiService.to.post(
          'user/$userId/menu-rights',
          data: payload,
        );
      } catch (_) {
        response = await ApiService.to.post(
          'rough-entry/user/$userId/menu-rights',
          data: payload,
        );
      }
      isLoading.value = false;

      if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
        final msg = (response.data is Map && response.data['message'] != null)
            ? response.data['message'].toString()
            : 'Menu rights saved successfully';
        successDialog(messageText: msg);
        return true;
      } else {
        final err = (response != null && response.data is Map && response.data['message'] != null)
            ? response.data['message'].toString()
            : 'Failed to save menu rights';
        errorDialog(messageText: err);
      }
    } catch (e) {
      isLoading.value = false;
      errorDialog(messageText: 'Error saving menu rights: $e');
    }
    return false;
  }

  // --- Module 3: Allow Issue (Transfer Screen Mapping) ---
  Future<AllowIssueResponse?> getUserAllowIssue(dynamic userId) async {
    try {
      final response =
          await ApiService.to.get('rough-entry/user/$userId/allow-issue');
      if (response.statusCode == 200 && response.data != null) {
        if (response.data is Map<String, dynamic>) {
          return AllowIssueResponse.fromJson(
              response.data as Map<String, dynamic>);
        }
      }
    } catch (e) {
      log('getUserAllowIssue error: $e');
    }
    return null;
  }

  Future<bool> saveUserAllowIssue(
    dynamic userId,
    List<int> allowedUserIds,
  ) async {
    try {
      isLoading.value = true;
      final payload = {'allowedUserIds': allowedUserIds};
      final response = await ApiService.to.post(
        'rough-entry/user/$userId/allow-issue',
        data: payload,
      );
      isLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final msg = (response.data is Map && response.data['message'] != null)
            ? response.data['message'].toString()
            : 'Allow Issue permissions saved successfully';
        successDialog(messageText: msg);
        return true;
      } else {
        final err = (response.data is Map && response.data['message'] != null)
            ? response.data['message'].toString()
            : 'Failed to save allow issue permissions';
        errorDialog(messageText: err);
      }
    } catch (e) {
      isLoading.value = false;
      errorDialog(messageText: 'Error saving allow issue permissions: $e');
    }
    return false;
  }

  Future<List<Map<String, dynamic>>?> getTransferTargets(
      dynamic fromUserId) async {
    try {
      final response = await ApiService.to.get(
        'rough-entry/user/transfer-targets',
        queryParameters: {'fromUserId': fromUserId},
      );
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();
      }
    } catch (e) {
      log('getTransferTargets error: $e');
    }
    return null;
  }

  // --- Module 4: Report Rights ---
  Future<UserReportRightsResponse?> getUserReportRights(dynamic userId) async {
    try {
      final response =
          await ApiService.to.get('rough-entry/user/$userId/report-rights');
      if (response.statusCode == 200 && response.data != null) {
        if (response.data is Map<String, dynamic>) {
          return UserReportRightsResponse.fromJson(
              response.data as Map<String, dynamic>);
        }
      }
    } catch (e) {
      log('getUserReportRights error: $e');
    }
    return null;
  }

  Future<bool> saveUserReportRights(
    dynamic userId,
    List<int> reportCodes,
  ) async {
    try {
      isLoading.value = true;
      final payload = {'reportCodes': reportCodes};
      final response = await ApiService.to.post(
        'rough-entry/user/$userId/report-rights',
        data: payload,
      );
      isLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final msg = (response.data is Map && response.data['message'] != null)
            ? response.data['message'].toString()
            : 'Report rights saved successfully';
        successDialog(messageText: msg);
        return true;
      } else {
        final err = (response.data is Map && response.data['message'] != null)
            ? response.data['message'].toString()
            : 'Failed to save report rights';
        errorDialog(messageText: err);
      }
    } catch (e) {
      isLoading.value = false;
      errorDialog(messageText: 'Error saving report rights: $e');
    }
    return false;
  }

  Future<List<Map<String, dynamic>>?> getUserAllowedReports(
      dynamic userId) async {
    try {
      final response = await ApiService.to
          .get('rough-entry/user/$userId/allowed-reports');
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();
      }
    } catch (e) {
      log('getUserAllowedReports error: $e');
    }
    return null;
  }

  Future<void> getPaymentMstData({bool force = false}) async {
    if (!force && paymentMstList.isNotEmpty) return;
    try {
      final dio = ApiService.to.dio;

      final response = await dio.get(
        '${baseUrl}rough-entry/payment-mst',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        paymentMstList.value = data
            .map((json) => PaymentMstModel.fromJson(json))
            .toList()
            .reversed
            .toList();
      } else {
        errorDialog(messageText: 'Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.getPaymentMstData');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> getPaymentDetData({bool force = false}) async {
    if (!force && paymentDetList.isNotEmpty) return;
    try {
      final dio = ApiService.to.dio;

      final response = await dio.get(
        '${baseUrl}rough-entry/payment-det',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        paymentDetList.value = data
            .map((json) => PaymentDetModel.fromJson(json))
            .toList()
            .reversed
            .toList();
      } else {
        errorDialog(messageText: 'Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.getPaymentDetData');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> getPaymentDetAccData({bool force = false}) async {
    if (!force && paymentDetAccList.isNotEmpty) return;
    try {
      final dio = ApiService.to.dio;

      final response = await dio.get(
        '${baseUrl}rough-entry/payment-det-acc',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        paymentDetAccList.value = data
            .map((json) => PaymentDetAccModel.fromJson(json))
            .toList()
            .reversed
            .toList();
      } else {
        errorDialog(messageText: 'Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.getPaymentDetAccData');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> getPendingPaymentData({bool force = false}) async {
    if (!force && pendingPaymentList.isNotEmpty) return;
    try {
      final dio = ApiService.to.dio;

      final response = await dio.get(
        '${baseUrl}executeView/getPendingPayment',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        pendingPaymentList.value =
            data.map((json) => PendingPaymentModel.fromJson(json)).toList();
      } else {
        errorDialog(messageText: 'Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.getPendingPaymentData');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<RxList<PaymentDetailsModel>> getBookPartyPaymentDetails(
      int partyCode, paymentMstId) async {
    isLoading.value = true;
    try {
      final dio = ApiService.to.dio;

      final response = await dio.get(
        '${baseUrl}search/paymentDetails?paymentMstId=$paymentMstId&partyCode=$partyCode',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        bookPartyPaymentDetailsList.value =
            data.map((json) => PaymentDetailsModel.fromJson(json)).toList();
        isLoading.value = false;
        return bookPartyPaymentDetailsList;
      } else {
        errorDialog(messageText: 'Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.getBookPartyPaymentDetails');
      if (kDebugMode) {
        log('$error');
      }
    }
    return <PaymentDetailsModel>[].obs;
  }

  Future<RxList<OutstandingPaymentDetails>> getOutstandingPaymentDetails(
      {required int partyCode,
      required DateTime fromDate,
      required DateTime toDate}) async {
    isLoading.value = true;
    try {
      final dio = ApiService.to.dio;

      final response = await dio.get(
        '${baseUrl}search/outstandingPaymentDetails?fromDate=$fromDate&toDate=$toDate&partyCode=$partyCode',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        outstandingPaymentDetailsList.value = data
            .map((json) => OutstandingPaymentDetails.fromJson(json))
            .toList();
        isLoading.value = false;
        return outstandingPaymentDetailsList;
      } else {
        isLoading.value = false;
        errorDialog(messageText: 'Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      isLoading.value = false;
      errorDialog(messageText: 'An unexpected error occurred.getOutstandingPaymentDetails');
      if (kDebugMode) {
        log('$error');
      }
    }
    return <OutstandingPaymentDetails>[].obs;
  }

  Future<RxList<OutstandingPurchaseSaleDetails>>
      getOutstandingPurchaseSaleDetails({bool force = false}) async {
    if (!force && outstandingPurchaseSaleDetailsList.isNotEmpty) {
      return outstandingPurchaseSaleDetailsList;
    }
    isLoading.value = true;
    isLoadingDashboardData.value = true;
    try {
      final dio = ApiService.to.dio;

      final response = await dio.get(
        '${baseUrl}report/outstandingPurchaseDetails',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        if (kDebugMode) {
          print('OutStanding Purchase Sale Details: ${data.length}');
        }

        // Mapping each JSON object to a PartyMstModel
        outstandingPurchaseSaleDetailsList.value = data
            .map((json) => OutstandingPurchaseSaleDetails.fromJson(json))
            .toList();
        isLoading.value = false;
        isLoadingDashboardData.value = false;
        return outstandingPurchaseSaleDetailsList;
      } else {
        errorDialog(messageText: 'Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred. getOutstandingPurchaseSaleDetails');
      if (kDebugMode) {
        log('$error');
      }
    }
    return <OutstandingPurchaseSaleDetails>[].obs;
  }

  Future<RxList<PaymentDetailsModel>> getAccPartyPaymentDetails(
      int partyCode, paymentMstId) async {
    isLoading.value = true;
    try {
      final dio = ApiService.to.dio;

      final response = await dio.get(
        '${baseUrl}search/paymentDetails?paymentMstId=$paymentMstId&partyCode=$partyCode',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        accPartyPaymentDetailsList.value =
            data.map((json) => PaymentDetailsModel.fromJson(json)).toList();
        for (var i in accPartyPaymentDetailsList) {
          if (kDebugMode) {
            print('${i.invNo}  : JAMT ${i.jAmtRs}');
            print('${i.invNo}  : UAMT ${i.uAmtRs}');
          }
        }
        isLoading.value = false;
        return accPartyPaymentDetailsList;
      } else {
        errorDialog(messageText: 'Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.getAccPartyPaymentDetails');
      if (kDebugMode) {
        log('$error');
      }
    }
    return <PaymentDetailsModel>[].obs;
  }

  Future<void> addPaymentData({
    DateTime? paymentDate,
    String? paymentDay,
    String? chequeNo,
    int? partyCode,
    int? accountCode,
    double? jAmtRs,
    double? uAmtRs,
    String? remarks1,
    double? pAmtRs,
    double? aAmtRs,
    double? bookJAmtRs,
    double? bookUAmtRs,
    double? accJAmtRs,
    double? accUAmtRs,
    required RxList<PendingPaymentModel> accountDataGridSource,
    required RxList<PendingPaymentModel> bookDataGridSource,
  }) async {
    try {
      isLoading.value = true;
      final dio = ApiService.to.dio;
      var params = <String, dynamic>{
        "PaymentDate": DateFormat('yyyy-MM-dd HH:mm:ss').format(paymentDate!),
        "PaymentDay": paymentDay,
        "ChequeNo": chequeNo,
        "PartyCode": partyCode,
        "AccountCode": accountCode,
        "RateType": 'RS',
        "ExRate": 0.00,
        "JAmtRs": jAmtRs,
        // "JAmtDollar": Joi.number().precision(2),
        "UAmtRs": uAmtRs,
        // "UAmtDollar": Joi.number().precision(2),
        "Remarks1": remarks1,
        // "Remarks2":Joi.string(),
        "PAmtRs": pAmtRs,
        // "PAmtDollar": Joi.number().precision(2),
        "AAmtRs": aAmtRs,
        // "AAmtDollar": Joi.number().precision(2),
        "Sflag": "I",
        "LogID": "0",
        "PcID": "TESTFROMWEB",
        "Ever": 0,
        "CompanyCode": companyCode.value,
      };

      final response = await dio.post(
        '${baseUrl}rough-entry/payment-mst/add',
        data: jsonEncode(params),
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        // if (bookDataGridSource.isNotEmpty) {
        if (bookJAmtRs! > 0 || bookUAmtRs! > 0) {
          addCreditDebitData(
            mstId: 0,
            purMstId: 0,
            saleMstId: 0,
            invoiceDate: paymentDate,
            orgInvoiceDate: DateFormat('yyyy-MM-dd').format(paymentDate),
            paymentMstId: response.data['data']['PaymentMstID'],
            dueDate: DateFormat('yyyy-MM-dd').format(paymentDate),
            remarks1: remarks1,
            remarks2: ' ',
            partyCode: partyCode.toString(),
            creditRs: bookJAmtRs,
            debitRs: bookUAmtRs,
            invAmtRs: 0.00,
            drCr: ' ',
            formType: 'PAYMENT',
            entryType: 'PAYMENT',
            traType: 'PAYMENT',
            formName: 'FrmPayment',
            perPartyCode: accountCode.toString(),
            orgCt: 0,
            dueDays: 0,
            invoiceNo: 'ON ACCOUNT',
            srNo: 0,
            brokerCode: 0,
          );
        }
        await Future.wait(
          bookDataGridSource
              .where((value) =>
                  value.jAmtRs! > 0 || value.uAmtRs! > 0) // Filter entries
              .map((value) => addCreditDebitData(
                    mstId: value.mstID,
                    purMstId: 0,
                    saleMstId: 0,
                    invoiceDate: paymentDate,
                    orgInvoiceDate: value.orgInvDate,
                    paymentMstId: response.data['data']['PaymentMstID'],
                    dueDate: value.dueDate,
                    remarks1: remarks1,
                    remarks2: ' ',
                    partyCode: partyCode.toString(),
                    creditRs: value.jAmtRs,
                    debitRs: value.uAmtRs,
                    invAmtRs: value.amtRs,
                    drCr: value.drCr,
                    formType: value.trnType,
                    entryType: 'PAYMENT',
                    traType: value.traType,
                    formName: 'FrmPayment',
                    perPartyCode: accountCode.toString(),
                    orgCt: value.orgCt,
                    dueDays: value.dueDays,
                    invoiceNo: value.invNo,
                    srNo: value.subRefID,
                    brokerCode: value.orgBrokerCode,
                  )),
        );
        await Future.wait(bookDataGridSource.asMap().entries.map((entry) {
          int index = entry.key; // index of the current entry
          var value = entry.value;
          // current entry data
          return _addPaymentDetData(
              paymentMstId: response.data['data']['PaymentMstID'],
              partyCode: partyCode,
              subRefId: value.subRefID,
              // Need to Verify
              trnType: value.trnType,
              // Need To Verify
              traType: value.traType,
              srNo: index + 1,
              mstId: value.mstID,
              dueDays: value.dueDays,
              dueDate: value.dueDate,
              drCr: value.drCr,
              bdDrCr: value.bDDrCr,
              odDrCr: value.oDDrCr ?? ' ',
              amtRs: value.amtRs,
              bAmtRs: value.bAmtRs,
              brDrCr: value.bRDrCr,
              jAmtRs: value.jAmtRs,
              uAmtRs: value.uAmtRs,
              oAmtRs: value.oAmtRs,
              orDrCr: value.oRDrCr ?? ' ',
              orgInvDate: value.orgInvDate,
              brokerCode: value.orgBrokerCode,
              orgCt: value.orgCt,
              invNo: value.invNo);
        }));

        // if (accountDataGridSource.isNotEmpty) {
        if (accJAmtRs! > 0 || accUAmtRs! > 0) {
          addCreditDebitData(
            mstId: 0,
            purMstId: 0,
            saleMstId: 0,
            invoiceDate: paymentDate,
            orgInvoiceDate: DateFormat('yyyy-MM-dd').format(paymentDate),
            paymentMstId: response.data['data']['PaymentMstID'],
            dueDate: DateFormat('yyyy-MM-dd').format(paymentDate),
            remarks1: remarks1,
            remarks2: ' ',
            partyCode: accountCode.toString(),
            creditRs: accJAmtRs,
            debitRs: accUAmtRs,
            invAmtRs: 0.00,
            drCr: ' ',
            formType: 'PAYMENT',
            entryType: 'PAYMENT',
            traType: 'PAYMENT',
            formName: 'FrmPayment',
            perPartyCode: partyCode.toString(),
            orgCt: 0,
            dueDays: 0,
            invoiceNo: 'ON ACCOUNT',
            srNo: 0,
            brokerCode: 0,
          );
        }
        await Future.wait(
          accountDataGridSource
              .where((value) =>
                  value.jAmtRs! > 0 || value.uAmtRs! > 0) // Add filtering
              .map((value) => addCreditDebitData(
                    mstId: value.mstID,
                    purMstId: 0,
                    saleMstId: 0,
                    invoiceDate: paymentDate,
                    orgInvoiceDate: value.orgInvDate,
                    paymentMstId: response.data['data']['PaymentMstID'],
                    dueDate: value.dueDate,
                    remarks1: remarks1,
                    remarks2: ' ',
                    partyCode: accountCode.toString(),
                    creditRs: value.jAmtRs,
                    debitRs: value.uAmtRs,
                    invAmtRs: value.amtRs,
                    drCr: value.drCr,
                    formType: value.trnType,
                    entryType: 'PAYMENT',
                    traType: value.traType,
                    formName: 'FrmPayment',
                    perPartyCode: partyCode.toString(),
                    orgCt: value.orgCt,
                    dueDays: value.dueDays,
                    invoiceNo: value.invNo,
                    srNo: value.subRefID,
                    brokerCode: value.orgBrokerCode,
                  )),
        );
        await Future.wait(accountDataGridSource.asMap().entries.map((entry) {
          int index = entry.key; // index of the current entry
          var value = entry.value;
          if (kDebugMode) {
            print('WHILE CALLING API JAMT:${value.jAmtRs}');
            print('WHILE CALLING API UAMT:${value.uAmtRs}');
          }
          // current entry data
          return _addPaymentDetAccData(
              paymentMstId: response.data['data']['PaymentMstID'],
              partyCode: accountCode,
              subRefId: value.subRefID,
              // Need to Verify
              trnType: value.trnType,
              // Need To Verify
              traType: value.traType,
              srNo: index + 1,
              mstId: value.mstID,
              dueDays: value.dueDays,
              dueDate: value.dueDate,
              bdDrCr: value.bDDrCr,
              odDrCr: value.oDDrCr ?? ' ',
              drCr: value.drCr,
              amtRs: value.amtRs,
              bAmtRs: value.bAmtRs,
              brDrCr: value.bRDrCr,
              jAmtRs: value.jAmtRs,
              uAmtRs: value.uAmtRs,
              oAmtRs: value.oAmtRs,
              orDrCr: value.oRDrCr ?? ' ',
              orgInvDate: value.orgInvDate,
              brokerCode: value.orgBrokerCode,
              orgCt: value.orgCt,
              invNo: value.invNo);
        })).then(
            (value) => successDialog(messageText: response.data['message']));
        // }
        // if (bookDataGridSource.isEmpty && accountDataGridSource.isEmpty) {
        //
        //   successDialog(messageText: response.data['message']);
        // }
        await getPaymentMstData();
        await getPaymentDetData();
        await getPaymentDetAccData();
        await getCreditDebitData();
        await getOutstandingPurchaseSaleDetails();
        await getPendingPaymentData();
        /* } else {
        isLoading.value = false;
        errorDialog(messageText: 'Failed to Add data: ${response.statusCode}');
      }*/
      }
    } catch (error) {
      isLoading.value = false;
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error addPaymentData');
      }
    }
  }

  Future<void> updatePaymentData({
    required int mstId,
    DateTime? paymentDate,
    String? paymentDay,
    String? chequeNo,
    int? partyCode,
    int? accountCode,
    double? jAmtRs,
    double? uAmtRs,
    String? remarks1,
    double? pAmtRs,
    double? aAmtRs,
    double? bookJAmtRs,
    double? bookUAmtRs,
    double? accJAmtRs,
    double? accUAmtRs,
    required RxList<PaymentDetailsModel> accountDataGridSource,
    required RxList<PaymentDetailsModel> bookDataGridSource,
  }) async {
    try {
      isLoading.value = true;
      await deletePaymentDetails(id: mstId);
      final dio = ApiService.to.dio;

      var params = <String, dynamic>{
        "PaymentDate": DateFormat('yyyy-MM-dd HH:mm:ss').format(paymentDate!),
        "PaymentDay": paymentDay,
        "ChequeNo": chequeNo,
        "PartyCode": partyCode,
        "AccountCode": accountCode,
        "RateType": 'RS',
        "ExRate": 0.00,
        "JAmtRs": jAmtRs,
        // "JAmtDollar": Joi.number().precision(2),
        "UAmtRs": uAmtRs,
        // "UAmtDollar": Joi.number().precision(2),
        "Remarks1": remarks1,
        // "Remarks2":Joi.string(),
        "PAmtRs": pAmtRs,
        // "PAmtDollar": Joi.number().precision(2),
        "AAmtRs": aAmtRs,
        // "AAmtDollar": Joi.number().precision(2),
        "Sflag": "U",
        "LogID": "0",
        "PcID": "TESTFROMWEB",
        "Ever": 0,
        "CompanyCode": companyCode.value,
      };

      final response = await dio.put('${baseUrl}rough-entry/payment-mst/$mstId',
          data: jsonEncode(params));

      // if (kDebugMode) {
      //   print(response.data['data']);
      // }

      if (response.statusCode == 200) {
        isLoading.value = false;
        // if (bookDataGridSource.isNotEmpty) {
        if (bookJAmtRs! > 0 || bookUAmtRs! > 0) {
          addCreditDebitData(
            mstId: 0,
            purMstId: 0,
            saleMstId: 0,
            invoiceDate: paymentDate,
            orgInvoiceDate: DateFormat('yyyy-MM-dd').format(paymentDate),
            paymentMstId: response.data['data']['PaymentMstID'],
            dueDate: DateFormat('yyyy-MM-dd').format(paymentDate),
            remarks1: remarks1,
            remarks2: ' ',
            partyCode: partyCode.toString(),
            creditRs: bookJAmtRs,
            debitRs: bookUAmtRs,
            invAmtRs: 0.00,
            drCr: ' ',
            formType: 'PAYMENT',
            entryType: 'PAYMENT',
            traType: 'PAYMENT',
            formName: 'FrmPayment',
            perPartyCode: accountCode.toString(),
            orgCt: 0,
            dueDays: 0,
            invoiceNo: 'ON ACCOUNT',
            srNo: 0,
            brokerCode: 0,
          ).then((v) {
            log('CREDIT DEBIT ENTRY FOR ${response.data['data']['PaymentMstID']}');
          });
        }
        await Future.wait(
          bookDataGridSource
              .where((value) =>
                  value.jAmtRs! > 0 || value.uAmtRs! > 0) // Filter entries
              .map((value) => addCreditDebitData(
                    mstId: value.mstID,
                    purMstId: 0,
                    saleMstId: 0,
                    invoiceDate: paymentDate,
                    orgInvoiceDate: value.orgInvDate,
                    paymentMstId: response.data['data']['PaymentMstID'],
                    dueDate: value.dueDate,
                    remarks1: remarks1,
                    remarks2: ' ',
                    partyCode: partyCode.toString(),
                    creditRs: value.jAmtRs,
                    debitRs: value.uAmtRs,
                    invAmtRs: value.amtRs,
                    drCr: value.drCr,
                    formType: value.trnType,
                    entryType: 'PAYMENT',
                    traType: value.traType,
                    formName: 'FrmPayment',
                    perPartyCode: accountCode.toString(),
                    orgCt: value.orgCt,
                    dueDays: value.dueDays,
                    invoiceNo: value.invNo,
                    srNo: value.subRefID,
                    brokerCode: value.orgBrokerCode,
                  )),
        );
        await Future.wait(bookDataGridSource.asMap().entries.map((entry) {
          int index = entry.key; // index of the current entry
          var value = entry.value;
          // current entry data
          return _addPaymentDetData(
              paymentMstId: response.data['data']['PaymentMstID'],
              partyCode: partyCode,
              subRefId: value.subRefID,
              // Need to Verify
              trnType: value.trnType,
              // Need To Verify
              traType: value.traType,
              srNo: index + 1,
              mstId: value.mstID,
              dueDays: value.dueDays,
              dueDate: value.dueDate,
              drCr: value.drCr,
              bdDrCr: value.bDDrCr,
              odDrCr: value.oDDrCr ?? ' ',
              amtRs: value.amtRs,
              bAmtRs: value.bAmtRs,
              brDrCr: value.bRDrCr,
              jAmtRs: value.jAmtRs,
              uAmtRs: value.uAmtRs,
              oAmtRs: value.oAmtRs,
              orDrCr: value.oRDrCr ?? ' ',
              orgInvDate: value.orgInvDate,
              brokerCode: value.orgBrokerCode,
              orgCt: value.orgCt,
              invNo: value.invNo);
        }));
        // }
        // if (accountDataGridSource.isNotEmpty) {
        if (accJAmtRs! > 0 || accUAmtRs! > 0) {
          addCreditDebitData(
            mstId: 0,
            purMstId: 0,
            saleMstId: 0,
            invoiceDate: paymentDate,
            orgInvoiceDate: DateFormat('yyyy-MM-dd').format(paymentDate),
            paymentMstId: response.data['data']['PaymentMstID'],
            dueDate: DateFormat('yyyy-MM-dd').format(paymentDate),
            remarks1: remarks1,
            remarks2: ' ',
            partyCode: accountCode.toString(),
            creditRs: accJAmtRs,
            debitRs: accUAmtRs,
            invAmtRs: 0.00,
            drCr: ' ',
            formType: 'PAYMENT',
            entryType: 'PAYMENT',
            traType: 'PAYMENT',
            formName: 'FrmPayment',
            perPartyCode: partyCode.toString(),
            orgCt: 0,
            dueDays: 0,
            invoiceNo: 'ON ACCOUNT',
            srNo: 0,
            brokerCode: 0,
          );
        }
        await Future.wait(
          accountDataGridSource
              .where((value) =>
                  value.jAmtRs! > 0 || value.uAmtRs! > 0) // Add filtering
              .map((value) => addCreditDebitData(
                    mstId: value.mstID,
                    purMstId: 0,
                    saleMstId: 0,
                    invoiceDate: paymentDate,
                    orgInvoiceDate: value.orgInvDate,
                    paymentMstId: response.data['data']['PaymentMstID'],
                    dueDate: value.dueDate,
                    remarks1: remarks1,
                    remarks2: ' ',
                    partyCode: accountCode.toString(),
                    creditRs: value.jAmtRs,
                    debitRs: value.uAmtRs,
                    invAmtRs: value.amtRs,
                    drCr: value.drCr,
                    formType: value.trnType,
                    entryType: 'PAYMENT',
                    traType: value.traType,
                    formName: 'FrmPayment',
                    perPartyCode: partyCode.toString(),
                    orgCt: value.orgCt,
                    dueDays: value.dueDays,
                    invoiceNo: value.invNo,
                    srNo: value.subRefID,
                    brokerCode: value.orgBrokerCode,
                  )),
        );
        await Future.wait(accountDataGridSource.asMap().entries.map((entry) {
          int index = entry.key; // index of the current entry
          var value = entry.value;
          // current entry data
          return _addPaymentDetAccData(
              paymentMstId: response.data['data']['PaymentMstID'],
              partyCode: accountCode,
              subRefId: value.subRefID,
              // Need to Verify
              trnType: value.trnType,
              // Need To Verify
              traType: value.traType,
              srNo: index + 1,
              mstId: value.mstID,
              dueDays: value.dueDays,
              dueDate: value.dueDate,
              bdDrCr: value.bDDrCr,
              odDrCr: value.oDDrCr ?? ' ',
              drCr: value.drCr,
              amtRs: value.amtRs,
              bAmtRs: value.bAmtRs,
              brDrCr: value.bRDrCr,
              jAmtRs: value.jAmtRs,
              uAmtRs: value.uAmtRs,
              oAmtRs: value.oAmtRs,
              orDrCr: value.oRDrCr ?? ' ',
              orgInvDate: value.orgInvDate,
              brokerCode: value.orgBrokerCode,
              orgCt: value.orgCt,
              invNo: value.invNo);
        })).then(
            (value) => successDialog(messageText: response.data['message']));
        // }
        // if (bookDataGridSource.isEmpty && accountDataGridSource.isEmpty) {
        //   successDialog(messageText: response.data['message']);
        // }
        await getPaymentMstData();
        await getPaymentDetData();
        await getPaymentDetAccData();
        await getCreditDebitData();
        await getOutstandingPurchaseSaleDetails();
        await getPendingPaymentData();
      } else {
        isLoading.value = false;
        errorDialog(messageText: 'Failed to Add data: ${response.statusCode}');
      }
    } catch (error) {
      isLoading.value = false;

      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> _addPaymentDetData(
      {paymentMstId,
      partyCode,
      subRefId,
      srNo,
      trnType,
      mstId,
      dueDate,
      drCr,
      amtRs,
      bAmtRs,
      brDrCr,
      jAmtRs,
      uAmtRs,
      oAmtRs,
      orDrCr,
      bdDrCr,
      odDrCr,
      traType,
      orgInvDate,
      dueDays,
      brokerCode,
      orgCt,
      invNo}) async {
    try {
      isLoading.value = true;
      final dio = ApiService.to.dio;
      var params = <String, dynamic>{
        "PaymentMstID": paymentMstId,
        "PartyCode": partyCode,
        "SubRefID": subRefId,
        "SrNo": srNo,
        "TrnType": trnType,
        "MstID": mstId,
        "DueDate": dueDate,
        "DrCr": drCr,
        "AmtRs": amtRs,
        // "AmtDollar": Joi.number().precision(2),
        "BAmtRs": bAmtRs,
        // "BAmtDollar": Joi.number().precision(2),
        "BRDrCr": brDrCr,
        "BDDrCr": bdDrCr,
        "JAmtRs": jAmtRs,
        // "JAmtDollar": Joi.number().precision(2),
        "UAmtRs": uAmtRs,
        // "UAmtDollar": Joi.number().precision(2),
        "OAmtRs": oAmtRs,
        // "OAmtDollar": Joi.number().precision(2),
        // "ORDrCr": orDrCr,
        // "ODDrCr": odDrCr,
        "TraType": traType,
        "OrgInvDate": orgInvDate,
        "DueDays": dueDays,
        "OrgRateType": 'RS',
        // "OrgExRate": Joi.number().precision(4),
        "OrgBrokerCode": brokerCode,
        "OrgCt": orgCt,
        "InvNo": invNo,
      };

      final response = await dio.post(
        '${baseUrl}rough-entry/payment-det/add',
        data: jsonEncode(params),
      );

      if (response.statusCode == 200) {
        isLoading.value = false;

        // successDialog(messageText: response.data['message']);
        // await getPaymentMstData();
      } else {
        isLoading.value = false;
        errorDialog(messageText: 'Failed to Add data: ${response.statusCode}');
      }
    } catch (error) {
      isLoading.value = false;
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error  _addPaymentDetData');
      }
    }
  }

  Future<void> _addPaymentDetAccData(
      {paymentMstId,
      partyCode,
      subRefId,
      srNo,
      trnType,
      mstId,
      dueDate,
      drCr,
      amtRs,
      bAmtRs,
      brDrCr,
      jAmtRs,
      uAmtRs,
      oAmtRs,
      orDrCr,
      traType,
      orgInvDate,
      bdDrCr,
      odDrCr,
      dueDays,
      brokerCode,
      orgCt,
      invNo}) async {
    try {
      isLoading.value = true;
      final dio = ApiService.to.dio;
      var params = <String, dynamic>{
        "PaymentMstID": paymentMstId,
        "PartyCode": partyCode,
        "SubRefID": subRefId,
        "SrNo": srNo,
        "TrnType": trnType,
        "MstID": mstId,
        "DueDate": dueDate,
        "DrCr": drCr,
        "AmtRs": amtRs,
        // "AmtDollar": Joi.number().precision(2),
        "BAmtRs": bAmtRs,
        // "BAmtDollar": Joi.number().precision(2),
        "BRDrCr": brDrCr,
        "BDDrCr": bdDrCr,
        "JAmtRs": jAmtRs,
        // "JAmtDollar": Joi.number().precision(2),
        "UAmtRs": uAmtRs,
        // "UAmtDollar": Joi.number().precision(2),
        "OAmtRs": oAmtRs,
        // "OAmtDollar": Joi.number().precision(2),
        // "ORDrCr": orDrCr,
        // "ODDrCr": odDrCr,
        "TraType": traType,
        "OrgInvDate": orgInvDate,
        "DueDays": dueDays,
        "OrgRateType": 'RS',
        // "OrgExRate": Joi.number().precision(4),
        "OrgBrokerCode": brokerCode,
        "OrgCt": orgCt,
        "InvNo": invNo,
      };

      // if (kDebugMode) {
      //   print('Account Party Params: $params');
      // }

      final response = await dio.post(
        '${baseUrl}rough-entry/payment-det-acc/add',
        data: jsonEncode(params),
      );

      if (response.statusCode == 200) {
        isLoading.value = false;

        // successDialog(messageText: response.data['message']);
        // await getPaymentMstData();
      } else {
        isLoading.value = false;
        errorDialog(messageText: 'Failed to Add data: ${response.statusCode}');
      }
    } catch (error) {
      isLoading.value = false;
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error  _addPaymentDetAccData');
      }
    }
  }

  Future<void> addPartyData({
    String? partyType,
    String? partyName,
    String? contactPerson,
    String? address,
    String? mobileNo,
    String? phNo,
    String? fax,
    String? email,
    String? website,
    String? pan,
    String? adhar,
    String? bankName,
    String? branchName,
    String? bankAdd,
    String? ifscCode,
    String? bankAcNo,
    String? location,
    String? city,
    String? state,
    String? gstNo,
    String? remarks,
    int? sortId,
    int? pinCode,
    String? typeCode,
    bool? active,
    double? cGst,
    double? sGst,
    double? iGst,
    double? creditOpBalRs,
    double? creditOpBalDollor,
    double? debitOpBalRs,
    double? debitOpBalDollor,
  }) async {
    try {
      isLoading.value = true;
      final dio = ApiService.to.dio;

      // Resolve party type name if numeric typeCode is provided
      String? resolvedTypeName = partyType;
      if (resolvedTypeName == null && typeCode != null) {
        final matchedType = partyTypeMstList.firstWhereOrNull(
          (p) => p.typeCode.toString() == typeCode || p.typeName == typeCode,
        );
        resolvedTypeName = matchedType?.typeName ?? typeCode;
      } else if (resolvedTypeName != null) {
        final matchedType = partyTypeMstList.firstWhereOrNull(
          (p) => p.typeCode.toString() == resolvedTypeName || p.typeName == resolvedTypeName,
        );
        if (matchedType != null && matchedType.typeName != null) {
          resolvedTypeName = matchedType.typeName;
        }
      }

      // Dynamically create the params map matching the API specification
      var params = <String, dynamic>{
        if (resolvedTypeName != null) "Type": resolvedTypeName,
        if (resolvedTypeName != null) "PartyType": resolvedTypeName,
        if (partyName != null) "Name": partyName,
        if (partyName != null) "PartyName": partyName,
        if (contactPerson != null) "ContactPerson": contactPerson,
        if (address != null) "Address": address,
        if (mobileNo != null) "MobileNo": mobileNo,
        if (mobileNo != null) "Mobileno": mobileNo,
        if (phNo != null) "PhNo": phNo,
        if (fax != null) "Fax": fax,
        if (email != null) "EmailID": email,
        if (website != null) "WebSite": website,
        if (pan != null) "PanNo": pan,
        if (adhar != null) "AdharNo": adhar,
        if (bankName != null) "BankName": bankName,
        if (branchName != null) "BranchName": branchName,
        if (bankAdd != null) "BankAddress": bankAdd,
        if (bankAdd != null) "BankAdress": bankAdd,
        if (ifscCode != null) "IFSCCode": ifscCode,
        if (bankAcNo != null) "BankAcNo": bankAcNo,
        "Sflag": "I",
        "LogID": 0,
        "PcID": "TESTFROMWEB",
        "Ever": 0,
        "CompanyCode": companyCode.value,
        if (sortId != null) "SortID": sortId,
        if (active != null) "Active": active,
        if (location != null) "Location": location,
        if (city != null) "City": city,
        if (state != null) "State": state,
        if (pinCode != null) "PinCode": pinCode,
        if (gstNo != null) "GstNo": gstNo,
        if (cGst != null) "CGST": cGst,
        if (sGst != null) "SGST": sGst,
        if (iGst != null) "IGST": iGst,
        "IsDelete": false,
        if (typeCode != null) "TypeCode": typeCode,
        if (creditOpBalRs != null) "CreditOpBalRs": creditOpBalRs,
        if (creditOpBalDollor != null) "CreditOpBalDollar": creditOpBalDollor,
        if (debitOpBalRs != null) "DebitOpBalRs": debitOpBalRs,
        if (debitOpBalDollor != null) "DebitOpBalDollar": debitOpBalDollor,
        if (remarks != null) "Remarks": remarks,
      };

      final response = await dio.post(
        '${baseUrl}rough-entry/party/add',
        data: jsonEncode(params),
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        final msg = (response.data is Map && response.data['message'] != null)
            ? response.data['message']
            : 'Party Entry Saved Successfully';
        successDialog(messageText: msg);
        await getPartyData();
      } else {
        isLoading.value = false;
        errorDialog(messageText: 'Failed to Add data: ${response.statusCode}');
      }
    } catch (error) {
      isLoading.value = false;
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> updatePartyData({
    required id,
    String? partyType,
    String? partyName,
    String? contactPerson,
    String? address,
    String? mobileNo,
    String? phNo,
    String? fax,
    String? email,
    String? website,
    String? pan,
    String? adhar,
    String? bankName,
    String? branchName,
    String? bankAdd,
    String? ifscCode,
    String? bankAcNo,
    String? location,
    String? city,
    String? state,
    String? gstNo,
    String? remarks,
    int? sortId,
    int? pinCode,
    String? typeCode,
    bool? active,
    double? cGst,
    double? sGst,
    double? iGst,
    double? creditOpBalRs,
    double? creditOpBalDollor,
    double? debitOpBalRs,
    double? debitOpBalDollor,
  }) async {
    try {
      isLoading.value = true;
      final dio = ApiService.to.dio;

      // Resolve party type name if numeric typeCode is provided
      String? resolvedTypeName = partyType;
      if (resolvedTypeName == null && typeCode != null) {
        final matchedType = partyTypeMstList.firstWhereOrNull(
          (p) => p.typeCode.toString() == typeCode || p.typeName == typeCode,
        );
        resolvedTypeName = matchedType?.typeName ?? typeCode;
      } else if (resolvedTypeName != null) {
        final matchedType = partyTypeMstList.firstWhereOrNull(
          (p) => p.typeCode.toString() == resolvedTypeName || p.typeName == resolvedTypeName,
        );
        if (matchedType != null && matchedType.typeName != null) {
          resolvedTypeName = matchedType.typeName;
        }
      }

      // Dynamically create the params map matching the API specification
      var params = <String, dynamic>{
        if (resolvedTypeName != null) "Type": resolvedTypeName,
        if (resolvedTypeName != null) "PartyType": resolvedTypeName,
        if (partyName != null) "Name": partyName,
        if (partyName != null) "PartyName": partyName,
        if (contactPerson != null) "ContactPerson": contactPerson,
        if (address != null) "Address": address,
        if (mobileNo != null) "MobileNo": mobileNo,
        if (mobileNo != null) "Mobileno": mobileNo,
        if (phNo != null) "PhNo": phNo,
        if (fax != null) "Fax": fax,
        if (email != null) "EmailID": email,
        if (website != null) "WebSite": website,
        if (pan != null) "PanNo": pan,
        if (adhar != null) "AdharNo": adhar,
        if (bankName != null) "BankName": bankName,
        if (branchName != null) "BranchName": branchName,
        if (bankAdd != null) "BankAddress": bankAdd,
        if (bankAdd != null) "BankAdress": bankAdd,
        if (ifscCode != null) "IFSCCode": ifscCode,
        if (bankAcNo != null) "BankAcNo": bankAcNo,
        "Sflag": "U",
        "LogID": 0,
        "PcID": "TESTFROMWEB",
        "Ever": 0,
        "CompanyCode": companyCode.value,
        if (sortId != null) "SortID": sortId,
        if (active != null) "Active": active,
        if (location != null) "Location": location,
        if (city != null) "City": city,
        if (state != null) "State": state,
        if (pinCode != null) "PinCode": pinCode,
        if (gstNo != null) "GstNo": gstNo,
        if (cGst != null) "CGST": cGst,
        if (sGst != null) "SGST": sGst,
        if (iGst != null) "IGST": iGst,
        "IsDelete": false,
        if (typeCode != null) "TypeCode": typeCode,
        if (creditOpBalRs != null) "CreditOpBalRs": creditOpBalRs,
        if (creditOpBalDollor != null) "CreditOpBalDollar": creditOpBalDollor,
        if (debitOpBalRs != null) "DebitOpBalRs": debitOpBalRs,
        if (debitOpBalDollor != null) "DebitOpBalDollar": debitOpBalDollor,
        if (remarks != null) "Remarks": remarks,
      };

      final response = await dio.put(
        '${baseUrl}rough-entry/party/$id',
        data: jsonEncode(params),
      );

      if (response.statusCode == 200) {
        await getPartyData();
        isLoading.value = false;
        final msg = (response.data is Map && response.data['message'] != null)
            ? response.data['message']
            : 'Party Entry Updated Successfully';
        successDialog(messageText: msg);
      } else {
        isLoading.value = false;
        errorDialog(messageText: 'Failed to Add data: ${response.statusCode}');
      }
    } catch (error) {
      isLoading.value = false;
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> addPurchaseData(
      {String? partyCode,
      invoiceNo,
      invoiceDate,
      brokerCode,
      dueDays,
      dueDate,
      onlyDueDate,
      double? totalAmt,
      totalWt,
      totalRate,
      required List entries}) async {
    try {
      isLoading.value = true;
      final dio = ApiService.to.dio;

      var params = {
        // "RPType": "12",
        // "DayBookCode": 10,
        "InvoiceNo": "$invoiceNo",
        "InvoiceDate": DateFormat('yyyy-MM-dd HH:mm:ss').format(invoiceDate),
        // "Recdate": "2024-08-28 00:00:00",
        "PartyCode": partyCode,
        "BrokerCode": brokerCode,
        "DueDay": dueDays,
        "DueDate": dueDate,
        // "RDType": "dsf",
        // "Exchange": 45.2,
        // "TPc": 5,
        "TWeight": totalWt,
        "TAmtRs": totalAmt,
        "TAmtDollar": totalAmt,
        "TRateRs": totalRate,
        "TRateDollar": totalRate,
        // "InvCharge": 5645.56,
        // "InvChargePer": 5645.52,
        // "AddPer": 575.57,
        // "AddFix": 25.85,
        // "AddPer1": 757.35,
        // "AddFix1": 75.57,
        // "LessPer": 10.27,
        // "LessPer1": 13.27,
        // "LessFix": 547.23,
        // "LessFix1": 55.35,
        // "ExpPer": 5447.52,
        // "ExpFix": 2542.25,
        // "LinPer": 254.55,
        // "LinFix": 7574.52,
        // "ComPer": 4725.75,
        // "ComFix": 54.25,
        // "TotExpPer": 254.57,
        // "TotExpFix": 452.52,
        // "BroPer": 425.52,
        // "BroFix": 547.5,
        // "BroRs": 57.57,
        // "IntPer": 25.75,
        "TotAmtDollar": totalAmt,
        "TotNetAmtRs": totalAmt,
        "TotAmtRs": totalAmt,
        // "Rec": 10,
        "LogID": 0,
        "PCID": "TESTFROMWEB",
        "Ever": 0,
        "SDate": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        "CompanyCode": companyCode.value,
        // "VPartyCode": 2,
        // "IdBookNo": 2,
        // "ChkAdd": "ADD",
        // "ChkLess": "ADD",
        // "ChkExp": "ADD",
        // "ChkLin": "ADD",
        // "ChkCom": "ADD",
        // "ChkBro": "ADD",
        // "AvgRate": 4725.25,
        "NetAmtDollar": totalAmt,
        "NetAmtRs": totalAmt,
        "TotNetAmtDollar": totalAmt,
        // "PSite": "2024-08-28 00:00:00",
        // "LessType": "ADD",
        // "Remarks": "ADD",
        // "BIllType": "ADD",
        // "LabAmtRs": 542.558,
        // "LabAmtDollar": 4528.58,
        // "GstPer": 12.25,
        // "GstAmtRs": 758.36,
        // "GstAmtDollar": 452.32,
        // "AssRec": "I",
        // "EntryForm": 2,
        "EntryType": "I",
        // "InvChargeRs": 45.23,
        // "ComFixRs": 45.23,
        // "ChkInv": "FR",
        // "ExpFixRs": 45.23,
        // "LinFixRs": 45.23,
        // "TotExpFixRs": 45.23,
        // "AddFixRs": 45.23,
        // "LessFixRs": 45.23,
        "FinalNetAmtDollar": totalAmt,
        "FinalNetAmtRs": totalAmt
      };

      final response = await dio.post('${baseUrl}rough-entry/purchase/add',
          data: jsonEncode(params));

      // if (kDebugMode) {
      //   print(response.data['data']);
      // }

      if (response.statusCode == 200) {
        await Future.wait(entries.asMap().entries.map((entry) {
          int index = entry.key; // index of the current entry
          var value = entry.value;
          // current entry data
          return _addPurchaseRoughData(
              wt: value['wt'],
              rate: value['rate'],
              amount: value['amount'],
              roughName: value['rough'],
              description: value['description'],
              roughPurMstID: response.data['data']['RoughPurMstID'],
              srNo: index + 1 // incremented srNo
              );
        }));
        Future.wait(List.generate(2, (index) {
          return addCreditDebitData(
            mstId: response.data['data']['RoughPurMstID'],
            purMstId: response.data['data']['RoughPurMstID'],
            saleMstId: 0,
            invoiceDate: invoiceDate,
            orgInvoiceDate: DateFormat('yyyy-MM-dd').format(invoiceDate),
            paymentMstId: 0,
            dueDate: dueDate,
            remarks1: ' ',
            remarks2: ' ',
            partyCode:
                index == 0 ? companyPartyCode.value.toString() : partyCode,
            creditRs: index == 0 ? 0.00 : totalAmt,
            debitRs: index == 0 ? totalAmt : 0.00,
            invAmtRs: totalAmt,
            drCr: index == 0 ? 'DR' : 'CR',
            formType: 'Purchase',
            entryType: index == 0 ? 'NIL' : 'PARTY',
            traType: index == 0 ? 'NIL' : 'PARTY',
            formName: 'FrmPurchaseEntry',
            perPartyCode:
                index == 0 ? partyCode : companyPartyCode.value.toString(),
            orgCt: totalWt,
            dueDays: dueDays,
            invoiceNo: response.data['data']['InvoiceNo'],
            srNo: index + 1,
            brokerCode: brokerCode,
          );
        }));
        await getPurchaseData();
        await getPurchaseDetailsData();
        await getCreditDebitData();
        await getOutstandingPurchaseSaleDetails();
        await getPendingPaymentData();
        isLoading.value = true;
        final invoiceGenerator = PurchaseInvoiceGenerator();
        final pdfData = await invoiceGenerator.generateInvoice(
            id: purchaseDataList.length + 1,
            invoiceDate: invoiceDate,
            invoiceNo: response.data['data']['InvoiceNo'],
            partyCode: partyCode.toString(),
            brokerCode: brokerCode,
            dueDate: onlyDueDate,
            dueDays: dueDays,
            entries: entries,
            totalWt: totalWt,
            totalAmt: totalAmt!,
            totalRate: totalRate);
        isLoading.value = false;
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdfData,
        ).then((value) => successDialog(messageText: response.data['message']));
        if (!kDebugMode) {
          await Printing.sharePdf(
            bytes: pdfData,
            filename:
                '${response.data['data']['InvoiceNo']}.pdf', // Set the custom name here
          );
        }
      } else {
        isLoading.value = false;

        errorDialog(messageText: 'Failed to Add data: ${response.statusCode}');
      }
    } catch (error) {
      isLoading.value = false;

      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> addCreditDebitData({
    String? partyCode,
    invoiceNo,
    invoiceDate,
    orgInvoiceDate,
    brokerCode,
    dueDays,
    mstId,
    purMstId,
    saleMstId,
    // polishPurMstId,
    // polishRecMstId,
    paymentMstId,
    // exRate,
    creditRs,
    debitRs,
    drCr,
    formType,
    entryType,
    formName,
    srNo,
    invAmtRs,
    perPartyCode,
    remarks1,
    remarks2,
    traType,
    dueDate,
    orgCt,
  }) async {
    try {
      isLoading.value = true;
      final dio = ApiService.to.dio;

      var params = {
        "MstID": mstId,
        // Purchase Sale Mst ID
        "PurchaseMstID": purMstId,
        "SaleMstID": saleMstId,
        // "PolishPurMstID": polishPurMstId,
        // "PolishRecMstID": polishRecMstId,
        "PaymentMstID": paymentMstId,
        "InvDate": DateFormat('yyyy-MM-dd').format(invoiceDate),
        "DueDate": dueDate,
        "RateType": 'RS',
        "ExRate": 0.00,
        "PartyCode": partyCode,
        "CreditRs": creditRs,
        // "CreditDollar":Joi.number().precision(2),
        "DebitRs": debitRs,
        // "DebitDollar": Joi.number().precision(2),
        "InvAmtRs": invAmtRs,
        // "InvAmtDollar":Joi.number().precision(2),
        "DrCrType": drCr,
        "FormType": formType,
        "EntryType": entryType,
        "Sflag": 'I',
        "SDateTime": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "LogID": "0",
        "PcID": 'TESTFROMWEB',
        "Ever": 0,
        "FormName": formName,
        "SrNo": srNo,
        "PerPartyCode": perPartyCode,
        "Remarks1": remarks1,
        "Remarks2": remarks2,
        "CompanyCode": companyCode.value,
        "TraType": traType,
        // "OrgInvDate": DateFormat('yyyy-MM-dd HH:mm:ss').parse(orgInvoiceDate),
        "OrgInvDate": orgInvoiceDate,
        "DueDays": dueDays,
        "OrgRateType": 'RS',
        "OrgExRate": 0.0,
        "OrgBrokerCode": brokerCode,
        "OrgCt": orgCt,
        "InvoiceNo": invoiceNo,
        // "PolishSaleMstId": Joi.number().integer(),
        // "ExpenseMstID": Joi.number().integer(),
      };

      log(params.toString());

      final response = await dio.post('${baseUrl}rough-entry/credit-debit/add',
          data: jsonEncode(params));
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('${response.data['message']}');
        }
        isLoading.value = false;
      } else {
        isLoading.value = false;
        errorDialog(messageText: 'Failed to Add data: ${response.statusCode}');
      }
    } catch (error) {
      isLoading.value = false;
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error  addCreditDebitData');
      }
    }
  }

  Future<void> addSaleData(
      {String? partyCode,
      invoiceNo,
      invoiceDate,
      brokerCode,
      dueDays,
      dueDate,
      onlyDueDate,
      roughName,
      description,
      wt,
      rate,
      amount,
      double? totalAmt,
      totalWt,
      totalRate,
      required List<Map<String, String>> entries}) async {
    try {
      isLoading.value = true;
      final dio = ApiService.to.dio;

      var params = {
        "PolishDate": DateFormat('yyyy-MM-dd HH:mm:ss').format(invoiceDate),
        "InvoiceNo": "$invoiceNo",
        // "InvNo": 123,
        "InvoiceDate": DateFormat('yyyy-MM-dd HH:mm:ss').format(invoiceDate),
        "DueDay": dueDays,
        "DueDate": dueDate,
        // "InvCode": "1",
        // "SaleType": "LOCAL",
        // "InsuranceName": "RELIANCE",
        // "SGstPer": 12.453,
        // "CGstPer": 12.453,
        // "IGstPer": 12.453,
        // "SGstAmount": 14.23,
        // "CGstAmount": 12.23,
        // "IGstAmount": 12.32,
        // "SGstUsdAmount": 1.456,
        // "CGstUsdAmount": 1.456,
        // "IGstUsdAmount": 1.456,
        "TotRsAmt": totalAmt, //total
        "TotUsdAmt": totalAmt, // total
        "RoundRs": 0,
        "RoundUsd": 0,
        "NetUsdAmount": totalAmt, //total
        "RdType": "RS",
        "DollarRate": 1,
        "PaymentRec": "N",
        "BroPer": 0,
        "BroRsAmount": 0,
        "BroUSDAmount": 0,
        "BrokerCode": brokerCode,
        "BankCode": 0,
        "PartyCode": partyCode,
        "FinalRsAmount": totalAmt, //total
        "FinalUsdAmount": totalAmt, //total
        "TPcs": 0,
        "TWeight": totalWt, //total rough wt
        "TRate": totalRate, // ang rate = total amt / total wt
        "TAmount": totalAmt, // total
        "TDRate": totalRate, // rate = toal amt / total wt
        "TDAmount": totalAmt, // dollar amt total
        "Sflag": "I",
        "SDate": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        "LogID": 0, // userid
        "PCID": "TESTWEB", // deviceId
        "Ever": 0, // 0
        "CompanyCode": companyCode.value // Global var Company Code
      };

      final response = await dio.post('${baseUrl}rough-entry/polish-sale/add',
          data: jsonEncode(params));

      if (response.data['data'] != null) {
        await Future.wait(entries.asMap().entries.map((entry) {
          int index = entry.key; // index of the current entry
          var value = entry.value;
          // current entry data
          return _addSaleRoughData(
              wt: value['wt'],
              rate: value['rate'],
              amount: value['amount'],
              roughName: value['rough'],
              description: value['description'],
              polishSaleMstID: response.data['data']['PolishSaleMstID'],
              srNo: index + 1 // incremented srNo
              );
        }));
        Future.wait(List.generate(2, (index) {
          return addCreditDebitData(
            mstId: response.data['data']['PolishSaleMstID'],
            purMstId: 0,
            saleMstId: response.data['data']['PolishSaleMstID'],
            invoiceDate: invoiceDate,
            orgInvoiceDate: DateFormat('yyyy-MM-dd').format(invoiceDate),
            paymentMstId: 0,
            dueDate: dueDate,
            remarks1: ' ',
            remarks2: ' ',
            partyCode:
                index == 0 ? companyPartyCode.value.toString() : partyCode,
            creditRs: index == 0 ? totalAmt : 0.00,
            debitRs: index == 0 ? 0.00 : totalAmt,
            invAmtRs: totalAmt,
            drCr: index == 0 ? 'CR' : 'DR',
            formType: 'Sale',
            entryType: index == 0 ? 'NIL' : 'PARTY',
            traType: index == 0 ? 'NIL' : 'PARTY',
            formName: 'FrmSaleEntry',
            perPartyCode:
                index == 0 ? partyCode : companyPartyCode.value.toString(),
            orgCt: totalWt,
            dueDays: dueDays,
            invoiceNo: response.data['data']['InvoiceNo'],
            srNo: index + 1,
            brokerCode: brokerCode,
          );
        }));
        await getSaleData();
        await getSaleDetailsData();
        await getCreditDebitData();
        await getOutstandingPurchaseSaleDetails();
        await getPendingPaymentData();
        final invoiceGenerator = SaleInvoiceGenerator();
        final pdfData = await invoiceGenerator.generateInvoice(
            id: polishSaleList.length + 1,
            invoiceDate: invoiceDate,
            invoiceNo: response.data['data']['InvoiceNo'],
            partyCode: partyCode.toString(),
            brokerCode: brokerCode,
            dueDate: onlyDueDate,
            dueDays: dueDays,
            entries: entries,
            totalWt: totalWt,
            totalAmt: totalAmt!,
            totalRate: totalRate);
        isLoading.value = false;
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdfData,
        ).then((value) => successDialog(messageText: response.data['message']));
        if (!kDebugMode) {
          await Printing.sharePdf(
            bytes: pdfData,
            filename:
                '${response.data['data']['InvoiceNo']}.pdf', // Set the custom name here
          );
        }
      } else {
        isLoading.value = false;
        errorDialog(
            messageText: 'Failed to Add data: : ${response.data['message']}');
      }
    } catch (error) {
      isLoading.value = false;

      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> addMemoIssueData(
      {String? partyCode,
      invoiceNo,
      invoiceDate,
      brokerCode,
      dueDays,
      dueDate,
      roughName,
      description,
      wt,
      rate,
      amount,
      double? totalAmt,
      totalWt,
      totalRate,
      required List<Map<String, String>> entries}) async {
    try {
      isLoading.value = true;
      final dio = ApiService.to.dio;

      var params = {
        // "PolishDate": DateFormat('yyyy-MM-dd HH:mm:ss').format(invoiceDate),
        // "InvoiceNo": "$invoiceNo",
        // "InvNo": 123,
        "InvoiceDate": DateFormat('yyyy-MM-dd HH:mm:ss').format(invoiceDate),
        // "DueDay": dueDays,
        // "DueDate": dueDate,
        // "InvCode": "1",
        // "SaleType": "LOCAL",
        // "InsuranceName": "RELIANCE",
        // "SGstPer": 12.453,
        // "CGstPer": 12.453,
        // "IGstPer": 12.453,
        // "SGstAmount": 14.23,
        // "CGstAmount": 12.23,
        // "IGstAmount": 12.32,
        // "SGstUsdAmount": 1.456,
        // "CGstUsdAmount": 1.456,
        // "IGstUsdAmount": 1.456,
        "TotRsAmt": totalAmt, //total
        "TotUsdAmt": totalAmt, // total
        // "RoundRs": 0,
        // "RoundUsd": 0,
        "NetUsdAmount": totalAmt, //total
        // "RdType": "RS",
        // "DollarRate": 1,
        // "PaymentRec": "N",
        // "BroPer": 0,
        // "BroRsAmount": 0,
        // "BroUSDAmount": 0,
        "BrokerCode": brokerCode,
        // "BankCode": 0,
        "PartyCode": partyCode,
        "FinalRsAmount": totalAmt, //total
        "FinalUsdAmount": totalAmt, //total
        // "TPcs": 0,
        "TWeight": totalWt, //total rough wt
        "TRate": totalRate, // ang rate = total amt / total wt
        "TAmount": totalAmt, // total
        "TDRate": totalRate, // rate = toal amt / total wt
        "TDAmount": totalAmt, // dollar amt total
        "Sflag": "I",
        "SDate": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        "LogID": 0, // userid
        "PCID": "TESTWEB", // deviceId
        "Ever": 0, // 0
        "CompanyCode": companyCode.value // Global var Company Code
      };

      final response = await dio.post('${baseUrl}rough-entry/memo-issue/add',
          data: jsonEncode(params));

      if (response.data['data'] != null) {
        await Future.wait(entries.asMap().entries.map((entry) {
          int index = entry.key; // index of the current entry
          var value = entry.value;
          // current entry data
          return _addMemoIssueRoughData(
              wt: value['wt'],
              rate: value['rate'],
              amount: value['amount'],
              roughName: value['rough'],
              description: value['description'],
              memoIssueMstID: response.data['data']['MemoIssueMstID'],
              srNo: index + 1,
              rec: 'N' // incremented srNo
              );
        }));
        await getMemoIssueData();
        await getMemoIssueDetailsData();
        isLoading.value = true;
        final invoiceGenerator = MemoIssueInvoiceGenerator();
        final pdfData = await invoiceGenerator.generateInvoice(
            id: response.data['data']['MemoIssueMstID'],
            invoiceDate: invoiceDate,
            // invoiceNo: response.data['data']['InvoiceNo'],
            partyCode: partyCode.toString(),
            // brokerCode: brokerCode,
            // dueDate: onlyDueDate,
            // dueDays: dueDays,
            entries: entries,
            totalWt: totalWt,
            totalAmt: totalAmt!,
            totalRate: totalRate);
        isLoading.value = false;
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdfData,
        ).then((value) => successDialog(messageText: response.data['message']));
        if (!kDebugMode) {
          await Printing.sharePdf(
            bytes: pdfData,
            filename:
                'Memo-Issue/${getPartyName(int.parse(partyCode!))}/${DateTime.now()}.pdf', // Set the custom name here
          );
        }
      } else {
        isLoading.value = false;
        errorDialog(messageText: response.data['message']);
      }
    } catch (error) {
      isLoading.value = false;
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> addMemoRecData(
      {String? partyCode,
      invoiceNo,
      invoiceDate,
      brokerCode,
      dueDays,
      dueDate,
      roughName,
      description,
      wt,
      rate,
      amount,
      double? totalAmt,
      totalWt,
      totalRate,
      totalLossWt,
      totalRecWt,
      totalRecAmount,
      memoIssueDetailId,
      required List<Map<String, String>> entries}) async {
    try {
      isLoading.value = true;
      final dio = ApiService.to.dio;

      var params = {
        // "PolishDate": DateFormat('yyyy-MM-dd HH:mm:ss').format(invoiceDate),
        // "InvoiceNo": "$invoiceNo",
        // "InvNo": 123,
        "InvoiceDate": DateFormat('yyyy-MM-dd HH:mm:ss').format(invoiceDate),
        // "DueDay": dueDays,
        // "DueDate": dueDate,
        // "InvCode": "1",
        // "SaleType": "LOCAL",
        // "InsuranceName": "RELIANCE",
        // "SGstPer": 12.453,
        // "CGstPer": 12.453,
        // "IGstPer": 12.453,
        // "SGstAmount": 14.23,
        // "CGstAmount": 12.23,
        // "IGstAmount": 12.32,
        // "SGstUsdAmount": 1.456,
        // "CGstUsdAmount": 1.456,
        // "IGstUsdAmount": 1.456,
        "TotRsAmt": totalAmt, //total
        "TotUsdAmt": totalAmt, // total
        // "RoundRs": 0,
        // "RoundUsd": 0,
        "NetUsdAmount": totalAmt, //total
        // "RdType": "RS",
        // "DollarRate": 1,
        // "PaymentRec": "N",
        // "BroPer": 0,
        // "BroRsAmount": 0,
        // "BroUSDAmount": 0,
        "BrokerCode": brokerCode,
        // "BankCode": 0,
        "PartyCode": partyCode,
        "FinalRsAmount": totalAmt, //total
        "FinalUsdAmount": totalAmt, //total
        // "TPcs": 0,
        "TWeight": totalWt, //total rough wt
        "TRate": totalRate, // ang rate = total amt / total wt
        "TAmount": totalAmt, // total
        "TDRate": totalRate, // rate = toal amt / total wt
        "TDAmount": totalAmt, // dollar amt total
        "Sflag": "I",
        "SDate": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        "LogID": 0, // userid
        "PCID": "TESTWEB", // deviceId
        "Ever": 0, // 0
        "CompanyCode": companyCode.value // Global var Company Code
      };

      final response = await dio.post('${baseUrl}rough-entry/memo-rec/add',
          data: jsonEncode(params));

      if (response.data['data'] != null) {
        await Future.wait(entries.asMap().entries.map((entry) {
          int index = entry.key; // index of the current entry
          var value = entry.value;
          // current entry data
          return _addMemoRecRoughData(
              memoIssueDetId: value['detId'],
              wt: value['wt'],
              recWt: value['recWt'],
              lossWt: value['lossWt'],
              rate: value['rate'],
              amount: value['amount'],
              roughName: value['rough'],
              description: value['description'],
              memoRecMstID: response.data['data']['MemoRecMstID'],
              srNo: index + 1 // incremented srNo
              );
        }));
        await Future.wait(entries.asMap().entries.map((entry) {
          var value = entry.value;
          return _updateMemoIssueRoughData(
            id: value['detId'],
            rec: 'Y',
          );
        }));
        await getMemoRecData();
        await getMemoRecDetailsData();
        await getMemoIssueDetailsData();
        isLoading.value = true;
        final invoiceGenerator = MemoRecInvoiceGenerator();
        final pdfData = await invoiceGenerator.generateInvoice(
            id: response.data['data']['MemoRecMstID'],
            invoiceDate: invoiceDate,
            // invoiceNo: response.data['data']['InvoiceNo'],
            partyCode: partyCode.toString(),
            // brokerCode: brokerCode,
            // dueDate: onlyDueDate,
            // dueDays: dueDays,
            entries: entries,
            totalWt: totalWt,
            totalLossWt: totalLossWt,
            totalRecWt: totalRecWt,
            totalAmt: totalAmt!,
            totalRecAmt: totalRecAmount,
            totalRate: totalRate);
        isLoading.value = false;
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdfData,
        ).then((value) => successDialog(messageText: response.data['message']));
        if (!kDebugMode) {
          await Printing.sharePdf(
            bytes: pdfData,
            filename:
                'Memo-Receive/${getPartyName(int.parse(partyCode!))}/${DateTime.now()}.pdf', // Set the custom name here
          );
        }
      } else {
        isLoading.value = false;

        errorDialog(
            messageText: 'Failed to Add data: : ${response.data['message']}');
      }
    } catch (error) {
      isLoading.value = false;

      errorDialog(messageText: '$error');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> updatePurchaseData(
      {required int id,
      String? partyCode,
      invoiceNo,
      invoiceDate,
      brokerCode,
      dueDays,
      dueDate,
      onlyDueDate,
      double? totalAmt,
      totalWt,
      totalRate,
      required List entries}) async {
    try {
      isLoading.value = true;
      await deletePurchaseCreditDebitDetails(id: id);
      final dio = ApiService.to.dio;

      var params = {
        // "RPType": "12",
        // "DayBookCode": 10,
        "InvoiceNo": "$invoiceNo",
        "InvoiceDate": DateFormat('yyyy-MM-dd HH:mm:ss').format(invoiceDate),
        // "Recdate": "2024-08-28 00:00:00",
        "PartyCode": partyCode,
        "BrokerCode": brokerCode,
        "DueDay": dueDays,
        "DueDate": dueDate,
        // "RDType": "dsf",
        // "Exchange": 45.2,
        // "TPc": 5,
        "TWeight": totalWt,
        "TAmtRs": totalAmt,
        "TAmtDollar": totalAmt,
        "TRateRs": totalRate,
        "TRateDollar": totalRate,
        // "InvCharge": 5645.56,
        // "InvChargePer": 5645.52,
        // "AddPer": 575.57,
        // "AddFix": 25.85,
        // "AddPer1": 757.35,
        // "AddFix1": 75.57,
        // "LessPer": 10.27,
        // "LessPer1": 13.27,
        // "LessFix": 547.23,
        // "LessFix1": 55.35,
        // "ExpPer": 5447.52,
        // "ExpFix": 2542.25,
        // "LinPer": 254.55,
        // "LinFix": 7574.52,
        // "ComPer": 4725.75,
        // "ComFix": 54.25,
        // "TotExpPer": 254.57,
        // "TotExpFix": 452.52,
        // "BroPer": 425.52,
        // "BroFix": 547.5,
        // "BroRs": 57.57,
        // "IntPer": 25.75,
        "TotAmtDollar": totalAmt,
        "TotNetAmtRs": totalAmt,
        "TotAmtRs": totalAmt,
        // "Rec": 10,
        "LogID": 0,
        "PCID": "TESTFROMWEB",
        "Ever": 0,
        "SDate": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        "CompanyCode": companyCode.value,
        // "VPartyCode": 2,
        // "IdBookNo": 2,
        // "ChkAdd": "ADD",
        // "ChkLess": "ADD",
        // "ChkExp": "ADD",
        // "ChkLin": "ADD",
        // "ChkCom": "ADD",
        // "ChkBro": "ADD",
        // "AvgRate": 4725.25,
        "NetAmtDollar": totalAmt,
        "NetAmtRs": totalAmt,
        "TotNetAmtDollar": totalAmt,
        // "PSite": "2024-08-28 00:00:00",
        // "LessType": "ADD",
        // "Remarks": "ADD",
        // "BIllType": "ADD",
        // "LabAmtRs": 542.558,
        // "LabAmtDollar": 4528.58,
        // "GstPer": 12.25,
        // "GstAmtRs": 758.36,
        // "GstAmtDollar": 452.32,
        // "AssRec": "I",
        // "EntryForm": 2,
        "EntryType": "U",
        // "InvChargeRs": 45.23,
        // "ComFixRs": 45.23,
        // "ChkInv": "FR",
        // "ExpFixRs": 45.23,
        // "LinFixRs": 45.23,
        // "TotExpFixRs": 45.23,
        // "AddFixRs": 45.23,
        // "LessFixRs": 45.23,
        "FinalNetAmtDollar": totalAmt,
        "FinalNetAmtRs": totalAmt
      };

      final response = await dio.put('${baseUrl}rough-entry/purchase/$id',
          data: jsonEncode(params));

      // if (kDebugMode) {
      //   print(response.data['data']);
      // }

      if (response.statusCode == 200) {
        await Future.wait(entries.asMap().entries.map((entry) {
          int index = entry.key; // index of the current entry
          var value = entry.value;

          // Check if the 'id' exists in the entry data
          if (value.containsKey('id') && value['id'] != null) {
            // Call the update function if 'id' exists
            return _updatePurchaseRoughData(
              id: value['id'],
              wt: value['wt'],
              rate: value['rate'],
              amount: value['amount'],
              description: value['description'],
              roughName: value['rough'],
              roughPurMstID: response.data['data']['RoughPurMstID'],
              srNo: index + 1, // incremented srNo
            );
          } else {
            // Call the add function if 'id' does not exist
            return _addPurchaseRoughData(
              wt: value['wt'],
              rate: value['rate'],
              amount: value['amount'],
              description: value['description'],
              roughName: value['rough'],
              roughPurMstID: response.data['data']['RoughPurMstID'],
              srNo: index + 1, // incremented srNo
            );
          }
        }));
        Future.wait(List.generate(2, (index) {
          return addCreditDebitData(
            mstId: response.data['data']['RoughPurMstID'],
            purMstId: response.data['data']['RoughPurMstID'],
            saleMstId: 0,
            invoiceDate: invoiceDate,
            orgInvoiceDate: DateFormat('yyyy-MM-dd').format(invoiceDate),
            paymentMstId: 0,
            dueDate: dueDate,
            remarks1: ' ',
            remarks2: ' ',
            partyCode:
                index == 0 ? companyPartyCode.value.toString() : partyCode,
            creditRs: index == 0 ? 0.00 : totalAmt,
            debitRs: index == 0 ? totalAmt : 0.00,
            invAmtRs: totalAmt,
            drCr: index == 0 ? 'DR' : 'CR',
            formType: 'Purchase',
            entryType: index == 0 ? 'NIL' : 'PARTY',
            traType: index == 0 ? 'NIL' : 'PARTY',
            formName: 'FrmPurchaseEntry',
            perPartyCode:
                index == 0 ? partyCode : companyPartyCode.value.toString(),
            orgCt: totalWt,
            dueDays: dueDays,
            invoiceNo: response.data['data']['InvoiceNo'],
            srNo: index + 1,
            brokerCode: brokerCode,
          );
        }));
        isLoading.value = false;
        await getPurchaseData();
        await getPurchaseDetailsData();
        await getCreditDebitData();
        await getOutstandingPurchaseSaleDetails();
        await getPendingPaymentData();
        final invoiceGenerator = PurchaseInvoiceGenerator();
        final pdfData = await invoiceGenerator.generateInvoice(
            id: purchaseDataList.length + 1,
            invoiceDate: invoiceDate,
            invoiceNo: invoiceNo,
            partyCode: partyCode.toString(),
            brokerCode: brokerCode,
            dueDate: onlyDueDate,
            dueDays: dueDays,
            entries: entries,
            totalWt: totalWt,
            totalAmt: totalAmt!,
            totalRate: totalRate);
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdfData,
        ).then((value) => successDialog(messageText: response.data['message']));
        await Printing.sharePdf(
          bytes: pdfData,
          filename: '$invoiceNo.pdf', // Set the custom name here
        );
      } else {
        isLoading.value = false;

        errorDialog(
            messageText: 'Failed to Add data: : ${response.statusCode}');
      }
    } catch (error) {
      isLoading.value = false;

      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> updateSaleData(
      {required int id,
      String? partyCode,
      invoiceNo,
      invoiceDate,
      brokerCode,
      dueDays,
      dueDate,
      onlyDueDate,
      roughName,
      description,
      wt,
      rate,
      amount,
      double? totalAmt,
      totalWt,
      totalRate,
      required List<Map<String, String>> entries}) async {
    try {
      isLoading.value = true;
      await deleteSaleCreditDebitDetails(id: id);
      final dio = ApiService.to.dio;

      var params = {
        "PolishDate": DateFormat('yyyy-MM-dd HH:mm:ss').format(invoiceDate),
        "InvoiceNo": "$invoiceNo",
        // "InvNo": 123,
        "InvoiceDate": DateFormat('yyyy-MM-dd HH:mm:ss').format(invoiceDate),
        "DueDay": dueDays,
        "DueDate": dueDate,
        // "InvCode": "1",
        // "SaleType": "LOCAL",
        // "InsuranceName": "RELIANCE",
        // "SGstPer": 12.453,
        // "CGstPer": 12.453,
        // "IGstPer": 12.453,
        // "SGstAmount": 14.23,
        // "CGstAmount": 12.23,
        // "IGstAmount": 12.32,
        // "SGstUsdAmount": 1.456,
        // "CGstUsdAmount": 1.456,
        // "IGstUsdAmount": 1.456,
        "TotRsAmt": totalAmt, //total
        "TotUsdAmt": totalAmt, // total
        "RoundRs": 0,
        "RoundUsd": 0,
        "NetUsdAmount": totalAmt, //total
        "RdType": "RS",
        "DollarRate": 1,
        "PaymentRec": "N",
        "BroPer": 0,
        "BroRsAmount": 0,
        "BroUSDAmount": 0,
        "BrokerCode": brokerCode,
        "BankCode": 0,
        "PartyCode": partyCode,
        "FinalRsAmount": totalAmt, //total
        "FinalUsdAmount": totalAmt, //total
        "TPcs": 0,
        "TWeight": totalWt, //total rough wt
        "TRate": totalRate, // ang rate = total amt / total wt
        "TAmount": totalAmt, // total
        "TDRate": totalRate, // rate = toal amt / total wt
        "TDAmount": totalAmt, // dollar amt total
        "Sflag": "U",
        "SDate": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        "LogID": 0, // userid
        "PCID": "TESTWEB", // deviceId
        "Ever": 0, // 0
        "CompanyCode": companyCode.value // Global var Company Code
      };

      final response = await dio.put('${baseUrl}rough-entry/polish-sale/$id',
          data: jsonEncode(params));

      if (response.data['data'] != null) {
        await Future.wait(entries.asMap().entries.map((entry) {
          int index = entry.key; // index of the current entry
          var value = entry.value;
          // current entry data
          if (value.containsKey('id') && value['id'] != null) {
            return _updateSaleRoughData(
                id: value['id'],
                wt: value['wt'],
                rate: value['rate'],
                amount: value['amount'],
                roughName: value['rough'],
                description: value['description'],
                polishSaleMstID: response.data['data']['PolishSaleMstID'],
                srNo: index + 1 // incremented srNo
                );
          } else {
            return _addSaleRoughData(
                wt: value['wt'],
                rate: value['rate'],
                amount: value['amount'],
                description: value['description'],
                roughName: value['rough'],
                polishSaleMstID: response.data['data']['PolishSaleMstID'],
                srNo: index + 1 // incremented srNo
                );
          }
        }));
        Future.wait(List.generate(2, (index) {
          return addCreditDebitData(
            mstId: response.data['data']['PolishSaleMstID'],
            purMstId: 0,
            saleMstId: response.data['data']['PolishSaleMstID'],
            invoiceDate: invoiceDate,
            orgInvoiceDate: DateFormat('yyyy-MM-dd').format(invoiceDate),
            paymentMstId: 0,
            dueDate: dueDate,
            remarks1: ' ',
            remarks2: ' ',
            partyCode:
                index == 0 ? companyPartyCode.value.toString() : partyCode,
            creditRs: index == 0 ? 0.00 : totalAmt,
            debitRs: index == 0 ? totalAmt : 0.00,
            invAmtRs: totalAmt,
            drCr: index == 0 ? 'DR' : 'CR',
            formType: 'Sale',
            entryType: index == 0 ? 'NIL' : 'PARTY',
            traType: index == 0 ? 'NIL' : 'PARTY',
            formName: 'FrmSaleEntry',
            perPartyCode:
                index == 0 ? partyCode : companyPartyCode.value.toString(),
            orgCt: totalWt,
            dueDays: dueDays,
            invoiceNo: response.data['data']['InvoiceNo'],
            srNo: index + 1,
            brokerCode: brokerCode,
          );
        }));
        await getSaleData();
        await getSaleDetailsData();
        await getCreditDebitData();
        await getOutstandingPurchaseSaleDetails();
        await getPendingPaymentData();
        isLoading.value = false;
        final invoiceGenerator = SaleInvoiceGenerator();
        final pdfData = await invoiceGenerator.generateInvoice(
            id: polishSaleList.length + 1,
            invoiceDate: invoiceDate,
            invoiceNo: invoiceNo,
            partyCode: partyCode.toString(),
            brokerCode: brokerCode,
            dueDate: onlyDueDate,
            dueDays: dueDays,
            entries: entries,
            totalWt: totalWt,
            totalAmt: totalAmt!,
            totalRate: totalRate);
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdfData,
        ).then((value) => successDialog(messageText: response.data['message']));
        await Printing.sharePdf(
          bytes: pdfData,
          filename: '$invoiceNo.pdf', // Set the custom name here
        );
      } else {
        isLoading.value = false;

        errorDialog(
            messageText: 'Failed to Add data: : ${response.data['message']}');
      }
    } catch (error) {
      isLoading.value = false;

      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> updateMemoIssueData(
      {required int id,
      String? partyCode,
      invoiceNo,
      invoiceDate,
      brokerCode,
      dueDays,
      dueDate,
      roughName,
      description,
      wt,
      rate,
      amount,
      double? totalAmt,
      totalWt,
      totalRate,
      required List<Map<String, String>> entries}) async {
    try {
      isLoading.value = true;
      final dio = ApiService.to.dio;

      var params = {
        // "PolishDate": DateFormat('yyyy-MM-dd HH:mm:ss').format(invoiceDate),
        // "InvoiceNo": "$invoiceNo",
        // "InvNo": 123,
        "InvoiceDate": DateFormat('yyyy-MM-dd HH:mm:ss').format(invoiceDate),
        // "DueDay": dueDays,
        // "DueDate": dueDate,
        // "InvCode": "1",
        // "SaleType": "LOCAL",
        // "InsuranceName": "RELIANCE",
        // "SGstPer": 12.453,
        // "CGstPer": 12.453,
        // "IGstPer": 12.453,
        // "SGstAmount": 14.23,
        // "CGstAmount": 12.23,
        // "IGstAmount": 12.32,
        // "SGstUsdAmount": 1.456,
        // "CGstUsdAmount": 1.456,
        // "IGstUsdAmount": 1.456,
        "TotRsAmt": totalAmt, //total
        "TotUsdAmt": totalAmt, // total
        // "RoundRs": 0,
        // "RoundUsd": 0,
        "NetUsdAmount": totalAmt, //total
        // "RdType": "RS",
        // "DollarRate": 1,
        // "PaymentRec": "N",
        // "BroPer": 0,
        // "BroRsAmount": 0,
        // "BroUSDAmount": 0,
        "BrokerCode": brokerCode,
        // "BankCode": 0,
        "PartyCode": partyCode,
        "FinalRsAmount": totalAmt, //total
        "FinalUsdAmount": totalAmt, //total
        // "TPcs": 0,
        "TWeight": totalWt, //total rough wt
        "TRate": totalRate, // ang rate = total amt / total wt
        "TAmount": totalAmt, // total
        "TDRate": totalRate, // rate = toal amt / total wt
        "TDAmount": totalAmt, // dollar amt total
        "Sflag": "U",
        "SDate": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        "LogID": 0, // userid
        "PCID": "TESTWEB", // deviceId
        "Ever": 0, // 0
        "CompanyCode": companyCode.value // Global var Company Code
      };

      final response = await dio.put('${baseUrl}rough-entry/memo-issue/$id',
          data: jsonEncode(params));

      if (response.data['data'] != null) {
        await Future.wait(entries.asMap().entries.map((entry) {
          int index = entry.key; // index of the current entry
          var value = entry.value;
          // current entry data
          if (value.containsKey('id') && value['id'] != null) {
            return _updateMemoIssueRoughData(
                id: value['id'],
                wt: value['wt'],
                rate: value['rate'],
                amount: value['amount'],
                roughName: value['rough'],
                description: value['description'],
                memoIssueMstID: response.data['data']['MemoIssueMstID'],
                srNo: index + 1,
                rec: 'N' // incremented srNo
                );
          } else {
            return _addMemoIssueRoughData(
                wt: value['wt'],
                rate: value['rate'],
                amount: value['amount'],
                description: value['description'],
                roughName: value['rough'],
                memoIssueMstID: response.data['data']['MemoIssueMstID'],
                srNo: index + 1,
                rec: 'N' // incremented srNo
                );
          }
        }));
        await getMemoIssueData();
        await getMemoIssueDetailsData();
        isLoading.value = true;
        final invoiceGenerator = MemoIssueInvoiceGenerator();
        final pdfData = await invoiceGenerator.generateInvoice(
            id: response.data['data']['MemoIssueMstID'],
            invoiceDate: invoiceDate,
            // invoiceNo: response.data['data']['InvoiceNo'],
            partyCode: partyCode.toString(),
            // brokerCode: brokerCode,
            // dueDate: onlyDueDate,
            // dueDays: dueDays,
            entries: entries,
            totalWt: totalWt,
            totalAmt: totalAmt!,
            totalRate: totalRate);
        isLoading.value = false;
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdfData,
        ).then((value) => successDialog(messageText: response.data['message']));
        if (!kDebugMode) {
          await Printing.sharePdf(
            bytes: pdfData,
            filename:
                'Memo-Issue/${getPartyName(int.parse(partyCode!))}/${DateTime.now()}.pdf', // Set the custom name here
          );
        }
      } else {
        isLoading.value = false;

        errorDialog(
            messageText: 'Failed to Add data: : ${response.data['message']}');
      }
    } catch (error) {
      isLoading.value = false;

      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> updateMemoRecData(
      {required int id,
      String? partyCode,
      invoiceNo,
      invoiceDate,
      brokerCode,
      dueDays,
      dueDate,
      roughName,
      description,
      wt,
      rate,
      amount,
      double? totalAmt,
      totalWt,
      totalRate,
      required List<Map<String, String>> entries}) async {
    try {
      isLoading.value = true;
      final dio = ApiService.to.dio;

      var params = {
        // "PolishDate": DateFormat('yyyy-MM-dd HH:mm:ss').format(invoiceDate),
        // "InvoiceNo": "$invoiceNo",
        // "InvNo": 123,
        "InvoiceDate": DateFormat('yyyy-MM-dd HH:mm:ss').format(invoiceDate),
        // "DueDay": dueDays,
        // "DueDate": dueDate,
        // "InvCode": "1",
        // "SaleType": "LOCAL",
        // "InsuranceName": "RELIANCE",
        // "SGstPer": 12.453,
        // "CGstPer": 12.453,
        // "IGstPer": 12.453,
        // "SGstAmount": 14.23,
        // "CGstAmount": 12.23,
        // "IGstAmount": 12.32,
        // "SGstUsdAmount": 1.456,
        // "CGstUsdAmount": 1.456,
        // "IGstUsdAmount": 1.456,
        "TotRsAmt": totalAmt, //total
        "TotUsdAmt": totalAmt, // total
        // "RoundRs": 0,
        // "RoundUsd": 0,
        "NetUsdAmount": totalAmt, //total
        // "RdType": "RS",
        // "DollarRate": 1,
        // "PaymentRec": "N",
        // "BroPer": 0,
        // "BroRsAmount": 0,
        // "BroUSDAmount": 0,
        "BrokerCode": brokerCode,
        // "BankCode": 0,
        "PartyCode": partyCode,
        "FinalRsAmount": totalAmt, //total
        "FinalUsdAmount": totalAmt, //total
        // "TPcs": 0,
        "TWeight": totalWt, //total rough wt
        "TRate": totalRate, // ang rate = total amt / total wt
        "TAmount": totalAmt, // total
        "TDRate": totalRate, // rate = toal amt / total wt
        "TDAmount": totalAmt, // dollar amt total
        "Sflag": "U",
        "SDate": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        "LogID": 0, // userid
        "PCID": "TESTWEB", // deviceId
        "Ever": 0, // 0
        "CompanyCode": companyCode.value // Global var Company Code
      };

      final response = await dio.put('${baseUrl}rough-entry/memo-rec/$id',
          data: jsonEncode(params));

      if (response.data['data'] != null) {
        await Future.wait(entries.asMap().entries.map((entry) {
          int index = entry.key; // index of the current entry
          var value = entry.value;
          // current entry data
          if (value.containsKey('id') && value['id'] != null) {
            return _updateMemoRecRoughData(
                id: value['id'],
                wt: value['wt'],
                recWt: value['recWt'],
                rate: value['rate'],
                amount: value['amount'],
                roughName: value['rough'],
                description: value['description'],
                memoRecMstID: response.data['data']['MemoRecMstID'],
                srNo: index + 1 // incremented srNo
                );
          } else {
            return _addMemoRecRoughData(
                wt: value['wt'],
                rate: value['rate'],
                amount: value['amount'],
                description: value['description'],
                roughName: value['rough'],
                memoRecMstID: response.data['data']['MemoRecMstID'],
                srNo: index + 1 // incremented srNo
                );
          }
        }));
        await getMemoRecData();
        await getMemoRecDetailsData();
        isLoading.value = true;
        final invoiceGenerator = MemoRecInvoiceGenerator();
        final pdfData = await invoiceGenerator.generateInvoice(
            id: response.data['data']['MemoRecMstID'],
            invoiceDate: invoiceDate,
            // invoiceNo: response.data['data']['InvoiceNo'],
            partyCode: partyCode.toString(),
            // brokerCode: brokerCode,
            // dueDate: onlyDueDate,
            // dueDays: dueDays,
            entries: entries,
            totalWt: totalWt,
            totalAmt: totalAmt!,
            totalRate: totalRate);
        isLoading.value = false;
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdfData,
        ).then((value) => successDialog(messageText: response.data['message']));
        if (!kDebugMode) {
          await Printing.sharePdf(
            bytes: pdfData,
            filename:
                'Memo-Receive/${getPartyName(int.parse(partyCode!))}/${DateTime.now()}.pdf', // Set the custom name here
          );
        }
      } else {
        isLoading.value = false;

        errorDialog(
            messageText: 'Failed to Add data: : ${response.data['message']}');
      }
    } catch (error) {
      isLoading.value = false;

      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> _addPurchaseRoughData(
      {roughName, roughPurMstID, wt, rate, amount, description, srNo}) async {
    try {
      final dio = ApiService.to.dio;

      var params = {
        "RoughPurMstID": roughPurMstID,
        "Srno": srNo,
        "RoughTypeCode": int.parse(roughName),
        // "RoughQualityCode": 3,
        // "RoughCharniCode": 4,
        // "Pc": 2,
        "Wt": wt,
        "RateRs": rate,
        "AmtRs": amount,
        "RateDollar": rate,
        "AmtDollar": amount,
        // "Site": "AUGUST",
        // "Rec": 1,
        // "OldInvoiceNo": "TEST",
        // "OldRoughPurMstID": "TEST",
        "Description": description
      };

      final response = await dio.post('${baseUrl}rough-entry/rough-details/add',
          data: jsonEncode(params));

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Added!');
        }
      } else {
        errorDialog(
            messageText: 'Failed to Add data: : ${response.data['message']}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> _addSaleRoughData(
      {roughName, wt, rate, amount, description, srNo, polishSaleMstID}) async {
    try {
      final dio = ApiService.to.dio;

      var params = {
        "PolishSaleMstID": polishSaleMstID,
        "SrNo": srNo,
        // "ClarityCode": 1,
        // "CharniCode": 1,
        // "Pcs": 1,
        "Carats": wt,
        "RateRs": rate,
        "AmountRs": amount,
        "RateD": rate,
        "AmountD": amount,
        // "PenCarats": 12.232,
        "Type": "ROUGH",
        // "InvNo": "",
        // "RoughPurMstID": 2,
        "RoughTypeCode": int.parse(roughName),
        "Description": description
      };

      final response = await dio.post('${baseUrl}rough-entry/sale-details/add',
          data: jsonEncode(params));

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Added!');
        }
      } else {
        errorDialog(
            messageText: 'Failed to Add data: : ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> _addMemoIssueRoughData(
      {roughName,
      wt,
      rate,
      amount,
      description,
      srNo,
      memoIssueMstID,
      rec}) async {
    try {
      final dio = ApiService.to.dio;

      var params = {
        "MemoIssueMstID": memoIssueMstID,
        "SrNo": srNo,
        // "ClarityCode": 1,
        // "CharniCode": 1,
        // "Pcs": 1,
        "Carats": wt,
        "RateRs": rate,
        "AmountRs": amount,
        "RateD": rate,
        "AmountD": amount,
        // "PenCarats": 12.232,
        "Type": "ROUGH",
        // "InvNo": "",
        // "RoughPurMstID": 2,
        "RoughTypeCode": int.parse(roughName),
        "Description": description,
        "Rec": rec
      };

      final response = await dio.post(
          '${baseUrl}rough-entry/memo-issue-details/add',
          data: jsonEncode(params));

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Added!');
        }
      } else {
        errorDialog(
            messageText: 'Failed to Add data: : ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> _addMemoRecRoughData(
      {memoIssueDetId,
      roughName,
      wt,
      recWt,
      lossWt,
      rate,
      amount,
      description,
      srNo,
      memoRecMstID}) async {
    try {
      final dio = ApiService.to.dio;

      var params = {
        "MemoRecMstID": memoRecMstID,
        "MemoIssueDetID": memoIssueDetId,
        "SrNo": srNo,
        // "ClarityCode": 1,
        // "CharniCode": 1,
        // "Pcs": 1,
        "RecCarats": recWt,
        "LossCarats": lossWt,
        "Carats": wt,
        "RateRs": rate,
        "AmountRs": amount,
        "RateD": rate,
        "AmountD": amount,
        // "PenCarats": 12.232,
        "Type": "ROUGH",
        // "InvNo": "",
        // "RoughPurMstID": 2,
        "RoughTypeCode": int.parse(roughName),
        "Description": description
      };

      final response = await dio.post(
          '${baseUrl}rough-entry/memo-rec-details/add',
          data: jsonEncode(params));

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Added!');
        }
      } else {
        errorDialog(
            messageText: 'Failed to Add data: : ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> _updateSaleRoughData(
      {required id,
      roughName,
      wt,
      description,
      rate,
      amount,
      srNo,
      polishSaleMstID}) async {
    try {
      final dio = ApiService.to.dio;

      var params = {
        "PolishSaleMstID": polishSaleMstID,
        "SrNo": srNo,
        // "ClarityCode": 1,
        // "CharniCode": 1,
        // "Pcs": 1,
        "Carats": wt,
        "RateRs": rate,
        "AmountRs": amount,
        "RateD": rate,
        "AmountD": amount,
        // "PenCarats": 12.232,
        "Type": "ROUGH",
        // "InvNo": "",
        // "RoughPurMstID": 2,
        "RoughTypeCode": int.parse(roughName),
        "Description": description
      };

      final response = await dio.put('${baseUrl}rough-entry/sale-details/$id',
          data: jsonEncode(params));

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Updated!');
        }
      } else {
        errorDialog(
            messageText: 'Failed to Update Data: ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> _updateMemoIssueRoughData(
      {required id,
      roughName,
      wt,
      description,
      rate,
      amount,
      srNo,
      rec,
      memoIssueMstID}) async {
    try {
      final dio = ApiService.to.dio;

      var params = {
        if (memoIssueMstID != null) "MemoIssueMstID": memoIssueMstID,
        if (srNo != null) "SrNo": srNo,
        // "ClarityCode": 1,
        // "CharniCode": 1,
        // "Pcs": 1,
        if (wt != null) "Carats": wt,
        if (rate != null) "RateRs": rate,
        if (amount != null) "AmountRs": amount,
        if (rate != null) "RateD": rate,
        if (amount != null) "AmountD": amount,
        // "PenCarats": 12.232,
        "Type": "ROUGH",
        // "InvNo": "",
        // "RoughPurMstID": 2,
        if (roughName != null) "RoughTypeCode": int.parse(roughName),
        if (description != null) "Description": description,
        "Rec": rec
      };

      final response = await dio.put(
          '${baseUrl}rough-entry/memo-issue-details/$id',
          data: jsonEncode(params));

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Updated! $id $rec');
        }
      } else {
        errorDialog(
            messageText: 'Failed to Update Data: ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> _updateMemoRecRoughData(
      {required id,
      roughName,
      wt,
      recWt,
      description,
      rate,
      amount,
      srNo,
      memoRecMstID}) async {
    try {
      final dio = ApiService.to.dio;

      var params = {
        "MemoRecMstID": memoRecMstID,
        "SrNo": srNo,
        // "ClarityCode": 1,
        // "CharniCode": 1,
        // "Pcs": 1,
        "Carats": wt,
        "RecCarats": recWt,
        "RateRs": rate,
        "AmountRs": amount,
        "RateD": rate,
        "AmountD": amount,
        // "PenCarats": 12.232,
        "Type": "ROUGH",
        // "InvNo": "",
        // "RoughPurMstID": 2,
        "RoughTypeCode": int.parse(roughName),
        "Description": description
      };

      final response = await dio.put(
          '${baseUrl}rough-entry/memo-rec-details/$id',
          data: jsonEncode(params));

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Updated!');
        }
      } else {
        errorDialog(
            messageText: 'Failed to Update Data: ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> _updatePurchaseRoughData(
      {required id,
      roughName,
      wt,
      description,
      rate,
      amount,
      srNo,
      roughPurMstID}) async {
    try {
      final dio = ApiService.to.dio;

      var params = {
        "RoughPurMstID": roughPurMstID,
        "Srno": srNo,
        "RoughTypeCode": int.parse(roughName),
        // "RoughQualityCode": 3,
        // "RoughCharniCode": 4,
        // "Pc": 2,
        "Wt": wt,
        "RateRs": rate,
        "AmtRs": amount,
        "RateDollar": rate,
        "AmtDollar": amount,
        // "Site": "AUGUST",
        // "Rec": 1,
        // "OldInvoiceNo": "TEST",
        // "OldRoughPurMstID": "TEST",
        "Description": description
      };

      final response = await dio.put('${baseUrl}rough-entry/rough-details/$id',
          data: jsonEncode(params));

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Updated!');
        }
      } else {
        errorDialog(
            messageText: 'Failed to Update Data: ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> deletePurchaseRoughData({required id}) async {
    try {
      isDeleteLoading.value = true;
      final dio = ApiService.to.dio;

      final response =
          await dio.delete('${baseUrl}rough-entry/rough-details/$id');

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Deleted!');
        }
        await getPurchaseDetailsData();
        isDeleteLoading.value = false;
      } else {
        isDeleteLoading.value = false;
        errorDialog(
            messageText: 'Failed to Delete Data: ${response.statusCode}');
      }
    } catch (error) {
      isDeleteLoading.value = false;

      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> deleteSaleRoughData({required id}) async {
    try {
      isDeleteLoading.value = true;

      final dio = ApiService.to.dio;

      final response =
          await dio.delete('${baseUrl}rough-entry/sale-details/$id');

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Deleted!');
        }
        await getSaleDetailsData();
        isDeleteLoading.value = false;
      } else {
        isDeleteLoading.value = false;

        errorDialog(
            messageText: 'Failed to Delete Data: ${response.statusCode}');
      }
    } catch (error) {
      isDeleteLoading.value = false;

      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> deleteMemoIssueRoughData({required id}) async {
    try {
      isDeleteLoading.value = true;

      final dio = ApiService.to.dio;

      final response =
          await dio.delete('${baseUrl}rough-entry/memo-issue-details/$id');

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Deleted!');
        }
        await getMemoIssueDetailsData();
        isDeleteLoading.value = false;
      } else {
        isDeleteLoading.value = false;

        errorDialog(
            messageText: 'Failed to Delete Data: ${response.statusCode}');
      }
    } catch (error) {
      isDeleteLoading.value = false;

      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> deleteMemoRecRoughData({required id, detId}) async {
    try {
      isDeleteLoading.value = true;

      final dio = ApiService.to.dio;

      final response =
          await dio.delete('${baseUrl}rough-entry/memo-rec-details/$id');

      if (response.statusCode == 200) {
        _updateMemoIssueRoughData(id: detId, rec: 'N');
        if (kDebugMode) {
          print('Deleted!');
        }
        await getMemoRecDetailsData();
        await getMemoIssueDetailsData();
        isDeleteLoading.value = false;
      } else {
        isDeleteLoading.value = false;
        errorDialog(
            messageText: 'Failed to Delete Data: ${response.statusCode}');
      }
    } catch (error) {
      isDeleteLoading.value = false;

      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> deletePartyData({required id}) async {
    try {
      isDeleteLoading.value = true;
      final dio = ApiService.to.dio;

      final response = await dio.delete('${baseUrl}rough-entry/party/$id');

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Deleted!');
        }
        await getPartyData();
        isDeleteLoading.value = false;
        final msg = (response.data is Map && response.data['message'] != null)
            ? response.data['message']
            : 'Party Entry Deleted Successfully';
        successDialog(messageText: msg);
      } else {
        isDeleteLoading.value = false;
        errorDialog(
            messageText: 'Failed to Delete Data: ${response.statusCode}');
      }
    } catch (error) {
      isDeleteLoading.value = false;
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> deletePurchaseData(
      {required int id, required List entries}) async {
    try {
      isDeleteLoading.value = true;
      await deletePurchaseCreditDebitDetails(id: id);
      final dio = ApiService.to.dio;

      final response = await dio.delete('${baseUrl}rough-entry/purchase/$id');

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Deleted!');
        }

        // Ensure entries is not null and is a list
        if (entries.isNotEmpty) {
          // Ensure we create a list of Future<void> for Future.wait to process
          await Future.wait(
            entries.map((value) {
              return deletePurchaseRoughData(id: value['id']);
            }).toList(),
          );
        }

        // After processing deletion, refresh data and stop loading
        await getPurchaseDetailsData();
        await getPurchaseData();
        await getCreditDebitData();
        await getOutstandingPurchaseSaleDetails();
        await getPendingPaymentData();
        isDeleteLoading.value = false;

        successDialog(messageText: response.data['message']);
      } else {
        isDeleteLoading.value = false;
        errorDialog(
            messageText: 'Failed to Delete Data: ${response.statusCode}');
      }
    } catch (error) {
      isDeleteLoading.value = false;
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> deleteAssortData(
      {required int id}) async {
    try {
      isDeleteLoading.value = true;
      // await deletePurchaseCreditDebitDetails(id: id);
      final dio = ApiService.to.dio;

      final response = await dio.delete('${baseUrl}rough-entry/assort/$id');

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Deleted!');
        }

        // Ensure entries is not null and is a list

        // After processing deletion, refresh data and stop loading

        await getAssortData();
        isDeleteLoading.value = false;

        successDialog(messageText: response.data['message']);
      } else {
        isDeleteLoading.value = false;
        errorDialog(
            messageText: 'Failed to Delete Data: ${response.statusCode}');
      }
    } catch (error) {
      isDeleteLoading.value = false;
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> deleteSaleData({required int id, required List entries}) async {
    try {
      isDeleteLoading.value = true;
      await deleteSaleCreditDebitDetails(id: id);
      final dio = ApiService.to.dio;

      final response =
          await dio.delete('${baseUrl}rough-entry/polish-sale/$id');

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Deleted!');
        }

        // Ensure entries is not null and is a list
        if (entries.isNotEmpty) {
          // Ensure we create a list of Future<void> for Future.wait to process
          await Future.wait(
            entries.map((value) {
              return deleteSaleRoughData(id: value['id']);
            }).toList(),
          );
        }

        // After processing deletion, refresh data and stop loading
        await getSaleDetailsData();
        await getSaleData();
        await getCreditDebitData();
        await getOutstandingPurchaseSaleDetails();
        await getPendingPaymentData();
        isDeleteLoading.value = false;
        successDialog(messageText: response.data['message']);
      } else {
        isDeleteLoading.value = false;
        errorDialog(
            messageText: 'Failed to Delete Data: ${response.statusCode}');
      }
    } catch (error) {
      isDeleteLoading.value = false;
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> deleteMemoIssueData(
      {required int id, required List entries}) async {
    try {
      isDeleteLoading.value = true;

      final dio = ApiService.to.dio;

      final response = await dio.delete('${baseUrl}rough-entry/memo-issue/$id');

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Deleted!');
        }

        // Ensure entries is not null and is a list
        if (entries.isNotEmpty) {
          // Ensure we create a list of Future<void> for Future.wait to process
          await Future.wait(
            entries.map((value) {
              return deleteMemoIssueRoughData(id: value['id']);
            }).toList(),
          );
        }

        // After processing deletion, refresh data and stop loading
        await getMemoIssueDetailsData();
        await getMemoIssueData();
        isDeleteLoading.value = false;

        successDialog(messageText: response.data['message']);
      } else {
        isDeleteLoading.value = false;
        errorDialog(
            messageText: 'Failed to Delete Data: ${response.statusCode}');
      }
    } catch (error) {
      isDeleteLoading.value = false;
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> deleteMemoRecData(
      {required int id, required List entries}) async {
    try {
      isDeleteLoading.value = true;

      final dio = ApiService.to.dio;

      final response = await dio.delete('${baseUrl}rough-entry/memo-rec/$id');

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Deleted!');
        }

        // Ensure entries is not null and is a list
        if (entries.isNotEmpty) {
          // Ensure we create a list of Future<void> for Future.wait to process
          await Future.wait(
            entries.map((value) {
              return deleteMemoRecRoughData(
                  id: value['id'], detId: value['detId']);
            }).toList(),
          );
        }

        // After processing deletion, refresh data and stop loading
        await getMemoRecDetailsData();
        await getMemoIssueDetailsData();
        await getMemoRecData();
        isDeleteLoading.value = false;

        successDialog(messageText: response.data['message']);
      } else {
        isDeleteLoading.value = false;
        errorDialog(
            messageText: 'Failed to Delete Data: ${response.statusCode}');
      }
    } catch (error) {
      isDeleteLoading.value = false;
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> deletePaymentData({required int id}) async {
    try {
      isDeleteLoading.value = true;
      await deletePaymentDetails(id: id);
      final dio = ApiService.to.dio;

      final response =
          await dio.delete('${baseUrl}rough-entry/payment-mst/$id');

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Deleted!');
        }

        // Ensure entries is not null and is a list
        // if (entries.isNotEmpty) {
        //   // Ensure we create a list of Future<void> for Future.wait to process
        //   await Future.wait(
        //     entries.map((value) {
        //       return deleteMemoRecRoughData(
        //           id: value['id'], detId: value['detId']);
        //     }).toList(),
        //   );
        // }

        // After processing deletion, refresh data and stop loading
        await getPaymentMstData();
        await getPaymentDetData();
        await getPaymentDetAccData();
        await getOutstandingPurchaseSaleDetails();
        await getPendingPaymentData();

        isDeleteLoading.value = false;

        successDialog(messageText: response.data['message']);
      } else {
        isDeleteLoading.value = false;
        errorDialog(
            messageText: 'Failed to Delete Data: ${response.statusCode}');
      }
    } catch (error) {
      isDeleteLoading.value = false;
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> deletePaymentDetails({required int id}) async {
    try {
      // isDeleteLoading.value = true;

      final dio = ApiService.to.dio;

      final response =
          await dio.delete('${baseUrl}delete/payment-details?paymentMstId=$id');

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Deleted!');
        }

        // Ensure entries is not null and is a list
        // if (entries.isNotEmpty) {
        //   // Ensure we create a list of Future<void> for Future.wait to process
        //   await Future.wait(
        //     entries.map((value) {
        //       return deleteMemoIssueRoughData(id: value['id']);
        //     }).toList(),
        //   );
        // }

        // After processing deletion, refresh data and stop loading
        await getCreditDebitData();
        await getPaymentDetData();
        await getPaymentDetAccData();
        await getPaymentMstData();
        // isDeleteLoading.value = false;
        log(response.data['message']);
      } else {
        // isDeleteLoading.value = false;
        errorDialog(
            messageText: 'Failed to Delete Data: ${response.statusCode}');
      }
    } catch (error) {
      // isDeleteLoading.value = false;
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> deletePurchaseCreditDebitDetails({required int id}) async {
    try {
      // isDeleteLoading.value = true;

      final dio = ApiService.to.dio;

      final response = await dio
          .delete('${baseUrl}delete/purchase-credit-debit-details?mstId=$id');

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Deleted!');
        }

        // Ensure entries is not null and is a list
        // if (entries.isNotEmpty) {
        //   // Ensure we create a list of Future<void> for Future.wait to process
        //   await Future.wait(
        //     entries.map((value) {
        //       return deleteMemoIssueRoughData(id: value['id']);
        //     }).toList(),
        //   );
        // }

        // After processing deletion, refresh data and stop loading
        await getCreditDebitData();
        log(response.data['message']);
      } else {
        // isDeleteLoading.value = false;
        errorDialog(
            messageText: 'Failed to Delete Data: ${response.statusCode}');
      }
    } catch (error) {
      // isDeleteLoading.value = false;
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> deleteSaleCreditDebitDetails({required int id}) async {
    try {
      // isDeleteLoading.value = true;

      final dio = ApiService.to.dio;

      final response = await dio
          .delete('${baseUrl}delete/sale-credit-debit-details?mstId=$id');

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Deleted!');
        }

        // Ensure entries is not null and is a list
        // if (entries.isNotEmpty) {
        //   // Ensure we create a list of Future<void> for Future.wait to process
        //   await Future.wait(
        //     entries.map((value) {
        //       return deleteMemoIssueRoughData(id: value['id']);
        //     }).toList(),
        //   );
        // }

        // After processing deletion, refresh data and stop loading
        await getCreditDebitData();
        log(response.data['message']);
      } else {
        // isDeleteLoading.value = false;
        errorDialog(
            messageText: 'Failed to Delete Data: ${response.statusCode}');
      }
    } catch (error) {
      // isDeleteLoading.value = false;
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

//   Future<void> getIpAddress() async {
//     deviceInfo.value = 'Searching...';
//     // final info = NetworkInfo();
//     // String? ip = await info.getWifiIP(); // Get the Wi-Fi IP address
//     //   ipAddress.value = ip ?? 'No IP found'; // Update state with IP address
//     try {
//       /// Initialize Ip Address
//       var ip = IpAddress(type: RequestType.json);
// print(ip.getIp());
//       /// Get the IpAddress based on requestType.
//       dynamic data = await ip.getIp();
//       deviceInfo.value = data['ip'];
//     } on IpAddressException catch (exception) {
//       errorDialog(messageText: exception.message);
//
//       /// Handle the exception.
//       if (kDebugMode) {
//         print(exception.message);
//       }
//     }
//   }

  // Future<void> getHostName() async {
  //   deviceInfo.value = Platform.lo;
  // }

  Future<void> getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    // String deviceInfo;

    if (kIsWeb) {
      var info = await deviceInfoPlugin.webBrowserInfo;
      if (kDebugMode) {
        print(info.data);
      }
      deviceInfo.value = info.browserName.name;
    } else {
      if (Platform.isAndroid) {
        var androidInfo = await deviceInfoPlugin.androidInfo;
        deviceInfo.value = androidInfo.model;
      } else if (Platform.isIOS) {
        var iosInfo = await deviceInfoPlugin.iosInfo;
        deviceInfo.value = iosInfo.model;
      }
    }// Get Android version
    // } else if (Platform.isMacOS) {
    //   var iosInfo = await deviceInfoPlugin.macOsInfo;
    //   deviceInfo.value = 'MacOS ${iosInfo.computerName}'; // Get iOS version
    // } else {
    //   deviceInfo.value = 'Unknown Device';
    // }
  }

  Future<void> addAssortData(
      {String? name,
        sortId,
        group,
      }) async {
    try {
      isLoading.value = true;
      final dio = ApiService.to.dio;

      var params = {
        "Name": "$name",
        "SortID": sortId,
        "AssortGroup": group,
        // "Active": true,
      };

      final response = await dio.post('${baseUrl}rough-entry/assort/add',
          data: jsonEncode(params));

      // if (kDebugMode) {
      //   print(response.data['data']);
      // }

      if (response.statusCode == 200) {
        await getAssortData();
        isLoading.value = false;
        successDialog(messageText: response.data['message']);
      } else {
        isLoading.value = false;

        errorDialog(messageText: 'Failed to Add data: ${response.statusCode}');
      }
    } catch (error) {
      isLoading.value = false;

      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> updateAssortData(
      {required int id , String? name,
        sortId,
        group,
      }) async {
    try {
      isLoading.value = true;
      final dio = ApiService.to.dio;

      var params = {
        "Name": "$name",
        "SortID": sortId,
        "AssortGroup": group,
        // "Active": true,
      };

      final response = await dio.put('${baseUrl}rough-entry/assort/$id',
          data: jsonEncode(params));

      // if (kDebugMode) {
      //   print(response.data['data']);
      // }

      if (response.statusCode == 200) {
        await getAssortData();
        isLoading.value = false;
        successDialog(messageText: response.data['message']);
      } else {
        isLoading.value = false;

        errorDialog(messageText: 'Failed to Add data: ${response.statusCode}');
      }
    } catch (error) {
      isLoading.value = false;

      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> updateRoughAssortData(
      {required int id,
        String? invoiceNo,
        wt,
        assWt,
        penWt,
        required List entries}) async {
    try {
      isLoading.value = true;
      await deletePurchaseCreditDebitDetails(id: id);
      final dio = ApiService.to.dio;

      var params = {
        "InvoiceNo": "$invoiceNo",
        "Wt": wt,
        "AssortWt": assWt,
        "PendingWt": penWt,
        "LogID": 0,
        "PCID": "TESTFROMWEB",
        "Ever": 0,
        "SDate": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        "CompanyCode": companyCode.value,
      };

      final response = await dio.put('${baseUrl}rough-entry/rough-assort/$id',
          data: jsonEncode(params));

      // if (kDebugMode) {
      //   print(response.data['data']);
      // }

      if (response.statusCode == 200) {
        await Future.wait(entries.asMap().entries.map((entry) {
          int index = entry.key; // index of the current entry
          var value = entry.value;

          // Check if the 'id' exists in the entry data
          if (value.containsKey('id') && value['id'] != null) {
            // Call the update function if 'id' exists
            return _updateAssortRoughData(
              id: value['id'],
              wt: value['wt'],
              rate: value['rate'],
              amount: value['amount'],
              assort: value['assort'],
              roughAssortMstID: response.data['data']['RoughAssortMstID'],
              // srNo: index + 1, // incremented srNo
            );
          } else {
            // Call the add function if 'id' does not exist
            return _addAssortRoughData(
              wt: value['wt'],
              rate: value['rate'],
              amount: value['amount'],
              // description: value['description'],
              assort: value['assort'],
              roughAssortMstID: response.data['data']['RoughAssortMstID'],
              // srNo: index + 1, // incremented srNo
            );
          }
        }));
        await getRoughAssortData();
        await getRoughAssortDetailsData();
        isLoading.value = false;
        // await getRoughAssortData();
       successDialog(messageText: response.data['message']);
      } else {
        isLoading.value = false;

        errorDialog(
            messageText: 'Failed to Add data: : ${response.statusCode}');
      }
    } catch (error) {
      isLoading.value = false;

      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> _updateAssortRoughData(
      {required id,
        assort,
        wt,
        rate,
        amount,
        roughAssortMstID}) async {
    try {
      final dio = ApiService.to.dio;

      var params = {
        "RoughAssortMstID": roughAssortMstID,
        "AssortName": assort,
        "Wt": wt,
        "Rate": rate,
        "Ammount": amount,
      };

      final response = await dio.put('${baseUrl}rough-entry/rough-assort-det/$id',
          data: jsonEncode(params));

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Updated!');
        }
      } else {
        errorDialog(
            messageText: 'Failed to Update Data: ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> _addAssortRoughData(
      {assort, roughAssortMstID, wt, rate, amount}) async {
    try {
      final dio = ApiService.to.dio;

      var params = {
        "RoughAssortMstID": roughAssortMstID,
        "AssortName": assort,
        "Wt": wt,
        "Rate": rate,
        "Ammount": amount,
      };

      final response = await dio.post('${baseUrl}rough-entry/rough-assort-det/add',
          data: jsonEncode(params));

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Added!');
        }
      } else {
        errorDialog(
            messageText: 'Failed to Add data: : ${response.data['message']}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> addRoughAssortData(
      {String? invoiceNo,
        wt,
        assWt,
        penWt,
        required List entries}) async {
    try {
      isLoading.value = true;
      final dio = ApiService.to.dio;

      var params = {
        "InvoiceNo": "$invoiceNo",
        "Wt": wt,
        "AssortWt": assWt,
        "PendingWt": penWt,
        "LogID": 0,
        "PCID": "TESTFROMWEB",
        "Ever": 0,
        "SDate": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        "CompanyCode": companyCode.value,
      };

      final response = await dio.post('${baseUrl}rough-entry/rough-assort/add',
          data: jsonEncode(params));

      // if (kDebugMode) {
      //   print(response.data['data']);
      // }

      if (response.statusCode == 200) {
        await Future.wait(entries.asMap().entries.map((entry) {
          int index = entry.key; // index of the current entry
          var value = entry.value;
          // current entry data
          return _addAssortRoughData(
              wt: value['wt'],
              rate: value['rate'],
              amount: value['amount'],
              assort: value['assort'],
              // description: value['description'],
              roughAssortMstID: response.data['data']['RoughAssortMstID'],
              // srNo: index + 1 // incremented srNo
          );
        }));
        await getRoughAssortData();
        await getRoughAssortDetailsData();
        isLoading.value = false;
       successDialog(messageText: response.data['message']);
      } else {
        isLoading.value = false;

        errorDialog(messageText: 'Failed to Add data: ${response.statusCode}');
      }
    } catch (error) {
      isLoading.value = false;

      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> deleteRoughAssortData(
      {required int id, required List entries}) async {
    try {
      isDeleteLoading.value = true;
      // await deletePurchaseCreditDebitDetails(id: id);
      final dio = ApiService.to.dio;

      final response = await dio.delete('${baseUrl}rough-entry/rough-assort/$id');

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Deleted!');
        }

        // Ensure entries is not null and is a list
        if (entries.isNotEmpty) {
          // Ensure we create a list of Future<void> for Future.wait to process
          await Future.wait(
            entries.map((value) {
              return deleteRoughAssortDetData(id: value['id']);
            }).toList(),
          );
        }
        await getRoughAssortData();
        await getRoughAssortDetailsData();
        // After processing deletion, refresh data and stop loading
        isDeleteLoading.value = false;

        successDialog(messageText: response.data['message']);
      } else {
        isDeleteLoading.value = false;
        errorDialog(
            messageText: 'Failed to Delete Data: ${response.statusCode}');
      }
    } catch (error) {
      isDeleteLoading.value = false;
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> deleteRoughAssortDetData({required id}) async {
    try {
      isDeleteLoading.value = true;
      final dio = ApiService.to.dio;

      final response =
      await dio.delete('${baseUrl}rough-entry/rough-assort-det/$id');

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Deleted!');
        }
        isDeleteLoading.value = false;
      } else {
        isDeleteLoading.value = false;
        errorDialog(
            messageText: 'Failed to Delete Data: ${response.statusCode}');
      }
    } catch (error) {
      isDeleteLoading.value = false;

      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  static bool enableAutoFetchOnInit = false;

  @override
  Future<void> onInit() async {
    super.onInit();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken.value = prefs.getString('token') ?? '';
    refreshToken.value = prefs.getString('refreshToken') ?? '';
    await restoreUserSession();
    if (authToken.value.isNotEmpty && refreshToken.value.isNotEmpty) {
      ApiClient().startAutoRefreshTimer();
    }
    // Do not bulk-fetch all 35+ APIs on init/login.
    // Each screen loads its required data lazily on mount.
    if (authToken.value.isNotEmpty && companyCode.value > 0) {
      if (menuList.isEmpty) {
        await getMenuList();
      }
    }
  }
}
