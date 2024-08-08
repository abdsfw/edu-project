import 'package:flutter/material.dart';

import '../utils/styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.data,
    this.style = Styles.textStyle16,
    this.color = const Color.fromARGB(255, 255, 255, 255),
    this.onTap,
    required this.urlImage,
  });
  final String data;
  final TextStyle style;
  final Color color;
  final void Function()? onTap;
  final String? urlImage;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        color: color,
        shadowColor: const Color.fromARGB(89, 197, 191, 191),
        elevation: 10,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          onTap: onTap,
          child:
              //  Padding(
              // padding: const EdgeInsets.all(10),
              // child:
              Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: (urlImage == null)
                  ? null
                  : DecorationImage(
                      image: AssetImage(
                        urlImage!,

                      ),
                      fit: BoxFit.cover,

                    ),
             
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            child: Center(
              child: Text(
                data,
                style: Styles.textStyle23PriCol.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // child: ListTile(
          //   // leading: Container(zzz
          //   //   height: 30,
          //   //   child: Image.asset('assets/icon/rectangle-code.png'),
          //   // ),
          //   title:
          //   Text(
          //     data,
          //     style: Styles.textStyle20PriCol,
          //   ),
          //   // const Icon(
          //   //   Icons.code,
          //   //   color: AppColor.kPrimaryColor,
          //   // ),
          // ),

          // ),
        ),
      ),
    );
  }
}
