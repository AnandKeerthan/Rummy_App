// ignore_for_file: file_names

abstract class BaseApiService {
  final String baseUrl = "ENTER-YOUR-URL";
  Future<dynamic> getResponse(String url);
}
