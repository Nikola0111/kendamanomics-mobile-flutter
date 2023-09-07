import 'package:flutter/material.dart';
import 'package:kendamanomics_mobile/models/bottom_navigation_data.dart';
import 'package:kendamanomics_mobile/pages/leaderboard.dart';
import 'package:kendamanomics_mobile/pages/profile.dart';
import 'package:kendamanomics_mobile/pages/tamas_page.dart';

class MainPageContainerProvider extends ChangeNotifier {
  final _bottomNav = <BottomNavigationData>[];
  int _pageIndex = 0;

  List<BottomNavigationData> get bottomNav => _bottomNav;
  int get pageIndex => _pageIndex;

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
}
