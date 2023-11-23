import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/models/bottom_navigation_data.dart';
import 'package:kendamanomics_mobile/pages/leaderboards.dart';
import 'package:kendamanomics_mobile/pages/profile_page.dart';
import 'package:kendamanomics_mobile/pages/tamas_page.dart';
import 'package:kendamanomics_mobile/services/auth_service.dart';
import 'package:kendamanomics_mobile/services/user_service.dart';
import 'package:kiwi/kiwi.dart';

class MainPageContainerProvider extends ChangeNotifier with LoggerMixin {
  final _authService = KiwiContainer().resolve<AuthService>();
  final _userService = KiwiContainer().resolve<UserService>();
  final _contentGlobalKey = GlobalKey();
  List<BottomNavigationData> _bottomNav = <BottomNavigationData>[];
  String _previousImagePath = '';
  int _pageIndex = 1;
  double _contentHeight = 0.0;

  List<BottomNavigationData> get bottomNav => _bottomNav;
  GlobalKey get contentGlobalKey => _contentGlobalKey;
  int get pageIndex => _pageIndex;
  double get contentHeight => _contentHeight;

  set pageIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }

  MainPageContainerProvider() {
    _initBottomNav();
    _userService.subscribe(_listenToUserService);
  }

  void _listenToUserService(UserServiceEvents event, dynamic params) async {
    switch (event) {
      case UserServiceEvents.imageUploaded:
        bool shouldRebuild = _initBottomNav();
        if (shouldRebuild) notifyListeners();
        break;
    }
  }

  void calculateContentHeight() {
    if (_contentHeight != 0.0) return;
    final renderBox = _contentGlobalKey.currentContext?.findRenderObject() as RenderBox;
    _contentHeight = renderBox.size.height;
  }

  bool _initBottomNav() {
    final profileImagePath = _authService.player!.playerImageUrl;
    if (profileImagePath != null && profileImagePath.startsWith(_previousImagePath) && _previousImagePath.isNotEmpty) {
      return false;
    }
    if (profileImagePath != null) {
      _previousImagePath = profileImagePath.split('?')[0];
    }

    _bottomNav = [];
    _bottomNav.addAll([
      const BottomNavigationData(pathOrUrl: 'assets/icon/icon_leaderboard.png', isLocal: true, pageName: Leaderboards.pageName),
      const BottomNavigationData(pathOrUrl: 'assets/icon/icon_tama.png', isLocal: true, pageName: TamasPage.pageName),
      BottomNavigationData(
        pathOrUrl: profileImagePath,
        isLocal: false,
        pageName: ProfilePage.pageName,
        extraData: _authService.getCurrentUserId(),
      ),
    ]);

    return true;
  }

  @override
  void dispose() {
    _userService.unsubscribe(_listenToUserService);
    super.dispose();
  }

  @override
  String get className => 'MainPageContainerProvider';
}
