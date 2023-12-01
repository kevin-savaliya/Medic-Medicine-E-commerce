import 'dart:developer';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'config.dart';

class InterstitialAdCreator {
  InterstitialAd? _interstitialAd;
  String adUnitId = '';
  bool isLoaded = false;

  InterstitialAdCreator(this.adUnitId);

  Future createShowInterstitialAd({
    Function? loadedCallback,
    Function? loadFailCallback,
  }) async {
    if (!Config.isAdShow()) {
      return;
    }
    if (isLoaded) {
      return;
    }
    isLoaded = true;

    await InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          isLoaded = false;
          log('InterstitialAd loaded $adUnitId');
          _interstitialAd = ad;
          _interstitialAd!.setImmersiveMode(true);
          if (loadedCallback != null) {
            loadedCallback();
          }
        },
        onAdFailedToLoad: (LoadAdError error) {
          isLoaded = false;
          log('InterstitialAd load fail $adUnitId $error');
          _interstitialAd = null;
          if (loadFailCallback != null) {
            loadFailCallback();
          }
        },
      ),
    );
  }

  Future<void> showInterstitialAd({
    Function? successCallback,
    Function? failCallback,
    Function? openCallback,
  }) async {
    if (!Config.isAdShow()) {
      return;
    }
    if (_interstitialAd == null) {
      log('InterstitialAd  Warning: attempt to show interstitial before loaded.');
      if (failCallback != null) {
        failCallback();
      }
      createShowInterstitialAd();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        log('InterstitialAd onAdShowedFullScreenContent');
        if (openCallback != null) {
          openCallback();
        }
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        log('InterstitialAd onAdDismissedFullScreenContent');
        if (successCallback != null) {
          successCallback();
        }
        ad.dispose();
        dispose();
        createShowInterstitialAd();
      },
      onAdClicked: (InterstitialAd ad) {},
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        if (failCallback != null) {
          failCallback();
        }
        log('InterstitialAd onAdFailedToShowFullScreenContent $error');
        ad.dispose();
        dispose();
        createShowInterstitialAd();
      },
    );

    _interstitialAd!.show();
  }

  void dispose() async {
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }
}

getInterstitialAdInstance(
  adUnitId, {
  Function(InterstitialAdCreator instance)? loadedCallback,
  Function()? loadFailCallback,
}) {
  InterstitialAdCreator instance = InterstitialAdCreator(adUnitId);
  log("InterstitialAd Instance $adUnitId create");
  instance.createShowInterstitialAd(
      loadedCallback: () => loadedCallback?.call(instance),
      loadFailCallback: loadFailCallback);
  return instance;
}
