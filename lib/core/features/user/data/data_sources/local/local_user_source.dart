import '../../../../../../startup.dart';
import '../../data.dart';
import 'models.dart';

class LocalUserSource {
  final ObjectBox _objectBox;

  LocalUserSource(this._objectBox);

  Future<UserInfoDto?> getCachedUserInfo() async {
    final quickCategoriesBox = _objectBox.store.box<UserInfoEntity>();

    final result = await quickCategoriesBox.getAllAsync();
    final model = result.firstOrNull;

    return model?.toDto();
  }

  Future<void> cacheUserInfo(UserInfoDto data) async {
    final quickCategoriesBox = _objectBox.store.box<UserInfoEntity>();

    final quickCategory = UserInfoEntity.fromDto(data);

    await quickCategoriesBox.removeAllAsync();

    await quickCategoriesBox.putAsync(quickCategory);
  }
}
