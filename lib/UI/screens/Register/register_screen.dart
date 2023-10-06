import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/FireBaseErrorCodes.dart';
import 'package:todo/UI/dialog_util.dart';
import 'package:todo/UI/screens/Login/login_screen.dart';
import 'package:todo/database/usersDao.dart';
import 'package:todo/models/users.dart' as MyUser;
import 'package:todo/provider/app_provider.dart';
import 'package:todo/validation_util.dart';
import 'package:todo/shared/components.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();
  TextEditingController fullName = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    AppProvider provider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
            minimum: const EdgeInsets.all(2),
            child: Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(top: 30),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Register",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    defaultTextForm(
                        controller: fullName,
                        type: TextInputType.name,
                        validate: (text) {
                          if (text!.isEmpty) {
                            return 'Name cannot be empty';
                          }
                          return null;
                        },
                        label: "Full Name",
                        hintText: "John Smith"),
                    const SizedBox(
                      height: 20,
                    ),
                    defaultTextForm(
                      controller: userName,
                      type: TextInputType.text,
                      label: "User Name",
                      validate: (text) {
                        if (text!.isEmpty) {
                          return 'User Name cannot be empty';
                        }
                        return null;
                      },
                      hintText: "John",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    defaultTextForm(
                      controller: emailController,
                      type: TextInputType.emailAddress,
                      label: "Email Address",
                      pre: const Icon(Icons.email_outlined),
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
                      pre: const Icon(Icons.lock_outline),
                      controller: passwordController,
                      type: TextInputType.visiblePassword,
                      obsecure: true,
                      label: "Password",
                      isPassword: true,
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
                      height: 20,
                    ),
                    defaultTextForm(
                      suffixPressed: () {
                        provider.changeSuffixVisibility();
                      },
                      pre: const Icon(Icons.lock_outline),
                      controller: passwordConfirmationController,
                      type: TextInputType.visiblePassword,
                      obsecure: true,
                      isPassword: true,
                      label: "Password Confirmation",
                      validate: (text) {
                        if (text!.isEmpty) {
                          return 'Password Confirmation cannot be empty';
                        }
                        if (text.length < 6) {
                          return " Password Should be at least 6 characters";
                        }
                        if (!(passwordController.text ==
                            passwordConfirmationController.text)) {
                          return "Password Mismatching";
                        }
                        return null;
                      },
                      hintText: "hkljhaduy12784!@#",
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          createAccount(context);
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void createAccount(BuildContext context) async {
    if (formKey.currentState!.validate() == false) {
      return;
    }
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      await UserDao.createUser(
        MyUser.User(
          id: credential.user?.uid,
          userName: userName.text,
          fullName: fullName.text,
          email: emailController.text,
        )
      );
      DialogUtil.showMessage(context, 'Registered Successfully' , posActionTitle: 'ok' , posAction: (){
        navigateAndFinish(context, LoginScreen());
      });
      print(credential.user?.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == FireBaseErrorCodes.weakPassword) {
        print('The password provided is too weak.');
      } else if (e.code == FireBaseErrorCodes.emailInUse) {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}
