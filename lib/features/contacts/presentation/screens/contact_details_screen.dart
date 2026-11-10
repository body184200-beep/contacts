import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/contact_avatar.dart';
import '../../../../domain/data/models/contact_model.dart';
import '../../../../domain/data/provider/contact_provider.dart';
import '../../logic/contact_details_controller.dart';

class ContactDetailsScreen extends StatefulWidget {
  final int contactId;

  const ContactDetailsScreen({super.key, required this.contactId});

  @override
  State<ContactDetailsScreen> createState() => _ContactDetailsScreenState();
}

class _ContactDetailsScreenState extends State<ContactDetailsScreen> {
  late final ContactDetailsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ContactDetailsController(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ContactProvider>(
        builder: (context, provider, child) {
          return FutureBuilder<ContactModel?>(
            future: _controller.getContact(widget.contactId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                return Scaffold(
                  appBar: AppBar(title: const Text('Contact Details')),
                  body: const Center(child: Text('Contact not found')),
                );
              }

              final contact = snapshot.data!;

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 220,
                    pinned: true,
                    foregroundColor: Appcolors.white,
                    backgroundColor: Appcolors.primary,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        tooltip: 'Edit Contact',
                        onPressed: () => _controller.editContact(contact),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'Delete Contact',
                        onPressed: () => _controller.deleteContact(contact),
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Appcolors.primaryDark, Appcolors.primaryLight],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 36),
                            ContactAvatar(
                              name: contact.name,
                              imagePath: contact.image,
                              radius: 46,
                              fontSize: 36,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              contact.name,
                              style: const TextStyle(
                                color: Appcolors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (contact.designation.isNotEmpty || contact.company.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                child: Text(
                                  [contact.designation, contact.company]
                                      .where((e) => e.isNotEmpty)
                                      .join(' • '),
                                  style: TextStyle(
                                    color: Appcolors.white.withValues(alpha: 0.9),
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Quick Action Buttons
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(
                            icon: Icons.phone_rounded,
                            label: 'Call',
                            color: Appcolors.success,
                            onTap: () => _controller.makeCall(contact.mobile),
                          ),
                          _buildActionButton(
                            icon: Icons.message_rounded,
                            label: 'SMS',
                            color: Appcolors.primary,
                            onTap: () => _controller.sendSms(contact.mobile),
                          ),
                          if (contact.email.isNotEmpty)
                            _buildActionButton(
                              icon: Icons.email_rounded,
                              label: 'Email',
                              color: Appcolors.warning,
                              onTap: () => _controller.sendEmail(contact.email),
                            ),
                          _buildActionButton(
                            icon: contact.isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            label: 'Favorite',
                            color: Appcolors.favorite,
                            onTap: () => _controller.toggleFavorite(contact),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Detail Items List
                  SliverList(
                    delegate: SliverChildListDelegate([
                      _buildInfoCard([
                        _buildInfoTile(
                          icon: Icons.phone_outlined,
                          title: 'Mobile',
                          value: contact.mobile,
                          onTap: () => _controller.makeCall(contact.mobile),
                        ),
                        if (contact.email.isNotEmpty) ...[
                          const Divider(height: 1),
                          _buildInfoTile(
                            icon: Icons.email_outlined,
                            title: 'Email',
                            value: contact.email,
                            onTap: () => _controller.sendEmail(contact.email),
                          ),
                        ],
                      ]),

                      if (contact.address.isNotEmpty ||
                          contact.company.isNotEmpty ||
                          contact.designation.isNotEmpty ||
                          contact.website.isNotEmpty)
                        _buildInfoCard([
                          if (contact.address.isNotEmpty)
                            _buildInfoTile(
                              icon: Icons.location_on_outlined,
                              title: 'Address',
                              value: contact.address,
                            ),
                          if (contact.company.isNotEmpty) ...[
                            const Divider(height: 1),
                            _buildInfoTile(
                              icon: Icons.business_outlined,
                              title: 'Company',
                              value: contact.company,
                            ),
                          ],
                          if (contact.designation.isNotEmpty) ...[
                            const Divider(height: 1),
                            _buildInfoTile(
                              icon: Icons.badge_outlined,
                              title: 'Designation',
                              value: contact.designation,
                            ),
                          ],
                          if (contact.website.isNotEmpty) ...[
                            const Divider(height: 1),
                            _buildInfoTile(
                              icon: Icons.language_outlined,
                              title: 'Website',
                              value: contact.website,
                              onTap: () => _controller.openWebsite(contact.website),
                            ),
                          ],
                        ]),
                      const SizedBox(height: 32),
                    ]),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Appcolors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Appcolors.border),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Appcolors.primarySoft,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Appcolors.primary, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 12, color: Appcolors.textSecondary),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Appcolors.textPrimary,
        ),
      ),
      trailing: onTap != null
          ? const Icon(Icons.arrow_forward_ios, size: 14, color: Appcolors.textMuted)
          : null,
      onTap: onTap,
    );
  }
}
