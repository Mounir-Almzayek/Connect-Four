import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectfour/presentation/HomePage.dart';
import 'package:connectfour/routes/AppRoutes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'SignUpPage.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(30, 60, 30, 20),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 52),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 32),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sign In',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                              color: Color(0xFF000000),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Experience the best our app has to offer!',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ],
                      ),
                    ),

                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xFF000000),
                        ),
                        children: [
                          const TextSpan(text: 'If you don’t have an account register you can '),
                          TextSpan(
                            text: 'Register here!',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xFF4D47C3),
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpPage()),);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  EmailForm(
                    formKey: _emailFormKey,
                    controller: _emailController,
                    onChanged: (value) {
                      setState(() {
                        _emailFormKey.currentState?.validate();
                      });
                    },
                  ),
                  PasswordForm(
                    formKey: _passwordFormKey,
                    passwordController: _passwordController,
                    isPasswordVisible: _isPasswordVisible,
                    onPasswordVisibilityChanged: (isVisible) {
                      setState(() {
                        _isPasswordVisible = isVisible;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        _passwordFormKey.currentState?.validate();
                      });
                    },
                  ),
                ],
              ),
              Container(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                      onTap: (){
                        resetPassword();
                      },
                      child: const Text(
                        'Forgort password ?',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                          color: Color(0xFFB0B0B0),
                        ),
                      )
                  )
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: const Color(0xFF4D47C3),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x664D47C3),
                      offset: Offset(0, 4),
                      blurRadius: 30.5,
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () {
                    signInWithEmailAndPassword();
                  },
                  style: TextButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    padding: EdgeInsets.symmetric(vertical: 17),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 27),
                child: const Center(
                  child: Text(
                    'or',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFFB5B5B5),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFFFFFFF),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x2B000000),
                      offset: Offset(0, 2),
                      blurRadius: 1.5,
                    ),
                    BoxShadow(
                      color: Color(0x15000000),
                      offset: Offset(0, 0),
                      blurRadius: 1.5,
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () {
                    signInWithGoogle();
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 23,
                        height: 23,
                        child: SvgPicture.asset(
                          'assets/svgs/logo_google.svg',
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Text(
                        'Continue with Google',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color(0x8A000000),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField(String labelText,
      {bool isPassword = false, required TextEditingController controller}) {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        color: Color(0xFFF0EFFF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && !_isPasswordVisible,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $labelText';
          }
          return null;
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 22.2),
          labelText: labelText,
          labelStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            fontSize: 15,
            color: Color(0xFFA7A3FF),
          ),
          border: InputBorder.none,
          suffixIcon: isPassword
              ? IconButton(
                  icon: SvgPicture.asset(
                    _isPasswordVisible
                        ? 'assets/svgs/eye_open.svg'
                        : 'assets/svgs/eye_closed.svg',
                    width: 20,
                    height: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }

  void signInWithEmailAndPassword() async {
    final emailFormValid = _emailFormKey.currentState?.validate() ?? false;
    final passwordFormValid = _passwordFormKey.currentState?.validate() ?? false;

    if (emailFormValid && passwordFormValid) {
      try {
        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();

        // Show a loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signing in...')),
        );

        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password
        );

        if (credential.user != null && !credential.user!.emailVerified) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please verify your email address.')),
          );
          await FirebaseAuth.instance.signOut();
          return;
        }

        Navigator.pushReplacementNamed(context, AppRoutes.homePage);

      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password provided for that user.';
        } else {
          errorMessage = 'An error occurred. Please try again.';
        }
        // Show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        // Show a generic error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
    }else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please correct the errors in the form.')),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      // Show a loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signing in with Google...')),
      );

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // Handle the case where the user cancels the sign-in process
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google sign-in was cancelled.')),
        );
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final uid = user.uid;
        final email = user.email;
        final displayName = user.displayName ?? "No Name";

        DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(uid);

        DocumentSnapshot docSnapshot = await userDoc.get();

        if (!docSnapshot.exists) {
          await userDoc.set({
            'username': displayName,
            'email': email,
            'winsCount': 0,
          });
        }

        // Navigate to the HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }


  void resetPassword() async{
    final email = _emailController.text.trim();
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    }on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(
              'The email address you are trying to reset the password for does not exist.')),
        );
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('An email has been sent to your account to reset your password.')),
    );
  }
}

class EmailForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final Function(String?) onChanged;

  EmailForm({
    required this.formKey,
    required this.controller,
    required this.onChanged,
  });

  @override
  _EmailFormState createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Container(
        margin: EdgeInsets.only(bottom: 25),
        decoration: BoxDecoration(
          color: Color(0xFFF0EFFF),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 22.2),
            labelText: 'Your Email',
            labelStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: Color(0xFFA7A3FF),
            ),
            border: InputBorder.none,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Your Email';
            }
            return null;
          },
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}

class PasswordForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController passwordController;
  final bool isPasswordVisible;
  final Function(bool) onPasswordVisibilityChanged;
  final Function(String?) onChanged;

  PasswordForm({
    required this.formKey,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.onPasswordVisibilityChanged,
    required this.onChanged,
  });

  @override
  _PasswordFormState createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Container(
        margin: EdgeInsets.only(bottom: 25),
        decoration: BoxDecoration(
          color: Color(0xFFF0EFFF),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextFormField(
          controller: widget.passwordController,
          obscureText: !widget.isPasswordVisible,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 22.2),
            labelText: 'Password',
            labelStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: Color(0xFFA7A3FF),
            ),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: SvgPicture.asset(
                widget.isPasswordVisible
                    ? 'assets/svgs/eye_open.svg'
                    : 'assets/svgs/eye_closed.svg',
                width: 20,
                height: 20,
              ),
              onPressed: () {
                widget.onPasswordVisibilityChanged(!widget.isPasswordVisible);
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Password';
            }
            return null;
          },
          onChanged: (value) {
            widget.onChanged(value);
          },
        ),
      ),
    );
  }
}
