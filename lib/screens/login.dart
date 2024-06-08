// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gericare/constants.dart';
import 'package:gericare/cubits/auth_info.dart';
import 'package:gericare/db_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool responseSuccess = false;
  bool isPasswordVisible = false;
  final dbservice = DbService();

  final formKey = GlobalKey<FormState>();

  FormFieldValidator<String>? usernameValidator = (value) {
    if (value!.isEmpty) {
      return "*Username cannot be empty";
    }
    return null;
  };

  FormFieldValidator<String>? passwordValidator = (value) {
    if (value!.isEmpty) {
      return "*Password cannot be empty";
    } else if (value.length < 3) {
      return "*Password must be at least 3 characters";
    }
    return null;
  };

  @override
  Widget build(BuildContext context) {
    final authInfoCubit = BlocProvider.of<AuthInfoCubit>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/splash_image_white.png",
                height: 150,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: usernameController,
                keyboardType: TextInputType.emailAddress,
                maxLines: 1,
                validator: usernameValidator,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  filled: true,
                  fillColor: fillGrey,
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
                  suffixIcon: Icon(
                    responseSuccess ? Icons.check : null,
                    size: 20,
                    color: greenTick,
                  ),
                  hintText: "Enter your username",
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
                  enabledBorder: borderOutlineStyle,
                  focusedBorder: borderOutlineStyle,
                  focusedErrorBorder: errorBorderOutlineStyle,
                  errorBorder: errorBorderOutlineStyle,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                autocorrect: false,
                validator: passwordValidator,
                maxLines: 1,
                obscureText: isPasswordVisible ? false : true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  filled: true,
                  fillColor: fillGrey,
                  prefixIcon: const Icon(
                    Icons.lock_rounded,
                    color: Colors.grey,
                  ),
                  suffixIcon: SizedBox(
                    height: 20,
                    width: 20,
                    child: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: Colors.grey,
                      ),
                      onPressed: () => setState(() {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      }),
                    ),
                  ),
                  hintText: "Enter your password",
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
                  enabledBorder: borderOutlineStyle,
                  focusedBorder: borderOutlineStyle,
                  focusedErrorBorder: errorBorderOutlineStyle,
                  errorBorder: errorBorderOutlineStyle,
                ),
              ),
              const SizedBox(height: 5),
              forgotPWDInkwell(),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(
                        side: BorderSide(color: primaryColor, width: 1)),
                  ),
                  onPressed: () async {
                    // dont proceed if form is invalid
                    if (formKey.currentState!.validate()) {
                      final response = await dbservice.login(
                          usernameController.text, passwordController.text);

                      if (response['success']) {
                        // show snackbar
                        if (context.mounted) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/home', (Route<dynamic> route) => false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              duration: Duration(seconds: 2),
                              content: Text(
                                "Login Successful",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: appBarTitle,
                            ),
                          );
                        }

                        setState(() {
                          responseSuccess = true;
                        });
                        authInfoCubit.updateAuthInfo(response);
                        print("Login Successful");
                      } else {
                        setState(() {
                          responseSuccess = false;
                        });
                        print("Login Failed");
                      }
                    }
                  },
                  child: const Text("Login",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                    (responseSuccess == false &&
                            usernameController.text.isNotEmpty)
                        ? "*Incorrect username or password"
                        : "",
                    style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget forgotPWDInkwell() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            print("Forgot Password");
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: const Text(
            "Forgot Password?",
            style: TextStyle(
                color: primaryColor, fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
