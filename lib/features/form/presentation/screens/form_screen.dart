import 'package:flutter/material.dart';

import '../../../../domain/models/contact_model.dart';
import '../widgets/text_form_field_controller.dart';

class FormScreen extends StatefulWidget {
  final ContactModel contactModel;

  const FormScreen({super.key, required this.contactModel});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();
  final companyController = TextEditingController();
  final websiteController = TextEditingController();
  final designationController = TextEditingController();

  

  @override
  void initState() {
    super.initState();

    nameController.text = widget.contactModel.name;
    emailController.text = widget.contactModel.email;
    mobileController.text = widget.contactModel.mobile;
    addressController.text = widget.contactModel.address;
    companyController.text = widget.contactModel.company;
    websiteController.text = widget.contactModel.website;
    designationController.text = widget.contactModel.designation;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    addressController.dispose();
    companyController.dispose();
    websiteController.dispose();
    designationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Form"), centerTitle: true,
      actions: [
        IconButton(onPressed: saveContacts,
            icon: const Icon(Icons.save))
      ],),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormFieldController(
              controller: nameController,
              label: "Name",
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 12),

            TextFormFieldController(
              controller: emailController,
              label: "Email",
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),

            TextFormFieldController(
              controller: mobileController,
              label: "Mobile",
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),

            TextFormFieldController(
              controller: addressController,
              label: "Address",
              keyboardType: TextInputType.streetAddress,
            ),
            const SizedBox(height: 12),

            TextFormFieldController(
              controller: companyController,
              label: "Company",
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 12),

            TextFormFieldController(
              controller: websiteController,
              label: "Website",
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 12),

            TextFormFieldController(
              controller: designationController,
              label: "Designation",
              keyboardType: TextInputType.text,
            ),
          ],
        ),
      ),
    );
  }

  void saveContacts() async{
    if (_formKey.currentState!.validate()) {
      widget.contactModel.name = nameController.text;
      widget.contactModel.email = emailController.text;
      widget.contactModel.mobile = mobileController.text;
      widget.contactModel.address = addressController.text;
      widget.contactModel.company = companyController.text;
      widget.contactModel.website = websiteController.text;
      widget.contactModel.designation = designationController.text;
    }
    
  }
}
