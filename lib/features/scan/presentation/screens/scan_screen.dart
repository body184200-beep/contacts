import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/hints.dart';
import '../../logic/scan_controller.dart';
import '../widgets/drop_target_item.dart';
import '../widgets/line_item.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  late final ScanController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScanController(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Card'),
        actions: [
          if (_controller.isScan)
            TextButton.icon(
              onPressed: _controller.proceedToForm,
              icon: const Icon(Icons.arrow_forward, color: Appcolors.white, size: 18),
              label: const Text(
                'Next',
                style: TextStyle(
                  color: Appcolors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Source Buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Appcolors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Appcolors.border),
            ),
            child: Column(
              children: [
                if (_controller.imagePath.isNotEmpty &&
                    File(_controller.imagePath).existsSync()) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(_controller.imagePath),
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _controller.pickAndScan(
                          ImageSource.camera,
                          () => setState(() {}),
                        ),
                        icon: const Icon(Icons.camera_alt_outlined),
                        label: const Text('Camera'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Appcolors.primary,
                          foregroundColor: Appcolors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _controller.pickAndScan(
                          ImageSource.gallery,
                          () => setState(() {}),
                        ),
                        icon: const Icon(Icons.photo_library_outlined),
                        label: const Text('Gallery'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Appcolors.primary,
                          side: const BorderSide(color: Appcolors.primary),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (_controller.isScan) ...[
            const SizedBox(height: 20),
            // Targets
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Appcolors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Appcolors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Assign Fields',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Appcolors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...[
                    ContactProperties.name,
                    ContactProperties.mobile,
                    ContactProperties.email,
                    ContactProperties.address,
                    ContactProperties.website,
                    ContactProperties.company,
                    ContactProperties.designation,
                  ].map(
                    (prop) => DropTargetItem(
                      property: prop,
                      currentValue: _controller.properties[prop] ?? '',
                      onDrop: (val) => _controller.assignProperty(
                        prop,
                        val,
                        () => setState(() {}),
                      ),
                      onClear: () => _controller.clearProperty(
                        prop,
                        () => setState(() {}),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            // Drag Hint
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Appcolors.primarySoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Appcolors.primary, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      Hints.hint,
                      style: TextStyle(
                        fontSize: 12,
                        color: Appcolors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            // Scanned Chips
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Appcolors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Appcolors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Extracted Text Elements',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Appcolors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _controller.lines.map((line) {
                      return LineItem(line: line);
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _controller.proceedToForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Appcolors.primary,
                foregroundColor: Appcolors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Continue to Form',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }
}
