class BottomNavigationData {
  final String? pathOrUrl;
  final bool isLocal;
  final String pageName;
  final String? extraData;

  const BottomNavigationData({required this.pathOrUrl, required this.isLocal, required this.pageName, this.extraData});
}
