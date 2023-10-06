import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/Network/local/cache_helper.dart';
import 'package:todo/UI/screens/Home/home_screen.dart';
import 'package:todo/UI/screens/Login/login_screen.dart';
import 'package:todo/firebase_options.dart';
import 'package:todo/provider/app_provider.dart';
import 'package:todo/shared/components.dart';
import 'package:todo/style/themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseFirestore.instance.disableNetwork();
  FirebaseFirestore.instance.settings =
      Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  Widget? widget;
  await CacheHelper.init();
  String? token = await CacheHelper.getData(
      key: 'token'
  );
  if (token != null) {
    widget = const HomeScreen();
  } else {
    widget = LoginScreen();
  }
  bool? isDark = await CacheHelper.getData(key: 'isDark');
  String? isEnglish = await CacheHelper.getData(key: 'isEnglish');
  runApp(ChangeNotifierProvider(
      create: (BuildContext context) => AppProvider()
        ..changeAppTheme(fromShared: isDark)
        ..changeAppLanguage(fromShared: isEnglish),
      child: MyApp(isDark: isDark, isEnglish: isEnglish , startWidget: widget,)));
}

class MyApp extends StatelessWidget {
  final bool? isDark;
  final String? isEnglish;
  final Widget? startWidget;
  MyApp({required this.isDark, required this.isEnglish , required this.startWidget});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppProvider>(context);
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: provider.isDark ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      locale: Locale(provider.isEnglish == 'en' ? 'en' : 'ar'),
      home: SplashScreen(startWidget: startWidget,),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final Widget? startWidget;
  SplashScreen({required this.startWidget});
  @override
  State<SplashScreen> createState() => _SplashScreenState(startWidget: startWidget);
}

class _SplashScreenState extends State<SplashScreen> {
  final Widget? startWidget ;
  _SplashScreenState({required this.startWidget});
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 3), () {
      navigateAndFinish(context, startWidget);
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppProvider>(context);
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Image.asset(
                provider.isDark
                    ? 'assets/images/dark/splash – 1.png'
                    : 'assets/images/light/splash.png',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            )
          ],
        ),
      ),
    );
  }
}
