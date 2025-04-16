// ignore_for_file: use_key_in_widget_constructors, camel_case_types, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled7/core/cubit/auth_cubit.dart';
import 'package:untitled7/core/cubit/project_cubit.dart';
import 'package:untitled7/view/login_screen.dart';
import 'core/util/cache_helper.dart';
import 'core/util/strings.dart';
import 'view/onboarding_screen.dart';
import 'view/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.int();
  token = '';

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
        BlocProvider(
          create: (context) => ProjectCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Splash_screen(),
        routes: {
          '/onBoardingScreen': (context) => OnboardingScreen(),
          '/home': (context) => const LoginScreen(),
        },
      ),
    );
  }
}
