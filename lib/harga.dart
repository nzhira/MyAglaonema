import 'package:flutter/material.dart'; //impor library material design berisi yang widget dasar
import 'package:firebase_storage/firebase_storage.dart';

class HargaPage extends StatelessWidget { //mendefinisikan class
  static const String firebaseStorageBaseUrl = 'https://firebasestorage.googleapis.com/v0/b/scanaglao.appspot.com/o/';
  @override
  Widget build(BuildContext context) { //membangun tampilan HargaPage
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Harga Aglaonema',
          style: TextStyle(color: Colors.black), 
        ),
        backgroundColor: Colors.lightGreen, 
        leading: IconButton( //menambahkan tombol kembali
          icon: Icon(Icons.arrow_back), //ikon panah kembali
          onPressed: () { 
            Navigator.pop(context); //aksi untuk tombol kembali ke halaman sebelumnya
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          //kotak list pertama
          _buildListItem(
            context,
            'Aglaonema Suksom Jaipong', 
            '${firebaseStorageBaseUrl}suksom_jaipong.jpg?alt=media&token=f0f13794-d27a-4b00-93c6-988adc93ac35', 
            'Rp 50.000 - Rp 500.000', 
          ),
          SizedBox(height: 10), //jarak antar list
          //kotak list kedua
          _buildListItem(
            context,
            'Aglaonema Red Anjamani',
            '${firebaseStorageBaseUrl}red_anjamani.jpg?alt=media&token=d10c78c9-71dc-441d-873d-dbe80981bee2',
            'Rp 20.000 - Rp 100.000',
          ),
          SizedBox(height: 10), //jarak antar list
          //kotak list ketiga
          _buildListItem(
            context,
            'Aglaonema Dud Anjamani',
            '${firebaseStorageBaseUrl}dud_anjamani.jpg?alt=media&token=9efb59e5-9e8d-446b-b986-af704912a642',
            'RP 20.000 - Rp 100.000',
          ),
          SizedBox(height: 10), //jarak antar list
          //kotak list keempat
          _buildListItem(
            context,
            'Aglaonema Bigroy Putih',
            '${firebaseStorageBaseUrl}bigroy_putih.jpg?alt=media&token=22146a9d-1cc5-4dc3-bd7c-6112e2316b4d',
            'Rp 75.000 - Rp 500.000',
          ),
          SizedBox(height: 10), //jarak antar list
          //kotak list kelima
          _buildListItem(
            context,
            'Aglaonema Legacy Merah',
            '${firebaseStorageBaseUrl}legacy_merah.jpg?alt=media&token=d47b6aef-11b5-48aa-be98-226b3b383ab8',
            'Rp 50.000 - Rp 300.000',
          ),
          SizedBox(height: 10), //jarak antar list
          //kotak list keenam
          _buildListItem(
            context,
            'Aglaonema Siam Aurora',
            '${firebaseStorageBaseUrl}siam_aurora.jpg?alt=media&token=f6b10eb9-c8ec-40c2-af09-2c917eb3031c',
            'Rp 10.000 - Rp 50.000',
          ),
          SizedBox(height: 10), //jarak antar list
          //kotak list ketujuh
          _buildListItem(
            context,
            'Aglaonema Snow White',
            '${firebaseStorageBaseUrl}snow_white.jpg?alt=media&token=d12853cc-eb4e-4a06-ad0a-7ba1812ee9a0',
            'Rp 25.000 - Rp 100.000',
          ),
          SizedBox(height: 10), //jarak antar list
        ],
      ),
    );
  }

  //membuat kotak list
  Widget _buildListItem(BuildContext context, String title, String image, String price) { //mendefinisikan method
    return Container(
      decoration: BoxDecoration( 
        border: Border.all(color: Colors.grey), //menambahkan frame
      ),
      child: ListTile(
        title: Text(
          title,
          textAlign: TextAlign.center, //posisi teks di tengah
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          children: <Widget>[
            SizedBox(height: 10), //jarak antara judul dan gambar
            CircleAvatar(
              backgroundImage: NetworkImage(image), //gambar Aglaonema
              radius: 50, //ukuran gambar
            ),
            SizedBox(height: 10), //jarak antara gambar dan harga
            Text(
              price,
              textAlign: TextAlign.center, //posisi teks di tengah
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        onTap: () {
        },
      ),
    );
  }
}
