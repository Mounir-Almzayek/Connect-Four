import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'HomePage.dart';
import 'SignInPage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailFormKey = GlobalKey<FormState>();
  final _nameFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _passwordsMatch = true;

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
                            'Sign Up',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              fontSize: 26,
                              color: Color(0xFF000000),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Join us today and unlock the full potential of our app!',
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
                          const TextSpan(text: 'If you already have an account, you can '),
                          TextSpan(
                            text: 'Login here!',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xFF4D47C3),
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInPage()),);
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
                  NameForm(
                    formKey: _nameFormKey,
                    controller: _usernameController,
                    onChanged: (value) {
                      setState(() {
                        _nameFormKey.currentState?.validate();
                      });
                    },
                  ),
                  PasswordForm(
                    formKey: _passwordFormKey,
                    passwordController: _passwordController,
                    confirmPasswordController: _confirmPasswordController,
                    isPasswordVisible: _isPasswordVisible,
                    onPasswordVisibilityChanged: (isVisible) {
                      setState(() {
                        _isPasswordVisible = isVisible;
                      });
                    },
                    onPasswordsMatchChanged: (match) {
                      setState(() {
                        _passwordsMatch = match;
                        _passwordFormKey.currentState?.validate();
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
                    createUserWithEmailAndPassword();
                  },
                  style: TextButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    padding: EdgeInsets.symmetric(vertical: 17),
                  ),
                  child: const Text(
                    'Register',
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

  void createUserWithEmailAndPassword() async {
    final emailFormValid = _emailFormKey.currentState?.validate() ?? false;
    final nameFormValid = _nameFormKey.currentState?.validate() ?? false;
    final passwordFormValid = _passwordFormKey.currentState?.validate() ?? false;

    if (emailFormValid && nameFormValid && passwordFormValid) {

      try {
        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();
        final username = _usernameController.text.trim();

        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final user = FirebaseAuth.instance.currentUser;
        final uid = user?.uid;

        if (uid != null) {
          DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(uid);

          await userDoc.set({
            'username': username,
            'email': email,
            'winsCount': 0,
          });

        }
        await user?.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An email has been sent to you. check your inbox.')),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInPage()));

      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'weak-password') {
          errorMessage = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'The account already exists for that email.';
        } else {
          errorMessage = 'An error occurred. Please try again.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
    } else {
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

class NameForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final Function(String?) onChanged;

  NameForm({
    required this.formKey,
    required this.controller,
    required this.onChanged,
  });

  @override
  _NameFormState createState() => _NameFormState();
}

class _NameFormState extends State<NameForm> {
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
            labelText: 'Your Name',
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
              return 'Please enter Your Name';
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
  final TextEditingController confirmPasswordController;
  final bool isPasswordVisible;
  final Function(bool) onPasswordVisibilityChanged;
  final Function(bool) onPasswordsMatchChanged;
  final Function(String?) onChanged;

  PasswordForm({
    required this.formKey,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isPasswordVisible,
    required this.onPasswordVisibilityChanged,
    required this.onPasswordsMatchChanged,
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
      child: Column(
        children: [
          Container(
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
          Container(
            margin: EdgeInsets.only(bottom: 25),
            decoration: BoxDecoration(
              color: Color(0xFFF0EFFF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextFormField(
              controller: widget.confirmPasswordController,
              obscureText: !widget.isPasswordVisible,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 22.2),
                labelText: 'Confirm Password',
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
                  return 'Please confirm your password';
                }
                if (value != widget.passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
              onChanged: (value) {
                widget.onPasswordsMatchChanged(value == widget.passwordController.text);
                widget.onChanged(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
