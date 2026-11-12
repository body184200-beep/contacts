import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/data/models/contact_model.dart';
import '../../../../domain/data/provider/contact_provider.dart';
import '../../contacts/presentation/screens/contact_details_screen.dart';
import '../../form/presentation/screens/form_screen.dart';
import '../../scan/presentation/screens/scan_screen.dart';

class HomeController {
  final BuildContext context;

  HomeController(this.context);

  ContactProvider get _provider =>
      Provider.of<ContactProvider>(context, listen: false);

  void init() {
    _provider.loadContacts();
  }

  void onTabChanged(int index) {
    if (index == 0) {
      _provider.loadContacts();
    } else {
      _provider.loadFavorites();
    }
  }

  void onSearch(String query) {
    _provider.searchContacts(query);
  }

  void onToggleSort(bool isAscending) {
    _provider.sortContacts(isAscending);
  }

  Future<void> onToggleFavorite(ContactModel contact) async {
    await _provider.toggleFavorite(contact);
  }

  Future<void> onDeleteContact(ContactModel contact) async {
    await _provider.removeContact(contact);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${contact.name} deleted'),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {},
          ),
        ),
      );
    }
  }

  void openContactDetails(int contactId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ContactDetailsScreen(contactId: contactId),
      ),
    );
  }

  void openScanScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ScanScreen()),
    );
  }

  void openManualForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FormScreen(
          contactModel: ContactModel(name: '', mobile: ''),
        ),
      ),
    );
  }

  void showAddContactOptions() {
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
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFEEF2FF),
                    child: Icon(Icons.document_scanner, color: Color(0xFF2563EB)),
                  ),
                  title: const Text('Scan Business Card'),
                  subtitle: const Text('Extract contact information via OCR'),
                  onTap: () {
                    Navigator.pop(ctx);
                    openScanScreen();
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFECFDF5),
                    child: Icon(Icons.edit, color: Color(0xFF10B981)),
                  ),
                  title: const Text('Add Manually'),
                  subtitle: const Text('Enter details using form'),
                  onTap: () {
                    Navigator.pop(ctx);
                    openManualForm();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
