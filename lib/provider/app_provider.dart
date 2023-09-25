import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/Network/local/cache_helper.dart';

class AppProvider extends ChangeNotifier {
  String isEnglish = 'en';

  void changeAppLanguage({String? fromShared}) {
    if (fromShared != null) {
      isEnglish = fromShared;
    } else {
      isEnglish = (isEnglish == 'en') ? 'ar' : 'en';
      CacheHelper.saveData(key: 'isEnglish', value: isEnglish);
    }
    notifyListeners();
  }

  bool isDark = false;

    void changeAppTheme({bool? fromShared}) {
      if (fromShared != null) {
        isDark = fromShared;
        notifyListeners();
      }
      else {
        isDark = !isDark;
        CacheHelper.saveData(key: 'isDark', value: isDark).then((value) =>
            notifyListeners()
        );
      }
    }


}
