import 'package:contacts/core/theme/colors.dart';
import 'package:contacts/features/scan/presentation/screens/scan_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/bottom_navigation_bar.dart';
import '../widgets/fliatong_action_bottoms.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
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
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
      body: Center(child: Text("data")),
    );
  }
}
