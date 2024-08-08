import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:educational_app/core/utils/color_app.dart';
import 'package:educational_app/core/widgets/custom_Loading_indicator.dart';
import 'package:educational_app/features/enterCodePage/presentation/views/data/add_code_api.dart';
import 'package:educational_app/features/home/presentation/manager/cubit/f_ile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../../core/utils/styles.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';

class EnterCodeButton extends StatelessWidget {
  const EnterCodeButton({
    super.key,
    required this.data,
    this.style = Styles.textStyle16,
    this.color = const Color.fromARGB(255, 255, 255, 255),
    // this.onTap,
  });
  final String data;
  final TextStyle style;
  final Color color;
  // final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    FIleCubit fIleCubit = FIleCubit.get(context);
    TextEditingController _codeController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        color: color,
        shadowColor: const Color.fromARGB(89, 197, 191, 191),
        elevation: 10,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          // onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ExpansionTile(
              leading: SizedBox(
                height: 30,
                child: Image.asset('assets/icon/rectangle-code.png'),
              ),
              title: Text(
                data,
                style: Styles.textStyle20PriCol,
              ),
              children: [
                CustomTextFormField(
                  controller: _codeController,
                  // controller: _codeController,
                  labelStyle: Styles.textStyle12,
                  labelText: "Your code",
                  prefixIcon: Icons.code_sharp,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                        RegExp(r'[\u0600-\u06FF]')),
                  ],
                  readOnly: false,
                ),
                BlocConsumer<FIleCubit, FIleState>(
                  listener: (context, state) {
                    if (state is SuccessPostCodeState) {
                      showTopSnackBar(
                        Overlay.of(context),
                        const CustomSnackBar.success(
                          message: "code added successfully. Have a nice day",
                        ),
                      );
                      _codeController.clear();
                    } else if (state is FailurePostCodeState) {
                      showTopSnackBar(
                        Overlay.of(context),
                        const CustomSnackBar.error(
                          message: "Something went wrong. or the code is used",
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is LoadingPostCodeState) {
                      return const CustomLoadingIndicator(
                        color: AppColor.kPrimaryColor,
                      );
                    } else {
                      return ElevatedButton(
                        onPressed: () async {
                          if (_codeController.text.isEmpty) {
                            await AwesomeDialog(
                              context: context,
                              animType: AnimType.scale,
                              dialogType: DialogType.error,
                              body: const Center(
                                child: Text(
                                  "please insert code",
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              title: 'This is Ignored',
                              desc: 'This is also Ignored',
                              btnOkOnPress: () {},
                              btnOkColor: AppColor.kPrimaryColor,
                            ).show();
                            return;
                          }

                          fIleCubit.postCode(data: {
                            'code': _codeController.text,
                          });
                          // final response =
                          // await AddCodeApi.addCourseCode(_codeController.text);
                          // if (response.statusCode == 200 ||
                          //     response.statusCode == 201) {
                          // showTopSnackBar(
                          //   Overlay.of(context),
                          //   const CustomSnackBar.success(
                          //     message: "code added successfully. Have a nice day",
                          //   ),
                          // );
                          // } else {
                          //   print('response paras: ${response.reasonPhrase}');
                          // showTopSnackBar(
                          //   Overlay.of(context),
                          //   const CustomSnackBar.error(
                          //     message: "Something went wrong. or the code is used",
                          //   ),
                          // );
                          // }
                        },
                        child: const Text(
                          'send',
                          style: Styles.textStyle15PriCol,
                        ),
                      );
                    }
                  },
                ),
              ],
              // const Icon(
              //   Icons.code,
              //   color: AppColor.kPrimaryColor,
              // ),
            ),
            // Text(
            //   data,
            //   style: style,
            //   textAlign: TextAlign.center,
            // ),
          ),
        ),
      ),
    );
  }
}
