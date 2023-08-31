import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart' as Http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient extends GetxService {
  String appBaseUrl = 'http://api.ioevisa.net/api/job/index.php?' ;
  final String noInternetMessage = 'Connection to API server failed due to internet connection';
  final int timeoutInSeconds = 30;
  late String token;
  late Map<String, String> _mainHeaders;

  ApiClient({
    required this.appBaseUrl,

  });


  Future<Response> getData(String uri) async {
    print(appBaseUrl+uri);
    Http.Response _response = await Http.get(
        Uri.parse(appBaseUrl+uri)
    );
    print('response.body');
    return handleResponse(_response, uri);
  }

  Future<Response> postData(String uri, dynamic body) async {

    print('====> GetX Base URL: $appBaseUrl$uri');
    print('====> GetX Body: $body');

    Http.Response _response = await Http.post(
      Uri.parse(appBaseUrl+uri),
      body: jsonEncode(body),
    ).timeout(Duration(seconds: timeoutInSeconds));
    print("++++++++++++>>>=====");
    Response response = handleResponse(_response, uri);
    return response;



  }
  Response handleResponse(Http.Response response, String uri) {
    dynamic _body;
    try {
      _body = jsonDecode(response.body);
    }catch(e) {}
    Response _response = Response(
      body: _body != null ? _body : response.body, bodyString: response.body.toString(),
      request: Request(headers: response.request!.headers, method: response.request!.method, url: response.request!.url),
      headers: response.headers, statusCode: response.statusCode, statusText: response.reasonPhrase,
    );
    if(_response.statusCode != 200 && _response.body != null && _response.body is !String) {
      if(_response.body.toString().startsWith('{errors: [{code:')) {
        //ErrorResponse _errorResponse = ErrorResponse.fromJson(_response.body);
        _response = Response(statusCode: _response.statusCode, body: _response.body, statusText: 'error');
      }else if(_response.body.toString().startsWith('{message')) {
        _response = Response(statusCode: _response.statusCode, body: _response.body, statusText: _response.body['message']);
      }
    }else if(_response.statusCode != 200 && _response.body == null) {
      _response = Response(statusCode: 0, statusText: noInternetMessage);
    }
    debugPrint('====> API Response: [${_response.statusCode}] $uri\n${_response.body}');
    return _response;
  }
  Future<Response> postMultipartData(String uri, Map<String, String> body, List<MultipartBody> multipartBody) async {
    print(uri);
    //Stry {

    if(Foundation.kDebugMode) {
      //print('====> API Call: $uri\nToken: $token');
      print('====> API Body:${appBaseUrl+uri} $body with ${multipartBody.length} image ');
    }
    // print(uri);
    print(multipartBody.toString());
    Http.MultipartRequest _request = Http.MultipartRequest('POST', Uri.parse(appBaseUrl+uri));
    for(MultipartBody multipart in multipartBody) {
      if(multipart.file != null) {
        if(Foundation.kIsWeb) {
          Uint8List _list = await multipart.file.readAsBytes();
          Http.MultipartFile _part = Http.MultipartFile(
            multipart.key, multipart.file.readAsBytes().asStream(), _list.length,
            filename: basename(multipart.file.path), contentType: MediaType('image', 'jpg'),
          );
          _request.files.add(_part);
        }else {
          File _file = File(multipart.file.path);
          _request.files.add(Http.MultipartFile(
            multipart.key, _file.readAsBytes().asStream(), _file.lengthSync(), filename: _file.path.split('/').last,
          ));
        }
      }
    }
    _request.fields.addAll(body);
    Http.Response _response = await Http.Response.fromStream(await _request.send());
    Response response = handleResponse(_response, uri);
    if(Foundation.kDebugMode) {
      print('====> API Response: [${response.statusCode}] $uri\n${response.body}');
    }
    return response;
    // } catch (e) {
    //   return Response(statusCode: 1, statusText: noInternetMessage);
    // }
  }

}

class MultipartBody {
  String key;
  File file;

  MultipartBody(this.key, this.file);
}
