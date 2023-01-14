// 07:62:76:45:C4:2D:20:90:DA:04:BE:E4:DF:0C:FF:B1:93:7E:F8:DF

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {

  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static final StreamController<String> _messageStream = StreamController.broadcast();

  // suscribirse al stream
  static Stream<String> get messagesStream => _messageStream.stream;


  static Future<void> _backgroundHandler( RemoteMessage message ) async {
    //print( 'onBackground Handler ${ message.messageId }');
    print( message.data );
    _messageStream.add( message.data['product'] ?? 'No data');
  }

  static Future<void> _onMessageHandler( RemoteMessage message ) async {
    //print( 'onMessage Handler ${ message.messageId }');
    print( message.data );
    _messageStream.add( message.data['product'] ?? 'No data');
  }

  static Future<void> _onMessageOpenApp( RemoteMessage message ) async {
    //print( 'onMessageOpenApp Handler ${ message.messageId }');
    print( message.data );
    _messageStream.add( message.data['product'] ?? 'No data');
  }


  static Future  initializeApp() async {

    // Push Notifications
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    print('Token: $token');

    // Handlers
    FirebaseMessaging.onBackgroundMessage( _backgroundHandler );
    FirebaseMessaging.onMessage.listen( _onMessageHandler );
    FirebaseMessaging.onMessageOpenedApp.listen( _onMessageOpenApp );

    // Local Notifications
  }

  static closeStreams() {
    _messageStream.close();
  }

}