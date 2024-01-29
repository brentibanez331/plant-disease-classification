import 'package:flutter/material.dart';
import 'package:plant_disease_classifier/screens/home/home.dart';
import 'package:plant_disease_classifier/screens/pages/explore.dart';
import 'package:plant_disease_classifier/screens/pages/profile.dart';
import 'package:plant_disease_classifier/screens/pages/stats.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key, required this.currentIndex});
  final int currentIndex;
  // final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(40, 68, 241, 166)
                .withOpacity(0.5), // shadow color
            spreadRadius: 2, // spread radius
            blurRadius: 5, // blur radius
            offset: Offset(0, 2),
          )
        ]),
        child: BottomAppBar(
            color: Colors.white,
            // shape: CircularNotchedRectangle(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () {
                      if (currentIndex == 0) {
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      }
                    },
                    icon: Transform.scale(
                        scale: 1.2,
                        child: Image(
                            image: currentIndex == 0
                                ? AssetImage('assets/nav/home-active.png')
                                : AssetImage('assets/nav/home-inactive.png')))),
                IconButton(
                    onPressed: () {
                      if (currentIndex == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ExplorePage()),
                        );
                      } else if (currentIndex == 1) {
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ExplorePage()),
                        );
                      }
                    },
                    icon: Transform.scale(
                        scale: 1.2,
                        child: Image(
                            image: currentIndex == 1
                                ? AssetImage('assets/nav/explore-active.png')
                                : AssetImage(
                                    'assets/nav/explore-inactive.png')))),
                SizedBox(width: 30),
                IconButton(
                    onPressed: () {
                      if (currentIndex == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StatsPage()),
                        );
                      } else if (currentIndex == 4) {
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StatsPage()),
                        );
                      }
                    },
                    icon: Transform.scale(
                        scale: 1.2,
                        child: Image(
                            image: currentIndex == 4
                                ? AssetImage('assets/nav/stats-active.png')
                                : AssetImage(
                                    'assets/nav/stats-inactive.png')))),
                IconButton(
                    onPressed: () {
                      if (currentIndex == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfilePage()),
                        );
                      } else if (currentIndex == 5) {
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfilePage()),
                        );
                      }
                    },
                    icon: Transform.scale(
                        scale: 1.2,
                        child: Image(
                            image: currentIndex == 5
                                ? AssetImage('assets/nav/profile-active.png')
                                : AssetImage(
                                    'assets/nav/profile-inactive.png')))),
              ],
            )));
  }
}
