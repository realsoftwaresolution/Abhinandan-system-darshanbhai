import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:real_web_rough_entry_system/app_theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Modal/Popover dialog for configuring filters on an [AppDataGrid] column,
/// specifically featuring the 'From to To' numeric range filter.
class AppDataGridFilterDialog extends StatefulWidget {
  final GridColumn column;
  final String columnLabel;
  final DataGridSource source;
  final void Function({num? from, num? to}) onApplyRangeFilter;
  final void Function(List<Object?> selectedValues) onApplyCheckboxFilter;
  final VoidCallback onClearFilter;
  final void Function(DataGridSortDirection direction) onSort;
  final VoidCallback onClearSort;

  const AppDataGridFilterDialog({
    super.key,
    required this.column,
    required this.columnLabel,
    required this.source,
    required this.onApplyRangeFilter,
    required this.onApplyCheckboxFilter,
    required this.onClearFilter,
    required this.onSort,
    required this.onClearSort,
  });

  /// Displays the filter dialog centered or anchored near the column header.
  static Future<void> show({
    required BuildContext context,
    required GridColumn column,
    required String columnLabel,
    required DataGridSource source,
    required void Function({num? from, num? to}) onApplyRangeFilter,
    required void Function(List<Object?> selectedValues) onApplyCheckboxFilter,
    required VoidCallback onClearFilter,
    required void Function(DataGridSortDirection direction) onSort,
    required VoidCallback onClearSort,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (ctx) => AppDataGridFilterDialog(
        column: column,
        columnLabel: columnLabel,
        source: source,
        onApplyRangeFilter: onApplyRangeFilter,
        onApplyCheckboxFilter: onApplyCheckboxFilter,
        onClearFilter: onClearFilter,
        onSort: onSort,
        onClearSort: onClearSort,
      ),
    );
  }

  @override
  State<AppDataGridFilterDialog> createState() => _AppDataGridFilterDialogState();
}

class _AppDataGridFilterDialogState extends State<AppDataGridFilterDialog> {
  late final TextEditingController _fromController;
  late final TextEditingController _toController;
  late final TextEditingController _searchController;

  bool _isNumeric = false;
  num? _dataMin;
  num? _dataMax;
  final List<Object?> _distinctValues = [];
  final Set<Object?> _selectedValues = {};
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fromController = TextEditingController();
    _toController = TextEditingController();
    _searchController = TextEditingController();

    _analyzeColumnData();
    _loadExistingFilters();
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _analyzeColumnData() {
    final colName = widget.column.columnName;
    final Set<Object?> uniqueSet = {};
    bool hasNum = false;
    num? minVal;
    num? maxVal;

    for (final row in widget.source.rows) {
      for (final cell in row.getCells()) {
        if (cell.columnName == colName) {
          final val = cell.value;
          uniqueSet.add(val);

          if (val is num) {
            hasNum = true;
            if (minVal == null || val < minVal) minVal = val;
            if (maxVal == null || val > maxVal) maxVal = val;
          } else if (val is String && val.trim().isNotEmpty) {
            final parsed = num.tryParse(val.replaceAll(RegExp(r'[^0-9.-]'), ''));
            if (parsed != null) {
              hasNum = true;
              if (minVal == null || parsed < minVal) minVal = parsed;
              if (maxVal == null || parsed > maxVal) maxVal = parsed;
            }
          }
        }
      }
    }

    _isNumeric = hasNum;
    _dataMin = minVal;
    _dataMax = maxVal;
    _distinctValues.addAll(uniqueSet.toList()
      ..sort((a, b) {
        if (a == null && b == null) return 0;
        if (a == null) return -1;
        if (b == null) return 1;
        if (a is num && b is num) return a.compareTo(b);
        return a.toString().compareTo(b.toString());
      }));
    _selectedValues.addAll(uniqueSet);
  }

  void _loadExistingFilters() {
    final colName = widget.column.columnName;
    final conditions = widget.source.filterConditions[colName];
    if (conditions != null && conditions.isNotEmpty) {
      for (final cond in conditions) {
        if ((cond.type == FilterType.greaterThanOrEqual || cond.type == FilterType.greaterThan) &&
            cond.value is num) {
          _fromController.text = cond.value.toString();
        } else if ((cond.type == FilterType.lessThanOrEqual || cond.type == FilterType.lessThan) &&
            cond.value is num) {
          _toController.text = cond.value.toString();
        } else if (cond.type == FilterType.equals) {
          _selectedValues.clear();
          _selectedValues.add(cond.value);
        }
      }
    }
  }

  bool get _hasActiveFilter {
    return widget.source.filterConditions.containsKey(widget.column.columnName);
  }

  void _applyRange() {
    final fromText = _fromController.text.trim();
    final toText = _toController.text.trim();

    final fromNum = fromText.isNotEmpty ? num.tryParse(fromText) : null;
    final toNum = toText.isNotEmpty ? num.tryParse(toText) : null;

    if (fromNum == null && toNum == null) {
      widget.onClearFilter();
    } else {
      widget.onApplyRangeFilter(from: fromNum, to: toNum);
    }
    Navigator.of(context).pop();
  }

  void _clearFilter() {
    _fromController.clear();
    _toController.clear();
    widget.onClearFilter();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 8,
      backgroundColor: AppColors.cardBg,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 320,
          maxWidth: 380,
          maxHeight: 580,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            Divider(height: 1, color: AppColors.border),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSortSection(),
                    const SizedBox(height: 12),
                    Divider(height: 1, color: AppColors.border),
                    const SizedBox(height: 12),
                    if (_isNumeric) ...[
                      _buildNumericRangeSection(),
                      const SizedBox(height: 14),
                      Divider(height: 1, color: AppColors.border),
                      const SizedBox(height: 10),
                    ],
                    _buildValuesCheckboxSection(),
                  ],
                ),
              ),
            ),
            Divider(height: 1, color: AppColors.border),
            _buildFooterActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              _isNumeric ? Icons.pin : Icons.filter_alt_outlined,
              size: 16,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.columnLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _isNumeric ? 'Number Filter' : 'Text Filter',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (_hasActiveFilter)
            Container(
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Active',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          IconButton(
            icon: Icon(Icons.close, size: 18, color: AppColors.textSecondary),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }

  Widget _buildSortSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sort Column',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.arrow_upward, size: 14),
                label: Text(
                  _isNumeric ? 'Smallest to Largest' : 'A to Z',
                  style: const TextStyle(fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  side: BorderSide(color: AppColors.border),
                  foregroundColor: AppColors.textPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                onPressed: () {
                  widget.onSort(DataGridSortDirection.ascending);
                  Navigator.of(context).pop();
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.arrow_downward, size: 14),
                label: Text(
                  _isNumeric ? 'Largest to Smallest' : 'Z to A',
                  style: const TextStyle(fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  side: BorderSide(color: AppColors.border),
                  foregroundColor: AppColors.textPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                onPressed: () {
                  widget.onSort(DataGridSortDirection.descending);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNumericRangeSection() {
    final rangeHint = (_dataMin != null && _dataMax != null)
        ? 'Data Range: $_dataMin to $_dataMax'
        : 'Enter numeric range';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.swap_horiz, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Range Filter (From - To)',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_fromController.text.isNotEmpty || _toController.text.isNotEmpty)
                InkWell(
                  onTap: () {
                    _fromController.clear();
                    _toController.clear();
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Text(
                      'Clear Range',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.danger,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            rangeHint,
            style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'From (>=)',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 36,
                      child: TextField(
                        controller: _fromController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]')),
                        ],
                        style: TextStyle(fontSize: 12, color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: _dataMin != null ? '$_dataMin' : 'Min',
                          hintStyle: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                          ),
                        ),
                        onSubmitted: (_) => _applyRange(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18, left: 8, right: 8),
                child: Icon(Icons.arrow_forward, size: 14, color: AppColors.textSecondary),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'To (<=)',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 36,
                      child: TextField(
                        controller: _toController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]')),
                        ],
                        style: TextStyle(fontSize: 12, color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: _dataMax != null ? '$_dataMax' : 'Max',
                          hintStyle: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                          ),
                        ),
                        onSubmitted: (_) => _applyRange(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 32,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.check, size: 14),
              label: const Text(
                'Apply Range Filter',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              onPressed: _applyRange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValuesCheckboxSection() {
    final filteredValues = _distinctValues.where((val) {
      if (_searchQuery.isEmpty) return true;
      final s = val?.toString().toLowerCase() ?? '(blank)';
      return s.contains(_searchQuery.toLowerCase());
    }).toList();

    final allSelected = filteredValues.isNotEmpty &&
        filteredValues.every((val) => _selectedValues.contains(val));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Select Values',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            Text(
              '${_selectedValues.length} of ${_distinctValues.length} selected',
              style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 32,
          child: TextField(
            controller: _searchController,
            style: TextStyle(fontSize: 11, color: AppColors.textPrimary),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, size: 14, color: AppColors.textSecondary),
              prefixIconConstraints: const BoxConstraints(minWidth: 28),
              hintText: 'Search values...',
              hintStyle: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: AppColors.primary),
              ),
            ),
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: () {
            setState(() {
              if (allSelected) {
                _selectedValues.removeAll(filteredValues);
              } else {
                _selectedValues.addAll(filteredValues);
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox(
                    value: allSelected,
                    activeColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    onChanged: (bool? checked) {
                      setState(() {
                        if (checked == true) {
                          _selectedValues.addAll(filteredValues);
                        } else {
                          _selectedValues.removeAll(filteredValues);
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(Select All)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.border),
          ),
          child: ListView.builder(
            itemCount: filteredValues.length,
            padding: const EdgeInsets.symmetric(vertical: 2),
            itemBuilder: (context, index) {
              final val = filteredValues[index];
              final isChecked = _selectedValues.contains(val);
              final displayStr = val == null ? '(Blank)' : val.toString();

              return InkWell(
                onTap: () {
                  setState(() {
                    if (isChecked) {
                      _selectedValues.remove(val);
                    } else {
                      _selectedValues.add(val);
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: Checkbox(
                          value: isChecked,
                          activeColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                          onChanged: (bool? checked) {
                            setState(() {
                              if (checked == true) {
                                _selectedValues.add(val);
                              } else {
                                _selectedValues.remove(val);
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          displayStr,
                          style: TextStyle(
                            fontSize: 11,
                            color: val == null ? AppColors.textSecondary : AppColors.textPrimary,
                            fontStyle: val == null ? FontStyle.italic : FontStyle.normal,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFooterActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          if (_hasActiveFilter)
            TextButton.icon(
              icon: Icon(Icons.filter_alt_off, size: 14, color: AppColors.danger),
              label: Text(
                'Clear Filter',
                style: TextStyle(fontSize: 11, color: AppColors.danger, fontWeight: FontWeight.bold),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              onPressed: _clearFilter,
            ),
          const Spacer(),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              side: BorderSide(color: AppColors.border),
              foregroundColor: AppColors.textPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(fontSize: 11)),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            onPressed: () {
              if (_fromController.text.trim().isNotEmpty || _toController.text.trim().isNotEmpty) {
                _applyRange();
              } else {
                widget.onApplyCheckboxFilter(_selectedValues.toList());
                Navigator.of(context).pop();
              }
            },
            child: const Text('Apply', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
