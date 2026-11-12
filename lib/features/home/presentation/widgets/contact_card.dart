import 'package:flutter/material.dart';

import '../../../../core/custom_dialog/confirm_dismiss.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/contact_avatar.dart';
import '../../../../domain/data/models/contact_model.dart';

class ContactCard extends StatelessWidget {
  final ContactModel contact;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;
  final VoidCallback onDismissed;

  const ContactCard({
    super.key,
    required this.contact,
    required this.onTap,
    required this.onToggleFavorite,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Dismissible(
        key: Key('contact_${contact.id}'),
        direction: DismissDirection.endToStart,
        background: Container(
          decoration: BoxDecoration(
            color: Appcolors.error,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.delete_outline, color: Appcolors.white, size: 28),
              SizedBox(width: 8),
              Text(
                'Delete',
                style: TextStyle(
                  color: Appcolors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        confirmDismiss: (direction) async {
          return await showDialog<bool>(
            context: context,
            builder: (context) => const ConfirmDismiss(),
          );
        },
        onDismissed: (direction) => onDismissed(),
        child: Material(
          color: Appcolors.card,
          borderRadius: BorderRadius.circular(16),
          elevation: 0.5,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Appcolors.border),
              ),
              child: Row(
                children: [
                  ContactAvatar(
                    name: contact.name,
                    imagePath: contact.image,
                    radius: 26,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contact.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Appcolors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.phone_outlined,
                              size: 14,
                              color: Appcolors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              contact.mobile,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Appcolors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        if (contact.company.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(
                                Icons.business_outlined,
                                size: 14,
                                color: Appcolors.textMuted,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  contact.company,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Appcolors.textMuted,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onToggleFavorite,
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, anim) =>
                          ScaleTransition(scale: anim, child: child),
                      child: Icon(
                        contact.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        key: ValueKey(contact.isFavorite),
                        color: contact.isFavorite
                            ? Appcolors.favorite
                            : Appcolors.textMuted,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
