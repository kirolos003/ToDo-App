import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/Network/local/cache_helper.dart';
import 'package:todo/UI/dialog_util.dart';
import 'package:todo/UI/screens/Home/home_screen.dart';
import 'package:todo/UI/screens/Register/register_screen.dart';
import 'package:todo/database/usersDao.dart';
import 'package:todo/provider/app_provider.dart';
import 'package:todo/validation_util.dart';
import 'package:todo/shared/components.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    AppProvider provider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            provider.isDark ? const Color(0xff060E1E) : const Color(0xffDFECDB),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: provider.isDark
                ? const Color(0xff060E1E)
                : const Color(0xffDFECDB),
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
            minimum: const EdgeInsets.all(2),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(top: 30),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Login",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      defaultTextForm(

                        controller: emailController,
                        type: TextInputType.emailAddress,
                        label: "Email Address",
                        pre: Icon(Icons.email_outlined,
                            color: CacheHelper.getData(key: 'isDark') == true
                                ? Colors.white
                                : Colors.black),
                        validate: (text) {
                          if (text!.isEmpty) {
                            return 'Email Address cannot be empty';
                          }
                          if (!isValidEmail(emailController.text)) {
                            return "Enter Email in Valid Form";
                          }
                          return null;
                        },
                        hintText: "John.smith@gmail.com",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultTextForm(
                        pre: Icon(Icons.lock_outline,
                            color: CacheHelper.getData(key: 'isDark') == true
                                ? Colors.white
                                : Colors.black),
                        suf: provider.suffix,
                        controller: passwordController,
                        type: TextInputType.visiblePassword,
                        obsecure: true,
                        label: "Password",
                        isPassword: provider.isPassword,
                        validate: (text) {
                          if (text!.isEmpty) {
                            return 'Password cannot be empty';
                          }
                          if (text.length < 6) {
                            return " Password Should be at least 6 characters";
                          }
                          return null;
                        },
                        suffixPressed: () {
                          provider.changeSuffixVisibility();
                        },
                        hintText: "hkljhaduy12784!@#",
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: SizedBox(
                          height: 42,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith((states) {
                                if (CacheHelper.getData(key: 'isDark') == true) {
                                  return Colors.grey;
                                } else {
                                  return Colors.black;
                                }
                              }),
                            ),
                            onPressed: () {
                              loginToAccount(context);
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           Text(
                            'Don\'t have an account ? ',
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: 20
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              navigateTo(context, RegisterScreen());
                            },
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void loginToAccount(BuildContext context) async {
    if (formKey.currentState!.validate() == false) {
      return;
    }
    try {
      DialogUtil.showLoading(context, "Loading...");
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (credential.user != null) {
        var user = UserDao.getUser(credential.user!.uid);
        DialogUtil.hideDialog(context);
        CacheHelper.saveData(key: "token", value: credential.user!.uid);
        DialogUtil.showMessage(context,
            'This data is so confidential please press confirm to continue',
            isDismissAble: false,
            posActionTitle: "Confirm",
            negActionTitle: "Cancel", negAction: () {
          DialogUtil.hideDialog(context);
          CacheHelper.removeData(key: 'token');
        }, posAction: () {
          DialogUtil.showLoading(context, 'Loading ....', isDismissAble: false);
          navigateAndFinish(context, HomeScreen());
        });
      } else {
        DialogUtil.showMessage(context, 'Wrong E-mail or Paasword',
            posActionTitle: "ok", posAction: () {
          Navigator.pop(context);
        });
      }
    } on FirebaseAuthException catch (_) {
      DialogUtil.hideDialog(context);
      DialogUtil.showMessage(
          context, "Authentication failed. Wrong E-mail or Paaswor.");
    } catch (e, stackTrace) {
      print("Exception: $e\n$stackTrace");
      DialogUtil.showMessage(
          context, "Authentication failed. Please try again later.");
    }
  }
}
