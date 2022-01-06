import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function(File pickedImage) imagePickFn;
  const UserImagePicker({required this.imagePickFn, Key? key})
      : super(key: key);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  void _pickImage(bool isCamera) async {
    final pickedImageFile = await ImagePicker.platform.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImageFile != null) {
      final pickedImageAsFile = File(pickedImageFile.path);
      setState(() {
        _pickedImage = pickedImageAsFile;
      });
      widget.imagePickFn(pickedImageAsFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage!) : null,
        ),
        // verticaly center this
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton.icon(
              onPressed: () => _pickImage(true),
              icon: Icon(Icons.photo_camera),
              label: Text('Take a picture'),
            ),
            FlatButton.icon(
              onPressed: () => _pickImage(false),
              icon: Icon(Icons.image),
              label: Text('Add image'),
            ),
          ],
        ),
      ],
    );
  }
}
