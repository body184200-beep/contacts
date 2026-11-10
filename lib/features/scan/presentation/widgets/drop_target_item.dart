import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/constants.dart';

class DropTargetItem extends StatelessWidget {
  final String property;
  final String currentValue;
  final Function(String) onDrop;
  final VoidCallback onClear;

  const DropTargetItem({
    super.key,
    required this.property,
    required this.currentValue,
    required this.onDrop,
    required this.onClear,
  });

  IconData _getIconForProperty(String prop) {
    switch (prop) {
      case ContactProperties.name:
        return Icons.person_outline;
      case ContactProperties.mobile:
        return Icons.phone_outlined;
      case ContactProperties.email:
        return Icons.email_outlined;
      case ContactProperties.address:
        return Icons.location_on_outlined;
      case ContactProperties.website:
        return Icons.language_outlined;
      case ContactProperties.company:
        return Icons.business_outlined;
      case ContactProperties.designation:
        return Icons.badge_outlined;
      default:
        return Icons.text_fields_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasValue = currentValue.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Row(
              children: [
                Icon(
                  _getIconForProperty(property),
                  size: 18,
                  color: hasValue ? Appcolors.primary : Appcolors.textSecondary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    property[0].toUpperCase() + property.substring(1),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: hasValue ? FontWeight.bold : FontWeight.w500,
                      color: hasValue ? Appcolors.primary : Appcolors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: DragTarget<String>(
              onAcceptWithDetails: (details) {
                onDrop(details.data);
              },
              builder: (context, candidateData, rejectedData) {
                final bool isHovered = candidateData.isNotEmpty;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: isHovered
                        ? Appcolors.primarySoft
                        : (hasValue ? Appcolors.white : Appcolors.background),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isHovered
                          ? Appcolors.primary
                          : (hasValue ? Appcolors.primaryLight : Appcolors.border),
                      width: isHovered || hasValue ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          hasValue ? currentValue : 'Drop text here',
                          style: TextStyle(
                            fontSize: 13,
                            color: hasValue
                                ? Appcolors.textPrimary
                                : Appcolors.textMuted,
                            fontWeight:
                                hasValue ? FontWeight.w500 : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasValue)
                        InkWell(
                          onTap: onClear,
                          borderRadius: BorderRadius.circular(12),
                          child: const Padding(
                            padding: EdgeInsets.all(2),
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: Appcolors.textMuted,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
