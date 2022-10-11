class GasFee {
  double? gasLimit;
  double? gasPrice;

  GasFee({this.gasLimit, this.gasPrice});

  GasFee.fromJson(Map<String, dynamic> json) {
    gasLimit = json['gasLimit'];
    gasPrice = json['gasPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gasLimit'] = this.gasLimit;
    data['gasPrice'] = this.gasPrice;
    return data;
  }
}