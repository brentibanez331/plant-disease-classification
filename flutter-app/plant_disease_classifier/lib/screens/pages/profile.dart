import 'package:flutter/material.dart';
import 'package:plant_disease_classifier/components/custom_navbar.dart';
import 'package:plant_disease_classifier/screens/pages/prediction.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Homepage"),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 5),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(220, 68, 241, 166),
                  offset: Offset(0, 22),
                  blurRadius: 50)
            ],
            color: Color.fromARGB(255, 68, 241, 166),
          ),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Prediction()),
              );
            },
            child: ImageIcon(AssetImage('assets/nav/scan-default.png'),
                size: 35, color: Colors.white),
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(50), // Adjust the radius as needed
            ),
          )),
    );
  }
}
