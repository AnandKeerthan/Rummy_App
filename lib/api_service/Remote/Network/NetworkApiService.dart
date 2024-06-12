// ignore_for_file: file_names

import 'package:dsrummy/api_service/Remote/Api_CommonFunction/ApiException.dart';
import 'package:dsrummy/api_service/Remote/Network/BaseApiService.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app_export/app_export.dart';

class NetworkApiService extends BaseApiService {
  @override
  Future getResponse(String url) async {
    dynamic responseJson;
    try {
      String? token = await getUserToken();
      print("^^^^^^^^^^^^${token}");
      final response = await http.get(Uri.parse(baseUrl + url),
          headers: {"Authorization": "Bearer ${token}"});
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future getResponse1(String url) async {
    dynamic responseJson;
    try {
      String? token = await getUserToken();
      print(token);
      final response = await http.get(Uri.parse(baseUrl + url),
          headers: {"Authorization": "Bearer ${token}"});
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future postResponse(String url, {Map<String, dynamic>? body}) async {
    dynamic responseJson;
    var data = json.encode(body);
    var headers = {
      // "Authorization": "Bearer ${token.$}",
      "content-type": "application/json",
      "Accept": "application/json"
    };
    print(data);
    try {
      await http
          .post(Uri.parse(baseUrl + url), headers: headers, body: data)
          .then((value) {
        responseJson = jsonDecode(value.body);
      });
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future postResponseToken(String url, {Map<String, dynamic>? body}) async {
    String? token = await getUserToken();
    // print(
    //     "/////////////////////////////////////////////////////////////////::::::::::::::${token}");
    dynamic responseJson;
    var data = json.encode(body);
    var headers = {
      // "Authorization": "Bearer ${token.$}",
      "content-type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer ${token}"
    };
    print(data);
    try {
      await http
          .post(Uri.parse(baseUrl + url), headers: headers, body: data)
          .then((value) {
        responseJson = jsonDecode(value.body);
      });
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future postResponseTokenWithoutParams(
    String url,
  ) async {
    String? token = await getUserToken();
    print(
        "/////////////////////////////////////////////////////////////////::::::::::::::${token}");
    dynamic responseJson;
    var headers = {
      // "Authorization": "Bearer ${token.$}",
      "content-type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer ${token}"
    };
    try {
      await http
          .post(
        Uri.parse(baseUrl + url),
        headers: headers,
      )
          .then((value) {
        responseJson = jsonDecode(value.body);
      });
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future multipartProcedure(String url, http.MultipartFile files,
      {Map<String, dynamic>? body}) async {
    String? token = await getUserToken();
    print("-token--------${token}");
    dynamic responseJson;
    var request = http.MultipartRequest('POST', Uri.parse(baseUrl + url));
    Map<String, String> data = body!.cast();
    //for token
    print(data);
    request.headers.addAll({
      "Authorization": "Bearer ${token}",
      "content-type": "multipart/form-data",
      "Accept": "multipart/form-data"
    });

    try {
      request.files.add(files);

      request.fields.addAll(data);
      var response = await request.send();

      //for getting and decoding the response into json format
      var responsed = await http.Response.fromStream(response);
      responseJson = json.decode(responsed.body);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future multipartProcedureV1(String url, List<http.MultipartFile> files,
      {Map<String, dynamic>? body}) async {
    String? token = await getUserToken();

    dynamic responseJson;
    var request = http.MultipartRequest('POST', Uri.parse(baseUrl + url));
    Map<String, String> data = body!.cast();
    //for token
    print(data);
    request.headers.addAll({
      "Authorization": "Bearer ${token}",
      "content-type": "multipart/form-data",
      "Accept": "multipart/form-data"
    });

    try {
      //for image and videos and files
      // http.MultipartFile f = await http.MultipartFile.fromPath("images[]", file!.path);
      for (var i = 0; i < files.length; i++) {
        request.files.add(files[i]);
      }
      // request.files.addAll(files);
      request.fields.addAll(data);
      var response = await request.send();

      //for getting and decoding the response into json format
      var responsed = await http.Response.fromStream(response);
      responseJson = json.decode(responsed.body);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 404:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException('Error occured while communication with server'
            ' with status code : ${response.statusCode}');
    }
  }

  Future<String?> getUserToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("userToken");
  }
}

NetworkApiService networkApiService = NetworkApiService();
