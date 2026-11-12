import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/service/scan_service.dart';
import '../../../../core/utils/constants.dart';
import '../../../../domain/data/models/contact_model.dart';
import '../../form/presentation/screens/form_screen.dart';

class ScanController {
  final BuildContext context;

  bool isScan = false;
  List<String> lines = [];
  String imagePath = '';

  final Map<String, String> properties = {
    ContactProperties.name: '',
    ContactProperties.mobile: '',
    ContactProperties.email: '',
    ContactProperties.address: '',
    ContactProperties.website: '',
    ContactProperties.company: '',
    ContactProperties.designation: '',
  };

  ScanController(this.context);

  Future<void> pickAndScan(ImageSource source, VoidCallback onUpdate) async {
    EasyLoading.show(status: 'Scanning card...');
    try {
      final result = await ScanService().scanText(source);
      if (result != null) {
        isScan = true;
        lines = result.lines;
        imagePath = result.imagePath;
        onUpdate();
      }
    } catch (e) {
      debugPrint('Scan error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to extract text from image')),
        );
      }
    } finally {
      EasyLoading.dismiss();
    }
  }

  void assignProperty(String property, String value, VoidCallback onUpdate) {
    properties[property] = value;
    onUpdate();
  }

  void clearProperty(String property, VoidCallback onUpdate) {
    properties[property] = '';
    onUpdate();
  }

  void proceedToForm() {
    final contact = ContactModel(
      name: properties[ContactProperties.name] ?? '',
      mobile: properties[ContactProperties.mobile] ?? '',
      email: properties[ContactProperties.email] ?? '',
      address: properties[ContactProperties.address] ?? '',
      company: properties[ContactProperties.company] ?? '',
      website: properties[ContactProperties.website] ?? '',
      designation: properties[ContactProperties.designation] ?? '',
      image: imagePath,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => FormScreen(contactModel: contact),
      ),
    );
  }
}
