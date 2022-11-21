import 'package:actiongrid/Utilities/Internetcheck.dart';
import 'package:actiongrid/Utilities/Models/model.dart';
import 'package:actiongrid/constants.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'dart:convert';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:http/http.dart' as http;

/// The home page of the application which hosts the datagrid.
class Reportpage extends StatefulWidget {
  String? title;
  String? id;
  List<Headers>? headers;

  /// Creates the home page.
  Reportpage(
      {Key? key, required this.title, required this.id, required this.headers})
      : super(key: key);

  @override
  _ReportpageState createState() => _ReportpageState();
}

class _ReportpageState extends State<Reportpage> {
  bool _isLoading = true;

  List<Tabledata>? reports;
  late ReportDataSource reportDataSource;

  @override
  void initState() {
    setState(() {
      getData();
    });
  }

//Create columns
  List<GridColumn> createColumns() {
    List<GridColumn> columns = [];
    if (widget.headers != null) {
      for (var col in widget.headers!) {
        columns.add(GridColumn(
            columnWidthMode: ColumnWidthMode.fitByColumnName,
            columnName: col.column ?? "",
            label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.centerLeft,
                child: Text("${col.column ?? ""}",
                    style: const TextStyle(
                        color: Color(0xffaa0e3f),
                        fontWeight: FontWeight.bold)))));
      }
    }

    return columns;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: SafeArea(
        bottom: true,
        left: false,
        right: false,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: Color(0xff047CB7),
              ))
            : Stack(
                children: [
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
                      startSwipeActionsBuilder: (BuildContext context,
                          DataGridRow row, int rowIndex) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  if (reports != null) {
                                    deleteData(reports![rowIndex].orderID!);
                                  }
                                },
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
                      columnWidthMode: ColumnWidthMode.fitByCellValue,
                      columns: createColumns(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  //Api
  getData() async {
    Utils.checkInternetConnection().then((connectionResult) async {
      if (connectionResult) {
        setState(() {
          _isLoading = true;
        });

        String url =
            Constants.base_url + 'data/select_report_data?Id=${widget.id}';

        var uri = Uri.parse(url);

        final response = await http.get(
          uri,
          headers: <String, String>{
            'Content-Type': "application/json",
          },
        );
        setState(() {
          _isLoading = false;
        });
        if (response.statusCode == 200) {
          List parsed = json.decode(response.body);
          reports = parsed.map((job) => Tabledata.fromJson(job)).toList();
          if (reports != null) {
            reportDataSource = ReportDataSource(
                headers: widget.headers!, reportData: reports!);
          }
        } else {
          _showToast("Host Unreachable, try again later");
        }
      } else {
        _showToast("No internet connection available");
      }
    });
  }

  deleteData(String orderID) async {
    Utils.checkInternetConnection().then((connectionResult) async {
      if (connectionResult) {
        setState(() {
          _isLoading = true;
        });

        String url = Constants.base_url + 'data/delete/${widget.id}/${orderID}';

        var uri = Uri.parse(url);

        final response = await http.delete(
          uri,
          headers: <String, String>{
            'Content-Type': "application/json",
          },
        );

        if (response.statusCode == 200) {
          getData();
          _showToast("Deleted Successfully");
        } else {
          _showToast("Host Unreachable, try again later");
        }
      } else {
        _showToast("No internet connection available");
      }
    });
  }

  void _showToast(String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 2000),
        content: Text(msg),
      ),
    );
  }
}

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class ReportDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  List<DataGridRow> dataGridRows = [];
  List<DataGridCell> dataGridCells = [];
  ReportDataSource(
      {required List<Headers> headers, required List<Tabledata> reportData}) {
    for (Tabledata data in reportData) {
      dataGridCells = [];
      Map dataMap = data.toJson();
      for (var header in headers) {
        dataGridCells.add(DataGridCell<String>(
            columnName: header.column!, value: dataMap[header.column!]));
      }
      dataGridRows.add(DataGridRow(cells: dataGridCells));
    }
  }

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
          if (e.columnName == 'SalesChannel') {
            if (e.value == "offline") {
              return const Center(
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.red,
                ),
              );
            }
            return const Center(
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.green,
              ),
            );
          }
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(e.value.toString()),
          );
        }).toList());
  }

  void updateDataGridSource() {
    notifyListeners();
  }
}
