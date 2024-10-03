import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:ocean_rescue/pages/welcome/splash_screen.dart';
import 'package:ocean_rescue/theme/colorTheme.dart';
import 'package:ocean_rescue/widget/navbar/BottomNavBar.dart';
import '../../widget/button/GradientButton.dart';
import '../../widget/welcome/custom_scaffold.dart';
import '../../resources/auth_methods.dart';
import '../../theme/theme.dart';
import 'signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String email = "", password = "", username = "";

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  final _formSignupKey = GlobalKey<FormState>();

  void registration() async {
    if (passwordController.text.isNotEmpty) {
      String res;
      try {
        res = await AuthMethods().registation(
          email: emailController.text,
          password: passwordController.text,
          username: usernameController.text,
        );

        if (res == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Registered Successfully",
              style: TextStyle(fontSize: 20),
            ),
          ));

          if (context.mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => SplashScreen(),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              res,
              style: const TextStyle(fontSize: 20),
            ),
          ));
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "The password provided is too weak.",
              style: TextStyle(fontSize: 20),
            ),
          ));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "The account already exists for that email.",
              style: TextStyle(fontSize: 20),
            ),
          ));
        } else if (e.code == 'invalid-email') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "The email address is badly formatted.",
              style: TextStyle(fontSize: 20),
            ),
          ));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "An unexpected error occurred: ${e.toString()}",
            style: const TextStyle(fontSize: 20),
          ),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex: 9,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignupKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo and "Sign Up" text
                      Image.asset(
                        'assets/logo/logo_without_name.png', // Provide the path of the logo image
                        height: 50,
                        width: 50,
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10.0),
// Username Text Field
                      SizedBox(
                        width: double.infinity,
                        height: 65,
                        child: TextFormField(
                          controller: usernameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a valid username';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text('Username'),
                            hintText: 'Enter Username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            // Adding style to the text field
                            hintStyle:
                                const TextStyle(fontSize: 14), // Hint text size
                            labelStyle:
                                const TextStyle(fontSize: 14), // Label text size
                          ),
                          style: const TextStyle(fontSize: 14), // Input text size
                        ),
                      ),
                      const SizedBox(height: 15.0),
// Email Text Field
                      SizedBox(
                        width: double.infinity,
                        height: 65,
                        child: TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Email';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text('Email'),
                            hintText: 'Enter Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            // Adding style to the text field
                            hintStyle:
                                const TextStyle(fontSize: 14), // Hint text size
                            labelStyle:
                                const TextStyle(fontSize: 14), // Label text size
                          ),
                          style: const TextStyle(fontSize: 14), // Input text size
                        ),
                      ),
                      const SizedBox(height: 15.0),
// Password Text Field
                      SizedBox(
                        width: double.infinity,
                        height: 65,
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          obscuringCharacter: '*',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Password';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text('Password'),
                            hintText: 'Enter Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            // Adding style to the text field
                            hintStyle:
                                const TextStyle(fontSize: 14), // Hint text size
                            labelStyle:
                                const TextStyle(fontSize: 14), // Label text size
                          ),
                          style: const TextStyle(fontSize: 14), // Input text size
                        ),
                      ),

                      const SizedBox(height: 15.0),
                      // Sign-up button
                      GradientButton(
                        text: 'Sign Up',
                        onTap: () {
                          if (_formSignupKey.currentState!.validate()) {
                            setState(() {
                              email = emailController.text;
                              password = passwordController.text;
                              username = usernameController.text;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Processing Data'),
                              ),
                            );

                            registration();
                          }
                        },
                        height: 50.0,
                        width: double.infinity,
                        textStyle: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      // Google Sign-in option
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 10,
                            ),
                            child: Text(
                              'Sign up with',
                              style: TextStyle(
                                color: ColorTheme.litegray,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton.icon(
                          icon: Logo(Logos.google),
                          onPressed: () {
                            // Implement Google sign-in functionality
                          },
                          label: const Text('Continue with Google'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: const BorderSide(
                              color: ColorTheme
                                  .liteGreen1, // Set your desired border color here
                              width: 2, // Set the width of the border
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15.0),
                      // Sign-in redirection
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 10,
                            ),
                            child: Text(
                              'Already have an account?',
                              style: TextStyle(
                                color: ColorTheme.litegray,
                                fontSize: 12, // Set the desired text size here
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15.0),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignInScreen(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                                color: Color(0xFF1D225C)), // Text color
                          ),
                        ),
                      ),
                      // const SizedBox(height: 40.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
