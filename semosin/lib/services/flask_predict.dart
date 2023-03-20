import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class FlaskPredict {
  Future<String> predictImage(String path) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse("http://localhost:5000/uploader"));

    // XFile to File
    File selectedImage = File(path);

    // multipart request
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    request.files.add(
      http.MultipartFile('image', selectedImage.readAsBytes().asStream(),
          selectedImage.lengthSync(),
          filename: selectedImage.path.split('/').last),
    );

    request.headers.addAll(headers);
    var resp = await request.send();
    http.Response response = await http.Response.fromStream(resp);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));

    return dataConvertedJSON['result'];
  }
}
