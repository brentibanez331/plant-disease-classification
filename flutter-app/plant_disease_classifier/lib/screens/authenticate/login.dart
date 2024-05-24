import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'dart:developer' as dev_log;
import 'package:plant_disease_classifier/screens/home/home.dart';
import 'package:plant_disease_classifier/services/auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  late AnimationController _controller_logo;
  late Animation<double> _animationLogoSize;
  late Animation<Offset> _animationLogoPosition;

  late AnimationController _controllerInput;
  late Animation<double> _animationContainerPosition;

  String phoneNumber = '';
  bool isValid = false;
  bool isRegistering = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

  final _phoneFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _controller_logo = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animationLogoSize =
        Tween<double>(begin: 1.0, end: 0.8).animate(_controller_logo);

    Future.delayed(Duration(seconds: 2), () {
      _controller_logo.forward();
      _controllerInput.forward();
    });

    _controllerInput =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationContainerPosition = Tween<double>(begin: -430.0, end: 0.0)
        .animate(
            CurvedAnimation(parent: _controllerInput, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    _animationLogoPosition = Tween<Offset>(
      begin: Offset.zero, // Start from the center
      end: Offset(
          0,
          -(MediaQuery.of(context).size.height /
              3.5)), // Move up by 40% of the screen height
    ).animate(
      CurvedAnimation(parent: _controller_logo, curve: Curves.easeInOut),
    );

    return Scaffold(
      body: GestureDetector(
          onTap: () {
            _phoneFieldFocusNode.unfocus();
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              Image.asset(
                'images/bg-splash.png', // Replace with your image path
                fit: BoxFit.cover,
              ),
              // Animated Logo in the Center
              Center(
                child: AnimatedBuilder(
                  animation: _controller_logo,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: _animationLogoPosition.value,
                      child: Transform.scale(
                        scale: _animationLogoSize.value,
                        child: child,
                      ),
                    );
                  },
                  child: Image.asset(
                    'images/greenery-logo.png',
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
              AnimatedBuilder(
                  animation: _controllerInput,
                  builder: (context, child) {
                    return Positioned(
                      bottom: _animationContainerPosition
                          .value, // Place it at the bottom
                      left: 0, // Stretch it across the entire width
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 430,
                          padding: const EdgeInsets.only(
                              top: 50, left: 30, right: 30),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(50.0))),
                          child: Column(
                            children: [
                              const Text("Welcome Back!",
                                  style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w600)),
                              const Text(
                                  "Enter your phone number to get started",
                                  style: TextStyle(fontSize: 16)),
                              const SizedBox(height: 50),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Stack(
                                        children: [
                                          IntlPhoneField(
                                            focusNode: _phoneFieldFocusNode,
                                            dropdownTextStyle:
                                                const TextStyle(fontSize: 16),
                                            decoration: InputDecoration(
                                              labelText: 'Phone Number',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(),
                                              ),
                                              counterText: '',
                                            ),
                                            style:
                                                const TextStyle(fontSize: 17),
                                            initialCountryCode: 'PH',
                                            onChanged: (phone) {
                                              try {
                                                isValid = phone.isValidNumber();
                                                phoneNumber =
                                                    phone.completeNumber;
                                              } catch (e) {
                                                if (e
                                                    is NumberTooShortException) {
                                                  isValid = false;
                                                  phoneNumber = '';
                                                }
                                              }
                                              dev_log.log(phoneNumber);
                                            },
                                            onCountryChanged: (country) {
                                              dev_log.log(
                                                  'Country changed to: ${country.code}');
                                            },
                                            cursorColor: Colors.black,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 70),
                              // You need to wrap this with Positioned
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 90,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (isValid) {
                                      AuthService.sentOTP(
                                          phone: phoneNumber,
                                          errorStep: () => ScaffoldMessenger.of(
                                                  context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "Error in sending OTP"))),
                                          nextStep: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                        title: const Text(
                                                            "Enter your OTP"),
                                                        content: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Text(
                                                                "Enter 6-digit OTP"),
                                                            const SizedBox(
                                                                height: 12),
                                                            Form(
                                                              key: _formKey,
                                                              child:
                                                                  TextFormField(
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                controller:
                                                                    _otpController,
                                                                decoration:
                                                                    const InputDecoration(),
                                                                validator:
                                                                    (value) {
                                                                  if (value!
                                                                          .length !=
                                                                      6) {
                                                                    return "Invalid OTP";
                                                                  }
                                                                  return null;
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                              onPressed: () {
                                                                if (_formKey
                                                                    .currentState!
                                                                    .validate()) {
                                                                  AuthService.loginWithOTP(
                                                                          otp: _otpController
                                                                              .text)
                                                                      .then(
                                                                          (value) {
                                                                    if (value ==
                                                                        "Success") {
                                                                      Navigator.pop(
                                                                          context);
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => const HomePage()));
                                                                    } else {
                                                                      Navigator.pop(
                                                                          context);
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(SnackBar(
                                                                              content: Text(
                                                                        value,
                                                                      )));
                                                                    }
                                                                  });
                                                                }
                                                              },
                                                              child: const Text(
                                                                  "Submit")),
                                                        ]));
                                          });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromARGB(255, 47, 142, 0),
                                      foregroundColor: Colors.white,
                                      fixedSize: Size(120, 50),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15))),
                                  child: const Text("Verify OTP"),
                                ),
                              ),
                              Center(
                                  child: Container(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("Already have an account?")
                                        ],
                                      ))),
                            ],
                          )),
                    );
                  })
            ],
          )),
    );
  }
}
