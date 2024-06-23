import 'package:flutter/material.dart'; //impor library material design berisi yang widget dasar
import 'deteksi.dart'; //impor file deteksi.dart yang berisi halaman deteksi aglaonema
import 'perawatan.dart'; //impor file perawatan.dart yang berisi halaman cara perawatan aglaonema
import 'harga.dart'; //impor file harga.dart yang berisi halaman harga aglaonema

class DashboardPage extends StatelessWidget { //mendefinisikan widget
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) { //membangun tampilan DashboardPage
    return Scaffold(
      appBar: AppBar(
        title: Text('MyAglaonema', style: TextStyle(fontWeight: FontWeight.bold)), //judul AppBar dengan font tebal
        backgroundColor: Colors.lightGreen, //warna background AppBar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, //mengatur posisi utama widget
          children: <Widget>[
            SizedBox(height: 35), //menambah ruang di atas gambar untuk menaikkannya
            Image.asset(
              'assets/images/aglaonema.png',
              width: 250,
              height: 250,
            ),
            SizedBox(height: 15), //menambah ruang antara gambar dan teks
            Text( //menambahkan teks
              'Apa yang sedang ingin Anda cari?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black), //gaya teks
            ),
            SizedBox(height: 30), //menambah ruang antara teks dan tombol pertama
            ElevatedButton( //membuat tombol
              onPressed: () { //aksi ketika tombol ditekan
                Navigator.push( //mengarahkan ke halaman selanjutnya
                  context,
                  MaterialPageRoute(builder: (context) => DeteksiView()), //rute navigasi ke halaman Deteksi
                );
              },
              child: Text('Deteksi Aglaonema'),
            ),
            SizedBox(height: 10), //menambah ruang antara tombol pertama dan kedua
            ElevatedButton( //membuat tombol
              onPressed: () { //aksi ketika tombol ditekan
                Navigator.push( //mengarahkan ke halaman selanjutnya
                  context,
                  MaterialPageRoute(builder: (context) => PerawatanPage()), //rute navigasi ke halaman Perawatan
                );
              },
              child: Text('Cara Perawatan Aglaonema'),
            ),
            SizedBox(height: 10), //menambah ruang antara tombol kedua dan ketiga
            ElevatedButton( //membuat tombol
              onPressed: () { //aksi ketika tombol ditekan
                Navigator.push( //mengarahkan ke halaman selanjutnya
                  context,
                  MaterialPageRoute(builder: (context) => HargaPage()), //rute navigasi ke halaman harga
                );
              },
              child: Text('Harga Aglaonema'),
            ),
            SizedBox(height: 20), //menambah ruang di bawah tombol terakhir
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar( //ikon navigasi di layar bawah
        color: Colors.lightGreen, //warna background BottomAppBar
        child: Row( //tata letak horizontal
          mainAxisAlignment: MainAxisAlignment.center, //widget di tengah
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home, color: Colors.black), //ikon tombol beranda
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
