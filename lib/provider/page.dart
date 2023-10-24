import 'package:flutter/material.dart';
import '../route/route.dart';

class PageProvider extends ChangeNotifier {
  PageName? _pageName = PageName.login;
  String? _uid;
  bool _unknownPath = false;

  get pageName => _pageName;

  get uid => _uid;

  get isUnknown => _unknownPath;

  changePage(
      {required PageName? page, required String? uid, required bool unknown}) {
    _pageName = page;
    _uid = uid;
    _unknownPath = unknown;
    print('changePage: $_pageName, $_uid, $_unknownPath');
    notifyListeners();
  }
}
