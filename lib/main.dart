import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart'; //impor library material design yang berisi widget dasar
import 'package:scanaglao/firebase_options.dart';
import 'splash.dart'; //impor file splash.dart yang berisi halaman splash
import 'dashboard.dart'; //impor file dashboard.dart yang berisi halaman dashboard

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  
  runApp(const MyApp()); //menjalankan aplikasi dengan widget MyApp
}

class MyApp extends StatelessWidget { //mendefinisikan class
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) { //membangun tampilan aplikasi
    return MaterialApp(
      title: 'Splash to Dashboard Demo',
      debugShowCheckedModeBanner: false, //menghilangkan banner debug 
      theme: ThemeData( //mengatur tema aplikasi
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/', //mengatur rute awal ke halaman splash
      routes: {
        '/': (context) => const SplashScreen(), //rute untuk halaman splash
        '/dashboard': (context) => const DashboardPage(), //rute untuk halaman dashboard
      },
    );
  }
}
