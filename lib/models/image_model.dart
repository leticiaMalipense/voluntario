
class ImageModel {

  String title;
  var image;

  static ImageModel create(String title, var image) {
    ImageModel imageModel = ImageModel();
    imageModel.title = title;
    imageModel.image = image;

    return imageModel;
  }

  static ImageModel toModel(Map<String, dynamic> map) {
    ImageModel imageModel = ImageModel();
    imageModel.title = map["title"].toString();
    imageModel.image = map["image"];

    return imageModel;
  }

  static Map<String, dynamic> toJson(ImageModel imageModel) {
    Map<String, String> mapImage = {
      "title": imageModel.title,
      "image": imageModel.image
    };
    return mapImage;
  }
}