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

class Tabledata {
  int? orderId;
  String? itemType;
  String? salesChannel;
  String? country;
  String? orderPriority;
  String? orderDate;

  Tabledata(
      {this.orderId,
      this.itemType,
      this.salesChannel,
      this.country,
      this.orderPriority,
      this.orderDate});

  Tabledata.fromJson(Map<String, dynamic> json) {
    orderId = json['Order Id'];
    itemType = json['Item Type'];
    salesChannel = json['Sales Channel'];
    country = json['Country'];
    orderPriority = json['Order Priority'];
    orderDate = json['Order Date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Order Id'] = this.orderId;
    data['Item Type'] = this.itemType;
    data['Sales Channel'] = this.salesChannel;
    data['Country'] = this.country;
    data['Order Priority'] = this.orderPriority;
    data['Order Date'] = this.orderDate;
    return data;
  }
}
