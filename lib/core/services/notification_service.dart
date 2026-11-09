import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../app_keys.dart';
import '../../firebase_options.dart';
import 'package:flutter/material.dart';


  @pragma('vm:entry-point')
  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint('[BACKGROUND] ${message.notification?.title}');
  debugPrint('[BACKGROUND] ${message.notification?.body}');
}
class NotificationService {


  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Meminta izin notifikasi dan mengembalikan statusnya:
  /// authorized | provisional | denied | notDetermined
  Future<AuthorizationStatus> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('Notification permission: ${settings.authorizationStatus.name}');
    return settings.authorizationStatus;
  }


  Future<String?> getToken() async {
    final token = await _messaging.getToken();
    debugPrint('FCM Token: $token');
    return token;
  }

  /// Token dapat berubah, sehingga perubahan perlu didengarkan.
  void listenTokenRefresh(void Function(String token) onRefresh) {
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint('FCM Token diperbarui');
      onRefresh(newToken);
    });
  }
  // tambahkan ke NotificationService
// (import 'package:supabase_flutter/supabase_flutter.dart';)
Future<void> saveTokenToSupabase(String token) async {
  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) return;

  await Supabase.instance.client.from('device_tokens').upsert({
    'token': token,
    'user_id': user.id,
    'platform': defaultTargetPlatform.name,
    'updated_at': DateTime.now().toUtc().toIso8601String(),
  });
}

Future<void> init() async {
  await requestPermission();

  final token = await getToken();
  if (token != null) await saveTokenToSupabase(token); // opsional
  listenTokenRefresh(saveTokenToSupabase); // opsional

  // iOS: tampilkan banner saat aplikasi di foreground
  await _messaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // FOREGROUND: aplikasi sedang terbuka
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('[FOREGROUND] Notification received');
    debugPrint('title: ${message.notification?.title}');
    debugPrint('body : ${message.notification?.body}');
    debugPrint('data : ${message.data}');

    // Android tidak menampilkan notifikasi sistem saat foreground,
    // jadi tampilkan sendiri di dalam aplikasi.
    final title = message.notification?.title ?? 'Notifikasi';
    final body = message.notification?.body ?? '';
    messengerKey.currentState?.showSnackBar(
      SnackBar(content: Text('$title\n$body')),
    );
  });
}


}
