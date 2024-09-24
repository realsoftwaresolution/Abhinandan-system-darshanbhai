import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';
import 'package:real_web_rough_entry_system/memo%20issue/memo_issue_details_model.dart';
import 'package:real_web_rough_entry_system/memo%20issue/memo_issue_model.dart';
import 'package:real_web_rough_entry_system/memo%20receive/memo_rec_details_model.dart';
import 'package:real_web_rough_entry_system/memo%20receive/memo_rec_model.dart';
import 'package:real_web_rough_entry_system/party/party_model.dart';
import 'package:real_web_rough_entry_system/party/party_type_model.dart';
import 'package:real_web_rough_entry_system/purchase/purchase_details_model.dart';
import 'package:real_web_rough_entry_system/rough/rough_details_model.dart';
import 'package:real_web_rough_entry_system/rough/rough_model.dart';
import 'package:real_web_rough_entry_system/sale/sale_details_model.dart';
import 'package:real_web_rough_entry_system/sale/sale_model.dart';

class DefaultController extends GetxController {
  RxList<PartyMstModel> partyMstList = <PartyMstModel>[].obs;
  RxList<PurchaseDetailsModel> purchaseDataList = <PurchaseDetailsModel>[].obs;
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
  RxMap groupedData = {}.obs;
  RxBool isLoading = false.obs;
  RxBool isDeleteLoading = false.obs;
  RxInt companyCode = 0.obs;

  Future<void> getPartyData() async {
    try {
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

      final response = await dio.get(
        'http://50.62.183.116:301/rough-entry/party',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        partyMstList.value =
            data.map((json) => PartyMstModel.fromJson(json)).toList();
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
    try {
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

      final response = await dio.get(
        'http://50.62.183.116:301/rough-entry/purchase',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        purchaseDataList.value =
            data.map((json) => PurchaseDetailsModel.fromJson(json)).toList();
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

  Future<void> getPurchaseDetailsData() async {
    try {
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

      final response = await dio.get(
        'http://50.62.183.116:301/rough-entry/rough-details',
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
        'http://50.62.183.116:301/rough-entry/polish-sale',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        polishSaleList.value =
            data.map((json) => PolishSaleModel.fromJson(json)).toList();
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
        'http://50.62.183.116:301/rough-entry/memo-issue',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        memoIssueList.value =
            data.map((json) => MemoIssueModel.fromJson(json)).toList();
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
        'http://50.62.183.116:301/rough-entry/memo-rec',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        memoRecList.value =
            data.map((json) => MemoRecModel.fromJson(json)).toList();
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

  // Future<void> getSaleDetailsData() async {
  //   try {
  //     final dio = Dio(BaseOptions(headers: {
  //       'content-type': 'application/json',
  //     }));
  //
  //     final response = await dio.get(
  //       'http://50.62.183.116:301/rough-entry/sale-details',
  //     );
  //
  //     if (response.statusCode == 200) {
  //       // Assuming the response.data is a List of JSON objects
  //       final List<dynamic> data = response.data;
  //
  //       // Mapping each JSON object to a PartyMstModel
  //       saleDetailsList.value =
  //           data.map((json) => SaleDetailsModel.fromJson(json)).toList();
  //     } else {
  //       errorDialog(messageText: 'Failed to load data: ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     errorDialog(messageText: 'An unexpected error occurred.');
  //     if (kDebugMode) {
  //       log('$error');
  //     }
  //   }
  // }

  Future<void> getSaleDetailsData() async {
    try {
      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

      final response = await dio.get(
        'http://50.62.183.116:301/rough-entry/sale-details',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a SaleDetailsModel
        saleDetailsList.value =
            data.map((json) => SaleDetailsModel.fromJson(json)).toList();

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
        groupedData.forEach((key, value) {
          if (kDebugMode) {
            print('RoughTypeCode: $key, Total Weight after Sale: $value');
          }
        });
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
        'http://50.62.183.116:301/rough-entry/memo-issue-details',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        memoIssueDetailsList.value =
            data.map((json) => MemoIssueDetailsModel.fromJson(json)).toList();
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
        'http://50.62.183.116:301/rough-entry/memo-rec-details',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        memoRecDetailsList.value =
            data.map((json) => MemoRecDetailsModel.fromJson(json)).toList();
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
        'http://50.62.183.116:301/rough-entry/partyType',
      );

      if (response.statusCode == 200) {
        // Assuming the response.data is a List of JSON objects
        final List<dynamic> data = response.data;

        // Mapping each JSON object to a PartyMstModel
        partyTypeMstList.value =
            data.map((json) => PartyTypeMstModel.fromJson(json)).toList();
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
        'http://50.62.183.116:301/rough-entry/rough',
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
        errorDialog(messageText: 'Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      errorDialog(messageText: 'An unexpected error occurred.');
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
        'http://50.62.183.116:301/rough-entry/party/add',
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
        'http://50.62.183.116:301/rough-entry/party/$id',
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
          'http://50.62.183.116:301/rough-entry/purchase/add',
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
        await getPurchaseData();
        await getPurchaseDetailsData();
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
          'http://50.62.183.116:301/rough-entry/polish-sale/add',
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
        await getSaleData();
        await getSaleDetailsData();
        successDialog(messageText: response.data['message']);
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

      final response = await dio.post(
          'http://50.62.183.116:301/rough-entry/memo-issue/add',
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
        isLoading.value = false;
        successDialog(messageText: response.data['message']);
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

      final response = await dio.post(
          'http://50.62.183.116:301/rough-entry/memo-rec/add',
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
        isLoading.value = false;
        successDialog(messageText: response.data['message']);
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
          'http://50.62.183.116:301/rough-entry/purchase/$id',
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
        successDialog(messageText: response.data['message']);
        await getPurchaseData();
        await getPurchaseDetailsData();
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
          'http://50.62.183.116:301/rough-entry/polish-sale/$id',
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
        successDialog(messageText: response.data['message']);

        await getSaleData();
        await getSaleDetailsData();
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

      final response = await dio.put(
          'http://50.62.183.116:301/rough-entry/memo-issue/$id',
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
        isLoading.value = false;
        successDialog(messageText: response.data['message']);

        await getMemoIssueData();
        await getMemoIssueDetailsData();
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

      final response = await dio.put(
          'http://50.62.183.116:301/rough-entry/memo-rec/$id',
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
        isLoading.value = false;
        successDialog(messageText: response.data['message']);

        await getMemoRecData();
        await getMemoRecDetailsData();
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

      final response = await dio.post(
          'http://50.62.183.116:301/rough-entry/rough-details/add',
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

      final response = await dio.post(
          'http://50.62.183.116:301/rough-entry/sale-details/add',
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
          'http://50.62.183.116:301/rough-entry/memo-issue-details/add',
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
          'http://50.62.183.116:301/rough-entry/memo-rec-details/add',
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

      final response = await dio.put(
          'http://50.62.183.116:301/rough-entry/sale-details/$id',
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
          'http://50.62.183.116:301/rough-entry/memo-issue-details/$id',
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
          'http://50.62.183.116:301/rough-entry/memo-rec-details/$id',
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

      final response = await dio.put(
          'http://50.62.183.116:301/rough-entry/rough-details/$id',
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

      final response = await dio
          .delete('http://50.62.183.116:301/rough-entry/rough-details/$id');

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

      final response = await dio
          .delete('http://50.62.183.116:301/rough-entry/sale-details/$id');

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

      final response = await dio.delete(
          'http://50.62.183.116:301/rough-entry/memo-issue-details/$id');

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

      final response = await dio
          .delete('http://50.62.183.116:301/rough-entry/memo-rec-details/$id');

      if (response.statusCode == 200) {
        _updateMemoIssueRoughData(id: detId , rec: 'N');
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

      final response =
          await dio.delete('http://50.62.183.116:301/rough-entry/party/$id');

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

      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

      final response =
          await dio.delete('http://50.62.183.116:301/rough-entry/purchase/$id');

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

      final dio = Dio(BaseOptions(headers: {
        'content-type': 'application/json',
      }));

      final response = await dio
          .delete('http://50.62.183.116:301/rough-entry/polish-sale/$id');

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

      final response = await dio
          .delete('http://50.62.183.116:301/rough-entry/memo-issue/$id');

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

      final response =
          await dio.delete('http://50.62.183.116:301/rough-entry/memo-rec/$id');

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Deleted!');
        }

        // Ensure entries is not null and is a list
        if (entries.isNotEmpty) {
          // Ensure we create a list of Future<void> for Future.wait to process
          await Future.wait(
            entries.map((value) {
              return deleteMemoRecRoughData(id: value['id'], detId: value['detId']);
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

  @override
  Future<void> onInit() async {
    await getPartyData();
    await getPurchaseData();
    await getPartyTypeData();
    await getPurchaseDetailsData();
    await getSaleDetailsData();
    await getMemoIssueData();
    await getMemoIssueDetailsData();
    await getMemoRecData();
    await getMemoRecDetailsData();
    await getSaleData();
    await getRoughData();
    super.onInit();
  }
}
