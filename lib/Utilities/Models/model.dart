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
  String? id;
  String? reportName;
  String? databaseID;

  Reports({this.id, this.reportName});

  Reports.fromJson(Map<String, dynamic> json) {
    id = json['reportId'].toString();
    reportName = json['reportName'];
    databaseID = json['databaseID'];
  }
}

class Tabledata {
  String? orderID;
  String? reportID;
  String? itemType;
  String? region;
  String? salesChannel;
  String? country;
  String? orderPriority;
  String? orderDate;

  Tabledata(
      {this.orderID,
      this.reportID,
      this.itemType,
      this.region,
      this.salesChannel,
      this.country,
      this.orderPriority,
      this.orderDate});

  Tabledata.fromJson(Map<String, dynamic> json) {
    orderID = json['OrderID'].toString();
    reportID = json['ReportID'].toString();
    itemType = json['ItemType'];
    region = json['Region'];
    salesChannel = json['SalesChannel'];
    country = json['Country'];
    orderPriority = json['OrderPriority'];
    orderDate = json['OrderDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OrderID'] = this.orderID;
    data['ItemType'] = this.itemType;
    data['Region'] = this.region;
    data['SalesChannel'] = this.salesChannel;
    data['Country'] = this.country;
    data['OrderPriority'] = this.orderPriority;
    data['OrderDate'] = this.orderDate;
    return data;
  }
}
