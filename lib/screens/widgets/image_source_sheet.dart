import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  final Function(File) onImageSelected;

  ImageSourceSheet({this.onImageSelected});

  _imageSelected(PickedFile pfile) async {
    if (pfile != null && pfile.path != null) {
      File croppedImage = await ImageCropper.cropImage(
          sourcePath: pfile.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1));
      onImageSelected(croppedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final picker = ImagePicker();
    return BottomSheet(
        onClosing: () {},
        builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  child: Text('Camera'),
                  onPressed: () async {
                    PickedFile pfile =
                        await picker.getImage(source: ImageSource.camera);
                    _imageSelected(pfile);
                  },
                ),
                TextButton(
                    child: Text('Galeria'),
                    onPressed: () async {
                      PickedFile pfile =
                          await picker.getImage(source: ImageSource.gallery);
                      _imageSelected(pfile);
                    })
              ],
            ));
  }
}
