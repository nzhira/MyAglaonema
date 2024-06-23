import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart'; //impor library material design berisi yang widget dasar
import 'package:path_provider/path_provider.dart';
import 'dashboard.dart'; //impor file dashboard.dart yang berisi halaman dashboard

class SplashScreen extends StatefulWidget { //mendefinisikan class
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState(); 
}

class _SplashScreenState extends State<SplashScreen> { //mendefinisikan class
  @override
  void initState()  { //memuat data pertama kali
    super.initState(); 
    Future.delayed(const Duration(seconds: 3), () { //menunda eksekusi kode selama 3 detik
      Navigator.pushReplacement( //navigasi ke halaman dashboard
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()), //rute navigasi ke halaman dashboard
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( //membangun layout aplikasi
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/aglaonema.png', 
              width: MediaQuery.of(context).size.width * 0.6, //lebar gambar 60% dari layar perangkat
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 24), //menambahkan jarak antara gambar dan teks
            const Text(
              'MyAglaonema',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
