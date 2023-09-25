import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/Network/local/cache_helper.dart';
import 'package:todo/UI/screens/home_screen.dart';
import 'package:todo/provider/app_provider.dart';
import 'package:todo/shared/components.dart';
import 'package:todo/style/themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  bool? isDark = await CacheHelper.getData(key:'isDark');
  String? isEnglish = await CacheHelper.getData(key:'isEnglish');
  runApp(ChangeNotifierProvider(create: (BuildContext context) => AppProvider()..changeAppTheme(fromShared: isDark)..changeAppLanguage(fromShared: isEnglish),child: MyApp(isDark: isDark , isEnglish : isEnglish)));
}

class MyApp extends StatelessWidget {
  final bool? isDark;
  final String? isEnglish;
  MyApp({required this.isDark , required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppProvider>(context);
    return  MaterialApp(
      localizationsDelegates:AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: provider.isDark ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner:false,
      locale: Locale(provider.isEnglish  == 'en' ? 'en' : 'ar'),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 3), () {
      navigateAndFinish(context, HomeScreen());
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
                provider.isDark ?
                'assets/images/dark/splash – 1.png' : 'assets/images/light/splash.png',
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

