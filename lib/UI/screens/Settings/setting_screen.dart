import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/Network/local/cache_helper.dart';
import 'package:todo/UI/dialog_util.dart';
import 'package:todo/UI/screens/Login/login_screen.dart';
import 'package:todo/provider/app_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo/shared/components.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    AppProvider provider = Provider.of<AppProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color:
            provider.isDark ? const Color(0xff060E1E) : const Color(0xffDFECDB),
      ),
      child: SafeArea(
        minimum: const EdgeInsets.all(2),
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.settings,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                AppLocalizations.of(context)!.language,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  showLanguageBottomSheet();
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        provider.isEnglish == 'en'
                            ? AppLocalizations.of(context)!.english
                            : AppLocalizations.of(context)!.arabic,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const Icon(Icons.arrow_drop_down_outlined)
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Text(
                AppLocalizations.of(context)!.theme,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  showThemeBottomSheet();
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        provider.isDark
                            ? AppLocalizations.of(context)!.dark
                            : AppLocalizations.of(context)!.light,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const Icon(Icons.arrow_drop_down_outlined)
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  DialogUtil.showMessage(
                      context, "Are you sure you want to logout ?",
                      negActionTitle: "Cancel",
                      negAction: () {
                        Navigator.pop(context);
                      },
                      posActionTitle: "Yes",
                      posAction: () {
                        CacheHelper.removeData(key: "token");
                        navigateAndFinish(context, LoginScreen());
                      },
                      isDismissAble: true);
                },
                child: Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                          provider.isDark
                              ? const Color(0xff060E1E)
                              : const Color(0xffDFECDB),
                        )),
                        child: const Icon(
                          Icons.login_outlined,
                          size: 40,
                        )),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text("Log out"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showLanguageBottomSheet() {
    showModalBottomSheet(
        context: context, builder: (context) => const LanguageBottomSheet());
  }

  void showThemeBottomSheet() {
    showModalBottomSheet(
        context: context, builder: (context) => const ThemeBottomSheet());
  }
}

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    AppProvider provider = Provider.of<AppProvider>(context);
    return Container(
      color:
          provider.isDark ? const Color(0xff141922) : const Color(0xffDFECDB),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              provider.changeAppLanguage();
            },
            child: Text(
              AppLocalizations.of(context)!.english,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: provider.isDark ? Colors.white : Colors.black,
                  ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              provider.changeAppLanguage();
            },
            child: Text(
              AppLocalizations.of(context)!.arabic,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: provider.isDark ? Colors.white : Colors.black,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class ThemeBottomSheet extends StatelessWidget {
  const ThemeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    AppProvider provider = Provider.of<AppProvider>(context);
    return Container(
      color:
          provider.isDark ? const Color(0xff141922) : const Color(0xffDFECDB),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              provider.changeAppTheme();
            },
            child: Text(
              AppLocalizations.of(context)!.light,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: provider.isDark ? Colors.white : Colors.black,
                  ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              provider.changeAppTheme();
            },
            child: Text(
              AppLocalizations.of(context)!.dark,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: provider.isDark ? Colors.white : Colors.black,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
