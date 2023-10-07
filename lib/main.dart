import 'package:medic/_dart/_init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AppStorage().initStorage();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarDividerColor: AppColors.lightGrey,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        enableLog: true,
        initialRoute: '/',
        useInheritedMediaQuery: true,
        title: 'Medic',
        theme: ThemeColor.mThemeData(context),
        darkTheme: ThemeColor.mThemeData(context, isDark: true),
        defaultTransition: Transition.cupertino,
        opaqueRoute: Get.isOpaqueRouteDefault,
        popGesture: Get.isPopGestureEnable,
        transitionDuration: const Duration(milliseconds: 500),
        defaultGlobalState: true,
        initialBinding: GlobalBindings(),
        themeMode: ThemeMode.light,
        home: const SplashScreen());
  }
}

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserController(), fenix: true);
  }
}
