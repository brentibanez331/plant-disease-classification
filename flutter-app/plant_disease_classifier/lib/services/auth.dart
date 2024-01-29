import "package:firebase_auth/firebase_auth.dart";

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static String verifyID = "";
  static Future sentOTP({
    required String phone,
    required Function errorStep,
    required Function nextStep,
  }) async {
    await _auth
        .verifyPhoneNumber(
      timeout: const Duration(seconds: 30),
      phoneNumber: phone,
      verificationCompleted: (phoneAuthCredential) async {
        return;
      },
      verificationFailed: (error) async {
        return;
      },
      codeSent: (verificationId, forceResendingToken) async {
        verifyID = verificationId;
        nextStep();
      },
      codeAutoRetrievalTimeout: (verificationId) async {
        return;
      },
    )
        .onError((error, stackTrace) {
      errorStep();
    });
  }

  static Future loginWithOTP({required String otp}) async {
    final cred =
        PhoneAuthProvider.credential(verificationId: verifyID, smsCode: otp);
    try {
      final user = await _auth.signInWithCredential(cred);
      if (user.user != null) {
        return "Success";
      } else {
        return "Error in OTP";
      }
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  static Future logout() async {
    await _auth.signOut();
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    var user = _auth.currentUser;
    return user != null;
  }

  static Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }
}
