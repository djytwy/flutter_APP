import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomImagePicker extends StatefulWidget {
  final String title;
  final imageCallback;

  CustomImagePicker({Key key, this.title, this.imageCallback}):super(key:key);
  _CustomImagePickerState createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  Future <File> _imageFile;

  void _onImageButtonPressed(ImageSource source) {
    setState(() {
      _imageFile = ImagePicker.pickImage(source: source);
    });
    _imageCallBack();
  }

  void _imageCallBack(){
    widget.imageCallback(_imageFile);
  }

  @override
  void initState() {
    super.initState();
  }  

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        //相册选取照片
        FloatingActionButton(
          onPressed: () {
            _onImageButtonPressed(ImageSource.gallery);
          },
          child: const Icon(Icons.photo_library),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          //拍照
          child: FloatingActionButton(
            onPressed: () {
              _onImageButtonPressed(ImageSource.camera);
            },
            child: const Icon(Icons.camera_alt),
          ),
        )
      ],
    );
  }
}
