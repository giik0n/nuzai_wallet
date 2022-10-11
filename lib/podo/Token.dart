class Token {
  String? ticker;
  String? balance;
  String? name;
  String? image;
  String? amountInUsd;

  Token({this.ticker, this.balance, this.name, this.image, this.amountInUsd});

  Token.fromJson(Map<String, dynamic> json) {
    ticker = json['ticker'];
    balance = json['balance'];
    name = json['name'];
    image = json['image'];
    amountInUsd = json['amountInUsd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ticker'] = this.ticker;
    data['balance'] = this.balance;
    data['name'] = this.name;
    data['image'] = this.image;
    data['amountInUsd'] = this.amountInUsd;
    return data;
  }
}
