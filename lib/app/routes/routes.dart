import 'package:flutter/widgets.dart';
import 'package:denari_mobile/app/app.dart';
import 'package:denari_mobile/home/home.dart';
import 'package:denari_mobile/login/login.dart';
import 'package:denari_mobile/sign_up/sign_up.dart';


List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
  }
}