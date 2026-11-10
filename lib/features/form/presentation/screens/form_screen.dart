import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/contact_avatar.dart';
import '../../../../domain/data/models/contact_model.dart';
import '../../logic/form_controller.dart';
import '../widgets/text_form_field_controller.dart';

class FormScreen extends StatefulWidget {
  final ContactModel contactModel;

  const FormScreen({super.key, required this.contactModel});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  late final FormController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FormController(
      context: context,
      contactModel: widget.contactModel,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: Appcolors.primary),
                  title: const Text('Take Photo'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _controller.pickImage(ImageSource.camera, () => setState(() {}));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library, color: Appcolors.primary),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _controller.pickImage(ImageSource.gallery, () => setState(() {}));
                  },
                ),
                if (_controller.imagePath.isNotEmpty)
                  ListTile(
                    leading: const Icon(Icons.delete, color: Appcolors.error),
                    title: const Text('Remove Photo', style: TextStyle(color: Appcolors.error)),
                    onTap: () {
                      Navigator.pop(ctx);
                      _controller.removeImage(() => setState(() {}));
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.contactModel.id > 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Contact' : 'New Contact'),
        actions: [
          TextButton(
            onPressed: _controller.isSaving ? null : () => _controller.saveContact(),
            child: const Text(
              'Save',
              style: TextStyle(
                color: Appcolors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _controller.formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Avatar picker
            Center(
              child: Stack(
                children: [
                  ContactAvatar(
                    name: _controller.nameController.text.isNotEmpty
                        ? _controller.nameController.text
                        : 'New',
                    imagePath: _controller.imagePath,
                    radius: 54,
                    fontSize: 42,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _showImageOptions,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Appcolors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Appcolors.white, width: 2.5),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Appcolors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionHeader('Basic Information'),
            const SizedBox(height: 12),
            TextFormFieldController(
              controller: _controller.nameController,
              label: 'Name',
              keyboardType: TextInputType.name,
              isRequired: true,
              prefixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 14),

            TextFormFieldController(
              controller: _controller.mobileController,
              label: 'Mobile',
              keyboardType: TextInputType.phone,
              isRequired: true,
              prefixIcon: Icons.phone_outlined,
            ),
            const SizedBox(height: 14),

            TextFormFieldController(
              controller: _controller.emailController,
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
              isRequired: false,
              prefixIcon: Icons.email_outlined,
            ),
            const SizedBox(height: 24),

            _buildSectionHeader('Work Details'),
            const SizedBox(height: 12),
            TextFormFieldController(
              controller: _controller.companyController,
              label: 'Company',
              keyboardType: TextInputType.text,
              isRequired: false,
              prefixIcon: Icons.business_outlined,
            ),
            const SizedBox(height: 14),

            TextFormFieldController(
              controller: _controller.designationController,
              label: 'Designation / Job Title',
              keyboardType: TextInputType.text,
              isRequired: false,
              prefixIcon: Icons.badge_outlined,
            ),
            const SizedBox(height: 24),

            _buildSectionHeader('Other Information'),
            const SizedBox(height: 12),
            TextFormFieldController(
              controller: _controller.addressController,
              label: 'Address',
              keyboardType: TextInputType.streetAddress,
              isRequired: false,
              prefixIcon: Icons.location_on_outlined,
            ),
            const SizedBox(height: 14),

            TextFormFieldController(
              controller: _controller.websiteController,
              label: 'Website',
              keyboardType: TextInputType.url,
              isRequired: false,
              prefixIcon: Icons.language_outlined,
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _controller.isSaving ? null : () => _controller.saveContact(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Appcolors.primary,
                foregroundColor: Appcolors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
              ),
              child: _controller.isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Appcolors.white, strokeWidth: 2),
                    )
                  : Text(
                      isEditing ? 'Update Contact' : 'Save Contact',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Appcolors.textSecondary,
        letterSpacing: 0.5,
      ),
    );
  }
}
