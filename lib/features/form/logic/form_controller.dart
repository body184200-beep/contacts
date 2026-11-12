import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../domain/data/models/contact_model.dart';
import '../../../../domain/data/provider/contact_provider.dart';

class FormController {
  final BuildContext context;
  final ContactModel contactModel;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController designationController = TextEditingController();

  String imagePath = '';
  bool isSaving = false;

  FormController({required this.context, required this.contactModel}) {
    nameController.text = contactModel.name;
    emailController.text = contactModel.email;
    mobileController.text = contactModel.mobile;
    addressController.text = contactModel.address;
    companyController.text = contactModel.company;
    websiteController.text = contactModel.website;
    designationController.text = contactModel.designation;
    imagePath = contactModel.image;
  }

  Future<void> pickImage(ImageSource source, VoidCallback onUpdate) async {
    try {
      final picked = await ImagePicker().pickImage(source: source);
      if (picked != null) {
        imagePath = picked.path;
        onUpdate();
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void removeImage(VoidCallback onUpdate) {
    imagePath = '';
    onUpdate();
  }

  Future<bool> saveContact() async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    isSaving = true;

    contactModel.name = nameController.text.trim();
    contactModel.email = emailController.text.trim();
    contactModel.mobile = mobileController.text.trim();
    contactModel.address = addressController.text.trim();
    contactModel.company = companyController.text.trim();
    contactModel.website = websiteController.text.trim();
    contactModel.designation = designationController.text.trim();
    contactModel.image = imagePath;

    final provider = Provider.of<ContactProvider>(context, listen: false);
    await provider.saveContact(contactModel);

    isSaving = false;

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(contactModel.id > 0
              ? 'Contact updated successfully'
              : 'Contact added successfully'),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
      Navigator.pop(context, true);
    }

    return true;
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    addressController.dispose();
    companyController.dispose();
    websiteController.dispose();
    designationController.dispose();
  }
}
