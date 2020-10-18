class PostModel {
  List<String> comments;
  int ratingsCount;
  double ratingsAverage;
  int id;
  List<String> hashtags;
  int image;
  String text;

  PostModel(
      {this.comments,
      this.ratingsCount,
      this.ratingsAverage,
      this.id,
      this.hashtags,
      this.image,
      this.text});

  PostModel.fromJson(Map<String, dynamic> json) {
    comments = json['comments'].cast<String>();
    ratingsCount = json['ratings-count'];
    ratingsAverage = double.parse(json['ratings-average'].toString());
    id = json['id'];
    hashtags = json['hashtags'].cast<String>();
    image = json['image'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comments'] = this.comments;
    data['ratings-count'] = this.ratingsCount;
    data['ratings-average'] = this.ratingsAverage;
    data['id'] = this.id;
    data['hashtags'] = this.hashtags;
    data['image'] = this.image;
    data['text'] = this.text;
    return data;
  }
}
