import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImg extends StatefulWidget {
  UploadImg({
    Key key, 
    this.title, 
    this.imageCallback,
    this.scaffoldKey,
    this.context2
  }):super(key:key);

  final String title;
  final imageCallback;
  final BuildContext context2;
  final GlobalKey<ScaffoldState> scaffoldKey;

  _UploadImgState createState() => _UploadImgState();
}

class _UploadImgState extends State<UploadImg> {
  File _imageFile;

  Future _onImageButtonPressed(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source);
    setState(() {
      _imageFile = image;
    });
    widget.imageCallback(_imageFile);
  }

  @override
  void initState() {
    super.initState();
  }  

  @override
  Widget build(context2) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        // FlatButton(
        //   child: Text('button'),
        //   onPressed: (){
        //     showBottomSheet(
        //       context: context2,
        //       builder: (BuildContext context2) {
        //         return Container(
        //           height: 300,
        //           color: Colors.greenAccent,
        //           child: Center(
        //             child: Text('ModalBottomSheet'),
        //           )
        //         );
        //       }
        //     );
        //   },
        // ),
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
