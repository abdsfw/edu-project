import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:educational_app/features/home/presentation/views/home_page.dart';
import 'package:educational_app/features/login_and_resgister/presentation/view/register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../../core/cache/cashe_helper.dart';

class SplachView extends StatefulWidget {
  const SplachView({super.key});

  @override
  State<SplachView> createState() => _SplachViewState();
}

class _SplachViewState extends State<SplachView> with TickerProviderStateMixin {
  bool _checkedAuthentication = false;

  @override
  void initState() {
    // TODO: implement initState
    navigateToHome();
    _retrieveStoredToken();
    super.initState();
  }

  void _checkAuthentication() async {
    final hasToken = await _retrieveStoredToken();

    if (!_checkedAuthentication) {
      _checkedAuthentication = true;

      if (hasToken) {
        // router.pushReplacement(AppRouter.kHomeView);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
          (route) => false,
        );
      } else {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const RegisterScreen(),
          ),
          (route) => false,
        );
      }
    }
  }

  // context,
  // MaterialPageRoute(
  //   builder: (context) => const RegisterScreen(),
  // ),
  Future<bool> _retrieveStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print("my token");
    print(token);
    return token != null && token.isNotEmpty;
  }

  void navigateToHome() async {
    await CasheHelper.setData(key: Constants.kIsFirstTime, value: true);

    Future.delayed(const Duration(seconds: 3), () {
      // GoRouter.of(context).pushReplacement(AppRouter.klogin);
      _checkAuthentication();
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
          body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInUp(
              delay: const Duration(milliseconds: 1500),
              child: Spin(
                delay: const Duration(milliseconds: 1000),
                child: SizedBox(
                  width: w / 1.6,
                  height: h / 3.3,
                  child: Center(child: Image.asset("assets/image/logo.png")),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TypewriterAnimatedTextKit(
              onTap: () {
                print("Tap Event");
              },
              speed: Duration(milliseconds: 50),
              text: const ["The Best Way"],
              textStyle: const TextStyle(fontSize: 30.0, fontFamily: "Agne"),
            ),
          ],
        ),
      )),
    );
  }
}
