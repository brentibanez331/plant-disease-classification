import 'package:flutter/material.dart';
import 'package:plant_disease_classifier/screens/authenticate/login.dart';
import 'package:plant_disease_classifier/screens/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return const Login();
  }
}
