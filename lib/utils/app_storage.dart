import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medic/model/user_model.dart';

class AppStorage {
  // ignore: prefer_function_declarations_over_variables
  final storageBox = () => GetStorage(StorageKey.kAppStorageKey);

  Future<void> appLogout() async {
    await storageBox().remove(StorageKey.kIsBoardWatched);
    await storageBox().remove(StorageKey.kLoggedInUser);
    await storageBox().remove(StorageKey.kNotificationSettings);
    return;
  }

  dynamic read(String key) {
    return storageBox().read(key);
  }

  Future<void> write(String key, dynamic value) async {
    return await storageBox().write(key, value);
  }

  UserModel? getUserData() {
    String? loggedInUser = read(StorageKey.kLoggedInUser);
    if (loggedInUser == null) {
      return null;
    }
    UserModel userModel = UserModel.fromJson(loggedInUser);
    return userModel;
  }

  Future<void> setUserData(UserModel userModel) async {
    await write(StorageKey.kLoggedInUser, userModel.toJson());
    return;
  }

  Future<void> setNotificationSettingData(
      Map<String, dynamic> notificationModel) async {
    await write(StorageKey.kNotificationSettings, notificationModel);
    return;
  }

  Map<String, dynamic>? getNotificationSettingData() {
    var data = read(StorageKey.kNotificationSettings);
    if (data == null) {
      return null;
    }
    return data;
  }

  bool getBool(String key) {
    return read(key) ?? false;
  }

  Future<void> setBool(String key, bool value) async {
    await write(key, value);
    return;
  }

  Future<void> initStorage() async {
    await GetStorage.init(StorageKey.kAppStorageKey);
  }

  bool isBoardWatched() {
    return getBool(StorageKey.kIsBoardWatched);
  }

  bool checkLoginAndUserData() {
    if (FirebaseAuth.instance.currentUser != null && getUserData() == null) {
      FirebaseAuth.instance.signOut();
      return false;
    }
    return FirebaseAuth.instance.currentUser != null &&
        getUserData() != null &&
        getUserData()?.name != null;
  }
}

class StorageKey {
  static const String kAppStorageKey = 'AppStorageKey';

  static const String kLoggedInUser = 'LoggedInUser';
  static const String kNotificationSettings = 'notificationSetting';
  static const String kAppLanguage = 'appLanguage';
  static const String kIsBoardWatched = 'isBoardWatched';
}
