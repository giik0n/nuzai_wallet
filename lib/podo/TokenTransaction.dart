class TokenTransaction {
  String? id;
  String? transactionHash;
  String? from;
  String? to;
  String? amount;
  String? transactionTime;
  int? status;
  String? ticker;

  TokenTransaction(
      {this.id,
        this.transactionHash,
        this.from,
        this.to,
        this.amount,
        this.transactionTime,
        this.status,
        this.ticker});

  TokenTransaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transactionHash = json['transactionHash'];
    from = json['from'];
    to = json['to'];
    amount = json['amount'];
    transactionTime = json['transactionTime'];
    status = json['status'];
    ticker = json['ticker'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['transactionHash'] = this.transactionHash;
    data['from'] = this.from;
    data['to'] = this.to;
    data['amount'] = this.amount;
    data['transactionTime'] = this.transactionTime;
    data['status'] = this.status;
    data['ticker'] = this.ticker;
    return data;
  }
}