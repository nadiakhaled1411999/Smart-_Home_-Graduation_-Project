import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:untitled7/core/cubit/auth_cubit.dart';
import 'package:untitled7/core/cubit/auth_state.dart';
import 'package:untitled7/view/login_screen.dart';
import 'package:untitled7/view/verify_email_screen.dart';
import '../core/widgets/error_popup.dart';
import 'or_divider.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;
  bool isPasswordMatch = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
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
              builder: (context) => VerifyEmailScreen(
                email: emailController.text,
              ),
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
        return Scaffold(
          body: Container(
            height: double.infinity,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Image.asset(
                      'assets/images/Mobile login-bro.png',
                      // fit: BoxFit.fill,
                      height: 280,
                      width: 270,
                    ),
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  GradientText(
                    "Create\nYour Account",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                    colors: const [
                      Color(0xFF5672ED),
                      Color(0xFF407BFF),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 280,
                    height: 50,
                    child: Center(
                      child: TextFormField(
                        controller: userNameController,
                        decoration: InputDecoration(
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
                          label: const Text(
                            "User Name",
                            style: TextStyle(
                                color: Color(0xff000000),
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                          ),
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Color(0xff898888),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 280,
                    height: 50,
                    child: Center(
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
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
                          label: const Text(
                            "Email",
                            style: TextStyle(
                                color: Color(0xff000000),
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                          ),
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Color(0xff898888),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 280,
                    height: 50,
                    child: Center(
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: isPasswordHidden,
                        decoration: InputDecoration(
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
                          label: const Text(
                            "Password",
                            style: TextStyle(
                                color: Color(0xff000000),
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: const Color(0xff898888),
                            ),
                            onPressed: () {
                              setState(() {
                                isPasswordHidden = !isPasswordHidden;
                              });
                            },
                          ),
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Color(0xff898888),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 280,
                    height: 50,
                    child: Center(
                      child: TextFormField(
                        controller: confirmPasswordController,
                        obscureText: isConfirmPasswordHidden,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 1,
                              color: isPasswordMatch
                                  ? const Color(0xff3230C1)
                                  : Colors.red,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 1,
                              color: isPasswordMatch
                                  ? const Color(0xff3230C1)
                                  : Colors.red,
                            ),
                          ),
                          label: const Text(
                            "Confirm Password",
                            style: TextStyle(
                                color: Color(0xff000000),
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isConfirmPasswordHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: const Color(0xff898888),
                            ),
                            onPressed: () {
                              setState(() {
                                isConfirmPasswordHidden =
                                    !isConfirmPasswordHidden;
                              });
                            },
                          ),
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Color(0xff898888),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (!isPasswordMatch)
                    const Padding(
                      padding: EdgeInsets.only(left: 30.0, top: 8.0),
                      child: Padding(
                        padding: EdgeInsets.only(left: 28),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Password doesn\'t match',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isPasswordMatch = passwordController.text ==
                            confirmPasswordController.text;
                      });
                      if (isPasswordMatch) {
                        AuthCubit.get(context).signUp(userNameController.text,
                            emailController.text, passwordController.text);
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
                              "Sign Up",
                              style: TextStyle(
                                  color: Color(0xffE5E5E5),
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800),
                            ),
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
                  //           builder: (context) =>
                  //               VerifyEmailScreen(email: 'ahmedee@gmail.com'),
                  //         ));
                  //   },
                  //   child: Container(
                  //     height: 50,
                  //     width: 260,
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.circular(50),
                  //       border: Border.all(
                  //         color: const Color(0xFF125BFA), // Blue border color
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
                          "Already have an account?",
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
                                  builder: (context) => LoginScreen(),
                                ));
                          },
                          child: const Text(
                            "Sign In",
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
  }
}
