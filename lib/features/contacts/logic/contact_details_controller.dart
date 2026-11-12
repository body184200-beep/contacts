import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/custom_dialog/confirm_dismiss.dart';
import '../../../../domain/data/models/contact_model.dart';
import '../../../../domain/data/provider/contact_provider.dart';
import '../../form/presentation/screens/form_screen.dart';

class ContactDetailsController {
  final BuildContext context;

  ContactDetailsController(this.context);

  ContactProvider get _provider =>
      Provider.of<ContactProvider>(context, listen: false);

  Future<ContactModel?> getContact(int id) async {
    return await _provider.getContactById(id);
  }

  Future<void> makeCall(String phone) async {
    if (phone.trim().isEmpty) return;
    final Uri uri = Uri(scheme: 'tel', path: phone.trim());
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showError('Could not launch phone app');
    }
  }

  Future<void> sendSms(String phone) async {
    if (phone.trim().isEmpty) return;
    final Uri uri = Uri(scheme: 'sms', path: phone.trim());
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showError('Could not launch messaging app');
    }
  }

  Future<void> sendEmail(String email) async {
    if (email.trim().isEmpty) return;
    final Uri uri = Uri(scheme: 'mailto', path: email.trim());
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showError('Could not launch email app');
    }
  }

  Future<void> openWebsite(String url) async {
    if (url.trim().isEmpty) return;
    String formattedUrl = url.trim();
    if (!formattedUrl.startsWith('http://') && !formattedUrl.startsWith('https://')) {
      formattedUrl = 'https://$formattedUrl';
    }
    final Uri uri = Uri.parse(formattedUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showError('Could not open web link');
    }
  }

  Future<void> toggleFavorite(ContactModel contact) async {
    await _provider.toggleFavorite(contact);
  }

  void editContact(ContactModel contact) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FormScreen(contactModel: contact),
      ),
    );
  }

  Future<void> deleteContact(ContactModel contact) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => const ConfirmDismiss(),
    );

    if (confirmed == true) {
      await _provider.removeContact(contact);
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  void _showError(String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
