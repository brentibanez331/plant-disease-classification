// import "package:flutter/material.dart";
// import "package:plant_disease_classifier/services/auth.dart";

// class SignIn extends StatefulWidget {
//   const SignIn({super.key});

//   @override
//   State<SignIn> createState() => _SignInState();
// }

// class _SignInState extends State<SignIn> {
//   final AuthService _auth = AuthService();
//   final TextEditingController _phoneNumberController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//       appBar: AppBar(
//         backgroundColor: Colors.brown,
//         elevation: 0.0,
//         title: const Text('Sign in to AgriAid'),
//       ),
//       body: Container(
//         padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
//         child: Column(
//           children: [
//             TextFormField(
//               controller: _phoneNumberController,
//               decoration: const InputDecoration(
//                 prefixText: "+63",
//                 labelText: 'Phone Number',
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.phone,
//             ),
//             const SizedBox(height: 20), // Add spacing between fields
//             ElevatedButton(
//               child: const Text('Send OTP'),
//               onPressed: () async {
//                 String phoneNumber = _phoneNumberController.text;
//                 String verificationId = await _auth.signInMobile(phoneNumber);
//                 if (verificationId != '') { 
//                   _auth.verifyOTP(verificationId);
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
