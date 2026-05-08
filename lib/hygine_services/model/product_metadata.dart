class ProductMetaData {
  String? image;
  String? shortDescription;
  String? video;
  String? videoThumbnail;

  ProductMetaData({
    this.image,
    this.shortDescription,
    this.video,
    this.videoThumbnail,
  });

  factory ProductMetaData.fromJson(Map<String, dynamic> json) {
    return ProductMetaData(
      image: json['image'],
      shortDescription: json['short_description'],
      video: json['video'],
      videoThumbnail: json['video_thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'short_description': shortDescription,
      'video': video,
      'video_thumbnail': videoThumbnail,
    };
  }
}
