import 'package:flutter/material.dart';
import 'package:plant_disease_classifier/screens/authenticate/authenticate.dart';
import 'package:plant_disease_classifier/screens/home/home.dart';
import 'package:plant_disease_classifier/screens/splash/splash.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // return either Home or Authenticate widget
    return const Splash();
  }
}
