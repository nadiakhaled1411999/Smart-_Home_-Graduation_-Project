import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:untitled7/core/cubit/auth_cubit.dart';
import 'package:untitled7/core/cubit/auth_state.dart';
import 'package:untitled7/core/cubit/project_cubit.dart';
import 'package:untitled7/core/cubit/project_state.dart';
import 'package:untitled7/view/homescreen.dart';
import 'package:untitled7/view/forgot_password_screen.dart';
import 'package:untitled7/view/signup_screen.dart';
import 'package:untitled7/view/verify_email_screen.dart';

import '../core/util/strings.dart';
import '../core/widgets/error_popup.dart';
import 'or_divider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool isPasswordValid = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          // Show loading indicator
          showDialog(
            context: context,
            barrierDismissible: false, // Prevent dismiss by tapping outside
            builder: (context) => const SizedBox(
                height: 50,
                width: 50,
                child: Center(
                    child: CircularProgressIndicator(
                  color: Colors.blue,
                ))),
          );
        } else if (state is AuthAuthenticated) {
          // Navigate to authenticated screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(token: token),
            ),
          );
        } else if (state is AuthError) {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => ErrorPopup(
              errorMessage: state.message,
              onClose: () {
                Navigator.of(context).pop(); // Close the error popup
              },
            ),
          );
        }
      },
      builder: (context, state) {
        return BlocConsumer<ProjectCubit, ProjectState>(
          listener: (context, state) {
            if (state is ProjectLoading) {
              // Show loading indicator
              showDialog(
                context: context,
                barrierDismissible: false, // Prevent dismiss by tapping outside
                builder: (context) => const SizedBox(
                    height: 50,
                    width: 50,
                    child: Center(child: CircularProgressIndicator())),
              );
            } else if (state is ProjectLoaded) {
              // Navigate to authenticated screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(token: token),
                ),
              );
            } else if (state is ProjectError) {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) => ErrorPopup(
                  errorMessage: state.message,
                  onClose: () {
                    Navigator.of(context).pop(); // Close the error popup
                  },
                ),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              body: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Image.asset(
                            'assets/images/Mobile login-pana.png',
                            width: 290,
                            height: 300,
                            // fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 0.1,
                      ),
                      GradientText(
                        "Login To\nYour Account",
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                        colors: const [
                          Color(0xFF5672ED),
                          Color(0xFF407BFF),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 280,
                        height: 50,
                        child: Center(
                          child: TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.email,
                                color: Color(0xff898888),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Color(0xff3230C1),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Color(0xff3230C1),
                                ),
                              ),
                              labelText: "Email",
                              labelStyle: const TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),
                              hintStyle: const TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: 280,
                        height: 50,
                        child: Center(
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Color(0xff898888),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: isPasswordValid
                                      ? const Color(0xff3230C1)
                                      : Colors.red,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: isPasswordValid
                                      ? const Color(0xff3230C1)
                                      : Colors.red,
                                ),
                              ),
                              labelText: "Password",
                              labelStyle: const TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),
                              hintStyle: const TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: const Color(0xff898888),
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (!isPasswordValid)
                        const Padding(
                          padding: EdgeInsets.only(left: 60.0, top: 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Min 8, max 20 characters required for password',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(left: 120, top: 5),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPasswordScreen()));
                          },
                          child: GradientText(
                            "Forgot your password?",
                            style: const TextStyle(
                              fontSize: 15,
                              // fontWeight: FontWeight.w700,
                            ),
                            colors: const [
                              Color(0xFF5E7CFF),
                              Color(0xFF125BFA),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isPasswordValid =
                                passwordController.text.length >= 8 &&
                                    passwordController.text.length <= 20;
                          });
                          if (isPasswordValid) {
                            AuthCubit.get(context).signIn(
                                emailController.text, passwordController.text);
                            ProjectCubit.get(context).getData();
                          }
                        },
                        child: Container(
                          height: 60,
                          width: 260,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: const LinearGradient(colors: [
                                Color(0xFF5E7CFF),
                                Color(0xFF125BFA),
                              ])),
                          child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Sign In",
                                  style: TextStyle(
                                      color: Color(0xffE5E5E5),
                                      fontSize: 25,
                                      fontWeight: FontWeight.w800),
                                ),
                                // SizedBox(
                                //   width: 20,
                                // ),
                                // Image.asset(
                                //   'assets/Icons/n.jpg',
                                //   height: 25,
                                //   width: 25,
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      // const OrDivider(),
                      // const SizedBox(
                      //   height: 15,
                      // ),
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) => VerifyEmailScreen(
                      //               email: 'ahmedee@gmail.com'),
                      //         ));
                      //   },
                      //   child: Container(
                      //     height: 50,
                      //     width: 260,
                      //     decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.circular(50),
                      //       border: Border.all(
                      //         color:
                      //             const Color(0xFF125BFA), // Blue border color
                      //         width: 1,
                      //       ),
                      //     ),
                      //     child: Center(
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Image.asset(
                      //             'assets/images/google-color-icon.png',
                      //             height: 25,
                      //             width: 25,
                      //           ),
                      //           const SizedBox(
                      //             width: 6,
                      //           ),
                      //           const Text(
                      //             "Continue with Google",
                      //             style: TextStyle(
                      //               color: Color(0xFF125BFA), // Blue text color
                      //               fontSize: 20,
                      //               fontWeight: FontWeight.w800,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 15,
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignupScreen(),
                                    ));
                              },
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Color(0xFF125BFA),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
