import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/hints.dart';

class TextFormFieldController extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final bool isRequired;
  final IconData? prefixIcon;
  final String? Function(String?)? customValidator;

  const TextFormFieldController({
    super.key,
    required this.controller,
    required this.label,
    required this.keyboardType,
    this.isRequired = false,
    this.prefixIcon,
    this.customValidator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: customValidator ??
          (value) {
            if (isRequired && (value == null || value.trim().isEmpty)) {
              return Hints.emptyError;
            }
            return null;
          },
      decoration: InputDecoration(
        labelText: isRequired ? '$label *' : label,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: Appcolors.textSecondary, size: 20)
            : null,
      ),
    );
  }
}
