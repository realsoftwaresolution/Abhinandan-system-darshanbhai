import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:real_web_rough_entry_system/app_theme.dart';
import 'package:real_web_rough_entry_system/branch_transfer/branch_transfer_datagrid.dart';
import 'package:real_web_rough_entry_system/branch_transfer/branch_transfer_item_model.dart';
import 'package:real_web_rough_entry_system/common/components/app_button.dart';
import 'package:real_web_rough_entry_system/common/components/app_data_grid.dart';
import 'package:real_web_rough_entry_system/common/components/app_dropdown.dart';
import 'package:real_web_rough_entry_system/common/components/app_text_field.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/header.dart';
import 'package:real_web_rough_entry_system/responsive.dart';
import 'package:real_web_rough_entry_system/tab-view-dashboard/tab_controller.dart';
import 'package:real_web_rough_entry_system/user/user_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class BranchTransferFormScreen extends StatefulWidget {
  final bool showHeader;

  const BranchTransferFormScreen({super.key, this.showHeader = false});

  @override
  BranchTransferFormScreenState createState() =>
      BranchTransferFormScreenState();
}

class BranchTransferFormScreenState extends State<BranchTransferFormScreen> {
  final DefaultController defaultController = Get.find<DefaultController>();
  final TabControllerX _tabController = Get.isRegistered<TabControllerX>()
      ? Get.find<TabControllerX>()
      : Get.put(TabControllerX());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Text Controllers
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  // Focus Nodes
  final FocusNode _idFocus = FocusNode();
  final FocusNode _dateFocus = FocusNode();
  final FocusNode _fromManagerFocus = FocusNode();
  final FocusNode _toManagerFocus = FocusNode();
  final FocusNode _addFocus = FocusNode();
  final FocusNode _saveFocus = FocusNode();

  // Selected State
  final Rx<int?> _selectedFromManagerId = Rx<int?>(null);
  int? get selectedFromManagerId => _selectedFromManagerId.value;
  final Rx<int?> _selectedToManagerId = Rx<int?>(null);
  int? get selectedToManagerId => _selectedToManagerId.value;
  DateTime _selectedDate = DateTime.now();

  // To Man options dynamically loaded based on From Man's allowed issue
  final RxList<UserModel> _toManagerUsers = <UserModel>[].obs;
  List<UserModel> get toManagerUsers => _toManagerUsers;
  final RxBool _isLoadingToManagers = false.obs;

  // Form edit state
  bool _isEnabled = false;
  bool _isFromEdit = false;

  final RxBool _isLoadingUsers = false.obs;
  Worker? _userListWorker;
  Worker? _transferWorker;

  // Table items & DataGridSource
  final List<BranchTransferItemModel> _allItems = [];
  final List<BranchTransferItemModel> _displayItems = [];
  late BranchTransferDataGridSource _gridSource;
  final DataGridController _dataGridController = DataGridController();



  bool get isCurrentUserTypeUser {
    final grp = defaultController.currentUserGrp.value.trim().toUpperCase();
    return grp == 'USER' || !defaultController.isAdmin;
  }

  bool get isCurrentUserTypeAdmin {
    final grp = defaultController.currentUserGrp.value.trim().toUpperCase();
    return grp == 'ADMIN' || grp == 'SUPERADMIN' || defaultController.isAdmin;
  }

  bool get _isFromManagerEnabled {
    if (isCurrentUserTypeUser) {
      return false;
    }
    return true;
  }

  UserModel? get selectedFromManagerUser {
    final id = _selectedFromManagerId.value;
    if (id == null || id <= 0) return null;
    return defaultController.userModelList.firstWhereOrNull(
      (u) => u.counterMstId == id,
    );
  }

  double getMaxAllowedIssueWt(BranchTransferItemModel item) {
    final stock = item.stockWt;
    final manager = selectedFromManagerUser;
    if (manager == null) return stock;

    final plusType = manager.allowPlusType?.trim().toUpperCase();
    final plusVal = manager.allowPlusValue ?? 0.0;

    if (plusVal <= 0.0 || plusType == null || plusType.isEmpty) {
      return stock;
    }

    if (plusType == 'WT') {
      return stock + plusVal;
    } else if (plusType == 'PER') {
      return stock + (stock * (plusVal / 100.0));
    }

    return stock;
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _dateController.text = DateFormat('dd-MM-yyyy').format(_selectedDate);

    _gridSource = BranchTransferDataGridSource(
      initialItems: _displayItems,
      isEnabled: _isEnabled,
      getMaxAllowedIssueWt: (item) => getMaxAllowedIssueWt(item),
      onValidationWarning: (msg) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.orange.shade800,
          ),
        );
      },
      onRowChanged: (item) {
        if (mounted) setState(() {});
      },
    );

    _userListWorker = ever(defaultController.userModelList, (_) {
      if (mounted) {
        _initFromManager();
        setState(() {});
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _loadMasterData();

      if (defaultController.userModelList.isEmpty) {
        _isLoadingUsers.value = true;
        await defaultController.getUserData();
        _isLoadingUsers.value = false;
      }
      _initFromManager();
    });
  }

  void _loadMasterData() {
    if (defaultController.roughModel.isEmpty) {
      defaultController.getRoughData();
    }
    if (defaultController.polishTypeModelList.isEmpty) {
      defaultController.getPolishTypeData();
    }
    if (defaultController.qualityModelList.isEmpty) {
      defaultController.getQualityData();
    }
    if (defaultController.charniModelList.isEmpty) {
      defaultController.getCharniData();
    }
    if (defaultController.shapeModelList.isEmpty) {
      defaultController.getShapeData();
    }
    if (defaultController.colorModelList.isEmpty) {
      defaultController.getColorData();
    }
    if (defaultController.clarityModelList.isEmpty) {
      defaultController.getClarityData();
    }
  }

  void _clearTableItems() {
    for (var item in _allItems) {
      item.dispose();
    }
    _allItems.clear();
    _applyTableFilter();
  }

  Future<void> _fetchCombinedPurchaseData({dynamic fromUserId}) async {
    if (fromUserId == null || fromUserId == 0) {
      _clearTableItems();
      return;
    }
    final list = await defaultController.getBranchTransferCombinedData(
      fromUserId: fromUserId,
    );
    for (var item in _allItems) {
      item.dispose();
    }
    _allItems.clear();
    if (list.isNotEmpty) {
      _allItems.addAll(list);
    }
    _applyTableFilter();
  }

  void _applyTableFilter() {
    final query = _searchController.text.trim().toLowerCase();
    _displayItems.clear();
    if (query.isEmpty) {
      _displayItems.addAll(_allItems);
    } else {
      _displayItems.addAll(
        _allItems.where((item) {
          final type = _gridSource.resolveTypeName(item).toLowerCase();
          final inv = (item.invoiceNo ?? '').toLowerCase();
          final src = item.source.toLowerCase();
          final quality = _gridSource.resolveQuality(item).toLowerCase();
          final charni = _gridSource.resolveCharni(item).toLowerCase();
          final shape = _gridSource.resolveShape(item).toLowerCase();
          final color = _gridSource.resolveColor(item).toLowerCase();
          final clarity = _gridSource.resolveClarity(item).toLowerCase();

          return type.contains(query) ||
              inv.contains(query) ||
              src.contains(query) ||
              quality.contains(query) ||
              charni.contains(query) ||
              shape.contains(query) ||
              color.contains(query) ||
              clarity.contains(query);
        }),
      );
    }
    if (mounted) {
      _gridSource.updateItems(_displayItems);
    }
  }

  @override
  void dispose() {
    _userListWorker?.dispose();
    _transferWorker?.dispose();
    _idController.dispose();
    _dateController.dispose();
    _searchController.dispose();
    _idFocus.dispose();
    _dateFocus.dispose();
    _fromManagerFocus.dispose();
    _toManagerFocus.dispose();
    _addFocus.dispose();
    _saveFocus.dispose();
    for (var item in _allItems) {
      item.dispose();
    }
    super.dispose();
  }

  /// Initialize From Man based on user type (USER vs ADMIN)
  void _initFromManager() {
    if (isCurrentUserTypeUser) {
      final currentUserId = defaultController.currentUserId.value;
      _selectedFromManagerId.value = currentUserId > 0 ? currentUserId : null;
      if (_selectedFromManagerId.value != null &&
          _selectedFromManagerId.value! > 0) {
        _loadToManagersFor(_selectedFromManagerId.value!);
        _fetchCombinedPurchaseData(fromUserId: _selectedFromManagerId.value!);
      } else {
        _clearTableItems();
      }
    } else {
      final adminBranch = defaultController.effectiveBranchCode;
      if (adminBranch > 0 && _selectedFromManagerId.value != null) {
        final inBranch = defaultController.userModelList.any(
          (u) =>
              u.counterMstId == _selectedFromManagerId.value &&
              u.branchCode == adminBranch,
        );
        if (!inBranch) {
          _selectedFromManagerId.value = null;
          _toManagerUsers.clear();
          _clearTableItems();
        }
      }
    }
  }

  /// Loads all users allowed issue from the selected From Man, plus loggedIn user
  Future<void> _loadToManagersFor(int fromUserId) async {
    if (fromUserId <= 0) return;
    _isLoadingToManagers.value = true;
    final Set<int> allowedIds = <int>{};

    try {
      final targets = await defaultController.getTransferTargets(fromUserId);
      if (targets != null && targets.isNotEmpty) {
        for (var t in targets) {
          final id = int.tryParse((t['userId'] ??
                  t['CounterMstID'] ??
                  t['UserId'] ??
                  t['id'] ??
                  '')
              .toString());
          if (id != null && id > 0) {
            allowedIds.add(id);
          }
        }
      }
    } catch (e) {
      log('getTransferTargets error: $e');
    }

    final currentUserId = defaultController.currentUserId.value;
    if (currentUserId > 0) {
      allowedIds.remove(currentUserId);
    }
    allowedIds.remove(fromUserId);

    final List<UserModel> list = [];
    for (var id in allowedIds) {
      final matched = defaultController.userModelList.firstWhereOrNull(
        (u) => u.counterMstId == id,
      );
      if (matched != null) {
        list.add(matched);
      } else {
        list.add(UserModel(
          counterMstId: id,
          userName: 'User #$id',
          loginName: 'user_$id',
        ));
      }
    }

    list.sort((a, b) => (a.userName ?? a.loginName ?? '')
        .toLowerCase()
        .compareTo((b.userName ?? b.loginName ?? '').toLowerCase()));

    _toManagerUsers.value = list;
    _isLoadingToManagers.value = false;

    if (_selectedToManagerId.value != null &&
        !allowedIds.contains(_selectedToManagerId.value)) {
      _selectedToManagerId.value = null;
    }
  }

  List<UserModel> get fromManagerUsers {
    if (isCurrentUserTypeUser) {
      final currentUserId = defaultController.currentUserId.value;
      return defaultController.userModelList
          .where((u) => u.counterMstId == currentUserId)
          .toList();
    }

    final adminBranch = defaultController.effectiveBranchCode;
    if (adminBranch > 0) {
      return defaultController.userModelList
          .where((u) => u.branchCode == adminBranch)
          .toList();
    }
    return defaultController.userModelList;
  }

  List<DropdownMenuItem<int>> _buildFromManagerDropdownItems() {
    return fromManagerUsers.where((u) => u.counterMstId != null).map((u) {
      final name = (u.userName != null && u.userName!.trim().isNotEmpty)
          ? u.userName!.trim()
          : (u.loginName ?? 'User #${u.counterMstId}');
      return DropdownMenuItem<int>(
        value: u.counterMstId,
        child: Text(
          name,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 13),
        ),
      );
    }).toList();
  }

  List<AppDropdownItem<int>> _buildFromManagerAppDropdownItems() {
    return fromManagerUsers.where((u) => u.counterMstId != null).map((u) {
      final name = (u.userName != null && u.userName!.trim().isNotEmpty)
          ? u.userName!.trim()
          : (u.loginName ?? 'User #${u.counterMstId}');
      final subtitle = (u.loginName != null &&
              u.loginName!.isNotEmpty &&
              u.userName != null &&
              u.userName!.isNotEmpty)
          ? 'Login: ${u.loginName}'
          : null;
      return AppDropdownItem<int>(
        value: u.counterMstId!,
        label: name,
        subtitle: subtitle,
        icon: const Icon(Icons.person_rounded, size: 16),
      );
    }).toList();
  }

  List<DropdownMenuItem<int>> _buildToManagerDropdownItems() {
    return _toManagerUsers.where((u) => u.counterMstId != null).map((u) {
      final name = (u.userName != null && u.userName!.trim().isNotEmpty)
          ? u.userName!.trim()
          : (u.loginName ?? 'User #${u.counterMstId}');
      return DropdownMenuItem<int>(
        value: u.counterMstId,
        child: Text(
          name,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 13),
        ),
      );
    }).toList();
  }

  List<AppDropdownItem<int>> _buildToManagerAppDropdownItems() {
    return _toManagerUsers.where((u) => u.counterMstId != null).map((u) {
      final name = (u.userName != null && u.userName!.trim().isNotEmpty)
          ? u.userName!.trim()
          : (u.loginName ?? 'User #${u.counterMstId}');
      final subtitle = (u.loginName != null &&
              u.loginName!.isNotEmpty &&
              u.userName != null &&
              u.userName!.isNotEmpty)
          ? 'Login: ${u.loginName}'
          : null;
      return AppDropdownItem<int>(
        value: u.counterMstId!,
        label: name,
        subtitle: subtitle,
        icon: const Icon(Icons.person_pin_rounded, size: 16),
      );
    }).toList();
  }

  /// Action button: Add entry
  void _enableFields({bool needFocus = true}) {
    final hasBranch = defaultController.effectiveBranchCode > 0;
    final isDesiCode4 = defaultController.effectiveDesiCode == 4;
    if (!hasBranch || !isDesiCode4) {
      infoDialog(
        messageText:
            'Cannot add entry: Only users with a branch and designation code 4 are permitted to add entries.',
      );
      return;
    }

    setState(() {
      _isEnabled = true;
      _isFromEdit = false;
      _idController.clear();
      _selectedDate = DateTime.now();
      _dateController.text = DateFormat('dd-MM-yyyy').format(_selectedDate);
      _selectedToManagerId.value = null;
    });

    _gridSource.setEnabled(true);
    _initFromManager();

    if (needFocus) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_isFromManagerEnabled) {
          _fromManagerFocus.requestFocus();
        } else {
          _toManagerFocus.requestFocus();
        }
      });
    }
  }

  /// Action button: Cancel entry
  void _handleCancel() {
    setState(() {
      _isEnabled = false;
      _isFromEdit = false;
      _idController.clear();
      _selectedDate = DateTime.now();
      _dateController.text = DateFormat('dd-MM-yyyy').format(_selectedDate);
      _selectedToManagerId.value = null;
      if (!isCurrentUserTypeUser) {
        _selectedFromManagerId.value = null;
        _toManagerUsers.clear();
        _clearTableItems();
      }
    });
    _gridSource.setEnabled(false);
    _gridSource.toggleSelectAll(false);
    _initFromManager();
  }

  /// Action button: Save entry
  Future<void> _handleSave() async {
    if (!_isEnabled) return;

    final hasBranch = defaultController.effectiveBranchCode > 0;
    final isDesiCode4 = defaultController.effectiveDesiCode == 4;
    if (!hasBranch || !isDesiCode4) {
      infoDialog(
        messageText:
            'Cannot save: Only users with a branch and designation code 4 are permitted to add/save entries.',
      );
      return;
    }

    if (_selectedFromManagerId.value == null) {
      infoDialog(messageText: 'Please select From Man');
      return;
    }

    if (_selectedToManagerId.value == null) {
      infoDialog(messageText: 'Please select To Man');
      return;
    }

    if (_dateController.text.trim().isEmpty) {
      infoDialog(messageText: 'Please select Date');
      return;
    }

    // Row-wise check: Issue Wt is required for selected rows
    final checkedWithZero = _allItems.where((i) => i.isSelected && i.issueWt <= 0.0).toList();
    if (checkedWithZero.isNotEmpty) {
      final name = _gridSource.resolveTypeName(checkedWithZero.first);
      infoDialog(
        messageText:
            'Issue Wt is required for selected item ($name). Please enter an Issue Wt greater than 0.',
      );
      return;
    }

    // Only include rows where issueWt > 0 (rows with 0 or empty issueWt are NOT passed into the API)
    final itemsToSave = _allItems.where((i) => i.issueWt > 0.0).toList();
    if (itemsToSave.isEmpty) {
      infoDialog(
        messageText:
            'Please enter Issue Wt (> 0) for at least one item to save branch transfer.',
      );
      return;
    }

    // Validate max allowed issue Wt for each row to save
    for (var item in itemsToSave) {
      final maxAllowed = getMaxAllowedIssueWt(item);
      if (item.issueWt > maxAllowed) {
        final name = _gridSource.resolveTypeName(item);
        infoDialog(
          messageText:
              'Issue Wt (${item.issueWt.toStringAsFixed(3)}) cannot exceed max allowed (${maxAllowed.toStringAsFixed(3)}) for $name.',
        );
        return;
      }
    }

    final success = await defaultController.saveBranchTransferData(
      fromUserId: _selectedFromManagerId.value!,
      toUserId: _selectedToManagerId.value!,
      date: _dateController.text.trim(),
      items: itemsToSave,
    );

    if (success) {
      setState(() {
        _isEnabled = false;
        _isFromEdit = false;
        _idController.clear();
        _selectedToManagerId.value = null;
        if (!isCurrentUserTypeUser) {
          _selectedFromManagerId.value = null;
          _toManagerUsers.clear();
          _clearTableItems();
        }
      });

      _gridSource.setEnabled(false);
      _gridSource.toggleSelectAll(false);
      if (isCurrentUserTypeUser && _selectedFromManagerId.value != null) {
        _fetchCombinedPurchaseData(fromUserId: _selectedFromManagerId.value);
      }
    }
  }

  void _exitScreen() {
    _tabController.closeCurrentTab();
  }

  Future<void> _openDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }

    if (_isEnabled) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _saveFocus.requestFocus();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          if (widget.showHeader) const Header(title: 'Branch Transfer'),
          Expanded(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(Responsive.isMobile(context) ? 10 : 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Main Form Card with single row: id, from, to and date
                    _buildFormCard(),
                    const SizedBox(height: 10),

                    // DataTable Card
                    Expanded(
                      child: _buildDataTableCard(),
                    ),
                    const SizedBox(height: 10),

                    // Action buttons row at the bottom
                    _buildActionButtonsCard(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppColors.border),
      ),
      color: AppColors.cardBg,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.tune_rounded, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'BRANCH TRANSFER INFORMATION',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 768;

                // 1. Id Field
                final idField = AppTextField(
                  label: 'Id',
                  controller: _idController,
                  focusNode: _idFocus,
                  enabled: false,
                  hintText: 'Auto Generated',
                  prefixIcon: const Icon(Icons.tag_rounded, size: 16),
                  onFieldSubmitted: (_) {
                    if (_isFromManagerEnabled) {
                      _fromManagerFocus.requestFocus();
                    } else {
                      _toManagerFocus.requestFocus();
                    }
                  },
                );

                // 2. From Man Dropdown
                final fromManagerField = Obx(
                  () => AppDropdown<int>(
                    label: 'From Man',
                    value: _selectedFromManagerId.value,
                    items: _buildFromManagerDropdownItems(),
                    dropdownItems: _buildFromManagerAppDropdownItems(),
                    focusNode: _fromManagerFocus,
                    nextFocusNode: _toManagerFocus,
                    isEnabled: _isEnabled && _isFromManagerEnabled,
                    hintText: 'Select From Man',
                    searchHint: 'Search manager...',
                    prefixIcon: const Icon(Icons.person_rounded, size: 16),
                    onChanged: (val) {
                      _selectedFromManagerId.value = val;
                      if (val != null && val > 0) {
                        _loadToManagersFor(val);
                        _fetchCombinedPurchaseData(fromUserId: val);
                      } else {
                        _toManagerUsers.clear();
                        _selectedToManagerId.value = null;
                        _clearTableItems();
                      }
                    },
                  ),
                );

                // 3. To Man Dropdown
                final toManagerField = Obx(
                  () => AppDropdown<int>(
                    label: 'To Man',
                    value: _selectedToManagerId.value,
                    items: _buildToManagerDropdownItems(),
                    dropdownItems: _buildToManagerAppDropdownItems(),
                    focusNode: _toManagerFocus,
                    nextFocusNode: _dateFocus,
                    isEnabled: _isEnabled && _selectedFromManagerId.value != null,
                    hintText: _selectedFromManagerId.value == null
                        ? 'Select From Man first'
                        : (_isLoadingToManagers.value
                            ? 'Loading allowed users...'
                            : 'Select To Man'),
                    searchHint: 'Search manager...',
                    prefixIcon: const Icon(Icons.person_pin_rounded, size: 16),
                    onChanged: (val) {
                      _selectedToManagerId.value = val;
                    },
                  ),
                );

                // 4. Date Field
                final dateField = Focus(
                  onKeyEvent: (node, event) {
                    if (event is KeyDownEvent &&
                        (event.logicalKey == LogicalKeyboardKey.enter ||
                            event.logicalKey == LogicalKeyboardKey.numpadEnter)) {
                      if (_isEnabled) {
                        _openDatePicker();
                      }
                      return KeyEventResult.handled;
                    }
                    return KeyEventResult.ignored;
                  },
                  child: AppTextField(
                    label: 'Date',
                    controller: _dateController,
                    focusNode: _dateFocus,
                    readOnly: true,
                    enabled: _isEnabled,
                    prefixIcon:
                        const Icon(Icons.calendar_today_rounded, size: 16),
                    onTap: _isEnabled ? _openDatePicker : null,
                  ),
                );

                if (isDesktop) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 120,
                        child: idField,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: fromManagerField,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: toManagerField,
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 150,
                        child: dateField,
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(child: idField),
                          const SizedBox(width: 10),
                          Expanded(child: dateField),
                        ],
                      ),
                      const SizedBox(height: 10),
                      fromManagerField,
                      const SizedBox(height: 10),
                      toManagerField,
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtonsCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppColors.border),
      ),
      color: AppColors.cardBg,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Wrap(
          alignment: WrapAlignment.start,
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (!_isEnabled)
              AppButton(
                text: 'Add',
                icon: Icons.add_circle_outline_rounded,
                focusNode: _addFocus,
                onPressed: () => _enableFields(),
              ),
            if (_isFromEdit && !_isEnabled)
              AppButton(
                text: 'Edit',
                variant: AppButtonVariant.outline,
                icon: Icons.edit_note_rounded,
                onPressed: () {
                  setState(() => _isEnabled = true);
                  _gridSource.setEnabled(true);
                },
              ),
            if (_isEnabled)
              AppButton(
                text: 'Save',
                icon: Icons.save_rounded,
                focusNode: _saveFocus,
                isLoading: defaultController.isLoading.value,
                onPressed: _handleSave,
              ),
            if (_isEnabled)
              AppButton(
                text: 'Cancel',
                variant: AppButtonVariant.outline,
                icon: Icons.cancel_outlined,
                onPressed: _handleCancel,
              ),
            AppButton(
              text: 'Exit',
              variant: AppButtonVariant.secondary,
              icon: Icons.exit_to_app_rounded,
              onPressed: _exitScreen,
            ),
          ],
        ),
      ),
    );
  }

  List<GridColumn> _buildGridColumns() {
    final isDark = AppColors.isDark;
    final yellowHeaderBg =
        isDark ? const Color(0xFF78350F) : const Color(0xFFFEF08A);
    final yellowHeaderText =
        isDark ? const Color(0xFFFEF08A) : const Color(0xFF713F12);

    return [
      // 1. Checkbox Select Column
      GridColumn(
        columnName: 'select',
        width: 48,
        allowSorting: false,
        allowFiltering: false,
        label: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: Checkbox(
              value: _gridSource.isAllSelected
                  ? true
                  : (_gridSource.hasSomeSelected ? null : false),
              tristate: true,
              activeColor: AppColors.primary,
              side: BorderSide(
                color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
              onChanged: _isEnabled
                  ? (val) {
                      _gridSource.toggleSelectAll(val ?? false);
                      setState(() {});
                    }
                  : null,
            ),
          ),
        ),
      ),

      // 2. Source (Rough / Polish)
      AppDataGrid.buildColumn(
        columnName: 'source',
        labelText: 'Source',
        width: 75,
        alignment: Alignment.center,
      ),

      // 3. Type (Rough Type / Polish Type name as per source)
      AppDataGrid.buildColumn(
        columnName: 'type',
        labelText: 'Type',
        width: 130,
        alignment: Alignment.centerLeft,
      ),

      // 4. Inv No
      AppDataGrid.buildColumn(
        columnName: 'invoiceNo',
        labelText: 'Inv No',
        width: 85,
        alignment: Alignment.centerLeft,
      ),
      // 11. Quality
      AppDataGrid.buildColumn(
        columnName: 'quality',
        labelText: 'Quality',
        width: 80,
        alignment: Alignment.centerLeft,
      ),

      // 12. Charni
      AppDataGrid.buildColumn(
        columnName: 'charni',
        labelText: 'Charni',
        width: 80,
        alignment: Alignment.centerLeft,
      ),

      // 13. Shape
      AppDataGrid.buildColumn(
        columnName: 'shape',
        labelText: 'Shape',
        width: 90,
        alignment: Alignment.centerLeft,
      ),

      // 14. Color
      AppDataGrid.buildColumn(
        columnName: 'color',
        labelText: 'Color',
        width: 80,
        alignment: Alignment.centerLeft,
      ),

      // 15. Clarity
      AppDataGrid.buildColumn(
        columnName: 'clarity',
        labelText: 'Clarity',
        alignment: Alignment.centerLeft,
      ),


      // 7. Rate $
      AppDataGrid.buildColumn(
        columnName: 'rateDollar',
        labelText: 'Rate \$',
        width: 90,
        alignment: Alignment.centerRight,
      ),

      // 8. Rate Rs
      AppDataGrid.buildColumn(
        columnName: 'rateRs',
        labelText: 'Rate ₹',
        alignment: Alignment.centerRight,
      ),

      // 9. Amount $
      AppDataGrid.buildColumn(
        columnName: 'amtDollar',
        labelText: 'Amount \$',
        alignment: Alignment.centerRight,
      ),

      // 10. Amount Rs
      AppDataGrid.buildColumn(
        columnName: 'amtRs',
        labelText: 'Amount ₹',
        alignment: Alignment.centerRight,
      ),


// 5. Stock Pc
      AppDataGrid.buildColumn(
        columnName: 'stockPc',
        labelText: 'Stock Pc',
        width: 100,
        alignment: Alignment.centerRight,
      ),

      // 6. Stock Wt
      AppDataGrid.buildColumn(
        columnName: 'stockWt',
        labelText: 'Stock Wt',
        width: 100,
        alignment: Alignment.centerRight,
      ),
      // 16. Issue Pc (Editable Textbox, Yellow Header highlight)
      GridColumn(
        columnName: 'issuePc',
        width: 80,
        allowSorting: true,
        allowFiltering: true,
        label: Container(
          color: yellowHeaderBg,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Text(
            'Iss Pc',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: yellowHeaderText,
            ),
          ),
        ),
      ),

      // 17. Issue Wt (Editable Textbox, Yellow Header highlight)
      GridColumn(
        columnName: 'issueWt',
        width: 90,
        allowSorting: true,
        allowFiltering: true,
        label: Container(
          color: yellowHeaderBg,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Text(
            'Iss Wt',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: yellowHeaderText,
            ),
          ),
        ),
      ),

      // 18. Issue Rate
      AppDataGrid.buildColumn(
        columnName: 'issueRate',
        labelText: 'Iss Rate',
        alignment: Alignment.centerRight,
      ),

      // 19. Issue Amt
      AppDataGrid.buildColumn(
        columnName: 'issueAmt',
        labelText: 'Iss Amt',
        alignment: Alignment.centerRight,
      ),

      // 20. Diff Wt
      AppDataGrid.buildColumn(
        columnName: 'diffWt',
        labelText: 'Diff Wt',
        width: 85,
        alignment: Alignment.centerRight,
      ),

      // 21. Diff Rate
      AppDataGrid.buildColumn(
        columnName: 'diffRate',
        labelText: 'Diff Rate',
        width: 95,
        alignment: Alignment.centerRight,
      ),

      // 22. Diff Amt
      AppDataGrid.buildColumn(
        columnName: 'diffAmt',
        labelText: 'Diff Amt',
        width: 95,
        alignment: Alignment.centerRight,
      ),
    ];
  }

  Widget _buildDataTableCard() {
    final selectedCount = _allItems.where((i) => i.isSelected).length;
    final totalStockPc = _allItems.fold(0, (sum, i) => sum + i.stockPc);
    final totalStockWt = _allItems.fold(0.0, (sum, i) => sum + i.stockWt);
    final totalIssuePc = _allItems.fold(0, (sum, i) => sum + i.issuePc);
    final totalIssueWt = _allItems.fold(0.0, (sum, i) => sum + i.issueWt);
    final totalIssueAmt = _allItems.fold(0.0, (sum, i) => sum + i.issueAmt);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppColors.border),
      ),
      color: AppColors.cardBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Table Header Controls Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 650;
                return Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'COMBINED PURCHASE / STOCK ITEMS',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${_displayItems.length} items',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Quick Search Filter Box
                        SizedBox(
                          width: isCompact ? 160 : 220,
                          height: 32,
                          child: TextField(
                            controller: _searchController,
                            style: const TextStyle(fontSize: 12),
                            decoration: InputDecoration(
                              hintText: 'Search items...',
                              hintStyle: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                              prefixIcon: const Icon(Icons.search, size: 16),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? InkWell(
                                      onTap: () {
                                        _searchController.clear();
                                        _applyTableFilter();
                                      },
                                      child: const Icon(Icons.clear, size: 14),
                                    )
                                  : null,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 0),
                              filled: true,
                              fillColor: AppColors.background,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide:
                                    BorderSide(color: AppColors.borderLight),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide:
                                    BorderSide(color: AppColors.borderLight),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide:
                                    BorderSide(color: AppColors.primary),
                              ),
                            ),
                            onChanged: (_) => _applyTableFilter(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Refresh button
                        InkWell(
                          onTap: () {
                            if (_selectedFromManagerId.value != null &&
                                _selectedFromManagerId.value! > 0) {
                              _fetchCombinedPurchaseData(
                                fromUserId: _selectedFromManagerId.value,
                              );
                            } else {
                              infoDialog(
                                messageText:
                                    'Please select From Man first to load items',
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            height: 32,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.borderLight),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.refresh_rounded,
                                  size: 15,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Reload',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          Divider(height: 1, color: AppColors.borderLight),

          // The Data Grid Table
          Expanded(
            child: Obx(() {
              final isLoading = defaultController.isLoadingBranchTransfer.value;
              final hasFromMan = _selectedFromManagerId.value != null &&
                  _selectedFromManagerId.value! > 0;

              return Stack(
                children: [
                  AppDataGrid(
                    controller: _dataGridController,
                    source: _gridSource,
                    columns: _buildGridColumns(),
                    rowHeight: 25,
                    headerRowHeight: 25,
                    allowSorting: true,
                    allowMultiColumnSorting: true,
                    showSortNumbers: false,
                    allowFiltering: true,
                    allowColumnsResizing: true,
                    selectionMode: SelectionMode.none,
                    tableSummaryRows: [
                      GridTableSummaryRow(
                        showSummaryInRow: false,
                        position: GridTableSummaryRowPosition.bottom,
                        columns: const <GridSummaryColumn>[
                          GridSummaryColumn(
                            name: 'total_title',
                            columnName: 'source',
                            summaryType: GridSummaryType.count,
                          ),
                          GridSummaryColumn(
                            name: 'stockPc_sum',
                            columnName: 'stockPc',
                            summaryType: GridSummaryType.sum,
                          ),
                          GridSummaryColumn(
                            name: 'stockWt_sum',
                            columnName: 'stockWt',
                            summaryType: GridSummaryType.sum,
                          ),
                          GridSummaryColumn(
                            name: 'amtDollar_sum',
                            columnName: 'amtDollar',
                            summaryType: GridSummaryType.sum,
                          ),
                          GridSummaryColumn(
                            name: 'amtRs_sum',
                            columnName: 'amtRs',
                            summaryType: GridSummaryType.sum,
                          ),
                          GridSummaryColumn(
                            name: 'issuePc_sum',
                            columnName: 'issuePc',
                            summaryType: GridSummaryType.sum,
                          ),
                          GridSummaryColumn(
                            name: 'issueWt_sum',
                            columnName: 'issueWt',
                            summaryType: GridSummaryType.sum,
                          ),
                          GridSummaryColumn(
                            name: 'issueAmt_sum',
                            columnName: 'issueAmt',
                            summaryType: GridSummaryType.sum,
                          ),
                          GridSummaryColumn(
                            name: 'diffWt_sum',
                            columnName: 'diffWt',
                            summaryType: GridSummaryType.sum,
                          ),
                          GridSummaryColumn(
                            name: 'diffAmt_sum',
                            columnName: 'diffAmt',
                            summaryType: GridSummaryType.sum,
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (isLoading)
                    Container(
                      color: Colors.white.withValues(alpha: 0.65),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(color: AppColors.primary),
                            const SizedBox(height: 12),
                            Text(
                              'Loading stock items...',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (!hasFromMan)
                    IgnorePointer(
                      ignoring: true,
                      child: Container(
                        color: Colors.white.withValues(alpha: 0.85),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.person_search_rounded,
                                size: 48,
                                color: AppColors.textSecondary.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Select "From Man" to load stock items',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else if (_displayItems.isEmpty)
                    IgnorePointer(
                      ignoring: true,
                      child: Container(
                        color: Colors.white.withValues(alpha: 0.85),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: 48,
                                color: AppColors.textSecondary.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'No stock items found for selected manager',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }),
          ),

          // Bottom Summary Stat Bar
          Divider(height: 1, color: AppColors.borderLight),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 6,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 14,
                      color: selectedCount > 0
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Selected: $selectedCount of ${_allItems.length} items',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: selectedCount > 0
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 14,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _buildQuickStat(
                      'Stock',
                      '$totalStockPc Pc | ${totalStockWt.toStringAsFixed(3)} Wt',
                    ),
                    _buildQuickStat(
                      'Issue',
                      '$totalIssuePc Pc | ${totalIssueWt.toStringAsFixed(3)} Wt',
                      highlight: true,
                    ),
                    _buildQuickStat(
                      'Issue Amt',
                      '₹${NumberFormat('#,##0.00').format(totalIssueAmt)}',
                      highlight: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String label, String value, {bool highlight = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: highlight ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
