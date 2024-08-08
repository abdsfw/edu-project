import 'package:animate_do/animate_do.dart';
import 'package:educational_app/core/utils/color_app.dart';
import 'package:educational_app/core/utils/styles.dart';
import 'package:educational_app/core/widgets/custom_Loading_indicator.dart';
import 'package:educational_app/core/widgets/custom_error_dailog.dart';
import 'package:educational_app/core/widgets/custom_error_widget.dart';
import 'package:educational_app/core/widgets/custom_text_failed.dart';
import 'package:educational_app/features/edit_profile/presentation/manager/cubit/edit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

class EditProfileBody extends StatelessWidget {
  const EditProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    EditCubit edit = EditCubit.get(context);
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    // bool isRead = true;
    return BlocConsumer<EditCubit, EditState>(
      listener: (context, state) {
        if (state is GetInfoSuccess) {
          edit.nameController.text = edit.user.name ?? "";
          edit.usernameController.text = edit.user.username ?? " ";
        }
        if (state is EditSuccess) {
          const AlertDialog(
            content: Text("Ypdated"),
          );
        }
        if (state is EditFailure) {
          edit.nameController.text = edit.user.name ?? "";
          edit.usernameController.text = edit.user.username ?? " ";
          ErrorDialog.show(context, state.errMessage);
        }

        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is GetInfoFailure) {
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomErrorWidget(
                  errMessage: state.errMessage,
                  iconColor: AppColor.kPrimaryColor,
                  textStyle: Styles.textStyle15
                      .copyWith(color: AppColor.kPrimaryColor),
                ),
                IconButton(
                    onPressed: () async {
                      print("refrche");
                      await edit.fetchUserInfo();
                    },
                    icon: const Icon(Icons.refresh))
              ],
            ),
          );
        }
        if (state is GetInfoLoading || state is EditLoading) {
          return Scaffold(
            body: FadeInDown(
                delay: const Duration(milliseconds: 100),
                child: const CustomLoadingIndicator(
                  color: AppColor.kPrimaryColor,
                )),
          );
        }
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInDown(
                  delay: const Duration(milliseconds: 100),
                  child: Container(
                    width: w,
                    height: h / 2.5,
                    decoration: const BoxDecoration(
                        color: AppColor.kPrimaryColor,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(1000),
                            bottomLeft: Radius.circular(1000))),
                  ),
                ),
                FadeInRight(
                  delay: const Duration(milliseconds: 100),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      height: h * 0.5,
                      width: w,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: CustomTextFormField(
                              controller: edit.usernameController,
                              labelStyle: Styles.textStyle12,
                              labelText: "username",
                              prefixIcon: Icons.person,
                              readOnly: edit.isRead,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: CustomTextFormField(
                              controller: edit.nameController,
                              labelStyle: Styles.textStyle12,
                              labelText: "Name",
                              prefixIcon: Icons.person,
                              readOnly: edit.isRead,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Visibility(
                            visible: state is EditInitial ||
                                state is EndEdit ||
                                state is GetInfoSuccess ||
                                state is EditFailure,
                            child: ElevatedButton(
                                onPressed: () {
                                  edit.startEdit();
                                  print(edit.user.name);
                                },
                                child: const Text("Start edit profile")),
                          ),
                          Visibility(
                            visible: state is StartEdit,
                            child: ElevatedButton(
                                onPressed: () {
                                  edit.endEdit();
                                  edit.editUser({
                                    "user": edit.usernameController.text,
                                    "name": edit.nameController.text
                                  });
                                },
                                child: const Text("Ok")),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class GreenWidget extends StatelessWidget {
  const GreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/image/mask.png'), fit: BoxFit.fill)),
      child: Container(
          height: height * 0.1,
          width: width,
          margin: EdgeInsets.only(bottom: height * 0.05),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("My information", style: Styles.textStyle25White),
            ],
          )),
    );
  }
}
