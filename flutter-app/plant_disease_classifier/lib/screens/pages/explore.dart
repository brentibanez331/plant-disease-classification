import 'package:flutter/material.dart';
import 'package:plant_disease_classifier/components/custom_navbar.dart';
import 'package:plant_disease_classifier/screens/pages/chatpage.dart';
import 'package:plant_disease_classifier/screens/pages/prediction.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Great you are now logged in."),
            const SizedBox(
              height: 20,
            ),
            OutlinedButton(
              onPressed: () {
                // AuthService.logout();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatPage()),
                );
              },
              child: const Text("Chat with AI"),
            ),
            OutlinedButton(
              onPressed: () {
                // AuthService.logout();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatPage()),
                );
              },
              child: const Text("Community"),
            ),
            OutlinedButton(
              onPressed: () {
                // AuthService.logout();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatPage()),
                );
              },
              child: const Text("Marketplace"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 1),
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
