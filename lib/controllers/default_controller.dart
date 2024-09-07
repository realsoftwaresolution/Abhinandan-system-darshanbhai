import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:real_web_rough_entry_system/party/party_model.dart';
import 'package:real_web_rough_entry_system/party/party_type_model.dart';
import 'package:real_web_rough_entry_system/purchase/purchase_details_model.dart';
import 'package:real_web_rough_entry_system/rough/rough-details-model.dart';
import 'package:real_web_rough_entry_system/rough/rough_model.dart';
import 'package:real_web_rough_entry_system/sale/sale_details_model.dart';
import 'package:real_web_rough_entry_system/sale/sale_model.dart';

class DefaultController extends GetxController {
  RxList<PartyMstModel> partyMstList = <PartyMstModel>[].obs;
  RxList<PurchaseDetailsModel> purchaseDataList = <PurchaseDetailsModel>[].obs;
  RxList<PolishSaleModel> polishSaleList = <PolishSaleModel>[].obs;

  // RxList<RoughPurchaseModel> polishSaleList = <RoughPurchaseModel>[].obs;
  RxList<PartyTypeMstModel> partyTypeMstList = <PartyTypeMstModel>[].obs;
  RxList<RoughModel> roughModel = <RoughModel>[].obs;
  RxList<RoughDetailsModel> roughDetailsModel = <RoughDetailsModel>[].obs;
  RxList<SaleDetailsModel> saleDetailsList = <SaleDetailsModel>[].obs;
  RxMap groupedData = {}.obs;
  RxBool isLoading = false.obs;
  RxInt companyCode = 0.obs;

  Future<void> getPartyData() async {
    try {
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

      final response = await dio.get(
        'http://50.62.183.116:1433/rough-entry/party',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        partyMstList.value =
            data.map((json) => PartyMstModel.fromJson(json)).toList();
      } else {
        Get.rawSnackbar(message: 'Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      Get.rawSnackbar(message: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> getPurchaseData() async {
    try {
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

      final response = await dio.get(
        'http://50.62.183.116:1433/rough-entry/purchase',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        purchaseDataList.value =
            data.map((json) => PurchaseDetailsModel.fromJson(json)).toList();
      } else {
        Get.rawSnackbar(message: 'Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      Get.rawSnackbar(message: 'An unexpected error occurred.');
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
        'http://50.62.183.116:1433/rough-entry/rough-details',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a RoughDetailsModel
        roughDetailsModel.value =
            data.map((json) => RoughDetailsModel.fromJson(json)).toList();

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
        //   print('RoughTypeCode: $key, Total Weight: $value');
        // });

        // You can now use the groupedData map for further processing
      } else {
        Get.rawSnackbar(message: 'Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      Get.rawSnackbar(message: 'An unexpected error occurred.');
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
        'http://50.62.183.116:1433/rough-entry/polish-sale',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        polishSaleList.value =
            data.map((json) => PolishSaleModel.fromJson(json)).toList();
      } else {
        Get.rawSnackbar(message: 'Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      Get.rawSnackbar(message: 'An unexpected error occurred.');
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
        'http://50.62.183.116:1433/rough-entry/sale-details',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        saleDetailsList.value =
            data.map((json) => SaleDetailsModel.fromJson(json)).toList();
      } else {
        Get.rawSnackbar(message: 'Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      Get.rawSnackbar(message: 'An unexpected error occurred.');
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
        'http://50.62.183.116:1433/rough-entry/partyType',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        partyTypeMstList.value =
            data.map((json) => PartyTypeMstModel.fromJson(json)).toList();
      } else {
        Get.rawSnackbar(message: 'Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      Get.rawSnackbar(message: 'An unexpected error occurred.');
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
        'http://50.62.183.116:1433/rough-entry/rough',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        roughModel.value =
            data.map((json) => RoughModel.fromJson(json)).toList();

        // for (int i = 0; i < roughModel.length; i++) {
        //   print(roughModel[i].roughTypeName);
        //   print(roughModel.length);
        // }
      } else {
        Get.rawSnackbar(message: 'Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      Get.rawSnackbar(message: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
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
        'http://50.62.183.116:1433/rough-entry/party/add',
        data: jsonEncode(params),
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        Get.rawSnackbar(message: response.data['message']);
        await getPartyData();
      } else {
        isLoading.value = false;
        Get.rawSnackbar(message: 'Failed to Add Data: ${response.statusCode}');
      }
    } catch (error) {
      isLoading.value = false;
      Get.rawSnackbar(message: 'An unexpected error occurred.');
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
        'http://50.62.183.116:1433/rough-entry/party/$id',
        data: jsonEncode(params),
      );

      if (response.statusCode == 200) {
        await getPartyData();
        isLoading.value = false;
        Get.rawSnackbar(message: response.data['message']);
      } else {
        isLoading.value = false;
        Get.rawSnackbar(message: 'Failed to Add Data: ${response.statusCode}');
      }
    } catch (error) {
      isLoading.value = false;
      Get.rawSnackbar(message: 'An unexpected error occurred.');
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

      final response = await dio.post(
          'http://50.62.183.116:1433/rough-entry/purchase/add',
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
        isLoading.value = false;
        Get.rawSnackbar(message: response.data['message']);
        getPurchaseData();
        getPurchaseDetailsData();
      } else {
        isLoading.value = false;

        Get.rawSnackbar(message: 'Failed to Add Data: ${response.statusCode}');
      }
    } catch (error) {
      isLoading.value = false;

      Get.rawSnackbar(message: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
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

      final response = await dio.post(
          'http://50.62.183.116:1433/rough-entry/polish-sale/add',
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
        isLoading.value = false;
        Get.rawSnackbar(message: response.data['message']);
        getSaleData();
        getSaleDetailsData();
      } else {
        isLoading.value = false;

        Get.rawSnackbar(
            message: 'Failed to Add Data: ${response.data['message']}');
      }
    } catch (error) {
      isLoading.value = false;

      Get.rawSnackbar(message: 'An unexpected error occurred.');
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

      final response = await dio.put(
          'http://50.62.183.116:1433/rough-entry/purchase/$id',
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

        isLoading.value = false;
        Get.rawSnackbar(message: response.data['message']);
        getPurchaseData();
        getPurchaseDetailsData();
      } else {
        isLoading.value = false;

        Get.rawSnackbar(message: 'Failed to Add Data: ${response.statusCode}');
      }
    } catch (error) {
      isLoading.value = false;

      Get.rawSnackbar(message: 'An unexpected error occurred.');
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
        "Sflag": "U",
        "SDate": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        "LogID": 0, // userid
        "PCID": "TESTWEB", // deviceId
        "Ever": 0, // 0
        "CompanyCode": companyCode.value // Global var Company Code
      };

      final response = await dio.put(
          'http://50.62.183.116:1433/rough-entry/polish-sale/$id',
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
        isLoading.value = false;
        Get.rawSnackbar(message: response.data['message']);
        getSaleData();
        getSaleDetailsData();
      } else {
        isLoading.value = false;

        Get.rawSnackbar(
            message: 'Failed to Add Data: ${response.data['message']}');
      }
    } catch (error) {
      isLoading.value = false;

      Get.rawSnackbar(message: 'An unexpected error occurred.');
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

      final response = await dio.post(
          'http://50.62.183.116:1433/rough-entry/rough-details/add',
          data: jsonEncode(params));

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Added!');
        }
        // Get.rawSnackbar(message: response.data['message']);
      } else {
        Get.rawSnackbar(message: 'Failed to Add Data: ${response.statusCode}');
      }
    } catch (error) {
      Get.rawSnackbar(message: 'An unexpected error occurred.');
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

      final response = await dio.post(
          'http://50.62.183.116:1433/rough-entry/sale-details/add',
          data: jsonEncode(params));

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Added!');
        }
        // Get.rawSnackbar(message: response.data['message']);
      } else {
        Get.rawSnackbar(message: 'Failed to Add Data: ${response.statusCode}');
      }
    } catch (error) {
      Get.rawSnackbar(message: 'An unexpected error occurred.');
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

      final response = await dio.put(
          'http://50.62.183.116:1433/rough-entry/sale-details/$id',
          data: jsonEncode(params));

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Updated!');
        }
        // Get.rawSnackbar(message: response.data['message']);
      } else {
        Get.rawSnackbar(
            message: 'Failed to Update Data: ${response.statusCode}');
      }
    } catch (error) {
      Get.rawSnackbar(message: 'An unexpected error occurred.');
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

      final response = await dio.put(
          'http://50.62.183.116:1433/rough-entry/rough-details/$id',
          data: jsonEncode(params));

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Updated!');
        }
        // Get.rawSnackbar(message: response.data['message']);
      } else {
        Get.rawSnackbar(
            message: 'Failed to Update Data: ${response.statusCode}');
      }
    } catch (error) {
      Get.rawSnackbar(message: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> deletePurchaseRoughData({required id}) async {
    try {
      isLoading.value = true;
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

      final response = await dio
          .delete('http://50.62.183.116:1433/rough-entry/rough-details/$id');

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Deleted!');
        }
        getPurchaseDetailsData();
        isLoading.value = false;

        // Get.rawSnackbar(message: response.data['message']);
      } else {
        isLoading.value = false;
        Get.rawSnackbar(
            message: 'Failed to Delete Data: ${response.statusCode}');
      }
    } catch (error) {
      isLoading.value = false;

      Get.rawSnackbar(message: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> deleteSaleRoughData({required id}) async {
    try {
      isLoading.value = true;

      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

      final response = await dio
          .delete('http://50.62.183.116:1433/rough-entry/sale-details/$id');

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Deleted!');
        }
        getSaleDetailsData();
        isLoading.value = false;

        // Get.rawSnackbar(message: response.data['message']);
      } else {
        isLoading.value = false;

        Get.rawSnackbar(
            message: 'Failed to Delete Data: ${response.statusCode}');
      }
    } catch (error) {
      isLoading.value = false;

      Get.rawSnackbar(message: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> deletePartyData({required id}) async {
    try {
      isLoading.value = true;

      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

      final response =
          await dio.delete('http://50.62.183.116:1433/rough-entry/party/$id');

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Deleted!');
        }
        getPartyData();
        isLoading.value = false;

        Get.rawSnackbar(message: response.data['message']);
      } else {
        isLoading.value = false;

        Get.rawSnackbar(
            message: 'Failed to Delete Data: ${response.statusCode}');
      }
    } catch (error) {
      isLoading.value = false;

      Get.rawSnackbar(message: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> deletePurchaseData({required int id, required List entries}) async {
    try {
      isLoading.value = true;

      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

      final response =
      await dio.delete('http://50.62.183.116:1433/rough-entry/purchase/$id');

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
        getPurchaseDetailsData();
        getPurchaseData();
        isLoading.value = false;

        Get.rawSnackbar(message: response.data['message']);
      } else {
        isLoading.value = false;
        Get.rawSnackbar(message: 'Failed to Delete Data: ${response.statusCode}');
      }
    } catch (error) {
      isLoading.value = false;
      Get.rawSnackbar(message: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }

  Future<void> deleteSaleData({required int id, required List entries}) async {
    try {
      isLoading.value = true;

      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

      final response =
      await dio.delete('http://50.62.183.116:1433/rough-entry/polish-sale/$id');

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
        getSaleDetailsData();
        getSaleData();
        isLoading.value = false;

        Get.rawSnackbar(message: response.data['message']);
      } else {
        isLoading.value = false;
        Get.rawSnackbar(message: 'Failed to Delete Data: ${response.statusCode}');
      }
    } catch (error) {
      isLoading.value = false;
      Get.rawSnackbar(message: 'An unexpected error occurred.');
      if (kDebugMode) {
        log('$error');
      }
    }
  }


  @override
  Future<void> onInit() async {
    await getPartyData();
    await getPurchaseData();
    // await getPurchaseData();
    await getPartyTypeData();
    await getSaleDetailsData();
    await getSaleData();
    await getRoughData();
    await getPurchaseDetailsData();
    super.onInit();
  }
}
