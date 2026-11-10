import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../domain/data/models/contact_model.dart';
import '../../../../domain/data/provider/contact_provider.dart';

class ContactDetailsScreen extends StatelessWidget {
  final int contactId;

  const ContactDetailsScreen({super.key, required this.contactId});

  // الاتصال
  Future<void> makeCall(String mobile) async {
    final Uri uri = Uri(scheme: 'tel', path: mobile);

    await launchUrl(uri);
  }

  // إرسال SMS
  Future<void> sendSms(String mobile) async {
    final Uri uri = Uri(scheme: 'sms', path: mobile);

    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contact Details"), centerTitle: true),
      body: Consumer<ContactProvider>(
        builder: (context, contactProvider, child) {
          return FutureBuilder<ContactModel?>(
            future: contactProvider.getContactById(contactId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text("Something went wrong"));
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text("Contact not found"));
              }

              final contact = snapshot.data!;

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Center(
                    child:
                        contact.image.isNotEmpty &&
                            File(contact.image).existsSync()
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(contact.image),
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          )
                        : CircleAvatar(
                            radius: 55,
                            child: Text(
                              contact.name.isNotEmpty ? contact.name[0] : '?',
                              style: const TextStyle(fontSize: 35),
                            ),
                          ),
                  ),

                  const SizedBox(height: 20),

                  ListTile(
                    title: const Text("Name"),
                    subtitle: Text(contact.name),
                  ),

                  ListTile(
                    title: const Text("Mobile"),
                    subtitle: Text(contact.mobile),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => makeCall(contact.mobile),
                          icon: const Icon(Icons.call, color: Colors.green),
                        ),
                        IconButton(
                          onPressed: () => sendSms(contact.mobile),
                          icon: const Icon(Icons.message, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),

                  ListTile(
                    title: const Text("Email"),
                    subtitle: Text(contact.email),
                  ),

                  ListTile(
                    title: const Text("Address"),
                    subtitle: Text(contact.address),
                  ),

                  ListTile(
                    title: const Text("Company"),
                    subtitle: Text(contact.company),
                  ),

                  ListTile(
                    title: const Text("Website"),
                    subtitle: Text(contact.website),
                  ),

                  ListTile(
                    title: const Text("Designation"),
                    subtitle: Text(contact.designation),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
