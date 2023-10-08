import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' show Random;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification_bloc.dart';

class NotificationService {
  final _random = Random();
  NotificationService._internal();

  static final NotificationService instance = NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  FlutterLocalNotificationsPlugin get flutterLocalNotificationsPlugin =>
      _flutterLocalNotificationsPlugin;
  bool _started = false;
  final List<Function> _onMessageCallbacks = [];
  String? _deviceToken;
  String? get deviceToken => _deviceToken;

  // ********************************************************* //
  // YOU HAVE TO CALL THIS FROM SOMEWHERE (May be main widget)
  // ********************************************************* //
  void start() {
    if (!_started) {
      _integrateNotification();
      _refreshToken();
      _started = true;
    }
  }

  void _integrateNotification() {
    _registerNotification();
    _initializeLocalNotification();
  }

  Future<void> _registerNotification() async {
    _firebaseMessaging.requestPermission();
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('A new onMessageOpenedApp event was published!');
      Map<String, dynamic> msg = {
        'data': message.data,
      };
      _performActionOnNotification(msg);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      if (message.notification != null) {
        if (Platform.isAndroid) {
          _showNotification(message);
        }
        log('Message also contained a notification: ${message.notification?.toMap()}');
        // dispose();
      }
    });

    _firebaseMessaging.onTokenRefresh
        .listen(_tokenRefresh, onError: _tokenRefreshFailure);
  }

  void _showNotification(RemoteMessage message) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'Medic',
      'New Notification',
      priority: Priority.high,
      ticker: body(message),
      importance: Importance.max,
      showWhen: true,
      enableVibration: true,
      playSound: true,
      enableLights: true,
      visibility: NotificationVisibility.public,
      icon: '@drawable/ic_notification',
    );
    DarwinNotificationDetails iOSPlatformChannelSpecifics =
        const DarwinNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    //Logger.write("message.bodyLocArgs = ${message.bodyLocArgs}");
    await _flutterLocalNotificationsPlugin.show(
      _random.nextInt(1000000),
      title(message),
      body(message),
      platformChannelSpecifics,
      payload: json.encode(
        message.data,
      ),
    );
  }

  String title(RemoteMessage message) => message.notification?.title ?? "Medic";

  String body(RemoteMessage message) =>
      message.notification?.body ?? "You have new notification";

  void _initializeLocalNotification() {
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('@drawable/ic_notification');

    DarwinInitializationSettings iosInitializationSettings =
        const DarwinInitializationSettings();
    _flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        android: androidInitializationSettings,
        iOS: iosInitializationSettings,
      ),
      onDidReceiveNotificationResponse: _onSelectLocalNotification,
    );
  }

  Future _onSelectLocalNotification(NotificationResponse response) async {
    Map? data;
    if (response.payload != null) {
      data = json.decode(response.payload!);
    }
    Map<String, dynamic> message = {
      "data": data,
    };

    _performActionOnNotification(message);
    return null;
  }

  Future<void> getTokenAndUpdateCurrentUser() async {
    return _getFCMToken();
  }

  Future<void> _refreshToken() async {
    Future.delayed(const Duration(milliseconds: 900)).then((value) {
      _getFCMToken();
    });
  }

  void _getFCMToken() {
    _firebaseMessaging.getToken().then((token) async {
      log('fcm token: $token');
      _deviceToken = token;

      NotificationsBloc.instance.updateCurrentUserToken(token);
    }, onError: _tokenRefreshFailure);
  }

  void initializeController() {
    // notificationsBloc ??= Get.find();
  }
  Future<void> reGenerateFCMToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      //await _flutterLocalNotificationsPlugin.cancelAll();
      _deviceToken = null;
      // _refreshToken();
      log('Done', name: 'DELETED FCM TO DATABASE');
    } catch (e) {
      log(e.toString(), name: 'DELETED FCM TO DATABASE CATCH');
    }
  }

  void _tokenRefresh(String newToken) async {
    log('New Token : $newToken');
    _deviceToken = newToken;
    NotificationsBloc.instance.updateCurrentUserToken(newToken);
    // if (Utils.loggedInUserId != null) {
    //   DatabaseService(uid: Utils.loggedInUserId).updateUserFCMToken(newToken);
    // }
  }

  void _tokenRefreshFailure(error) {
    log("FCM token refresh failed with error $error");
  }

  void _performActionOnNotification(Map<String, dynamic> message) {
    NotificationsBloc.instance.newNotification(message);
  }

  void addOnMessageCallback(Function callback) {
    _onMessageCallbacks.add(callback);
  }

  void removeOnMessageCallback(Function callback) {
    _onMessageCallbacks.remove(callback);
  }

  Future<String?> getPayloadDetails() async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      return notificationAppLaunchDetails!.notificationResponse?.payload;
    }
    return null;
  }
}
