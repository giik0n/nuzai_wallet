class Token {
  String? ticker;
  String? balance;
  String? name;
  String? image;

  Token({this.ticker, this.balance, this.name, this.image});

  Token.fromJson(Map<String, dynamic> json) {
    ticker = json['ticker'];
    balance = json['balance'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ticker'] = this.ticker;
    data['balance'] = this.balance;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}