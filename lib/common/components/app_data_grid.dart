import 'dart:math';
import 'package:flutter/material.dart';
import 'package:real_web_rough_entry_system/app_theme.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

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
                  const TextStyle(
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
      return col;
    }

    // 3. Explicit ColumnWidthMode.fill specified on column
    if (col.columnWidthMode == ColumnWidthMode.fill) {
      return col;
    }

    if (!widget.autoFitColumns) {
      return col;
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

  /// Clones a [GridColumn] with the specified width.
  GridColumn _cloneColumn(GridColumn col, double width) {
    return GridColumn(
      columnName: col.columnName,
      label: col.label,
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
      allowFiltering: col.allowFiltering,
      filterPopupMenuOptions: col.filterPopupMenuOptions,
      filterIconPadding: const EdgeInsets.all(0.0),
    );
  }

  SfDataGridThemeData _buildDefaultTheme(BuildContext context) {
    return SfDataGridThemeData(
      headerColor: const Color(0xFFF1F5F9), // Slate 100
      headerHoverColor: const Color(0xFFE2E8F0), // Slate 200
      gridLineColor: const Color(0xFFE2E8F0), // Slate 200
      gridLineStrokeWidth: 1.0,
      rowHoverColor: AppColors.primary.withValues(alpha: 0.06),
      selectionColor: AppColors.primary.withValues(alpha: 0.14),
      sortIconColor: AppColors.primary,
      sortIcon: widget.showSortIcon ? null : const SizedBox.shrink(),
      filterIconColor: const Color(0xFF64748B), // Slate 500
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
        allowFiltering: widget.allowFiltering,
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

    return gridWidget;
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
