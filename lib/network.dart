import 'dart:io';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:async/async.dart';
import 'package:path/path.dart';

class NetworkUtils {
  static const localUrl = "http://volunteer.test-holooltech.com/api/";

  static Map<String, String> headers = {
    'Accept': 'application/json',
    'Content-type': 'application/json',
  };

  static Future<http.Response> get({
    required String url,
    Map<String, String> headers = const {},
  }) async {
    http.Response response;
    response = await http.get(Uri.parse(localUrl + url), headers: headers);
    return response;
  }

  static Future<http.Response> delete({
    required String url,
    Map<String, String> headers = const {},
  }) async {
    http.Response response;
    response = await http.delete(Uri.parse(localUrl + url), headers: headers);
    return response;
  }

  static Future<http.Response> post({
    required String url,
    Map<String, String> headers = const {},
    dynamic body,
  }) async {
    http.Response response;
    response = await http.post(
      Uri.parse(localUrl + url),
      headers: headers,
      body: body,
    );
    return response;
  }

  static Future<http.Response> put({
    required String url,
    Map<String, String> headers = const {},
    required dynamic body,
  }) async {
    http.Response response;
    response = await http.put(
      Uri.parse(localUrl + url),
      headers: headers,
      body: body,
    );
    return response;
  }

  static Future<http.StreamedResponse> postMultipart({
    required String url,
    Map<String, String>? headers,
    Map<String, String>? fields,
    Map<String, String>? files,
  }) async {
    var request = http.MultipartRequest('POST', Uri.parse(localUrl + url));
    if (files != null) {
      var _filesKeyList = files.keys.toList();
      var _filesNameList = files.values.toList();
      for (int i = 0; i < _filesKeyList.length; i++) {
        if (_filesNameList[i] != "") {
          var multipartFile = http.MultipartFile.fromPath(
            _filesKeyList[i],
            _filesNameList[i],
            filename: path.basename(_filesNameList[i]),
            contentType: getContentType(_filesNameList[i]),
          );
          request.files.add(await multipartFile);
        }
      }
    }
    request.headers.addAll(headers!);
    request.fields.addAll(fields!);
    http.StreamedResponse response = await request.send();
    return response;
  }

  static Future<http.StreamedResponse> postMultipartImg({
    required String url,
    Map<String, String>? headers,
    File? files,
  }) async {
    // open a bytestream
    var stream = new http.ByteStream(DelegatingStream.typed(files!.openRead()));
    // get file length
    var length = await files.length();
    var request = http.MultipartRequest('POST', Uri.parse(localUrl + url));

    var multipartFile = new http.MultipartFile(
      'file',
      stream,
      length,
      filename: basename(files.path),
    );

    request.files.add(multipartFile);

    request.headers.addAll(headers!);
    http.StreamedResponse response = await request.send();
    return response;
  }

  static MediaType getContentType(String name) {
    var fileName = name.split('/').last;
    var ext = fileName.split('.').last;
    if (ext == "png" || ext == "jpeg") {
      return MediaType.parse("image/jpg");
    } else if (ext == 'pdf') {
      return MediaType.parse("application/pdf");
    } else {
      return MediaType.parse("image/jpg");
    }
  }
}
