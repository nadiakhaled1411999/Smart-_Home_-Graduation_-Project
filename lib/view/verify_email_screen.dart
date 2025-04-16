// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:untitled7/core/cubit/auth_cubit.dart';
import 'package:untitled7/core/cubit/auth_state.dart';

import '../core/util/strings.dart';
import '../core/widgets/error_popup.dart';
import '../core/widgets/number_input_field.dart';
import 'homescreen.dart';

// ignore: must_be_immutable
class VerifyEmailScreen extends StatefulWidget {
  final String email;

  VerifyEmailScreen({super.key, required this.email});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController verifyCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Call sendEmailVerification when the screen is initialized
    AuthCubit.get(context).sendEmailVerification(widget.email);
  }

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
                child: Center(child: const CircularProgressIndicator())),
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
        return Scaffold(
          body: Container(
            height: double.infinity,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 5, top: 5),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Image.asset(
                          'assets/images/Privacy policy-rafiki.png',
                          // fit: BoxFit.fill,
                          height: 370,
                          width: 360,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  GradientText(
                    "Please enter the code delivered to \n your Email",
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                    colors: [
                      Color(0xFF5E7CFF),
                      Color(0xFF125BFA),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  NumberInputField(controller: verifyCodeController),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    onTap: () {
                      AuthCubit.get(context)
                          .verifyEmail(widget.email, verifyCodeController.text);
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
                              "Verify Email",
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
