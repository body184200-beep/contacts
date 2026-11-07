import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ScanService {
  Future<List<String>?> scanText(ImageSource imageSource) async {
    final xFile = await ImagePicker().pickImage(source: imageSource);

    if (xFile == null) return null;

    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      final recognizedText = await textRecognizer.processImage(
        InputImage.fromFilePath(xFile.path),
      );

      final tempList = <String>[];

      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          for (TextElement element in line.elements) {
            tempList.add(element.text);
          }
        }
      }

      return tempList;
    } finally {
      await textRecognizer.close();
    }
  }
}
