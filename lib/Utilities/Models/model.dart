class Headers {
  String? column;
  String? format;
  bool? groupByHeader;
  bool? allowUserUpdate;
  bool? dropdown;
  List<String>? values;

  Headers(
      {this.column,
      this.format,
      this.groupByHeader,
      this.allowUserUpdate,
      this.dropdown,
      this.values});

  Headers.fromJson(Map<String, dynamic> json) {
    column = json['column'];
    format = json['format'];
    groupByHeader = json['groupByHeader'];
    allowUserUpdate = json['allowUserUpdate'];
    dropdown = json['dropdown'];
    values = json['values'].cast<String>();
  }
}

class Reports {
  int? id;
  String? reportName;

  Reports({this.id, this.reportName});

  Reports.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reportName = json['reportName'];
  }
}
