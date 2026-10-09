import 'dart:math';
import 'package:flutter/material.dart';
import 'package:real_web_rough_entry_system/app_theme.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:real_web_rough_entry_system/common/components/app_data_grid_filter_dialog.dart';

/// Standard Enterprise [AppDataGrid] component for all system screens.
///
/// Features:
/// - **Intelligent Column Width Management**:
///   - Automatically sizes each column based on the maximum string length of its cell values
///     and header label (including sort/filter icons and padding), preventing clipping.
///   - If a caller specifies a fixed [GridColumn.width] (e.g. `width: 140`), that fixed width
///     is strictly respected and preserved.
///   - User manual column resizing via drag is also preserved.
/// - Full sorting support: single-column and multi-column with sort numbers
/// - Advanced column filtering with Excel-style menus
/// - Dynamic column resizing via drag
/// - Harmonized ERP theme matching [AppColors] (Slate 100 header, clean grid lines, primary accents)
/// - Configurable row heights, selection modes, and summaries
class AppDataGrid extends StatefulWidget {
  final DataGridSource source;
  final List<GridColumn> columns;
  final DataGridController? controller;
  final Key? gridKey;

  // Column Width Management
  final bool autoFitColumns;
  final double columnSafetyMargin;
  final double defaultMinColumnWidth;
  final ColumnSizer? columnSizer;

  // Sorting
  final bool allowSorting;
  final bool allowMultiColumnSorting;
  final bool showSortNumbers;
  final bool showSortIcon;
  final SortingGestureType sortingGestureType;

  // Filtering
  final bool allowFiltering;
  final bool showActiveFilterBar;
  final Color? activeFilterIconColor;
  final Color? filterIconColor;
  final Color? activeFilterBadgeColor;

  // Resizing
  final bool allowColumnsResizing;
  final ColumnResizeMode columnResizeMode;
  final ColumnResizeStartCallback? onColumnResizeStart;
  final ColumnResizeUpdateCallback? onColumnResizeUpdate;
  final ColumnResizeEndCallback? onColumnResizeEnd;

  // Editing & Navigation
  final bool allowEditing;
  final EditingGestureType editingGestureType;
  final GridNavigationMode navigationMode;

  // Layout & Sizing
  final double headerRowHeight;
  final double rowHeight;
  final ColumnWidthMode columnWidthMode;
  final ColumnWidthCalculationRange columnWidthCalculationRange;
  final GridLinesVisibility gridLinesVisibility;
  final GridLinesVisibility headerGridLinesVisibility;
  final bool isScrollbarAlwaysShown;

  // Frozen rows & columns
  final int frozenColumnsCount;
  final int frozenRowsCount;
  final int footerFrozenColumnsCount;
  final int footerFrozenRowsCount;

  // Selection
  final SelectionMode selectionMode;
  final void Function(List<DataGridRow> addedRows, List<DataGridRow> removedRows)? onSelectionChanged;
  final DataGridCellTapCallback? onCellTap;
  final DataGridCellDoubleTapCallback? onCellDoubleTap;

  // Summaries & Stacked Headers
  final List<GridTableSummaryRow> tableSummaryRows;
  final List<StackedHeaderRow> stackedHeaderRows;

  // Customization & Framing
  final BoxDecoration? decoration;
  final Widget? emptyPlaceholder;
  final SfDataGridThemeData? customTheme;
  final Clip clipBehavior;

  const AppDataGrid({
    super.key,
    required this.source,
    required this.columns,
    this.controller,
    this.gridKey,
    this.autoFitColumns = true,
    this.columnSafetyMargin = 14.0,
    this.defaultMinColumnWidth = 75.0,
    this.columnSizer,
    this.allowSorting = true,
    this.allowMultiColumnSorting = true,
    this.showSortNumbers = false,
    this.showSortIcon = false,
    this.sortingGestureType = SortingGestureType.doubleTap,
    this.allowFiltering = true,
    this.showActiveFilterBar = true,
    this.activeFilterIconColor,
    this.filterIconColor,
    this.activeFilterBadgeColor,
    this.allowColumnsResizing = true,
    this.columnResizeMode = ColumnResizeMode.onResize,
    this.onColumnResizeStart,
    this.onColumnResizeUpdate,
    this.onColumnResizeEnd,
    this.allowEditing = false,
    this.editingGestureType = EditingGestureType.tap,
    this.navigationMode = GridNavigationMode.row,
    this.headerRowHeight = 30.0,
    this.rowHeight = 25.0,
    this.columnWidthMode = ColumnWidthMode.auto,
    this.columnWidthCalculationRange = ColumnWidthCalculationRange.allRows,
    this.gridLinesVisibility = GridLinesVisibility.both,
    this.headerGridLinesVisibility = GridLinesVisibility.both,
    this.isScrollbarAlwaysShown = true,
    this.frozenColumnsCount = 0,
    this.frozenRowsCount = 0,
    this.footerFrozenColumnsCount = 0,
    this.footerFrozenRowsCount = 0,
    this.selectionMode = SelectionMode.single,
    this.onSelectionChanged,
    this.onCellTap,
    this.onCellDoubleTap,
    this.tableSummaryRows = const [],
    this.stackedHeaderRows = const [],
    this.decoration,
    this.emptyPlaceholder,
    this.customTheme,
    this.clipBehavior = Clip.antiAlias,
  });

  /// Factory helper to build a standardized [GridColumn] with consistent ERP header styling.
  ///
  /// - To set a **fixed width**, pass [width] (e.g. `width: 140`).
  /// - To auto-size based on **maximum value length**, leave [width] as `double.nan` (the default).
  static GridColumn buildColumn({
    required String columnName,
    required String labelText,
    bool visible = true,
    double width = double.nan,
    double? minimumWidth,
    double? maximumWidth,
    Alignment alignment = Alignment.centerLeft,
    bool? allowSorting,
    bool? allowFiltering,
    bool? allowResizing,
    ColumnWidthMode? columnWidthMode,
    Widget? customLabel,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    TextStyle? headerStyle,
  }) {
    return GridColumn(
      columnName: columnName,
      visible: visible,
      width: width,
      minimumWidth: minimumWidth ?? double.nan,
      maximumWidth: maximumWidth ?? double.nan,
      allowSorting: allowSorting ?? true,
      allowFiltering: allowFiltering ?? true,
      sortIconPosition: ColumnHeaderIconPosition.end,
      columnWidthMode: columnWidthMode ?? ColumnWidthMode.none,
      label: Container(
        padding: padding,
        alignment: alignment,
        child: customLabel ??
            Text(
              labelText,
              style: headerStyle ??
                  TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: AppColors.textPrimary,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
      ),
    );
  }

  @override
  State<AppDataGrid> createState() => _AppDataGridState();
}

class _AppDataGridState extends State<AppDataGrid> {
  final Map<String, double> _userResizedWidths = {};

  @override
  void initState() {
    super.initState();
    widget.source.addListener(_onSourceChanged);
  }

  @override
  void didUpdateWidget(covariant AppDataGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source != widget.source) {
      oldWidget.source.removeListener(_onSourceChanged);
      widget.source.addListener(_onSourceChanged);
    }
  }

  @override
  void dispose() {
    widget.source.removeListener(_onSourceChanged);
    super.dispose();
  }

  void _onSourceChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  /// Calculates text layout width with the given style.
  double _calculateTextWidth(String text, TextStyle style) {
    if (text.isEmpty) return 0.0;
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.size.width;
  }

  /// Recursively extracts the header label text from a [GridColumn.label] widget.
  String _extractHeaderText(GridColumn col) {
    String? found;
    void search(Widget widget) {
      if (found != null) return;
      if (widget is Text) {
        found = widget.data;
      } else if (widget is Container && widget.child != null) {
        search(widget.child!);
      } else if (widget is Padding && widget.child != null) {
        search(widget.child!);
      } else if (widget is Align && widget.child != null) {
        search(widget.child!);
      } else if (widget is Center && widget.child != null) {
        search(widget.child!);
      } else if (widget is Row) {
        for (final child in widget.children) {
          search(child);
        }
      }
    }

    search(col.label);
    return found ?? col.columnName;
  }

  /// Resolves the width for a [GridColumn]:
  /// 1. If user previously manually resized it via drag: uses user's width.
  /// 2. If caller passed a fixed [col.width]: strictly respects that fixed width.
  /// 3. If [col.columnWidthMode == ColumnWidthMode.fill]: leaves as fill.
  /// 4. Otherwise: calculates optimal width based on max string length of cell values + header title.
  GridColumn _resolveColumn(GridColumn col) {
    // 1. Manually resized by user via drag
    if (_userResizedWidths.containsKey(col.columnName)) {
      return _cloneColumn(col, _userResizedWidths[col.columnName]!);
    }

    // 2. Explicit fixed width passed by caller (e.g. width: 140)
    if (!col.width.isNaN && col.width > 0) {
      return _cloneColumn(col, col.width);
    }

    // 3. Explicit ColumnWidthMode.fill specified on column
    if (col.columnWidthMode == ColumnWidthMode.fill) {
      return _cloneColumn(col, double.nan);
    }

    if (!widget.autoFitColumns) {
      return _cloneColumn(col, col.width);
    }

    // 4. Auto-fit based on max value length + header text
    const headerStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
    const cellStyle = TextStyle(fontSize: 12);

    // Header measurement
    final headerText = _extractHeaderText(col);
    final headerTextWidth = _calculateTextWidth(headerText, headerStyle);

    double headerIconsWidth = 0.0;
    final isSortable = (widget.allowSorting && col.allowSorting && widget.showSortIcon);
    if (isSortable) {
      headerIconsWidth += 20.0; // Sort icon
      if (widget.allowMultiColumnSorting && widget.showSortNumbers) {
        headerIconsWidth += 18.0; // Sort number badge
      }
    }
    final isFilterable = (widget.allowFiltering && col.allowFiltering);
    if (isFilterable) {
      headerIconsWidth += 22.0; // Filter icon
    }
    if (headerIconsWidth > 0) {
      headerIconsWidth += 6.0; // Outer spacing
    }

    final headerRequiredWidth = headerTextWidth + headerIconsWidth + 16.0; // 16px padding

    // Cell measurement: scan rows to find maximum string length for this column
    String maxCellString = '';
    for (final row in widget.source.rows) {
      for (final cell in row.getCells()) {
        if (cell.columnName == col.columnName && cell.value != null) {
          final valStr = cell.value.toString();
          if (valStr.length > maxCellString.length) {
            maxCellString = valStr;
          }
        }
      }
    }

    final cellTextWidth = maxCellString.isNotEmpty
        ? _calculateTextWidth(maxCellString, cellStyle)
        : 0.0;
    final cellRequiredWidth = cellTextWidth + 16.0; // 16px cell padding

    // Optimal width
    double optimalWidth = max(headerRequiredWidth, cellRequiredWidth) + widget.columnSafetyMargin;

    // Apply sensible minimum
    final defaultMin = (isSortable || isFilterable)
        ? max(headerRequiredWidth, 85.0)
        : widget.defaultMinColumnWidth;

    if (!col.minimumWidth.isNaN) {
      optimalWidth = max(optimalWidth, col.minimumWidth);
    } else {
      optimalWidth = max(optimalWidth, defaultMin);
    }

    // Apply maximum width if specified
    if (!col.maximumWidth.isNaN) {
      optimalWidth = min(optimalWidth, col.maximumWidth);
    }

    return _cloneColumn(col, optimalWidth.ceilToDouble());
  }

  /// Clones a [GridColumn] with the specified width and enterprise header filter trigger.
  GridColumn _cloneColumn(GridColumn col, double width) {
    return GridColumn(
      columnName: col.columnName,
      label: _buildHeaderLabel(col),
      columnWidthMode: col.columnWidthMode,
      visible: col.visible,
      allowSorting: col.allowSorting,
      sortIconPosition: col.sortIconPosition,
      filterIconPosition: col.filterIconPosition,
      autoFitPadding: col.autoFitPadding,
      minimumWidth: col.minimumWidth,
      maximumWidth: col.maximumWidth,
      width: width,
      allowEditing: col.allowEditing,
      allowFiltering: false, // We render the custom filter icon inside _buildHeaderLabel
      filterPopupMenuOptions: col.filterPopupMenuOptions,
      filterIconPadding: const EdgeInsets.all(0.0),
    );
  }

  Widget _buildHeaderLabel(GridColumn col) {
    final bool isFilterable = widget.allowFiltering && col.allowFiltering;
    if (!isFilterable) {
      return col.label;
    }

    final bool isFiltered = widget.source.filterConditions.containsKey(col.columnName);

    return _HeaderFilterCell(
      column: col,
      columnLabel: _extractHeaderText(col),
      isFiltered: isFiltered,
      onFilterTap: () => _openColumnFilter(col),
      activeFilterIconColor: widget.activeFilterIconColor,
      filterIconColor: widget.filterIconColor,
      activeFilterBadgeColor: widget.activeFilterBadgeColor,
      child: col.label,
    );
  }

  void _openColumnFilter(GridColumn col) {
    final label = _extractHeaderText(col);
    AppDataGridFilterDialog.show(
      context: context,
      column: col,
      columnLabel: label,
      source: widget.source,
      onApplyRangeFilter: ({num? from, num? to}) {
        _applyRangeFilter(col.columnName, from: from, to: to);
      },
      onApplyCheckboxFilter: (selectedValues) {
        _applyCheckboxFilter(col.columnName, selectedValues);
      },
      onClearFilter: () {
        _clearFilter(col.columnName);
      },
      onSort: (direction) {
        _sortColumn(col.columnName, direction);
      },
      onClearSort: () {
        _clearSort();
      },
    );
  }

  void _applyRangeFilter(String columnName, {num? from, num? to}) {
    widget.source.clearFilters(columnName: columnName);
    if (from != null) {
      widget.source.addFilter(
        columnName,
        FilterCondition(
          type: FilterType.greaterThanOrEqual,
          value: from,
          filterOperator: FilterOperator.and,
        ),
      );
    }
    if (to != null) {
      widget.source.addFilter(
        columnName,
        FilterCondition(
          type: FilterType.lessThanOrEqual,
          value: to,
          filterOperator: FilterOperator.and,
        ),
      );
    }
    setState(() {});
  }

  void _applyCheckboxFilter(String columnName, List<Object?> selectedValues) {
    widget.source.clearFilters(columnName: columnName);
    if (selectedValues.isEmpty) {
      widget.source.addFilter(
        columnName,
        const FilterCondition(
          type: FilterType.equals,
          value: '__EMPTY_NO_MATCH__',
          filterOperator: FilterOperator.or,
        ),
      );
    } else {
      for (final val in selectedValues) {
        widget.source.addFilter(
          columnName,
          FilterCondition(
            type: FilterType.equals,
            value: val,
            filterOperator: FilterOperator.or,
          ),
        );
      }
    }
    setState(() {});
  }

  void _clearFilter(String columnName) {
    widget.source.clearFilters(columnName: columnName);
    setState(() {});
  }

  void _sortColumn(String columnName, DataGridSortDirection direction) {
    widget.source.sortedColumns.clear();
    widget.source.sortedColumns.add(
      SortColumnDetails(name: columnName, sortDirection: direction),
    );
    widget.source.sort();
    setState(() {});
  }

  void _clearSort() {
    widget.source.sortedColumns.clear();
    widget.source.sort();
    setState(() {});
  }

  Widget _buildActiveFiltersBar() {
    final activeCols = widget.source.filterConditions.keys.toList();
    if (activeCols.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: AppColors.isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(Icons.filter_alt, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            'Active Filters:',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final colName in activeCols)
                    _buildFilterChip(colName),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {
              widget.source.clearFilters();
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.danger.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Clear All',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.danger,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String colName) {
    final col = widget.columns.firstWhere(
      (c) => c.columnName == colName,
      orElse: () => GridColumn(columnName: colName, label: Text(colName)),
    );
    final colLabel = _extractHeaderText(col);
    final conditions = widget.source.filterConditions[colName] ?? [];

    String summary = '';
    num? fromVal;
    num? toVal;

    for (final c in conditions) {
      if ((c.type == FilterType.greaterThanOrEqual || c.type == FilterType.greaterThan) && c.value is num) {
        fromVal = c.value as num;
      } else if ((c.type == FilterType.lessThanOrEqual || c.type == FilterType.lessThan) && c.value is num) {
        toVal = c.value as num;
      }
    }

    if (fromVal != null && toVal != null) {
      summary = '$fromVal to $toVal';
    } else if (fromVal != null) {
      summary = '>= $fromVal';
    } else if (toVal != null) {
      summary = '<= $toVal';
    } else if (conditions.isNotEmpty) {
      if (conditions.length == 1 && conditions.first.type == FilterType.equals) {
        summary = '= ${conditions.first.value}';
      } else {
        summary = '${conditions.length} values';
      }
    }

    final bool isDark = AppColors.isDark;
    final Color activeColor = widget.activeFilterIconColor ??
        (isDark ? const Color(0xFFFB923C) : const Color(0xFFEA580C));
    final Color activeBadgeBg = widget.activeFilterBadgeColor ??
        (isDark ? const Color(0xFF431407) : const Color(0xFFFFF7ED));
    final Color activeBorder = isDark ? const Color(0xFFEA580C) : const Color(0xFFFDBA74);

    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: activeBadgeBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: activeBorder, width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.filter_alt,
            size: 13,
            color: activeColor,
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: () => _openColumnFilter(col),
            child: Text(
              '$colLabel: $summary',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: activeColor,
              ),
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: () => _clearFilter(colName),
            child: Icon(
              Icons.close,
              size: 13,
              color: activeColor,
            ),
          ),
        ],
      ),
    );
  }

  SfDataGridThemeData _buildDefaultTheme(BuildContext context) {
    final isDark = AppColors.isDark;

    return SfDataGridThemeData(
      headerColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
      headerHoverColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
      gridLineColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
      gridLineStrokeWidth: 1.0,
      rowHoverColor: AppColors.primary.withValues(alpha: isDark ? 0.12 : 0.06),
      selectionColor: AppColors.primary.withValues(alpha: isDark ? 0.22 : 0.14),
      sortIconColor: AppColors.primary,
      sortIcon: widget.showSortIcon ? null : const SizedBox.shrink(),
      filterIconColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
      filterIconHoverColor: AppColors.primary,
      columnResizeIndicatorColor: AppColors.primary,
      columnResizeIndicatorStrokeWidth: 2.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultTheme = _buildDefaultTheme(context);
    final themeData = widget.customTheme != null
        ? widget.customTheme!.copyWith(
            sortIcon: widget.customTheme!.sortIcon ??
                (widget.showSortIcon ? null : const SizedBox.shrink()),
          )
        : defaultTheme;
    final resolvedColumns = widget.columns.map(_resolveColumn).toList();

    Widget gridWidget = SfDataGridTheme(
      data: themeData,
      child: SfDataGrid(
        key: widget.gridKey,
        source: widget.source,
        columns: resolvedColumns,
        controller: widget.controller,
        columnSizer: widget.columnSizer ?? AppDataGridColumnSizer(),
        allowSorting: widget.allowSorting,
        allowMultiColumnSorting: widget.allowMultiColumnSorting,
        showSortNumbers: widget.showSortIcon && widget.showSortNumbers,
        sortingGestureType: widget.sortingGestureType,
        allowFiltering: false, // Handled by AppDataGrid custom filter UI
        allowColumnsResizing: widget.allowColumnsResizing,
        columnResizeMode: widget.columnResizeMode,
        onColumnResizeStart: widget.onColumnResizeStart,
        onColumnResizeUpdate: (details) {
          _userResizedWidths[details.column.columnName] = details.width;
          if (widget.onColumnResizeUpdate != null) {
            return widget.onColumnResizeUpdate!(details);
          }
          return true;
        },
        onColumnResizeEnd: widget.onColumnResizeEnd,
        allowEditing: widget.allowEditing,
        editingGestureType: widget.editingGestureType,
        navigationMode: widget.navigationMode,
        headerRowHeight: widget.headerRowHeight,
        rowHeight: widget.rowHeight,
        columnWidthMode: widget.columnWidthMode,
        columnWidthCalculationRange: widget.columnWidthCalculationRange,
        gridLinesVisibility: widget.gridLinesVisibility,
        headerGridLinesVisibility: widget.headerGridLinesVisibility,
        isScrollbarAlwaysShown: widget.isScrollbarAlwaysShown,
        frozenColumnsCount: widget.frozenColumnsCount,
        frozenRowsCount: widget.frozenRowsCount,
        footerFrozenColumnsCount: widget.footerFrozenColumnsCount,
        footerFrozenRowsCount: widget.footerFrozenRowsCount,
        selectionMode: widget.selectionMode,
        onSelectionChanged: widget.onSelectionChanged,
        onCellTap: widget.onCellTap,
        onCellDoubleTap: widget.onCellDoubleTap,
        tableSummaryRows: widget.tableSummaryRows,
        stackedHeaderRows: widget.stackedHeaderRows,
      ),
    );

    if (widget.emptyPlaceholder != null && widget.source.rows.isEmpty) {
      gridWidget = Stack(
        children: [
          gridWidget,
          Positioned.fill(
            child: IgnorePointer(
              child: Center(child: widget.emptyPlaceholder!),
            ),
          ),
        ],
      );
    }

    if (widget.decoration != null || widget.clipBehavior != Clip.none) {
      gridWidget = Container(
        decoration: widget.decoration ??
            BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(6),
            ),
        clipBehavior: widget.clipBehavior,
        child: gridWidget,
      );
    }

    if (widget.allowFiltering && widget.showActiveFilterBar && widget.source.filterConditions.isNotEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.hasBoundedHeight) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildActiveFiltersBar(),
                Expanded(child: gridWidget),
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildActiveFiltersBar(),
                gridWidget,
              ],
            );
          }
        },
      );
    }

    return gridWidget;
  }
}

/// Header cell widget rendering the column title along with a hoverable/active filter trigger icon.
class _HeaderFilterCell extends StatefulWidget {
  final GridColumn column;
  final String columnLabel;
  final bool isFiltered;
  final Widget child;
  final VoidCallback onFilterTap;
  final Color? activeFilterIconColor;
  final Color? filterIconColor;
  final Color? activeFilterBadgeColor;

  const _HeaderFilterCell({
    required this.column,
    required this.columnLabel,
    required this.isFiltered,
    required this.child,
    required this.onFilterTap,
    this.activeFilterIconColor,
    this.filterIconColor,
    this.activeFilterBadgeColor,
  });

  @override
  State<_HeaderFilterCell> createState() => _HeaderFilterCellState();
}

class _HeaderFilterCellState extends State<_HeaderFilterCell> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool isDark = AppColors.isDark;

    // Distinct active color (vibrant orange / amber by default)
    final Color activeColor = widget.activeFilterIconColor ??
        (isDark ? const Color(0xFFFB923C) : const Color(0xFFEA580C));

    // Distinct active badge background
    final Color activeBadgeBg = widget.activeFilterBadgeColor ??
        (isDark ? const Color(0xFF431407) : const Color(0xFFFFF7ED));

    // Distinct active badge border
    final Color activeBorder = isDark ? const Color(0xFFEA580C) : const Color(0xFFFDBA74);

    // Inactive filter icon color (slate 500, distinct and clear)
    final Color inactiveColor = widget.filterIconColor ??
        (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B));

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: widget.child),
          GestureDetector(
            key: ValueKey('grid_filter_icon_${widget.column.columnName}'),
            behavior: HitTestBehavior.opaque,
            onTap: widget.onFilterTap,
            child: Tooltip(
              message: widget.isFiltered
                  ? 'Active filter on ${widget.columnLabel} (Click to edit/clear)'
                  : 'Filter ${widget.columnLabel}',
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: widget.isFiltered
                    ? const EdgeInsets.symmetric(horizontal: 4, vertical: 2)
                    : const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: widget.isFiltered
                    ? BoxDecoration(
                        color: activeBadgeBg,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: activeBorder, width: 1.0),
                        boxShadow: [
                          BoxShadow(
                            color: activeColor.withValues(alpha: 0.18),
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      )
                    : (_isHovered
                        ? BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.25),
                              width: 1.0,
                            ),
                          )
                        : null),
                child: Icon(
                  widget.isFiltered ? Icons.filter_alt : Icons.filter_alt_outlined,
                  size: 14,
                  color: widget.isFiltered
                      ? activeColor
                      : (_isHovered ? AppColors.primary : inactiveColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom [ColumnSizer] ensuring generous cell and header padding during auto-calculations.
class AppDataGridColumnSizer extends ColumnSizer {
  @override
  double computeHeaderCellWidth(GridColumn column, TextStyle style) {
    return super.computeHeaderCellWidth(column, style) + 12.0;
  }

  @override
  double computeCellWidth(GridColumn column, DataGridRow row, Object? cellValue, TextStyle textStyle) {
    return super.computeCellWidth(column, row, cellValue, textStyle) + 16.0;
  }
}
