import 'dart:typed_data';

import 'package:image_downloader_web/image_downloader_web.dart';

Future<void> downloadImageWeb(Uint8List bytes, String name) async {
  await WebImageDownloader.downloadImageFromUInt8List(
    uInt8List: bytes,
    name: name,
  );
}
