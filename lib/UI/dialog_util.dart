import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogUtil {
  static void showLoading(BuildContext context, String message,
      {bool isDismissAble = true}) {
    showCupertinoDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(
              width: 20,
            ),
            Text(message),
          ],
        ),
      ),
      barrierDismissible: isDismissAble,
    );
  }

  static void hideDialog(BuildContext context) {
    Navigator.pop(context);
  }

  static void showMessage(BuildContext context, String message,
      {bool isDismissAble = true,
      String? posActionTitle,
      String? negActionTitle,
      Function? posAction,
      Function? negAction}) {
    List<Widget> actions = [];
    if (negActionTitle != null) {
      actions.add(TextButton(
          onPressed: () {
            negAction?.call();
          },
          child: Text(negActionTitle)));
    }
    if (posActionTitle != null) {
      actions.add(TextButton(
          onPressed: () {
            posAction?.call();
          },
          child: Text(posActionTitle)));
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: actions,
        content: Row(
          children: [
            Expanded(
              child: Text(
                message,
                maxLines: 5,
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: isDismissAble,
    );
  }
}
