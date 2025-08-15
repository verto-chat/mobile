

abstract interface class IAdMobId {
  String get profileBannerId;

  String get advertsEmptyBannerId;

  String get advertDetailBannerId;

  String get favoritesEmptyBannerId;

  String get favoritesBannerId;

  String get myAdvertsEmptyBannerId;

  String get myAdvertsBannerId;
}

const _testBannerId = 'ca-app-pub-3940256099942544/9214589741';

class TestAdMobId implements IAdMobId {
  @override
  String get profileBannerId => _testBannerId;

  @override
  String get advertDetailBannerId => _testBannerId;

  @override
  String get advertsEmptyBannerId => _testBannerId;

  @override
  String get favoritesBannerId => _testBannerId;

  @override
  String get favoritesEmptyBannerId => _testBannerId;

  @override
  String get myAdvertsBannerId => _testBannerId;

  @override
  String get myAdvertsEmptyBannerId => _testBannerId;
}
