class ImgurImages {
  List<ImgurImage> images;

  ImgurImages({required this.images});

  factory ImgurImages.fromJson(Map<String, dynamic> json) => ImgurImages(
      images: List<ImgurImage>.from(
          json["data"].map((x) => ImgurImage.fromJson(x))));
}

class ImgurImage {
  String? itemType;
  String? id;
  String? title;
  dynamic description;
  int? datetime;
  String? cover;
  int? coverWidth;
  int? coverHeight;
  String? accountUrl;
  int? accountId;
  String? link;
  bool? favorite;
  String? section;
  int? favoriteCount;
  int? imagesCount;
  bool? inGallery;
  List<Tag>? tags;
  bool? inMostViral;
  List<ImageDetails>? images;

  ImgurImage(
      {this.id,
      this.title,
      this.description,
      this.datetime,
      this.cover,
      this.coverWidth,
      this.coverHeight,
      this.accountUrl,
      this.accountId,
      this.link,
      this.favorite,
      this.section,
      this.favoriteCount,
      this.imagesCount,
      this.inGallery,
      this.tags,
      this.inMostViral,
      this.images,
      required this.itemType});

  factory ImgurImage.fromJson(Map<String, dynamic> json) {
    return ImgurImage(
        link: json['link'],
        itemType: json['type'],
        title: json['title'],
        description: json['description'],
        id: json['id']);
  }
}

class ImageDetails {
  String? id;
  dynamic title;
  dynamic description;
  int? datetime;
  String? type;
  bool? animated;
  int? width;
  int? height;
  int? size;
  int? views;
  dynamic vote;
  bool? favorite;
  dynamic section;
  dynamic accountUrl;
  dynamic accountId;
  bool? inMostViral;
  List<dynamic>? tags;

  String? link;
  dynamic favoriteCount;

  ImageDetails({
    this.id,
    this.title,
    this.description,
    this.datetime,
    this.type,
    this.animated,
    this.width,
    this.height,
    this.size,
    this.views,
    this.vote,
    this.favorite,
    this.section,
    this.accountUrl,
    this.accountId,
    this.inMostViral,
    this.tags,
    this.link,
    this.favoriteCount,
  });
}

class Tag {
  String? name;
  String? displayName;
  int? totalItems;
  String? backgroundHash;
  String? description;

  Tag({
    this.name,
    this.displayName,
    this.totalItems,
    this.backgroundHash,
    this.description,
  });
}
