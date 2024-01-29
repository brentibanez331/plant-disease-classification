import 'package:flutter/material.dart';
import 'package:plant_disease_classifier/components/custom_navbar.dart';
import 'package:plant_disease_classifier/screens/authenticate/login.dart';
import 'package:plant_disease_classifier/screens/pages/prediction.dart';
import 'package:plant_disease_classifier/services/auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // final List<Widget> _pages = [

    //   const Prediction(),
    //   const Prediction(),
    //   const Prediction(),
    //   const Prediction(),
    // ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Homepage"),
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
                AuthService.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 0),
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

class CustomMiddleItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ImageIcon(
          AssetImage('assets/nav/scan-default.png'),
          size: 50, // Adjust size as needed
        ),
        Container(
          height: 20, // Adjust height for overlap effect
          color: Colors.transparent,
        ),
      ],
    );
  }
}
