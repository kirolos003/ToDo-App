import 'package:flutter/material.dart';
import 'package:todo/UI/screens/Home/home_screen.dart';
import 'package:todo/shared/components.dart';

class DialogUtil{
  static void showLoading(BuildContext context , String message , {bool isDismissAble = true}){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20,),
              Text(message),
            ],
          ),
        ),
      barrierDismissible: isDismissAble,
    );
  }

  static void hideDialog(BuildContext context){
    Navigator.pop(context);
  }

  static void showMessage(
      BuildContext context ,
      String message ,
      {bool isDismissAble = true  , String? posActionTitle , String? negActionTitle}){
    List<Widget> actions = [];
    if(negActionTitle != null){
      actions.add(TextButton(onPressed: (){
        hideDialog(context);
      }, child: Text(negActionTitle)));
    }
    if(posActionTitle != null){
      actions.add(TextButton(onPressed: (){
        DialogUtil.showLoading(context, 'Loading ....' , isDismissAble: false);
        navigateTo(context, HomeScreen());
      }, child: Text(posActionTitle)));
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: actions,
        content: Row(
          children: [
            Expanded(
              child: Text(message , maxLines: 5,),
            ),
          ],
        ),
      ),
      barrierDismissible: isDismissAble,
    );
  }
}