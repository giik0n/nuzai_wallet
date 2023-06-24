class User {
  int? id;
  String? fullname;
  String? email;
  String? token;
  String? wallet;
  String? totalAmount;

  User(
      {this.id,
      this.fullname,
      this.email,
      this.token,
      this.wallet,
      this.totalAmount});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    email = json['email'];
    token = json['token'];
    totalAmount = json['totalAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullname'] = this.fullname;
    data['email'] = this.email;
    data['token'] = this.token;
    data['wallet'] = this.wallet;
    data['totalAmount'] = this.totalAmount;
    return data;
  }
}
