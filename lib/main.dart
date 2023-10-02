import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/Network/local/cache_helper.dart';
import 'package:todo/UI/screens/Login/login_screen.dart';
import 'package:todo/provider/app_provider.dart';
import 'package:todo/shared/components.dart';
import 'package:todo/style/themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBk4Cw1IM6FB8R6jsiWMc4Sxh9BRXPjMmk",
            appId: "1:42648457098:web:7907bb1b006bd00cdd4273",
            messagingSenderId: "42648457098",
            projectId: "todo-app-fab95"));
  }
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  FirebaseFirestore.instance.settings =
      const Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  await FirebaseFirestore.instance.disableNetwork();
  await CacheHelper.init();
  bool? isDark = await CacheHelper.getData(key: 'isDark');
  String? isEnglish = await CacheHelper.getData(key: 'isEnglish');
  runApp(ChangeNotifierProvider(
      create: (BuildContext context) => AppProvider()
        ..changeAppTheme(fromShared: isDark)
        ..changeAppLanguage(fromShared: isEnglish),
      child: MyApp(isDark: isDark, isEnglish: isEnglish)));
}

class MyApp extends StatelessWidget {
  final bool? isDark;
  final String? isEnglish;
  const MyApp({super.key, required this.isDark, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppProvider>(context);
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: provider.isDark ? ThemeMode.dark :ThemeMode.light,
      debugShowCheckedModeBanner: false,
      locale: Locale(provider.isEnglish == 'en' ? 'en' : 'ar'),
      home: const SplashScreen(),
    );
  }
}
//
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      navigateAndFinish(context, LoginScreen());
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
