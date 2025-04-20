import 'dart:typed_data';
import 'package:gcloud/storage.dart';
import 'package:mime/mime.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;


class CloudApi{
  final auth.ServiceAccountCredentials? _credentials;
  auth.AutoRefreshingAuthClient? _client;

  CloudApi(String json):
        _credentials = auth.ServiceAccountCredentials.fromJson(json);
  Future<ObjectInfo> save(String name, Uint8List imgBytes) async{

    _client ??= await auth.clientViaServiceAccount(_credentials!,Storage.SCOPES);
    final storage = Storage(_client!, "Image Upload to Google Storage");
    final bucket = storage.bucket("whatshop_bucket");

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final type = lookupMimeType(name);

    return await bucket.writeBytes(name, imgBytes, metadata: ObjectMetadata(
        contentType: type,
        custom: {
          'timestamp': '$timestamp'
        }
    ));
  }

}