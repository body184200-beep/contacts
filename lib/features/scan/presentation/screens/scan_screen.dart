import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

import 'package:contacts/core/theme/colors.dart';
import '../../../../core/service/scan_service.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/hints.dart';
import '../../../../core/utils/scan_methods.dart';
import '../../../../domain/models/contact_model.dart';
import '../widgets/drop_target_item.dart';
import '../widgets/line_item.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool isScan = false;
  List<String> lines = [];

  String name = '';
  String address = '';
  String mobile = '';
  String email = '';
  String company = '';
  String designation = '';
  String website = '';
  String image = '';

  void creatContact() {
    final contact = ContactModel(
      name: name,
      mobile: mobile,
      email: email,
      address: address,
      company: company,
      website: website,
      designation: designation,
      image: image,
    );
    Navigator.pop(context, contact);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: image.isNotEmpty ? null : creatContact,
            icon: Icon(Icons.arrow_forward_sharp),
          ),
        ],
      ),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () {
                  getImage(imageSource: ImageSource.camera);
                },
                icon: Icon(Icons.camera_alt, color: Appcolors.blue),
                label: const Text("Camera"),
              ),
              TextButton.icon(
                onPressed: () {
                  getImage(imageSource: ImageSource.gallery);
                },
                icon: Icon(Icons.image, color: Appcolors.blue),
                label: const Text("Gallery"),
              ),
            ],
          ),

          if (isScan) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    DropTargetItem(
                      property: ContactProperties.name,
                      onDrop: (value, property) {
                        setState(() {
                          getProertyValue(value, property, (field, newValue) {
                            switch (field) {
                              case ContactProperties.name:
                                name = newValue;
                                break;
                              case ContactProperties.email:
                                email = newValue;
                                break;
                              case ContactProperties.mobile:
                                mobile = newValue;
                                break;
                              case ContactProperties.address:
                                address = newValue;
                                break;
                              case ContactProperties.website:
                                website = newValue;
                                break;
                              case ContactProperties.company:
                                company = newValue;
                                break;
                              case ContactProperties.designation:
                                designation = newValue;
                                break;
                            }
                          });
                        });
                      },
                    ),
                    DropTargetItem(
                      property: ContactProperties.mobile,
                      onDrop: (value, property) {},
                    ),
                    DropTargetItem(
                      property: ContactProperties.email,
                      onDrop: (value, property) {},
                    ),
                    DropTargetItem(
                      property: ContactProperties.address,
                      onDrop: (value, property) {},
                    ),
                    DropTargetItem(
                      property: ContactProperties.website,
                      onDrop: (value, property) {},
                    ),
                    DropTargetItem(
                      property: ContactProperties.company,
                      onDrop: (value, property) {},
                    ),
                    DropTargetItem(
                      property: ContactProperties.designation,
                      onDrop: (value, property) {},
                    ),
                  ],
                ),
              ),
            ),

            Padding(padding: const EdgeInsets.all(8), child: Text(Hints.hint)),

            Padding(
              padding: const EdgeInsets.all(8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: lines.map((line) {
                  return LineItem(line: line);
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> getImage({required ImageSource imageSource}) async {
    EasyLoading.show(status: "Loading...");

    try {
      final result = await ScanService().scanText(imageSource);

      if (!mounted) return;

      if (result != null) {
        setState(() {
          isScan = true;
          lines = result;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }
}
