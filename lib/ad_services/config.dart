class Config {
  static final Config _instance = Config._();
  factory Config() => _getInstance();
  static Config get instance => _getInstance();

  Config._();

  static Config _getInstance() {
    return _instance;
  }

  static bool isAdShow() {
    if (isInfiniteNumberVersion) {
      return false;
    }
    return true;
  }

  static bool isInfiniteNumberVersion = false;
  static int watchAdApiCount = 3;
  static int appUserAdCount =
      20; // Do not actively display advertisements if the number of times exceeds (redemption page)
}
