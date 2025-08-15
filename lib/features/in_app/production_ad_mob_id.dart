import 'dart:io';

import '../../../features/in_app/ad_mob_id.dart';

class ProductionAdMobId implements IAdMobId {
  @override
  String get profileBannerId =>
      Platform.isAndroid ? "ca-app-pub-2514819883330721/6737177979" : "ca-app-pub-2514819883330721/6496153753";

  @override
  String get advertDetailBannerId =>
      Platform.isAndroid ? "ca-app-pub-2514819883330721/4652303630" : "ca-app-pub-2514819883330721/5372141323";

  @override
  String get advertsEmptyBannerId =>
      Platform.isAndroid ? "ca-app-pub-2514819883330721/4372553297" : "ca-app-pub-2514819883330721/1923834990";

  @override
  String get favoritesBannerId =>
      Platform.isAndroid ? "ca-app-pub-2514819883330721/9237033012" : "ca-app-pub-2514819883330721/7900734765";

  @override
  String get favoritesEmptyBannerId =>
      Platform.isAndroid ? "ca-app-pub-2514819883330721/8213911175" : "ca-app-pub-2514819883330721/6587653096";

  @override
  String get myAdvertsBannerId =>
      Platform.isAndroid ? "ca-app-pub-2514819883330721/4274666166" : "ca-app-pub-2514819883330721/1432896319";

  @override
  String get myAdvertsEmptyBannerId =>
      Platform.isAndroid ? "ca-app-pub-2514819883330721/4560255556" : "ca-app-pub-2514819883330721/3403086556";
}
