import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
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

class DefaultController extends GetxController {
  RxList<PartyMstModel> partyMstList = <PartyMstModel>[].obs;
  RxList<CompanyMst> companies = <CompanyMst>[].obs;
  RxList<PurchaseDetailsModel> purchaseDataList = <PurchaseDetailsModel>[].obs;
  RxList<CreditDebitMstModel> creditDebitDataList = <CreditDebitMstModel>[].obs;
  RxList<PolishSaleModel> polishSaleList = <PolishSaleModel>[].obs;
  RxList<MemoIssueModel> memoIssueList = <MemoIssueModel>[].obs;
  RxList<MemoRecModel> memoRecList = <MemoRecModel>[].obs;

  // RxList<RoughPurchaseModel> polishSaleList = <RoughPurchaseModel>[].obs;
  RxList<PartyTypeMstModel> partyTypeMstList = <PartyTypeMstModel>[].obs;
  RxList<RoughModel> roughModel = <RoughModel>[].obs;
  RxList<RoughDetailsModel> roughDetailsModel = <RoughDetailsModel>[].obs;
  RxList<SaleDetailsModel> saleDetailsList = <SaleDetailsModel>[].obs;
  RxList<MemoIssueDetailsModel> memoIssueDetailsList =
      <MemoIssueDetailsModel>[].obs;
  RxList<MemoRecDetailsModel> memoRecDetailsList = <MemoRecDetailsModel>[].obs;
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

  DataGridController accountDataGridController = DataGridController();
  DataGridController bookDataGridController = DataGridController();

  final RxString selectedTypeAccountParty = ''.obs;
  final RxString selectedTypeBookParty = ''.obs;

  // String baseUrl= 'http://localhost:301/';
  String baseUrl = 'http://50.62.183.116:301/';
  // String baseUrl = 'https://us-central1-real-rough-api.cloudfunctions.net/api/';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  Future<void> login(String username, String password) async {
    try {
      isLoading.value = true;
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));
      var params = <String, dynamic>{"CrName": username, "CrPass": password};
      final response =
          await dio.post('${baseUrl}rough-entry/user/login', data: params);
      if (response.data['data'] != null) {
        if (response.data['data']['Active'] == true) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('username', response.data['data']['CrName']);
          await prefs.setString('password', response.data['data']['CrPass']);
          await prefs.setBool('isLoggedIn', true);
          // await prefs.setBool('isDashboard', response.data['data']['Dashboard']);
          // enabledAdvancedDashboard = response.data['data']['Dashboard'];
          isLoading.value = false;
          Get.back();
          showCompanySelectionDialog(isFromSwitchCompany: false);
        } else {
          isLoading.value = false;
          infoDialog(messageText: 'User Inactive, Please Contact Your Admin.');
        }
      } else {
        isLoading.value = false;
        infoDialog(messageText: response.data['message']);
      }
    } catch (error) {
      isLoading.value = false;
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> getCompanies() async {
    try {
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

      final response = await dio.get(
        '${baseUrl}rough-entry/companies',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        companies.value =
            data.map((json) => CompanyMst.fromJson(json)).toList();
      } else {
        errorDialog(messageText: 'Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> getPartyData() async {
    try {
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

      final response = await dio.get(
        '${baseUrl}rough-entry/party',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        partyMstList.value = data
            .map((json) => PartyMstModel.fromJson(json))
            .toList()
            .reversed
            .toList();
      } else {
        errorDialog(messageText: 'Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> getCreditDebitData() async {
    try {
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> getPurchaseData() async {
    isLoadingDashboardData.value = true;
    try {
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> getPurchaseDetailsData() async {
    try {
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> getSaleData() async {
    try {
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> getMemoIssueData() async {
    try {
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> getMemoRecData() async {
    try {
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> getSaleDetailsData() async {
    try {
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> getMemoIssueDetailsData() async {
    try {
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> getMemoRecDetailsData() async {
    try {
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> getPartyTypeData() async {
    try {
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

      final response = await dio.get(
        '${baseUrl}rough-entry/partyType',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        partyTypeMstList.value = data
            .map((json) => PartyTypeMstModel.fromJson(json))
            .toList()
            .reversed
            .toList();
      } else {
        errorDialog(messageText: 'Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> getRoughData() async {
    try {
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

      final response = await dio.get(
        '${baseUrl}rough-entry/rough',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        roughModel.value = data
            .map((json) => RoughModel.fromJson(json))
            .toList()
            .reversed
            .toList();

        // for (int i = 0; i < roughModel.length; i++) {
        //   print(roughModel[i].roughTypeName);
        //   print(roughModel.length);
        // }
      } else {
        errorDialog(messageText: 'Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> getPaymentMstData() async {
    try {
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> getPaymentDetData() async {
    try {
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> getPaymentDetAccData() async {
    try {
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> getPendingPaymentData() async {
    try {
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<RxList<PaymentDetailsModel>> getBookPartyPaymentDetails(
      int partyCode, paymentMstId) async {
    isLoading.value = true;
    try {
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
    return <PaymentDetailsModel>[].obs;
  }

  Future<RxList<OutstandingPaymentDetails>> getOutstandingPaymentDetails(
      {required int partyCode,required DateTime fromDate,required DateTime toDate}) async {
    isLoading.value = true;
    try {
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
      errorDialog(messageText: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
    return <OutstandingPaymentDetails>[].obs;
  }

  Future<RxList<OutstandingPurchaseSaleDetails>> getOutstandingPurchaseSaleDetails() async {
    isLoading.value = true;
    isLoadingDashboardData.value = true;
    try {
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
      errorDialog(messageText: 'An unexpected error occurred.');
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
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
      errorDialog(messageText: 'An unexpected error occurred.');
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
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));
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
            orgInvoiceDate:
                DateFormat('yyyy-MM-dd').format(paymentDate),
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
      })).then((value) => successDialog(messageText: response.data['message']));
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
      }*/}
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
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
            orgInvoiceDate:
                DateFormat('yyyy-MM-dd').format(paymentDate),
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
            orgInvoiceDate:
                DateFormat('yyyy-MM-dd').format(paymentDate),
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
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));
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
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));
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
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

      // Dynamically create the params map
      var params = <String, dynamic>{
        if (partyType != null) "PartyType": partyType,
        if (partyName != null) "PartyName": partyName,
        if (contactPerson != null) "ContactPerson": contactPerson,
        if (address != null) "Address": address,
        if (mobileNo != null) "Mobileno": mobileNo,
        if (phNo != null) "PhNo": phNo,
        if (fax != null) "Fax": fax,
        if (email != null) "EmailID": email,
        if (website != null) "WebSite": website,
        if (pan != null) "PanNo": pan,
        if (adhar != null) "AdharNo": adhar,
        if (bankName != null) "BankName": bankName,
        if (branchName != null) "BranchName": branchName,
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
        successDialog(messageText: response.data['message']);
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
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

      // Dynamically create the params map
      var params = <String, dynamic>{
        if (partyType != null) "PartyType": partyType,
        if (partyName != null) "PartyName": partyName,
        if (contactPerson != null) "ContactPerson": contactPerson,
        if (address != null) "Address": address,
        if (mobileNo != null) "Mobileno": mobileNo,
        if (phNo != null) "PhNo": phNo,
        if (fax != null) "Fax": fax,
        if (email != null) "EmailID": email,
        if (website != null) "WebSite": website,
        if (pan != null) "PanNo": pan,
        if (adhar != null) "AdharNo": adhar,
        if (bankName != null) "BankName": bankName,
        if (branchName != null) "BranchName": branchName,
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
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
            orgInvoiceDate:
                DateFormat('yyyy-MM-dd').format(invoiceDate),
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
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

      var params = {
        "MstID": mstId, // Purchase Sale Mst ID
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
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
            orgInvoiceDate:
                DateFormat('yyyy-MM-dd').format(invoiceDate),
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
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
            orgInvoiceDate:
                DateFormat('yyyy-MM-dd').format(invoiceDate),
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
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
            orgInvoiceDate:
                DateFormat('yyyy-MM-dd').format(invoiceDate),
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
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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

      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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

      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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

      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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

      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

      final response = await dio.delete('${baseUrl}rough-entry/party/$id');

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Deleted!');
        }
        await getPartyData();
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

  Future<void> deletePurchaseData(
      {required int id, required List entries}) async {
    try {
      isDeleteLoading.value = true;
      await deletePurchaseCreditDebitDetails(id: id);
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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

  Future<void> deleteSaleData({required int id, required List entries}) async {
    try {
      isDeleteLoading.value = true;
      await deleteSaleCreditDebitDetails(id: id);
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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

      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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

      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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

      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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

      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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

      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

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

    // if (Platform.isWindows) {
    var info = await deviceInfoPlugin.webBrowserInfo;
    if (kDebugMode) {
      print(info.data);
    }
    deviceInfo.value = info.browserName.name; // Get Android version
    // } else if (Platform.isMacOS) {
    //   var iosInfo = await deviceInfoPlugin.macOsInfo;
    //   deviceInfo.value = 'MacOS ${iosInfo.computerName}'; // Get iOS version
    // } else {
    //   deviceInfo.value = 'Unknown Device';
    // }
  }

  @override
  Future<void> onInit() async {
    // await getIpAddress();
    await getDeviceInfo();
    await getOutstandingPurchaseSaleDetails();
    await getPurchaseData();
    // await getHostName();
    await getCompanies();
    await getPartyData();
    await getCreditDebitData();
    await getPartyTypeData();
    await getPurchaseDetailsData();
    await getSaleDetailsData();
    await getMemoIssueData();
    await getMemoIssueDetailsData();
    await getMemoRecData();
    await getMemoRecDetailsData();
    await getSaleData();
    await getRoughData();
    await getPaymentMstData();
    await getPaymentDetData();
    await getPaymentDetAccData();
    await getPendingPaymentData();
    super.onInit();
  }
}
