import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as Img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:queroservoluntario/models/image_model.dart';
import 'package:queroservoluntario/utils/app_style.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImagePickComponent {
  final imagePicker = ImagePicker();
  File image;
  bool updated = true;

  Center buildImagePicker(BuildContext context, bool enable, Function refresh, File file) {
    if (file != null && updated) {
      image = file;
      updated = false;
    }

    return Center(
        child: Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
            child: GestureDetector(
              onTap: enable ?  () {
                _showPicker(context, refresh);
              } : null,
              child: CircleAvatar(
                radius: 55,
                backgroundColor: AppColors.primaryColor,
                child: image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.file(
                          image,
                          width: 100,
                          height: 100,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(50)),
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
              ),
            )));
  }

  static Future<File> getFile(String title, Uint8List byte) async {
    Uint8List imageInUnit8List = byte;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = await File('${tempPath}/' + title).create();
    file.writeAsBytesSync(imageInUnit8List);
    return file;
  }

  void _showPicker(context, Function refresh) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery(refresh);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera(refresh);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromCamera(Function refresh) async {
    var xFile = (await imagePicker.pickImage(
        source: ImageSource.camera));

    if(xFile != null) {
      var path = xFile.path;
      File image = File(path);
      refresh(image);
    }
  }

  _imgFromGallery(Function refresh) async {
    var xFile = (await imagePicker.pickImage(
            source: ImageSource.gallery));
    if(xFile != null) {
      var path = xFile.path;
      File image = File(path);
      refresh(image);
    }
  }

  Future<ImageModel> generateImage() async {
    if (image != null && image.path != null && image.path.isNotEmpty) {
      var result = await FlutterImageCompress.compressWithFile(
        image.absolute.path
      );

      var split = image.path.split("/");
      return ImageModel.create(split.last, result);
    } else {
      return null;
    }
  }
}
