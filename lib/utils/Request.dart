import 'dart:io';
import 'package:dio/dio.dart';

class Request {
  Dio dio = Dio();
  // dio.options.baseUrl = '';
  Future httpGet(String url, Object data) async {
    try {
      Response response;
      response = await dio.get(
        'https://jspang.com',
        queryParameters: data
      );
      print(response);
      return response.data;
    } catch(e) {
      return print(e);
    }
  }

  Future httpPost(url, Object data, File file, [String type='']) async {
    try {
      Response response;
      if(type == 'file') {
        String path = file.path;
        String fileName = path.lastIndexOf('/') > -1 ? path.substring(path.lastIndexOf('/') + 1) : path;
        FormData formData = FormData.from({
          'chunk': '0',
          'success_action_status': '200',
          'Access-Control-Allow-Origin': '*',
          'file': new UploadFileInfo(new File(path), fileName)
        });
        data = formData;
      } 
      response = await dio.post(
        url,
        data: data
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return response.statusMessage;     // 报错情况
      }
    }catch(e){
      return print(e);
    }
  }
}