import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:real_web_rough_entry_system/app_theme.dart';
import 'package:real_web_rough_entry_system/common/components/app_button.dart';
import 'package:real_web_rough_entry_system/common/components/app_data_grid.dart';
import 'package:real_web_rough_entry_system/common/components/app_dropdown.dart';
import 'package:real_web_rough_entry_system/common/components/app_shortcuts.dart';
import 'package:real_web_rough_entry_system/common/components/app_text_field.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';
import 'package:real_web_rough_entry_system/controllers/default_controller.dart';
import 'package:real_web_rough_entry_system/header.dart';
import 'package:real_web_rough_entry_system/responsive.dart';
import 'package:real_web_rough_entry_system/tab-view-dashboard/tab_controller.dart';
import 'package:real_web_rough_entry_system/user/user_datagrid.dart';
import 'package:real_web_rough_entry_system/user/user_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class UserFormScreen extends StatefulWidget {
  final bool showHeader;

  const UserFormScreen({super.key, this.showHeader = false});

  @override
  UserFormScreenState createState() => UserFormScreenState();
}

class UserFormScreenState extends State<UserFormScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DefaultController defaultController = Get.find<DefaultController>();
  final TabControllerX tabController = Get.find<TabControllerX>();
  final DataGridController _dataGridController = DataGridController();

  late TabController _moduleTabController;
  late UserDataGridSource _userSource;
  Worker? _listWorker;

  // Controllers - Basic Information
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _loginNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _stockLimitController = TextEditingController();
  final TextEditingController _loginTimeFromController =
      TextEditingController(text: '09:00 AM');
  final TextEditingController _loginTimeToController =
      TextEditingController(text: '07:00 PM');
  final TextEditingController _sortIdController = TextEditingController();

  // Search filter controller
  final TextEditingController _searchFilterController =
      TextEditingController();

  // Focus Nodes
  final FocusNode _loginNameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _userNameFocus = FocusNode();
  final FocusNode _roleFocus = FocusNode();
  final FocusNode _branchFocus = FocusNode();
  final FocusNode _stockLimitFocus = FocusNode();
  final FocusNode _loginTimeFromFocus = FocusNode();
  final FocusNode _loginTimeToFocus = FocusNode();
  final FocusNode _sortIdFocus = FocusNode();

  // State
  final RxInt _selectedUserId = 0.obs;
  final RxString _selectedUserGrp = 'USER'.obs;
  final Rx<int?> _selectedBranchCode = Rx<int?>(null);
  final RxBool _obscurePassword = true.obs;
  bool _isActive = true;
  bool _isEnabled = false;
  bool _isFromEdit = false;
  bool _isSearchMode = false;

  final RxList<UserModel> userGridList = <UserModel>[].obs;

  // Module 2: Menu Rights State
  final Rx<UserMenuRightsResponse?> _menuRightsData =
      Rx<UserMenuRightsResponse?>(null);
  final RxBool _isLoadingMenuRights = false.obs;

  // Module 3: Allow Issue State
  final Rx<AllowIssueResponse?> _allowIssueData = Rx<AllowIssueResponse?>(null);
  final RxBool _isLoadingAllowIssue = false.obs;
  final TextEditingController _allowIssueSearchController =
      TextEditingController();
  final RxString _allowIssueSearchQuery = ''.obs;

  // Module 4: Report Rights State
  final Rx<UserReportRightsResponse?> _reportRightsData =
      Rx<UserReportRightsResponse?>(null);
  final RxBool _isLoadingReportRights = false.obs;
  final TextEditingController _reportRightsSearchController =
      TextEditingController();
  final RxString _reportRightsSearchQuery = ''.obs;

  @override
  void initState() {
    super.initState();
    _moduleTabController = TabController(length: 4, vsync: this);
    _moduleTabController.addListener(_handleTabChange);

    userGridList.value = defaultController.userModelList;
    _userSource = UserDataGridSource(userGridList);

    _listWorker = ever(defaultController.userModelList, (list) {
      if (mounted) {
        _filterUsers(_searchFilterController.text);
        setState(() {});
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (defaultController.userModelList.isEmpty) {
        defaultController.getUserData();
      }
      if (defaultController.branchModelList.isEmpty) {
        defaultController.getBranchData();
      }
    });
  }

  @override
  void dispose() {
    _listWorker?.dispose();
    _moduleTabController.removeListener(_handleTabChange);
    _moduleTabController.dispose();

    _codeController.dispose();
    _loginNameController.dispose();
    _passwordController.dispose();
    _userNameController.dispose();
    _stockLimitController.dispose();
    _loginTimeFromController.dispose();
    _loginTimeToController.dispose();
    _sortIdController.dispose();
    _searchFilterController.dispose();

    _loginNameFocus.dispose();
    _passwordFocus.dispose();
    _userNameFocus.dispose();
    _roleFocus.dispose();
    _branchFocus.dispose();
    _stockLimitFocus.dispose();
    _loginTimeFromFocus.dispose();
    _loginTimeToFocus.dispose();
    _sortIdFocus.dispose();

    _allowIssueSearchController.dispose();
    _reportRightsSearchController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_moduleTabController.indexIsChanging) return;
    final int idx = _moduleTabController.index;
    if (_selectedUserId.value != 0) {
      if (idx == 1 && _menuRightsData.value == null) {
        _loadMenuRightsForUser(_selectedUserId.value);
      } else if (idx == 2 && _allowIssueData.value == null) {
        _loadAllowIssueForUser(_selectedUserId.value);
      } else if (idx == 3 && _reportRightsData.value == null) {
        _loadReportRightsForUser(_selectedUserId.value);
      }
    }
  }

  void _filterUsers(String query) {
    if (query.trim().isEmpty) {
      userGridList.value = defaultController.userModelList;
    } else {
      final q = query.toLowerCase().trim();
      userGridList.value = defaultController.userModelList.where((u) {
        final login = (u.loginName ?? '').toLowerCase();
        final name = (u.userName ?? '').toLowerCase();
        final code = (u.counterMstId ?? '').toString();
        final role = (u.userGrp ?? '').toLowerCase();
        return login.contains(q) ||
            name.contains(q) ||
            code.contains(q) ||
            role.contains(q);
      }).toList();
    }
    _userSource.updateDataSource(userGridList);
  }

  List<DropdownMenuItem<String>> get roleDropdownItems => const [
        DropdownMenuItem<String>(value: 'USER', child: Text('USER')),
        DropdownMenuItem<String>(value: 'ADMIN', child: Text('ADMIN')),
      ];

  List<DropdownMenuItem<int>> get branchDropdownItems {
    return defaultController.branchModelList.map((b) {
      final code = b.branchCode ?? b.branchMstId ?? 0;
      return DropdownMenuItem<int>(
        value: code,
        child: Text('${b.branchName ?? 'Branch'} (#$code)'),
      );
    }).toList();
  }

  // ==================== ACTIONS: MODULE 1 (USER CRUD) ====================

  Future<void> _enableFields({bool needFocus = true}) async {
    setState(() {
      _isEnabled = true;
      _isFromEdit = false;
      _selectedUserId.value = 0;
      _codeController.text = '';
      _loginNameController.clear();
      _passwordController.clear();
      _userNameController.clear();
      _stockLimitController.clear();
      _loginTimeFromController.text = '09:00 AM';
      _loginTimeToController.text = '07:00 PM';
      _sortIdController.clear();
      _selectedUserGrp.value = 'USER';
      _selectedBranchCode.value = defaultController.branchModelList.isNotEmpty
          ? (defaultController.branchModelList.first.branchCode ??
              defaultController.branchModelList.first.branchMstId)
          : null;
      _isActive = true;
    });

    try {
      final next = await defaultController.getNextUserCode();
      if (next != null && mounted) {
        final dynamic nextCode = next['nextCode'] ?? next['nextSortID'];
        if (nextCode != null) {
          _sortIdController.text = nextCode.toString();
        }
      }
    } catch (_) {}

    if (needFocus && mounted) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _loginNameFocus.requestFocus();
      });
    }
  }

  void _clearFormFields() {
    setState(() {
      _isEnabled = false;
      _isFromEdit = false;
      _codeController.clear();
      _loginNameController.clear();
      _passwordController.clear();
      _userNameController.clear();
      _stockLimitController.clear();
      _loginTimeFromController.text = '09:00 AM';
      _loginTimeToController.text = '07:00 PM';
      _sortIdController.clear();
      _selectedUserGrp.value = 'USER';
      _selectedBranchCode.value = null;
      _isActive = true;
    });
    _dataGridController.selectedIndex = -1;
  }

  Future<void> _handleSave() async {
    if (!_isEnabled) return;

    final String loginName = _loginNameController.text.trim();
    if (loginName.isEmpty) {
      infoDialog(messageText: 'Please enter Login Name');
      _loginNameFocus.requestFocus();
      return;
    }

    final String userName = _userNameController.text.trim();
    if (userName.isEmpty) {
      infoDialog(messageText: 'Please enter User Full Name');
      _userNameFocus.requestFocus();
      return;
    }

    final String password = _passwordController.text.trim();
    if (!_isFromEdit && password.isEmpty) {
      infoDialog(messageText: 'Please enter Password for the new user');
      _passwordFocus.requestFocus();
      return;
    }

    final double? stockLimit =
        double.tryParse(_stockLimitController.text.trim());
    final int? sortId = int.tryParse(_sortIdController.text.trim());
    final int? branchCode = _selectedBranchCode.value;

    if (_isFromEdit) {
      final dynamic targetId = _selectedUserId.value;
      if (targetId == 0 || targetId == null) {
        errorDialog(messageText: 'Unable to identify User record to update');
        return;
      }

      final success = await defaultController.updateUserData(
        id: targetId,
        userName: userName,
        loginName: loginName,
        password: password.isNotEmpty ? password : null,
        userGrp: _selectedUserGrp.value,
        branchCode: branchCode,
        stockLimit: stockLimit,
        loginTimeFrom: _loginTimeFromController.text.trim(),
        loginTimeTo: _loginTimeToController.text.trim(),
        sortId: sortId,
        active: _isActive,
      );

      if (success) {
        _clearFormFields();
        _filterUsers(_searchFilterController.text);
      }
    } else {
      final success = await defaultController.addUserData(
        loginName: loginName,
        password: password,
        userName: userName,
        userGrp: _selectedUserGrp.value,
        branchCode: branchCode,
        stockLimit: stockLimit,
        loginTimeFrom: _loginTimeFromController.text.trim(),
        loginTimeTo: _loginTimeToController.text.trim(),
        sortId: sortId,
        active: _isActive,
      );

      if (success) {
        _clearFormFields();
        _filterUsers(_searchFilterController.text);
      }
    }
  }

  Future<void> _handleDelete() async {
    if (!_isFromEdit) return;
    final dynamic targetId = _selectedUserId.value;
    if (targetId == 0 || targetId == null) return;

    final success = await defaultController.deleteUserData(targetId);
    if (success) {
      _selectedUserId.value = 0;
      _clearFormFields();
      _filterUsers(_searchFilterController.text);
    }
  }

  void _loadUserFromRow(DataGridRow row) {
    final item = _userSource.findModelFromRow(row);
    if (item != null) {
      _loadFromModel(item);
      return;
    }

    final dynamic cellVal = row.getCells()[0].value;
    final userEntry = defaultController.userModelList.firstWhere(
      (entry) => entry.counterMstId == cellVal,
      orElse: () => UserModel(),
    );

    if (userEntry.counterMstId != null && userEntry.counterMstId != 0) {
      _loadFromModel(userEntry);
    }
  }

  void _loadFromModel(UserModel item) {
    final int id = item.counterMstId ?? 0;
    _selectedUserId.value = id;
    _codeController.text = id != 0 ? id.toString() : '';
    _loginNameController.text = item.loginName ?? '';
    _passwordController.text = ''; // Don't prefill plain password
    _userNameController.text = item.userName ?? '';
    _selectedUserGrp.value = item.userGrp ?? 'USER';
    _selectedBranchCode.value = item.branchCode;
    _stockLimitController.text =
        item.stockLimit != null ? item.stockLimit.toString() : '';
    _loginTimeFromController.text = item.loginTimeFrom ?? '09:00 AM';
    _loginTimeToController.text = item.loginTimeTo ?? '07:00 PM';
    _sortIdController.text = item.sortId != null ? item.sortId.toString() : '';
    _isActive = item.active ?? true;

    setState(() {
      _isFromEdit = true;
      _isEnabled = true;
      _isSearchMode = false;
    });

    // Reset cached rights so switching tabs reloads for this user
    _menuRightsData.value = null;
    _allowIssueData.value = null;
    _reportRightsData.value = null;

    _userNameFocus.requestFocus();
  }

  Future<void> _pickTime({required bool isFrom}) async {
    if (!_isEnabled) return;
    final currentStr = isFrom
        ? _loginTimeFromController.text.trim()
        : _loginTimeToController.text.trim();

    TimeOfDay initialTime = isFrom
        ? const TimeOfDay(hour: 9, minute: 0)
        : const TimeOfDay(hour: 19, minute: 0);

    if (currentStr.isNotEmpty) {
      try {
        final parsed =
            DateFormat('hh:mm a').parse(currentStr.toUpperCase());
        initialTime = TimeOfDay(hour: parsed.hour, minute: parsed.minute);
      } catch (_) {}
    }

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      final now = DateTime.now();
      final dt = DateTime(
          now.year, now.month, now.day, picked.hour, picked.minute);
      final formatted = DateFormat('hh:mm a').format(dt);
      if (isFrom) {
        _loginTimeFromController.text = formatted;
      } else {
        _loginTimeToController.text = formatted;
      }
    }
  }

  // ==================== ACTIONS: MODULE 2 (MENU RIGHTS) ====================

  Future<void> _loadMenuRightsForUser(int userId) async {
    _isLoadingMenuRights.value = true;
    final data = await defaultController.getUserMenuRights(userId);
    _menuRightsData.value = data;
    _isLoadingMenuRights.value = false;
  }

  Future<void> _saveMenuRights() async {
    final data = _menuRightsData.value;
    final userId = _selectedUserId.value;
    if (data == null || userId == 0) {
      infoDialog(messageText: 'Please select a user first');
      return;
    }

    final List<Map<String, dynamic>> menuRightsPayload = [];
    for (final cat in data.categories) {
      for (final menu in cat.menus) {
        menuRightsPayload.add({
          'MainMenuMstID': cat.mainMenuMstId ?? menu.mainMenuMstId ?? 1,
          'MenuMstID': menu.menuMstId,
          'CanView': menu.canView,
          'CanAdd': menu.canAdd,
          'CanEdit': menu.canEdit,
          'CanDel': menu.canDel,
        });
      }
    }

    await defaultController.saveUserMenuRights(userId, menuRightsPayload);
  }

  void _toggleCategoryPermission(
    UserMenuCategoryModel cat,
    String permType,
    bool targetVal,
  ) {
    setState(() {
      for (final m in cat.menus) {
        if (permType == 'view') m.canView = targetVal;
        if (permType == 'add') m.canAdd = targetVal;
        if (permType == 'edit') m.canEdit = targetVal;
        if (permType == 'del') m.canDel = targetVal;
        if (permType == 'all') {
          m.canView = targetVal;
          m.canAdd = targetVal;
          m.canEdit = targetVal;
          m.canDel = targetVal;
        }
      }
    });
  }

  // ==================== ACTIONS: MODULE 3 (ALLOW ISSUE) ====================

  Future<void> _loadAllowIssueForUser(int userId) async {
    _isLoadingAllowIssue.value = true;
    final data = await defaultController.getUserAllowIssue(userId);
    _allowIssueData.value = data;
    _isLoadingAllowIssue.value = false;
  }

  Future<void> _saveAllowIssue() async {
    final data = _allowIssueData.value;
    final userId = _selectedUserId.value;
    if (data == null || userId == 0) {
      infoDialog(messageText: 'Please select a user first');
      return;
    }

    final allowedIds = data.users
        .where((u) => u.isAllowed)
        .map((u) => u.userId)
        .whereType<int>()
        .toList();

    await defaultController.saveUserAllowIssue(userId, allowedIds);
  }

  void _setAllAllowIssue(bool isAllowed) {
    final data = _allowIssueData.value;
    if (data == null) return;
    setState(() {
      for (final u in data.users) {
        u.isAllowed = isAllowed;
      }
    });
  }

  // ==================== ACTIONS: MODULE 4 (REPORT RIGHTS) ====================

  Future<void> _loadReportRightsForUser(int userId) async {
    _isLoadingReportRights.value = true;
    final data = await defaultController.getUserReportRights(userId);
    _reportRightsData.value = data;
    _isLoadingReportRights.value = false;
  }

  Future<void> _saveReportRights() async {
    final data = _reportRightsData.value;
    final userId = _selectedUserId.value;
    if (data == null || userId == 0) {
      infoDialog(messageText: 'Please select a user first');
      return;
    }

    final allowedCodes = data.reports
        .where((r) => r.isAllowed)
        .map((r) => r.reportCode)
        .whereType<int>()
        .toList();

    await defaultController.saveUserReportRights(userId, allowedCodes);
  }

  void _setAllReportRights(bool isAllowed) {
    final data = _reportRightsData.value;
    if (data == null) return;
    setState(() {
      for (final r in data.reports) {
        r.isAllowed = isAllowed;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return AppKeyboardShortcutHandler(
        onAdd: (!_isEnabled && !_isFromEdit && _moduleTabController.index == 0)
            ? () => _enableFields()
            : null,
        onSave: (_isEnabled && _moduleTabController.index == 0)
            ? _handleSave
            : null,
        onDelete: (_isEnabled && _isFromEdit && _moduleTabController.index == 0)
            ? _handleDelete
            : null,
        onCancel: (_isEnabled || _isFromEdit) ? _clearFormFields : null,
        onExit: () => tabController.closeCurrentTab(),
        onSearch: () {
          if (_moduleTabController.index == 0) {
            setState(() {
              _isSearchMode = !_isSearchMode;
            });
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            children: [
              if (widget.showHeader)
                Header(
                  title: _isSearchMode && _moduleTabController.index == 0
                      ? 'User Master Search'
                      : 'User Master Entry',
                ),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _moduleTabController,
                  children: [
                    _isSearchMode ? _buildSearchView() : _buildFormView(),
                    _buildModule2MenuRightsTab(),
                    _buildModule3AllowIssueTab(),
                    _buildModule4ReportRightsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // ==================== TAB BAR ====================

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      child: TabBar(
        controller: _moduleTabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textMuted,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        unselectedLabelStyle: const TextStyle(fontSize: 13),
        tabs: const [
          Tab(
            icon: Icon(Icons.manage_accounts_rounded, size: 18),
            text: '1. User Details (CRUD)',
          ),
          Tab(
            icon: Icon(Icons.security_rounded, size: 18),
            text: '2. Menu Rights Matrix',
          ),
          Tab(
            icon: Icon(Icons.swap_horiz_rounded, size: 18),
            text: '3. Allow Issue (Transfer)',
          ),
          Tab(
            icon: Icon(Icons.assessment_rounded, size: 18),
            text: '4. Report Rights',
          ),
        ],
      ),
    );
  }

  // ==================== DEDICATED SEARCH VIEW (AS PER PARTY SCREEN) ====================

  Widget _buildSearchView() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(bottom: BorderSide(color: AppColors.borderLight)),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 650;
              final searchField = AppTextField(
                label: 'Search User',
                controller: _searchFilterController,
                hintText: 'Search by login name, full name, ID, role...',
                prefixIcon: const Icon(Icons.search_rounded, size: 18),
                onChanged: _filterUsers,
              );

              final actionButtons = Wrap(
                spacing: 10,
                runSpacing: 8,
                alignment: WrapAlignment.end,
                children: [
                  AppButton(
                    text: 'Clear Filter',
                    variant: AppButtonVariant.outline,
                    icon: Icons.clear_rounded,
                    onPressed: () {
                      _searchFilterController.clear();
                      _filterUsers('');
                    },
                  ),
                  AppButton(
                    text: 'Close Search',
                    variant: AppButtonVariant.secondary,
                    icon: Icons.close_rounded,
                    onPressed: () {
                      setState(() {
                        _isSearchMode = false;
                      });
                    },
                  ),
                ],
              );

              return isNarrow
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        searchField,
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: actionButtons,
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(child: searchField),
                        const SizedBox(width: 12),
                        actionButtons,
                      ],
                    );
            },
          ),
        ),
        Expanded(
          child: _buildDataGridWidget(),
        ),
      ],
    );
  }

  // ==================== MAIN FORM VIEW (AS PER PARTY SCREEN) ====================

  Widget _buildFormView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(Responsive.isMobile(context) ? 10.0 : 16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card 1: Basic Information & Account
            _buildBasicInfoCard(),

            const SizedBox(height: 16),

            // Card 2: Restrictions & Working Hours
            _buildRestrictionsCard(),

            const SizedBox(height: 16),

            // Bottom Action Bar
            _buildActionBar(),

            const SizedBox(height: 16),

            // Embedded Directory Card
            _buildDirectoryCard(),
          ],
        ),
      ),
    );
  }

  // ==================== CARD 1: BASIC INFORMATION ====================

  Widget _buildBasicInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person_outline_rounded,
                    size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Basic Information',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (_isFromEdit) ...[
                  const SizedBox(width: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.warningBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.warning),
                    ),
                    child: Text(
                      'EDIT MODE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const Divider(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                final codeWidget = SizedBox(
                  width: constraints.maxWidth >= 1000 ? 100 : null,
                  child: AppTextField(
                    label: 'Code',
                    controller: _codeController,
                    enabled: false,
                    hintText: 'Auto',
                  ),
                );

                final loginNameWidget = AppTextField(
                  label: 'Login Name *',
                  controller: _loginNameController,
                  focusNode: _loginNameFocus,
                  nextFocusNode: _passwordFocus,
                  enabled: _isEnabled,
                  hintText: 'e.g. Mahesh',
                );

                final passwordWidget = Obx(
                  () => AppTextField(
                    label: _isFromEdit
                        ? 'Password (optional update)'
                        : 'Password *',
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    nextFocusNode: _userNameFocus,
                    enabled: _isEnabled,
                    obscureText: _obscurePassword.value,
                    hintText: 'Enter password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword.value
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        size: 16,
                        color: AppColors.textMuted,
                      ),
                      onPressed: () =>
                          _obscurePassword.value = !_obscurePassword.value,
                    ),
                  ),
                );

                final nameWidget = AppTextField(
                  label: 'User Full Name *',
                  controller: _userNameController,
                  focusNode: _userNameFocus,
                  nextFocusNode: _roleFocus,
                  enabled: _isEnabled,
                  hintText: 'Enter Full User Name',
                );

                final roleWidget = Obx(
                  () => AppDropdown<String>(
                    label: 'User Role *',
                    focusNode: _roleFocus,
                    nextFocusNode: _branchFocus,
                    isEnabled: _isEnabled,
                    value: _selectedUserGrp.value,
                    items: roleDropdownItems,
                    hintText: 'Select Role',
                    onChanged: (val) {
                      if (val != null) _selectedUserGrp.value = val;
                    },
                  ),
                );

                final branchWidget = Obx(
                  () => AppDropdown<int>(
                    label: 'Branch',
                    focusNode: _branchFocus,
                    nextFocusNode: _stockLimitFocus,
                    isEnabled: _isEnabled,
                    value: _selectedBranchCode.value,
                    items: branchDropdownItems,
                    hintText: 'Select Branch',
                    onChanged: (val) {
                      _selectedBranchCode.value = val;
                    },
                  ),
                );

                final activeWidget = Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: _isActive,
                        activeColor: AppColors.primary,
                        onChanged: _isEnabled
                            ? (val) {
                                setState(() {
                                  _isActive = val ?? true;
                                });
                              }
                            : null,
                      ),
                      const Text(
                        'Active',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );

                if (constraints.maxWidth >= 1000) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          codeWidget,
                          const SizedBox(width: 12),
                          Expanded(flex: 2, child: loginNameWidget),
                          const SizedBox(width: 12),
                          Expanded(flex: 2, child: passwordWidget),
                          const SizedBox(width: 12),
                          Expanded(flex: 3, child: nameWidget),
                          const SizedBox(width: 12),
                          activeWidget,
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: roleWidget),
                          const SizedBox(width: 12),
                          Expanded(flex: 3, child: branchWidget),
                          const Spacer(flex: 4),
                        ],
                      ),
                    ],
                  );
                } else if (constraints.maxWidth >= 650) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 1, child: codeWidget),
                          const SizedBox(width: 12),
                          Expanded(flex: 2, child: loginNameWidget),
                          const SizedBox(width: 12),
                          activeWidget,
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: passwordWidget),
                          const SizedBox(width: 12),
                          Expanded(child: nameWidget),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: roleWidget),
                          const SizedBox(width: 12),
                          Expanded(child: branchWidget),
                        ],
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 85, child: codeWidget),
                          const SizedBox(width: 10),
                          Expanded(child: loginNameWidget),
                        ],
                      ),
                      const SizedBox(height: 12),
                      passwordWidget,
                      const SizedBox(height: 12),
                      nameWidget,
                      const SizedBox(height: 12),
                      roleWidget,
                      const SizedBox(height: 12),
                      branchWidget,
                      const SizedBox(height: 8),
                      activeWidget,
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

  // ==================== CARD 2: RESTRICTIONS & WORKING HOURS ====================

  Widget _buildRestrictionsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.tune_rounded, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Restrictions & Working Hours',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                final stockLimitWidget = AppTextField(
                  label: 'Stock Limit',
                  controller: _stockLimitController,
                  focusNode: _stockLimitFocus,
                  nextFocusNode: _loginTimeFromFocus,
                  enabled: _isEnabled,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  hintText: 'e.g. 150.00',
                );

                final loginTimeFromWidget = AppTextField(
                  label: 'Login Time From',
                  controller: _loginTimeFromController,
                  focusNode: _loginTimeFromFocus,
                  nextFocusNode: _loginTimeToFocus,
                  enabled: _isEnabled,
                  readOnly: true,
                  hintText: '09:00 AM',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.access_time_rounded, size: 18),
                    onPressed: () => _pickTime(isFrom: true),
                  ),
                  onTap: () => _pickTime(isFrom: true),
                );

                final loginTimeToWidget = AppTextField(
                  label: 'Login Time To',
                  controller: _loginTimeToController,
                  focusNode: _loginTimeToFocus,
                  nextFocusNode: _sortIdFocus,
                  enabled: _isEnabled,
                  readOnly: true,
                  hintText: '07:00 PM',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.access_time_rounded, size: 18),
                    onPressed: () => _pickTime(isFrom: false),
                  ),
                  onTap: () => _pickTime(isFrom: false),
                );

                final sortIdWidget = AppTextField(
                  label: 'Sort ID',
                  controller: _sortIdController,
                  focusNode: _sortIdFocus,
                  enabled: _isEnabled,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  hintText: '1',
                  onFieldSubmitted: (_) => _handleSave(),
                );

                if (constraints.maxWidth >= 1000) {
                  return Row(
                    children: [
                      Expanded(flex: 2, child: stockLimitWidget),
                      const SizedBox(width: 12),
                      Expanded(flex: 2, child: loginTimeFromWidget),
                      const SizedBox(width: 12),
                      Expanded(flex: 2, child: loginTimeToWidget),
                      const SizedBox(width: 12),
                      Expanded(flex: 1, child: sortIdWidget),
                    ],
                  );
                } else if (constraints.maxWidth >= 650) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: stockLimitWidget),
                          const SizedBox(width: 12),
                          Expanded(child: sortIdWidget),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: loginTimeFromWidget),
                          const SizedBox(width: 12),
                          Expanded(child: loginTimeToWidget),
                        ],
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      stockLimitWidget,
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: loginTimeFromWidget),
                          const SizedBox(width: 10),
                          Expanded(child: loginTimeToWidget),
                        ],
                      ),
                      const SizedBox(height: 12),
                      sortIdWidget,
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

  // ==================== BOTTOM ACTION BAR (AS PER PARTY SCREEN) ====================

  Widget _buildActionBar() {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.isMobile(context) ? 8.0 : 16.0,
          vertical: 12.0,
        ),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // Add Button
            AppButton(
              text: 'Add',
              icon: Icons.add_rounded,
              onPressed:
                  (!_isEnabled && !_isFromEdit) ? () => _enableFields() : null,
            ),

            // Save Button
            Obx(
              () => AppButton(
                text: 'Save',
                icon: Icons.save_rounded,
                isLoading: defaultController.isLoading.value,
                onPressed: _isEnabled ? _handleSave : null,
              ),
            ),

            // Delete Button
            Obx(
              () => AppButton(
                text: 'Delete',
                icon: Icons.delete_outline_rounded,
                variant: AppButtonVariant.danger,
                isLoading: defaultController.isDeleteLoading.value,
                onPressed: (_isEnabled && _isFromEdit) ? _handleDelete : null,
              ),
            ),

            // Cancel Button
            AppButton(
              text: 'Cancel',
              icon: Icons.refresh_rounded,
              variant: AppButtonVariant.secondary,
              onPressed: (_isEnabled || _isFromEdit) ? _clearFormFields : null,
            ),

            // Exit Button
            AppButton(
              text: 'Exit',
              icon: Icons.exit_to_app_rounded,
              variant: AppButtonVariant.outline,
              onPressed: () => tabController.closeCurrentTab(),
            ),

            // Search Toggle Button
            AppButton(
              text: 'Search Mode',
              icon: Icons.search_rounded,
              variant: AppButtonVariant.secondary,
              onPressed: () {
                setState(() {
                  _isSearchMode = !_isSearchMode;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // ==================== EMBEDDED DIRECTORY CARD (AS PER PARTY SCREEN) ====================

  Widget _buildDirectoryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 650;
                final titleWidget = Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.list_alt_rounded,
                        size: 18, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Obx(
                      () => Text(
                        'User Directory (${userGridList.length})',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                );

                final filterWidget = SizedBox(
                  width: isNarrow ? double.infinity : 260,
                  child: AppTextField(
                    label: 'Quick Filter',
                    controller: _searchFilterController,
                    hintText: 'Filter name, login, role...',
                    prefixIcon: const Icon(Icons.search_rounded, size: 16),
                    onChanged: _filterUsers,
                  ),
                );

                return isNarrow
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          titleWidget,
                          const SizedBox(height: 10),
                          filterWidget,
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          titleWidget,
                          filterWidget,
                        ],
                      );
              },
            ),
            const Divider(height: 20),
            SizedBox(
              height: 340,
              child: _buildDataGridWidget(),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== DATAGRID COMPONENT (AS PER PARTY SCREEN) ====================

  Widget _buildDataGridWidget() {
    return AppDataGrid(
      controller: _dataGridController,
      source: _userSource,
      allowSorting: true,
      allowMultiColumnSorting: true,
      showSortNumbers: true,
      allowFiltering: true,
      allowColumnsResizing: true,
      rowHeight: 30,
      headerRowHeight: 36,
      selectionMode: SelectionMode.single,
      onSelectionChanged: (addedRows, _) {
        if (addedRows.isNotEmpty) {
          _loadUserFromRow(addedRows.first);
        }
      },
      columnWidthMode: ColumnWidthMode.auto,
      frozenColumnsCount: 1,
      columns: <GridColumn>[
        GridColumn(
          columnName: 'Code',
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: const Text('ID',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ),
        GridColumn(
          columnName: 'Login Name',
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: const Text('Login Name',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ),
        GridColumn(
          columnName: 'User Name',
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: const Text('Full Name',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ),
        GridColumn(
          columnName: 'Role',
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: const Text('Role',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ),
        GridColumn(
          columnName: 'Branch',
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: const Text('Branch',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ),
        GridColumn(
          columnName: 'Stock Limit',
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.centerRight,
            child: const Text('Stock Limit',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ),
        GridColumn(
          columnName: 'Permitted Hours',
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: const Text('Hours',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ),
        GridColumn(
          columnName: 'Sort ID',
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: const Text('Sort ID',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ),
        GridColumn(
          columnName: 'Active',
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: const Text('Active',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ),
      ],
    );
  }

  // ==================== SHARED: USER CONTEXT BANNER ====================

  Widget _buildSelectedUserHeader(String moduleTitle, VoidCallback onReload) {
    return Obx(() {
      final selectedId = _selectedUserId.value;
      final users = defaultController.userModelList;
      final currentUser = users.firstWhereOrNull(
        (u) => u.counterMstId == selectedId,
      );

      return Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person_rounded,
                    size: 20, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    moduleTitle,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  if (currentUser != null)
                    Text(
                      'Configuring for: ${currentUser.userName ?? currentUser.loginName} (#${currentUser.counterMstId}) [${currentUser.userGrp ?? 'USER'}]',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    )
                  else
                    Text(
                      'No user selected. Select a user from Tab 1 or the dropdown.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
              const Spacer(),
              SizedBox(
                height: 34,
                child: DropdownButton<int>(
                  value: selectedId != 0 ? selectedId : null,
                  hint: const Text('Switch User',
                      style: TextStyle(fontSize: 12)),
                  underline: const SizedBox.shrink(),
                  items: users.map((u) {
                    return DropdownMenuItem<int>(
                      value: u.counterMstId,
                      child: Text(
                        '${u.userName ?? u.loginName} (#${u.counterMstId})',
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  }).toList(),
                  onChanged: (newId) {
                    if (newId != null) {
                      final matched = users.firstWhereOrNull(
                          (u) => u.counterMstId == newId);
                      if (matched != null) {
                        _loadFromModel(matched);
                        if (_moduleTabController.index == 1) {
                          _loadMenuRightsForUser(newId);
                        } else if (_moduleTabController.index == 2) {
                          _loadAllowIssueForUser(newId);
                        } else if (_moduleTabController.index == 3) {
                          _loadReportRightsForUser(newId);
                        }
                      }
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.refresh_rounded, size: 18),
                tooltip: 'Reload',
                onPressed: onReload,
              ),
            ],
          ),
        ),
      );
    });
  }

  // ==================== MODULE 2: MENU RIGHTS MATRIX ====================

  Widget _buildModule2MenuRightsTab() {
    return Obx(() {
      final selectedId = _selectedUserId.value;
      final isLoading = _isLoadingMenuRights.value;
      final rights = _menuRightsData.value;

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSelectedUserHeader(
              'Menu Rights Matrix',
              () {
                if (selectedId != 0) _loadMenuRightsForUser(selectedId);
              },
            ),
            const SizedBox(height: 12),
            if (selectedId == 0)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock_person_rounded,
                          size: 48, color: AppColors.textMuted),
                      const SizedBox(height: 12),
                      Text(
                        'Select a user from Tab 1 or the dropdown above to edit Menu Rights',
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              )
            else if (isLoading)
              const Expanded(
                child: Center(child: CupertinoActivityIndicator(radius: 14)),
              )
            else if (rights == null || rights.categories.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    'No menu rights hierarchy found for this user.',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: rights.categories.length,
                  itemBuilder: (context, catIdx) {
                    final cat = rights.categories[catIdx];
                    return _buildCategoryMatrixCard(cat);
                  },
                ),
              ),
            if (selectedId != 0 && rights != null) ...[
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      AppButton(
                        text: 'Save Menu Rights',
                        icon: Icons.save_rounded,
                        variant: AppButtonVariant.primary,
                        onPressed: _saveMenuRights,
                      ),
                      const SizedBox(width: 8),
                      AppButton(
                        text: 'Reload',
                        icon: Icons.refresh_rounded,
                        variant: AppButtonVariant.secondary,
                        onPressed: () => _loadMenuRightsForUser(selectedId),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildCategoryMatrixCard(UserMenuCategoryModel cat) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.folder_open_rounded,
                    size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  cat.mainMenuName ?? 'GENERAL',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  ' (${cat.menus.length} menus)',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
                const Spacer(),
                _bulkActionChip('View All', () {
                  final anyOff = cat.menus.any((m) => !m.canView);
                  _toggleCategoryPermission(cat, 'view', anyOff);
                }),
                const SizedBox(width: 6),
                _bulkActionChip('Add All', () {
                  final anyOff = cat.menus.any((m) => !m.canAdd);
                  _toggleCategoryPermission(cat, 'add', anyOff);
                }),
                const SizedBox(width: 6),
                _bulkActionChip('Edit All', () {
                  final anyOff = cat.menus.any((m) => !m.canEdit);
                  _toggleCategoryPermission(cat, 'edit', anyOff);
                }),
                const SizedBox(width: 6),
                _bulkActionChip('Del All', () {
                  final anyOff = cat.menus.any((m) => !m.canDel);
                  _toggleCategoryPermission(cat, 'del', anyOff);
                }),
                const SizedBox(width: 6),
                _bulkActionChip('All On', () {
                  _toggleCategoryPermission(cat, 'all', true);
                }),
                const SizedBox(width: 6),
                _bulkActionChip('Clear', () {
                  _toggleCategoryPermission(cat, 'all', false);
                }),
              ],
            ),
          ),
          const Divider(height: 1),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(4),
              1: FixedColumnWidth(80),
              2: FixedColumnWidth(80),
              3: FixedColumnWidth(80),
              4: FixedColumnWidth(80),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: AppColors.tableRowAlt),
                children: [
                  _tableHeaderCell('Menu Name'),
                  _tableHeaderCell('View', isCentered: true),
                  _tableHeaderCell('Add', isCentered: true),
                  _tableHeaderCell('Edit', isCentered: true),
                  _tableHeaderCell('Delete', isCentered: true),
                ],
              ),
              ...cat.menus.asMap().entries.map((entry) {
                final int idx = entry.key;
                final UserMenuItemRightModel menu = entry.value;
                final rowBg =
                    idx % 2 == 0 ? AppColors.surface : AppColors.tableRowAlt;

                return TableRow(
                  decoration: BoxDecoration(color: rowBg),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(
                        menu.menuName ?? 'Menu #${menu.menuMstId}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Center(
                      child: Checkbox(
                        value: menu.canView,
                        activeColor: AppColors.primary,
                        onChanged: (val) {
                          setState(() {
                            menu.canView = val ?? false;
                          });
                        },
                      ),
                    ),
                    Center(
                      child: Checkbox(
                        value: menu.canAdd,
                        activeColor: AppColors.primary,
                        onChanged: (val) {
                          setState(() {
                            menu.canAdd = val ?? false;
                          });
                        },
                      ),
                    ),
                    Center(
                      child: Checkbox(
                        value: menu.canEdit,
                        activeColor: AppColors.primary,
                        onChanged: (val) {
                          setState(() {
                            menu.canEdit = val ?? false;
                          });
                        },
                      ),
                    ),
                    Center(
                      child: Checkbox(
                        value: menu.canDel,
                        activeColor: AppColors.primary,
                        onChanged: (val) {
                          setState(() {
                            menu.canDel = val ?? false;
                          });
                        },
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bulkActionChip(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  // ==================== MODULE 3: ALLOW ISSUE ====================

  Widget _buildModule3AllowIssueTab() {
    return Obx(() {
      final selectedId = _selectedUserId.value;
      final isLoading = _isLoadingAllowIssue.value;
      final data = _allowIssueData.value;
      final query = _allowIssueSearchQuery.value.toLowerCase().trim();

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSelectedUserHeader(
              'Allow Issue (Transfer Screen Mapping)',
              () {
                if (selectedId != 0) _loadAllowIssueForUser(selectedId);
              },
            ),
            const SizedBox(height: 12),
            if (selectedId == 0)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.swap_horiz_rounded,
                          size: 48, color: AppColors.textMuted),
                      const SizedBox(height: 12),
                      Text(
                        'Select a user from Tab 1 or the dropdown above to edit Transfer Target Permissions',
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              )
            else if (isLoading)
              const Expanded(
                child: Center(child: CupertinoActivityIndicator(radius: 14)),
              )
            else if (data == null || data.users.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    'No target users available for Allow Issue mapping.',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
              )
            else ...[
              Row(
                children: [
                  SizedBox(
                    width: 260,
                    child: AppTextField(
                      label: 'Filter Users',
                      controller: _allowIssueSearchController,
                      hintText: 'Search target user...',
                      prefixIcon: const Icon(Icons.search_rounded, size: 16),
                      onChanged: (val) => _allowIssueSearchQuery.value = val,
                    ),
                  ),
                  const SizedBox(width: 12),
                  _bulkActionChip('Allow All', () => _setAllAllowIssue(true)),
                  const SizedBox(width: 8),
                  _bulkActionChip('Clear All', () => _setAllAllowIssue(false)),
                  const Spacer(),
                  Text(
                    'Allowed: ${data.users.where((u) => u.isAllowed).length} / ${data.users.length}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Card(
                  child: Builder(builder: (context) {
                    final filteredUsers = data.users.where((u) {
                      if (query.isEmpty) return true;
                      final name = (u.userName ?? '').toLowerCase();
                      final login = (u.loginName ?? '').toLowerCase();
                      return name.contains(query) || login.contains(query);
                    }).toList();

                    return ListView.separated(
                      itemCount: filteredUsers.length + 1,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, idx) {
                        if (idx == 0) {
                          return Container(
                            color: AppColors.tableRowAlt,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: const Row(
                              children: [
                                SizedBox(
                                  width: 60,
                                  child: Text('Allowed',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12)),
                                ),
                                SizedBox(
                                  width: 80,
                                  child: Text('User ID',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12)),
                                ),
                                SizedBox(
                                  width: 140,
                                  child: Text('Login Name',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12)),
                                ),
                                Expanded(
                                  child: Text('Full Name',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12)),
                                ),
                                SizedBox(
                                  width: 100,
                                  child: Text('Branch Code',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12)),
                                ),
                              ],
                            ),
                          );
                        }

                        final target = filteredUsers[idx - 1];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 60,
                                child: Checkbox(
                                  value: target.isAllowed,
                                  activeColor: AppColors.primary,
                                  onChanged: (val) {
                                    setState(() {
                                      target.isAllowed = val ?? false;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 80,
                                child: Text(
                                  '#${target.userId}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              SizedBox(
                                width: 140,
                                child: Text(
                                  target.loginName ?? '',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  target.userName ?? '',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: Text(
                                  target.branchCode != null
                                      ? 'Branch #${target.branchCode}'
                                      : '-',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      AppButton(
                        text: 'Save Allow Issue Permissions',
                        icon: Icons.save_rounded,
                        variant: AppButtonVariant.primary,
                        onPressed: _saveAllowIssue,
                      ),
                      const SizedBox(width: 8),
                      AppButton(
                        text: 'Reload',
                        icon: Icons.refresh_rounded,
                        variant: AppButtonVariant.secondary,
                        onPressed: () => _loadAllowIssueForUser(selectedId),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  // ==================== MODULE 4: REPORT RIGHTS ====================

  Widget _buildModule4ReportRightsTab() {
    return Obx(() {
      final selectedId = _selectedUserId.value;
      final isLoading = _isLoadingReportRights.value;
      final data = _reportRightsData.value;
      final query = _reportRightsSearchQuery.value.toLowerCase().trim();

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSelectedUserHeader(
              'Report Rights Configuration',
              () {
                if (selectedId != 0) _loadReportRightsForUser(selectedId);
              },
            ),
            const SizedBox(height: 12),
            if (selectedId == 0)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.assessment_rounded,
                          size: 48, color: AppColors.textMuted),
                      const SizedBox(height: 12),
                      Text(
                        'Select a user from Tab 1 or the dropdown above to edit Report Permissions',
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              )
            else if (isLoading)
              const Expanded(
                child: Center(child: CupertinoActivityIndicator(radius: 14)),
              )
            else if (data == null || data.reports.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    'No reports catalog available.',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
              )
            else ...[
              Row(
                children: [
                  SizedBox(
                    width: 260,
                    child: AppTextField(
                      label: 'Filter Reports',
                      controller: _reportRightsSearchController,
                      hintText: 'Search report name, heading...',
                      prefixIcon: const Icon(Icons.search_rounded, size: 16),
                      onChanged: (val) => _reportRightsSearchQuery.value = val,
                    ),
                  ),
                  const SizedBox(width: 12),
                  _bulkActionChip('Allow All', () => _setAllReportRights(true)),
                  const SizedBox(width: 8),
                  _bulkActionChip(
                      'Clear All', () => _setAllReportRights(false)),
                  const Spacer(),
                  Text(
                    'Allowed: ${data.reports.where((r) => r.isAllowed).length} / ${data.reports.length}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Card(
                  child: Builder(builder: (context) {
                    final filteredReports = data.reports.where((r) {
                      if (query.isEmpty) return true;
                      final name = (r.reportName ?? '').toLowerCase();
                      final heading = (r.reportHeading ?? '').toLowerCase();
                      return name.contains(query) || heading.contains(query);
                    }).toList();

                    return ListView.separated(
                      itemCount: filteredReports.length + 1,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, idx) {
                        if (idx == 0) {
                          return Container(
                            color: AppColors.tableRowAlt,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: const Row(
                              children: [
                                SizedBox(
                                  width: 60,
                                  child: Text('Allowed',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12)),
                                ),
                                SizedBox(
                                  width: 80,
                                  child: Text('Code',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12)),
                                ),
                                SizedBox(
                                  width: 200,
                                  child: Text('Report Name',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12)),
                                ),
                                Expanded(
                                  child: Text('Report Heading',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12)),
                                ),
                                SizedBox(
                                  width: 70,
                                  child: Text('Sort ID',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12)),
                                ),
                              ],
                            ),
                          );
                        }

                        final rep = filteredReports[idx - 1];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 60,
                                child: Checkbox(
                                  value: rep.isAllowed,
                                  activeColor: AppColors.primary,
                                  onChanged: (val) {
                                    setState(() {
                                      rep.isAllowed = val ?? false;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 80,
                                child: Text(
                                  '#${rep.reportCode}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              SizedBox(
                                width: 200,
                                child: Text(
                                  rep.reportName ?? '',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  rep.reportHeading ?? '',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              SizedBox(
                                width: 70,
                                child: Text(
                                  rep.sortId != null
                                      ? rep.sortId.toString()
                                      : '-',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      AppButton(
                        text: 'Save Report Rights',
                        icon: Icons.save_rounded,
                        variant: AppButtonVariant.primary,
                        onPressed: _saveReportRights,
                      ),
                      const SizedBox(width: 8),
                      AppButton(
                        text: 'Reload',
                        icon: Icons.refresh_rounded,
                        variant: AppButtonVariant.secondary,
                        onPressed: () => _loadReportRightsForUser(selectedId),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  // ==================== HELPER TABLE CELLS ====================

  Widget _tableHeaderCell(String text, {bool isCentered = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Text(
        text,
        textAlign: isCentered ? TextAlign.center : TextAlign.start,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
