enum AppFlavor { cobratopups, bdgamebazar, zsshop, rrrbazar, rangvotopup, evotopup, pipobazar, }

class AppConfig {
  final AppFlavor flavor;
  final String appName;
  final String flavourClientOrigin;
  final String walletName;


  AppConfig({
    required this.flavor,
    required this.appName,
    required this.flavourClientOrigin,
    required this.walletName
  });

  static late AppConfig instance;


  static void setConfig(AppConfig config) {
    instance = config;
  }
}
