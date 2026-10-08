import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/app_theme.dart';
import 'package:real_web_rough_entry_system/common/components/app_button.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanySelectionDialog extends StatefulWidget {
  final bool isSwitchCompany;

  const CompanySelectionDialog({super.key, required this.isSwitchCompany});

  @override
  State<CompanySelectionDialog> createState() => _CompanySelectionDialogState();
}

class _CompanySelectionDialogState extends State<CompanySelectionDialog> {
  late int _selectedCompanyCode;
  final FocusNode _proceedFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _selectedCompanyCode = defaultController.companyCode.value != 0
        ? defaultController.companyCode.value
        : 3;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _proceedFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _proceedFocus.dispose();
    super.dispose();
  }

  Future<void> _handleProceed() async {
    defaultController.companyCode.value = _selectedCompanyCode;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('companyCode', _selectedCompanyCode);

    if (widget.isSwitchCompany) {
      Get.back();
    } else {
      Get.offAllNamed('/MainScreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Center(
        child: Container(
          width: 440,
          constraints: const BoxConstraints(maxWidth: 440),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.business_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.isSwitchCompany ? 'Switch Company' : 'Select Company',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Choose the operating company branch',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.isSwitchCompany)
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () => Get.back(),
                        splashRadius: 18,
                      ),
                  ],
                ),
                const SizedBox(height: 20),

                // Company Selection Dropdown
                Obx(() {
                  final companies = defaultController.companies;
                  final availableList = companies.isNotEmpty
                      ? companies
                      : [getCompanyDetails(3)];

                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border, width: 1),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: availableList.any((e) => e.companyCode == _selectedCompanyCode)
                            ? _selectedCompanyCode
                            : (availableList.isNotEmpty ? availableList.first.companyCode : 3),
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        items: availableList.map((company) {
                          return DropdownMenuItem<int>(
                            value: company.companyCode ?? 3,
                            child: Row(
                              children: [
                                const Icon(Icons.apartment_rounded, size: 18, color: AppColors.primary),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    company.companyName ?? 'Abhinandan Diamond',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedCompanyCode = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),

                // Company Details Card Preview
                Builder(
                  builder: (context) {
                    final details = getCompanyDetails(_selectedCompanyCode);
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.borderLight, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (details.mobileno != null && details.mobileno!.isNotEmpty) ...[
                            Row(
                              children: [
                                const Icon(Icons.phone_rounded, size: 14, color: AppColors.textSecondary),
                                const SizedBox(width: 6),
                                Text(
                                  details.mobileno!,
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                          ],
                          if (details.address != null && details.address!.isNotEmpty) ...[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.location_on_rounded, size: 14, color: AppColors.textSecondary),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    details.address!,
                                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Proceed Button with Enter Shortcut
                AppButton(
                  text: widget.isSwitchCompany ? 'Confirm Switch' : 'Proceed to ERP',
                  icon: Icons.arrow_forward_rounded,
                  shortcutLabel: 'Enter',
                  height: 42,
                  focusNode: _proceedFocus,
                  autofocus: true,
                  onPressed: _handleProceed,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Press Enter to continue',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
