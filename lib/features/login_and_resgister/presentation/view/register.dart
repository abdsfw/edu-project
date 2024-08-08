import 'dart:math';

import 'package:educational_app/core/utils/color_app.dart';
import 'package:educational_app/core/utils/styles.dart';
import 'package:educational_app/core/widgets/app_text_dield.dart';
import 'package:educational_app/core/widgets/custom_Loading_indicator.dart';
import 'package:educational_app/core/widgets/custom_error_dailog.dart';
import 'package:educational_app/features/login_and_resgister/presentation/view/log_in_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../manager/cubit/login_cubit.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LogiCubitCubit loginCubit = LogiCubitCubit.get(context);
    // int generateRandomInt() {
    //   Random random = Random();
    //   return 9000000000 + random.nextInt(1000000000);
    // }

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          bottom: MediaQuery.of(context).padding.bottom,
          left: 24,
          right: 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(
                width: MediaQuery.of(context).size.width,
                height: 250,
                fit: BoxFit.contain,
                image: const AssetImage("assets/image/img_register.png"),
              ),
              Text(
                "Register",
                style:
                    Styles.textStyle35.copyWith(color: AppColor.kPrimaryColor),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextField(
                    controller: loginCubit.nameRegisterController,
                    prefix: Icon(Icons.person_outline),
                    hint: "Name",
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 24),
                  AppTextField(
                    controller: loginCubit.usernameRegisterController,
                    prefix: Icon(Icons.person_outline),
                    hint: "Username",
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 24),
                  AppTextField(
                    controller: loginCubit.passwordRegisterController,
                    // obscureText: true,
                    prefix: Icon(Icons.lock_outline_rounded),
                    // suffix: Icon(Icons.remove_red_eye_outlined),
                    hint: "Password",
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 24),
                  AppTextField(
                    controller: loginCubit.confirmpasswordRegisterController,
                    prefix: Icon(Icons.lock_outline_rounded),
                    hint: "confirm password",
                    textInputAction: TextInputAction.done,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 64,
                      child: BlocConsumer<LogiCubitCubit, LogiCubitState>(
                        listener: (context, state) {
                          // TODO: implement listener
                          if (state is RegisterCubitFailuer) {
                            ErrorDialog.show(context, state.errMessage);
                          }
                          if (state is RegisterCubitSuccess) {
                            // Navigate back to login screen on successful registration
                            loginCubit.usernameController.text =
                                loginCubit.usernameRegisterController.text;
                            loginCubit.passwordController.text =
                                loginCubit.passwordRegisterController.text;
                            loginCubit.usernameRegisterController.clear();
                            loginCubit.passwordRegisterController.clear();
                            loginCubit.confirmpasswordRegisterController
                                .clear();
                            loginCubit.nameRegisterController.clear();

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                              (route) {
                                return false;
                              },
                            );
                          }
                          if (state is RegisterCubitNotWriteAll) {
                            ErrorDialog.show(
                                context, "please Write all information");
                          }
                        },
                        builder: (context, state) {
                          if (state is RegisterCubitLoading) {
                            return CustomLoadingIndicator(
                              color: AppColor.kPrimaryColor,
                            );
                          }

                          return ElevatedButton(
                            onPressed: () async {
                              // Navigator.pushNamed(
                              //   context,
                              //   AppRouteName.otp,
                              // );
                              if (loginCubit
                                      .nameRegisterController.text.isEmpty ||
                                  loginCubit.usernameRegisterController.text
                                      .isEmpty ||
                                  loginCubit.passwordRegisterController.text
                                      .isEmpty ||
                                  loginCubit.confirmpasswordRegisterController
                                      .text.isEmpty) {
                                ErrorDialog.show(
                                    context, "Please write all information.");
                              } else if (loginCubit
                                      .passwordRegisterController.text !=
                                  loginCubit
                                      .confirmpasswordRegisterController.text) {
                                ErrorDialog.show(
                                    context, "Passwords don't match");
                              } else {
                                loginCubit.userregister({
                                  "name":
                                      loginCubit.nameRegisterController.text,
                                  "user": loginCubit
                                      .usernameRegisterController.text,
                                  "phone": loginCubit
                                      .passwordRegisterController.text,
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.kPrimaryColor),
                            child: const Text(
                              "Register",
                              style: Styles.textStyle18White,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "Already have an Account ? ",
                            style: Styles.textStyle15,
                          ),
                          TextSpan(
                            text: "Login here!",
                            style: Styles.textStyle15,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
