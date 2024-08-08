import 'package:educational_app/core/utils/styles.dart';
import 'package:educational_app/core/widgets/custom_Loading_indicator.dart';
import 'package:educational_app/core/widgets/custom_error_dailog.dart';
import 'package:educational_app/features/home/presentation/views/home_page.dart';
import 'package:educational_app/features/login_and_resgister/presentation/view/register.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../core/utils/color_app.dart';
import '../../../../core/widgets/app_text_dield.dart';
import '../manager/cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LogiCubitCubit loginCubit = LogiCubitCubit.get(context);
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
                image: const AssetImage("assets/image/img_login.png"),
              ),
              Text(
                "Login",
                style:
                    Styles.textStyle35.copyWith(color: AppColor.kPrimaryColor),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextField(
                    controller: loginCubit.usernameController,
                    prefix: const Icon(Icons.alternate_email_rounded),
                    hint: "Email Address",
                    textInputAction: TextInputAction.done,
                    init: loginCubit.autoFillUser ?? "",
                  ),
                  const SizedBox(height: 24),
                  AppTextField(
                    controller: loginCubit.passwordController,
                    // obscureText: true,
                    prefix: const Icon(Icons.lock_outline_rounded),
                    suffix: const Icon(Icons.remove_red_eye_outlined),
                    hint: "Password",
                    textInputAction: TextInputAction.done,
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: TextButton(
              //     onPressed: () {
              //       Navigator.pushNamed(
              //         context,
              //         AppRouteName.forgotPassword,
              //       );
              //     },
              //     child: const Text("Forgot Password ?"),
              //   ),
              // ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 64,
                  child: BlocConsumer<LogiCubitCubit, LogiCubitState>(
                    listener: (context, state) {
                      if (state is LoginCubitFailure) {
                        ErrorDialog.show(context, state.errMessage);
                      } else if (state is RegisterCubitSuccess) {
                        showTopSnackBar(
                          Overlay.of(context),
                          const CustomSnackBar.success(
                            message: "Create account success Login now",
                          ),
                        );
                      } else if (state is LoginCubitSuccess) {
                        print('success');
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is LoginCubitLoading) {
                        return const CustomLoadingIndicator(
                          color: AppColor.kPrimaryColor,
                        );
                      }
                      return ElevatedButton(
                        onPressed: () {
                          if (kDebugMode) {
                            print("LOGIN");
                          }
                          if (loginCubit.usernameController.text.isEmpty ||
                              loginCubit.passwordController.text.isEmpty) {
                            ErrorDialog.show(
                                context, "please Write all information");
                          } else {
                            loginCubit.login({
                              "user": loginCubit.usernameController.text,
                              "phone": loginCubit.passwordController.text
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.kPrimaryColor),
                        child: const Text(
                          "Login",
                          style: Styles.textStyle18White,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "Don't have an Account ? ",
                        style: Styles.textStyle15,
                      ),
                      TextSpan(
                        text: "Register here!",
                        style: Styles.textStyle15,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
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
}
