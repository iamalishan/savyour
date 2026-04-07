import 'dart:io';

import '../constants/app_imports.dart';

void captureAndShareScreenshot(ScreenshotController controller) async {
  try {
    final image = await controller.capture();
    if (image == null) return;

    final directory = await getTemporaryDirectory();
    final imagePath = File('${directory.path}/screenshot.png');
    await imagePath.writeAsBytes(image);

    await ShareParams(
      text: "🌟 Check out this cool screenshot!",
      files: [XFile(imagePath.path)],
    );
  } catch (e) {
    print("Error capturing screenshot: $e");
  }
}