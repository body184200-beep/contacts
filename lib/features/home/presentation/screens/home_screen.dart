import 'package:contacts/core/theme/colors.dart';
import 'package:contacts/features/scan/presentation/screens/scan_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/custom_dialog/confirm_dismiss.dart';
import '../../../../domain/data/provider/contact_provider.dart';
import '../../../contacts/presentation/screens/contact_details_screen.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/fliatong_action_bottoms.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ContactProvider>(context, listen: false).loadContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),
        centerTitle: true,
        backgroundColor: Appcolors.blue,
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      floatingActionButton: FloatingActionBottoms(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ScanScreen()),
          );
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: CustomBottomNavigationBar(),

      body: Consumer<ContactProvider>(
        builder: (context, contactProvider, child) {
          return ListView.builder(
            itemCount: contactProvider.contacts.length,
            itemBuilder: (context, index) {
              final contact = contactProvider.contacts[index];

              return Dismissible(
                key: Key(contact.id.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Appcolors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(Icons.delete, color: Appcolors.white),
                ),

                confirmDismiss: (direction) async {
                  return await showDialog<bool>(
                    context: context,
                    builder: (context) => const ConfirmDismiss(),
                  );
                },

                onDismissed: (direction) {
                  contactProvider.removeContact(contact);
                },

                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContactDetailsScreen(
                          contactId: contact.id,
                        ),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    child: Text(

                      contact.name.isNotEmpty ? contact.name[0] : '?',
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      contactProvider.toggleFavorite(contact);
                    },
                    icon: Icon(
                      contact.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Appcolors.red,
                    ),
                  ),
                  title: Text(contact.name),
                  subtitle: Text(contact.mobile),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
