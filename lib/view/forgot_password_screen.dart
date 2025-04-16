// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:untitled7/core/cubit/auth_cubit.dart';
import 'package:untitled7/core/cubit/auth_state.dart';

import '../core/widgets/error_popup.dart';
import 'reset_password_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is AuthLoading) {
          // Show loading indicator
          showDialog(
            context: context,
            barrierDismissible: false, // Prevent dismiss by tapping outside
            builder: (context) => SizedBox(
                height: 50,
                width: 50,
                child: Center(
                    child: const CircularProgressIndicator(
                  color: Colors.blue,
                ))),
          );
        } else if (state is AuthAuthenticated) {
          // Navigate to authenticated screen
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResetPasswordScreen(),
              ));
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
                      'assets/images/Forgot password-rafiki.png',
                      width: 320,
                      height: 330,
                      // fit: BoxFit.fill,
                    ),
                  ),
                  GradientText(
                    "Reset\nPassword",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                    colors: [
                      Color(0xFF5672ED),
                      Color(0xFF407BFF),
                    ],
                  ),
                  SizedBox(
                    height: 40,
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
                            borderSide: BorderSide(
                              width: 1,
                              color: Color(0xff3230C1),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 1,
                              color: Color(0xff3230C1),
                            ),
                          ),
                          label: Text(
                            "Email Address",
                            style: TextStyle(
                                color: Color(0xff000000),
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    onTap: () {
                      AuthCubit.get(context)
                          .forgetPassword(emailController.text);
                    },
                    child: Container(
                      height: 60,
                      width: 260,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          gradient: LinearGradient(colors: [
                            Color(0xFF5E7CFF),
                            Color(0xFF125BFA),
                          ])),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Send me code!",
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
