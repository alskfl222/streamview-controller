enum PageName {
  login,
  landing,
  viewer,
}

class StreamViewRoute {
  final PageName? pageName;
  final String? uid;
  final bool _isUnknown;

  StreamViewRoute.login()
      : pageName = PageName.login,
        uid = null,
        _isUnknown = false;

  StreamViewRoute.landing()
      : pageName = PageName.landing,
        uid = null,
        _isUnknown = false;

  StreamViewRoute.viewer(this.uid)
      : pageName = PageName.viewer,
        _isUnknown = false;

  StreamViewRoute.unknown()
      : pageName = null,
        uid = null,
        _isUnknown = true;

  bool get isLogin => pageName == PageName.login;
  bool get isLanding => pageName == PageName.landing;
  bool get isViewer => pageName == PageName.viewer;
  bool get isUnknown => _isUnknown;
}

