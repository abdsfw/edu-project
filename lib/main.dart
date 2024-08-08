import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:educational_app/constants.dart';
import 'package:educational_app/core/utils/color_app.dart';
import 'package:educational_app/core/utils/styles.dart';
import 'package:educational_app/features/collages/presentation/manager/college_cubit/college_cubit.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:educational_app/features/edit_profile/data/repo/user_repo_imp.dart';
import 'package:educational_app/features/edit_profile/presentation/manager/cubit/edit_cubit.dart';
import 'package:educational_app/features/home/data/repo/home_repo_impl.dart';
import 'package:educational_app/features/login_and_resgister/data/repo/login_repo_impl.dart';
import 'package:educational_app/features/login_and_resgister/presentation/manager/cubit/login_cubit.dart';
import 'package:educational_app/features/splach/spach_view.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_device/safe_device.dart';

import 'package:flutter/material.dart';
// import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:safe_device_check/device_check.dart';
// import 'package:safe_device/safe_device.dart';
// import 'package:screen_protector/screen_protector.dart';

import 'core/cache/cashe_helper.dart';
import 'core/utils/bloc_observer.dart';
import 'core/utils/permissions_class.dart';
import 'core/utils/service_locator.dart';
import 'features/collages/data/repo/college_repo_impl.dart';
import 'features/home/presentation/manager/cubit/f_ile_cubit.dart';
import 'generated/l10n.dart';

void main() async {
  /*
    This line makes sure that all lines are executed
    before the last line * runApp(const MyApp()); *
  */
  WidgetsFlutterBinding.ensureInitialized();
  /*
    Bloc observer is class that can tell me what
    the state now, and print state in every change in states
   */
  Bloc.observer = MyBlocObserver();
  await CasheHelper.casheInit();

  /*
    this code make app unable to auto rotate
  */
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  /*
    Service Locator is class make me a single object from
    any class , ...
  */

  await PermissionsClass.requestPermissions();
  // final storageStatus = await Permission.storage.request();

  // print('id info : ${androidInfo.id}');
  setupServiceLocator();

  // bool isSafeDevice = await SafeDevice.isSafeDevice;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  // bool isRooted = await DeviceCheck.isRooted;
  // bool isEmulator = await DeviceCheck.isEmulator;
  // bool jailbreaker = await FlutterJailbreakDetection.jailbroken;

  if (await CasheHelper.getData(key: Constants.kIsFirstTime)) {
    runApp(const MyApp());
  } else {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      bool safeDevice = await SafeDevice.isSafeDevice;
      bool isOnExternalStorage = await SafeDevice.isOnExternalStorage;
      bool isRealDevice = await SafeDevice.isRealDevice;
      bool isJailBroken = await SafeDevice.isJailBroken;
      bool isDevelopmentModeEnable = await SafeDevice.isDevelopmentModeEnable;
      bool canMockLocation = await SafeDevice.canMockLocation;
      if (androidInfo.isPhysicalDevice &&
          safeDevice &&
          !isOnExternalStorage &&
          isRealDevice &&
          !isJailBroken &&
          // !isDevelopmentModeEnable &&
          !canMockLocation) {
        runApp(const MyApp());
      } else {
        runApp(NotSupported(
          isJailBroken: isJailBroken,
          isOnExternalStorage: isOnExternalStorage,
          isRealDevice: isRealDevice,
          safeDevice: safeDevice,
          canMockLocation: canMockLocation,
          isDevelopmentModeEnable: isDevelopmentModeEnable,
        ));
      }
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      if (iosInfo.isPhysicalDevice) {
        runApp(const MyApp());
      } else {
        runApp(NotSupported());
      }
    }
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var iosSecureScreenShotChannel =
      const MethodChannel('secureScreenshotChannel');
  @override
  void initState() {
    startProtect();
    super.initState();
  }

  startProtect() async {
    if (Platform.isIOS) {
      iosSecureScreenShotChannel.invokeMethod("secureiOS");
    }
    print("ScreenProtector.preventScreenshotOn()");
  }

  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       print("app in resumed");
  //       break;
  //     case AppLifecycleState.inactive:
  //       print("app in inactive");
  //       break;
  //     case AppLifecycleState.paused:
  //       print("app in paused");
  //       break;
  //     case AppLifecycleState.detached:
  //       print("app in detached");
  //       break;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              CollegeCubit(getIt.get<CollegeRepoImpl>())..createDataBase(),
        ),
        BlocProvider(
          create: (context) =>
              FIleCubit(getIt.get<HomeRepoImpl>())..fetchExternalCourse(),
        ),
        BlocProvider(
          create: (context) => LogiCubitCubit(getIt.get<LoginRepoimpl>()),
        ),
        BlocProvider(
          create: (context) => EditCubit(getIt.get<UserRepoImp>()),
        )
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        title: "WiseKey", //'SuccessKey',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            color: AppColor.kPrimaryColor,
          ),
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColor.kPrimaryColor),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        // home: const LoginScreen(),

        home: const SplachView(),
      ),
    );
  }
}

class NotSupported extends StatefulWidget {
  NotSupported(
      {super.key,
      this.safeDevice,
      this.isOnExternalStorage,
      this.isRealDevice,
      this.isJailBroken,
      this.isDevelopmentModeEnable,
      this.canMockLocation});
  final bool? safeDevice;
  final bool? isOnExternalStorage;
  final bool? isRealDevice;
  final bool? isJailBroken;
  final bool? isDevelopmentModeEnable;
  final bool? canMockLocation;
  List<TestUnit> err = [];
  bool firstCheck = false;

  @override
  State<NotSupported> createState() => _NotSupportedState();
}

class TestUnit {
  final String errMessage;
  final void Function()? onTap;

  TestUnit(this.errMessage, this.onTap);
}

class _NotSupportedState extends State<NotSupported>
    with WidgetsBindingObserver {
  Future<void> check() async {
    widget.err.clear();
    // Location location = Location();
    // bool sasfeDeviceNew = await SafeDevice.isSafeDevice;
    setState(() {});
    // final _serviceEnabled = await location.requestService();
    // print(_serviceEnabled);
    bool isOnExternalStorageNew = await SafeDevice.isOnExternalStorage;
    bool isRealDeviceNew = await SafeDevice.isRealDevice;
    bool isJailBrokenNew = await SafeDevice.isJailBroken;
    bool isDevelopmentModeEnableNew = await SafeDevice.isDevelopmentModeEnable;
    bool canMockLocationNew = await SafeDevice.canMockLocation;

    if (isOnExternalStorageNew == true) {
      setState(() {
        const errMessage1 = ' run in internal storage.';
        widget.err.add(TestUnit(errMessage1, () {}));
      });
      print(1);
    }
    if (isRealDeviceNew == false) {
      setState(() {
        const errMessage2 = 'please run with real device.';
        widget.err.add(TestUnit(errMessage2, () {}));
      });
      print(2);
    }
    if (isJailBrokenNew == true) {
      setState(() {
        const errMessage3 = ' you can\'t run with root in your system';
        widget.err.add(TestUnit(errMessage3, () {}));
      });
      print(3);
    }
    if (isDevelopmentModeEnableNew != true) {
      setState(() {
        const errMessage4 = ' please turn off developer mode in your device.';
        widget.err.add(TestUnit(errMessage4, () {
          AppSettings.openAppSettings(
              type: AppSettingsType.developer, asAnotherTask: true);
        }));
      });
      print(4);
    }
    if (canMockLocationNew == true) {
      setState(() {
        const errMessage5 =
            ' please turn on location and turn off any vpn program then close Al-amin app and clear ram memory and try again';
        widget.err.add(TestUnit(errMessage5, () {
          AppSettings.openAppSettings(
              type: AppSettingsType.location, asAnotherTask: true);
        }));
      });
      print(5);
    }
    print(6);
    // setState(() {
    //   (widget.err.isEmpty)
    //       ? Navigator.of(context).pushAndRemoveUntil(
    //           MaterialPageRoute(
    //             builder: (newContext) => const SplashScreen(),
    //           ),
    //           (route) => false)
    //       : null;
    // });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        widget.err.clear();
        print("object");
        await check();
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    // String convertDriveLink(String sharedLink) {
    //   if (sharedLink.contains('drivesdk')) {
    //     sharedLink = sharedLink.replaceAll('drivesdk', 'sharing');
    //   }
    //   if (sharedLink.contains('/file/d/') &&
    //       sharedLink.contains('/view?usp=sharing')) {
    //     final startIdx = sharedLink.indexOf('/file/d/') + 8;
    //     final endIdx = sharedLink.indexOf('/view?usp=sharing');
    //     if (startIdx < endIdx) {
    //       final fileId = sharedLink.substring(startIdx, endIdx);
    //       return 'https://drive.google.com/uc?export=download&id=$fileId';
    //     }
    //   }
    //   return sharedLink;
    // }

    int count = 1;
    if (!widget.firstCheck) {
      widget.firstCheck = true;
      if (widget.isOnExternalStorage == true) {
        setState(() {
          final errMessage1 = '$count- run in internal storage.';
          widget.err.add(TestUnit(errMessage1, () {}));
          count++;
        });
      }
      if (widget.isRealDevice == false) {
        setState(() {
          final errMessage2 = '$count- please run with real device.';
          widget.err.add(TestUnit(errMessage2, () {}));

          count++;
        });
      }
      if (widget.isJailBroken == true) {
        setState(() {
          final errMessage3 = '$count- you can\'t run with root in your system';
          widget.err.add(TestUnit(errMessage3, () {}));

          count++;
        });
      }
      if (widget.isDevelopmentModeEnable == true) {
        setState(() {
          final errMessage4 =
              '$count- please turn off developer mode in your device.';
          widget.err.add(TestUnit(errMessage4, () {
            AppSettings.openAppSettings(
                type: AppSettingsType.developer, asAnotherTask: true);
          }));

          count++;
        });
      }
      if (widget.canMockLocation == true) {
        setState(() {
          final errMessage5 =
              '$count- please turn on location and turn off any vpn program then close Al-amin app and clear ram memory and try again';
          widget.err.add(TestUnit(errMessage5, () {
            AppSettings.openAppSettings(
                type: AppSettingsType.location, asAnotherTask: true);
          }));

          count++;
        });
      }
    }

    // print(convertDriveLink(
    // 'https://drive.google.com/file/d/1dcnvRcm02Oj6JbLXm7bNsm_vJ1WryRCj/view?usp=sharing'));
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              CollegeCubit(getIt.get<CollegeRepoImpl>())..createDataBase(),
        ),
        BlocProvider(
          create: (context) =>
              FIleCubit(getIt.get<HomeRepoImpl>())..fetchExternalCourse(),
        ),
        BlocProvider(
          create: (context) => LogiCubitCubit(getIt.get<LoginRepoimpl>()),
        ),
        // BlocProvider(
        //   create: (context) => SubjectBloc(),
        // ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            color: AppColor.kPrimaryColor,
          ),
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        // home: LoginScreen(),
        // home: RegisterScreenA(),
        home: Scaffold(
          appBar: AppBar(),
          body:
              //  Column(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              // const Center(
              //   child: Text(
              //     "Not supported for you :)",
              //     style: Styles.textStyle20PriCol,
              //   ),
              // ),
              (widget.err.isEmpty)
                  ? Center(
                      child: ElevatedButton(
                        child: const Text('Start your journey'),
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (newContext) => const SplachView(),
                              ),
                              (route) => false);
                        },
                      ),
                    )
                  : ListView.builder(
                      itemCount: widget.err.length,
                      itemBuilder: (context, index) => Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.err[index].errMessage,
                              style: Styles.textStyle20PriCol,
                            ),
                          ),
                          TextButton(
                              onPressed: widget.err[index].onTap,
                              child: const Text(
                                'click here',
                                style: TextStyle(),
                              )),
                        ],
                      ),
                    ),

          // Text(
          //   errMessage1,
          //   style: Styles.textStyle20PriCol,
          // ),
          // Text(
          //   errMessage2,
          //   style: Styles.textStyle20PriCol,
          // ),
          // Text(
          //   errMessage3,
          //   style: Styles.textStyle20PriCol,
          // ),
          // Text(
          //   errMessage4,
          //   style: Styles.textStyle20PriCol,
          // ),
          // Text(
          //   errMessage5,
          //   style: Styles.textStyle20PriCol,
          // ),

          // Text('isJailBroken: //${widget.isJailBroken}'),
          // Text('isRealDevice: ${widget.isRealDevice}'),
          // Text('isOnExternalStorage: ${widget.isOnExternalStorage}'),
          // Text('safeDevice: ${widget.safeDevice}'),
          // Text('isDevelopmentModeEnable: ${widget.isDevelopmentModeEnable}'),
          // Text('canMockLocation: ${widget.canMockLocation}'),
          // Text(convertDriveLink(
          //     'https://drive.google.com/file/d/1dcnvRcm02Oj6JbLXm7bNsm_vJ1WryRCj/view?usp=sharing'))
          //   ],
          // ),
        ),
      ),
    );
  }
}
