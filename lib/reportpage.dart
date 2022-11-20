import 'package:actiongrid/Utilities/Models/model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart' as rootBundle;
import 'dart:convert';
import 'package:syncfusion_flutter_core/theme.dart';

/// The home page of the application which hosts the datagrid.
class Reportpage extends StatefulWidget {
  /// Creates the home page.
  Reportpage({Key? key}) : super(key: key);

  @override
  _ReportpageState createState() => _ReportpageState();
}

class _ReportpageState extends State<Reportpage> {
  bool _loading = true;
  bool _nodata = false;

  late ReportDataSource reportDataSource;

  @override
  void initState() {}
//Create columns

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: SafeArea(
        bottom: true,
        left: false,
        right: false,
        child: Stack(
          children: [
            Visibility(
                visible: _nodata,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.height * 0.2,
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: Image.asset(
                        'assets/images/error.png',
                      ),
                    ),
                    const Text("No data found"),
                  ],
                ))),
            Visibility(
              visible: _loading,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xff047CB7),
                ),
              ),
            ),
            SfDataGridTheme(
              data: SfDataGridThemeData(
                  headerColor: const Color(0xffe5f1f7),
                  rowHoverColor: Colors.yellow,
                  rowHoverTextStyle: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  )),
              child: SfDataGrid(
                gridLinesVisibility: GridLinesVisibility.both,
                headerGridLinesVisibility: GridLinesVisibility.both,
                allowSorting: true,
                allowSwiping: true,
                onQueryRowHeight: (details) {
                  return details.getIntrinsicRowHeight(details.rowIndex);
                },
                source: reportDataSource,
                startSwipeActionsBuilder:
                    (BuildContext context, DataGridRow row, int rowIndex) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                          onTap: () {},
                          child: Container(
                              width: 100,
                              color: Colors.redAccent,
                              child: const Center(
                                child: Icon(Icons.delete),
                              ))),
                      GestureDetector(
                          onTap: () {},
                          child: Container(
                              width: 100,
                              color: Colors.greenAccent,
                              child: const Center(
                                child: Icon(Icons.edit),
                              ))),
                    ],
                  );
                },
                onSwipeStart: (data) {
                  if (data.swipeDirection ==
                      DataGridRowSwipeDirection.startToEnd) {
                    return true;
                  }
                  return false;
                },
                onCellTap: (details) {},
                columnWidthMode: ColumnWidthMode.fitByColumnName,
                columns: <GridColumn>[],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class ReportDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  List<DataGridRow> dataGridRows = [];
  ReportDataSource({required List<Tabledata> reportData}) {}

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    Color getBackgroundColor() {
      int index = effectiveRows.indexOf(row);
      if (index % 2 == 0) {
        return Colors.white;
      } else {
        return Colors.grey.withAlpha(4);
      }
    }

    return DataGridRowAdapter(
        color: getBackgroundColor(),
        cells: row.getCells().map<Widget>((e) {
          if (e.columnName == 'Sales Channel') {
            if (e.value == "offline") {
              return Center(
                child: const CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.red,
                ),
              );
            }
            return Center(
              child: const CircleAvatar(
                radius: 10,
                backgroundColor: Colors.green,
              ),
            );
          } else if (e.columnName == 'ID') {
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              child: Text(e.value.toString()),
            );
          }
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(e.value.toString()),
          );
        }).toList());
  }

  void updateDataGridSource() {
    notifyListeners();
  }
}
