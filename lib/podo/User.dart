class User {
  int? id;
  String? fullname;
  String? email;
  String? token;
  String? wallet;
  int? defaultNetwork;

  User(
      {this.id,
      this.fullname,
      this.email,
      this.token,
      this.wallet,
      this.defaultNetwork});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    email = json['email'];
    token = json['token'];
    wallet = json['wallet'];
    defaultNetwork = json['defaultNetwork'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullname'] = this.fullname;
    data['email'] = this.email;
    data['token'] = this.token;
    data['wallet'] = this.wallet;
    data['defaultNetwork'] = this.defaultNetwork;
    return data;
  }
}
