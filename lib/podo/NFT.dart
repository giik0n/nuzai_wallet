class NFT {
  String? title;
  String? fileName;
  String? description;
  String? image;
  String? ipfsUlrl;
  String? fileExtension;

  NFT(
      {this.title,
        this.fileName,
        this.description,
        this.image,
        this.ipfsUlrl,
        this.fileExtension});

  NFT.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    fileName = json['fileName'];
    description = json['description'];
    image = json['image'];
    ipfsUlrl = json['ipfsUlrl'];
    fileExtension = json['fileExtension'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['fileName'] = this.fileName;
    data['description'] = this.description;
    data['image'] = this.image;
    data['ipfsUlrl'] = this.ipfsUlrl;
    data['fileExtension'] = this.fileExtension;
    return data;
  }
}