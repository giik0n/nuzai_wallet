class NFT {
  String? title;
  String? description;
  String? image;
  String? model;
  String? extension;

  NFT({this.title, this.description, this.image, this.model, this.extension});

  NFT.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    image = json['image'];
    model = json['model'];
    extension = json['extension'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    data['model'] = this.model;
    data['extension'] = this.extension;
    return data;
  }
}
