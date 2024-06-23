import 'package:flutter/material.dart'; //impor library material design berisi yang widget dasar

class PerawatanPage extends StatelessWidget { //mendefinisikan class
  @override
  Widget build(BuildContext context) { //membangun tampilan PerawatanPage
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text(
          'Cara Perawatan Aglaonema',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton( //tombol kembali
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); //aksi dari tombol kembali ke halaman sebelumnya
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: <Widget>[
            Text(
              '1. Aglaonema membutuhkan penyiraman yang rutin, tetapi tidak terlalu sering menyesuaikan dengan kelembapan tanah.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '2. Pastikan tanah tetap lembab, tetapi air tidak sampai menggenang di pot.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '3. Letakkan Aglaonema di tempat yang mendapatkan sinar matahari yang cukup tetapi tidak secara langsung.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '4. Gunakan media tanam dengan komposisi : Sekam Sangrai, Sekam Fregmentasi, Pasir Malang, Pakis, Andam, dan Cocoped.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '5. Berikan pupuk dan insektisida secukupnya agar Aglaonema tumbuh dengan baik.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '6. Pangkas daun-daun yang sudah layu atau mati untuk mencegah penyebaran penyakit.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '7. Periksa tanaman secara rutin untuk melihat adanya tanda-tanda hama atau penyakit.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '8. Hindari suhu yang terlalu dingin atau terlalu panas.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
