import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:medic/controller/user_controller.dart';
import 'package:medic/model/user_model.dart';
import 'package:medic/utils/app_storage.dart';

class NotificationsBloc {
  bool _sendBufferedEvents = true;
  Map<String, dynamic>? _bufferedEvent;

  NotificationsBloc._internal() {
    _notificationStreamController.onListen = _onListen;
  }

  static final NotificationsBloc instance = NotificationsBloc._internal();

  Stream<Map<String, dynamic>?> get notificationStream =>
      _notificationStreamController.stream;
  final _notificationStreamController =
      StreamController<Map<String, dynamic>?>.broadcast();

  /// Called when `_notificationStreamController` gets first subscriber.
  ///
  /// We need to do this for onLaunch Notification.
  ///
  /// When we click the notification (when app is completely closed) `_notificationStreamController` will add event before it gets any subscriber.
  ///
  /// So we will cache the event before it gets first subscriber.
  ///
  /// In other scenario `_notificationStreamController` will have atleast one subscriber.
  _onListen() {
    if (_sendBufferedEvents) {
      if (_bufferedEvent != null) {
        _notificationStreamController.sink.add(_bufferedEvent);
      }
      _sendBufferedEvents = false;
    }
  }

  void newNotification(Map<String, dynamic> notification) {
    if (_sendBufferedEvents) {
      _bufferedEvent = notification;
    } else {
      _notificationStreamController.sink.add(notification);
    }
  }

  void dispose() {
    _notificationStreamController.close();
  }

  void updateCurrentUserToken(String? newToken) async {
    // TODO: update user fcm (post method fcm)

    if (!isLoggedIn()) {
      return;
    }
    if (newToken != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(Get.find<UserController>().loggedInUser.value!.id)
            .update({'fcmToken': newToken});
      } catch (e) {
        log('$e');
      }
    }
  }

  bool isLoggedIn() {
    UserModel? userData = AppStorage().getUserData();

    return userData != null;
  }

  static void onNotification(onNotificationListen) {
    NotificationsBloc.instance.notificationStream.listen(
        (Map<String, dynamic>? event) => onNotificationListen(event),
        onDone: () {});
  }
}
