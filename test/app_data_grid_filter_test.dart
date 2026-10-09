import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:real_web_rough_entry_system/common/components/app_data_grid.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class _TestEmployee {
  final int id;
  final String name;
  final double weight;

  _TestEmployee(this.id, this.name, this.weight);
}

class _TestDataSource extends DataGridSource {
  List<DataGridRow> _rows = [];

  _TestDataSource(List<_TestEmployee> employees) {
    _rows = employees
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'ID', value: e.id),
              DataGridCell<String>(columnName: 'Name', value: e.name),
              DataGridCell<double>(columnName: 'Weight', value: e.weight),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8.0),
          child: Text(cell.value.toString()),
        );
      }).toList(),
    );
  }
}

void main() {
  testWidgets('AppDataGrid From-to-To range filter filters numeric rows correctly',
      (WidgetTester tester) async {
    final employees = [
      _TestEmployee(5, 'Item 5', 1.5),
      _TestEmployee(10, 'Item 10', 2.0),
      _TestEmployee(20, 'Item 20', 3.5),
      _TestEmployee(30, 'Item 30', 4.0),
      _TestEmployee(45, 'Item 45', 5.5),
    ];

    final source = _TestDataSource(employees);

    final columns = [
      AppDataGrid.buildColumn(columnName: 'ID', labelText: 'ID'),
      AppDataGrid.buildColumn(columnName: 'Name', labelText: 'Name'),
      AppDataGrid.buildColumn(columnName: 'Weight', labelText: 'Weight'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppDataGrid(
            source: source,
            columns: columns,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify all 5 items are initially present
    expect(find.text('Item 5'), findsOneWidget);
    expect(find.text('Item 10'), findsOneWidget);
    expect(find.text('Item 20'), findsOneWidget);
    expect(find.text('Item 30'), findsOneWidget);
    expect(find.text('Item 45'), findsOneWidget);

    // Open filter dialog by tapping the filter icon for column ID
    final idFilterIcon = find.byKey(const ValueKey('grid_filter_icon_ID'));
    expect(idFilterIcon, findsOneWidget);

    await tester.tap(idFilterIcon);
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // Verify dialog has opened with "Range Filter (From - To)"
    expect(find.text('Range Filter (From - To)'), findsOneWidget);
    expect(find.text('From (>=)'), findsOneWidget);
    expect(find.text('To (<=)'), findsOneWidget);

    // Enter From: 10 and To: 30
    final textFields = find.byType(TextField);
    // Find textfield under From (>=) and To (<=)
    // The dialog contains From textfield, To textfield, and search textfield
    await tester.enterText(textFields.at(0), '10');
    await tester.enterText(textFields.at(1), '30');
    await tester.pumpAndSettle();

    // Tap "Apply Range Filter"
    await tester.tap(find.text('Apply Range Filter'));
    await tester.pumpAndSettle();

    // Verify dialog closed
    expect(find.text('Range Filter (From - To)'), findsNothing);

    // Verify active filter chip appeared: "ID: 10 to 30"
    expect(find.text('ID: 10 to 30'), findsOneWidget);
    expect(find.text('Active Filters:'), findsOneWidget);

    // Verify column ID filter icon changed to active solid icon with distinct orange color
    final idActiveIconFinder = find.descendant(
      of: find.byKey(const ValueKey('grid_filter_icon_ID')),
      matching: find.byType(Icon),
    );
    expect(idActiveIconFinder, findsOneWidget);
    final Icon activeIconWidget = tester.widget(idActiveIconFinder);
    expect(activeIconWidget.icon, Icons.filter_alt);
    expect(activeIconWidget.color, const Color(0xFFEA580C)); // Distinct active orange

    // Verify inactive column (Name) still has outline icon and slate color
    final nameInactiveIconFinder = find.descendant(
      of: find.byKey(const ValueKey('grid_filter_icon_Name')),
      matching: find.byType(Icon),
    );
    final Icon nameIconWidget = tester.widget(nameInactiveIconFinder);
    expect(nameIconWidget.icon, Icons.filter_alt_outlined);
    expect(nameIconWidget.color, const Color(0xFF64748B)); // Slate 500

    // Verify only items 10, 20, 30 are visible
    expect(find.text('Item 10'), findsOneWidget);
    expect(find.text('Item 20'), findsOneWidget);
    expect(find.text('Item 30'), findsOneWidget);
    expect(find.text('Item 5'), findsNothing);
    expect(find.text('Item 45'), findsNothing);

    // Clear filter by tapping the close icon on the active filter chip
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    // Verify all 5 items are restored
    expect(find.text('Item 5'), findsOneWidget);
    expect(find.text('Item 10'), findsOneWidget);
    expect(find.text('Item 20'), findsOneWidget);
    expect(find.text('Item 30'), findsOneWidget);
    expect(find.text('Item 45'), findsOneWidget);
    expect(find.text('Active Filters:'), findsNothing);

    // Verify ID filter icon reverted to outline icon with slate color
    final Icon restoredIdIconWidget = tester.widget(idActiveIconFinder);
    expect(restoredIdIconWidget.icon, Icons.filter_alt_outlined);
    expect(restoredIdIconWidget.color, const Color(0xFF64748B));
  });

  testWidgets('AppDataGrid decimal range filter and Clear All works properly',
      (WidgetTester tester) async {
    final employees = [
      _TestEmployee(5, 'Item 5', 1.5),
      _TestEmployee(10, 'Item 10', 2.0),
      _TestEmployee(20, 'Item 20', 3.5),
      _TestEmployee(30, 'Item 30', 4.0),
      _TestEmployee(45, 'Item 45', 5.5),
    ];

    final source = _TestDataSource(employees);

    final columns = [
      AppDataGrid.buildColumn(columnName: 'ID', labelText: 'ID'),
      AppDataGrid.buildColumn(columnName: 'Name', labelText: 'Name'),
      AppDataGrid.buildColumn(columnName: 'Weight', labelText: 'Weight'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppDataGrid(
            source: source,
            columns: columns,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Filter Weight >= 3.5
    final weightFilterIcon = find.byKey(const ValueKey('grid_filter_icon_Weight'));
    expect(weightFilterIcon, findsOneWidget);
    await tester.tap(weightFilterIcon);
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text('Range Filter (From - To)'), findsOneWidget);

    final textFields = find.byType(TextField);
    // Enter From: 3.5 (leave To empty)
    await tester.enterText(textFields.at(0), '3.5');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Apply Range Filter'));
    await tester.pumpAndSettle();

    // Verify chip shows "Weight: >= 3.5"
    expect(find.text('Weight: >= 3.5'), findsOneWidget);

    // Verify rows: only Item 20 (3.5), Item 30 (4.0), Item 45 (5.5)
    expect(find.text('Item 20'), findsOneWidget);
    expect(find.text('Item 30'), findsOneWidget);
    expect(find.text('Item 45'), findsOneWidget);
    expect(find.text('Item 5'), findsNothing);
    expect(find.text('Item 10'), findsNothing);

    // Now also apply ID <= 30
    final idFilterIcon = find.byKey(const ValueKey('grid_filter_icon_ID'));
    await tester.tap(idFilterIcon);
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    final idTextFields = find.byType(TextField);
    await tester.enterText(idTextFields.at(1), '30'); // To field
    await tester.pumpAndSettle();

    await tester.tap(find.text('Apply Range Filter'));
    await tester.pumpAndSettle();

    // Two active filter chips now
    expect(find.text('Weight: >= 3.5'), findsOneWidget);
    expect(find.text('ID: <= 30'), findsOneWidget);

    // Intersection: Weight >= 3.5 AND ID <= 30 -> only Item 20 (id: 20, wt: 3.5) and Item 30 (id: 30, wt: 4.0)
    expect(find.text('Item 20'), findsOneWidget);
    expect(find.text('Item 30'), findsOneWidget);
    expect(find.text('Item 45'), findsNothing); // id: 45 > 30

    // Click "Clear All"
    expect(find.text('Clear All'), findsOneWidget);
    await tester.tap(find.text('Clear All'));
    await tester.pumpAndSettle();

    // All active filters gone and all items restored
    expect(find.text('Active Filters:'), findsNothing);
    expect(find.text('Item 5'), findsOneWidget);
    expect(find.text('Item 10'), findsOneWidget);
    expect(find.text('Item 20'), findsOneWidget);
    expect(find.text('Item 30'), findsOneWidget);
    expect(find.text('Item 45'), findsOneWidget);
  });
}
