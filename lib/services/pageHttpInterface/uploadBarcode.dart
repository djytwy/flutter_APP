import 'dart:io';
import '../ajax.dart';
import '../../config/serviceUrl.dart';
import 'package:dio/dio.dart';


Future uploadBarcode(String url ,File imgfile) async {
  String path = imgfile.path;
  final name = path.substring(path.lastIndexOf("/") + 1, path.length);
  FormData formData = FormData.from({
    "fileName":  UploadFileInfo(File(path), name)
  });
  final _data = await upLoadImg(
      url: servicePath["barcode"],
      params: formData,
      method: 'post'
  );
  if (_data != null) {
    return _data;
  }
}