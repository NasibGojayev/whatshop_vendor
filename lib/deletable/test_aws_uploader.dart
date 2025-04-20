import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

void testAwsUploadFlow() async {
  try {
    final fileName = 'test.jpg';
    final contentType = 'image/jpeg';

    // STEP 1: Get signed URL
    print('Making request to backend...');
    final backendResponse = await http.post(
      Uri.parse('https://whatshoppy.pythonanywhere.com/get-upload-url'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'filename': fileName,
        'contentType': contentType,
      }),
    );

    print('Response status: ${backendResponse.statusCode}');
    print('Response headers: ${backendResponse.headers}');
    print('Response body: ${backendResponse.body}');

    if (backendResponse.statusCode != 200) {
      throw Exception('Backend request failed with status ${backendResponse.statusCode}');
    }

    final data = jsonDecode(backendResponse.body);
    final uploadUrl = data['uploadUrl'];
    final publicUrl = data['publicUrl'];

    print('Upload URL: $uploadUrl');
    print('Public URL: $publicUrl');

    // Rest of your upload code...
  } catch (e) {
    print('Error in testAwsUploadFlow: $e');
  }
}



void main() {
  testAwsUploadFlow();
  print('done');
}


