import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/models/bottom_navigation_data.dart';
import 'package:kendamanomics_mobile/pages/leaderboard.dart';
import 'package:kendamanomics_mobile/pages/profile.dart';
import 'package:kendamanomics_mobile/pages/tamas_page.dart';

class MainPageContainerProvider extends ChangeNotifier with LoggerMixin {
  final _bottomNav = <BottomNavigationData>[];
  final _contentGlobalKey = GlobalKey();
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
    _bottomNav.clear();
    _bottomNav.addAll([
      const BottomNavigationData(pathOrUrl: 'assets/icon/icon_leaderboard.png', isLocal: true, pageName: Leaderboard.pageName),
      const BottomNavigationData(pathOrUrl: 'assets/icon/icon_tama.png', isLocal: true, pageName: TamasPage.pageName),
      const BottomNavigationData(pathOrUrl: 'assets/icon/icon_leaderboard.png', isLocal: true, pageName: Profile.pageName),
    ]);
  }

  void calculateContentHeight() {
    if (_contentHeight != 0.0) return;
    final renderBox = _contentGlobalKey.currentContext?.findRenderObject() as RenderBox;
    _contentHeight = renderBox.size.height;
    logI('height of content is: $_contentHeight');
  }

  @override
  String get className => 'MainPageContainerProvider';
}
