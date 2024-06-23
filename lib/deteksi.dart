import 'dart:io'; //interaksi dengan sistem operasi
import 'dart:developer'; // melihat log
import 'package:firebase_remote_config/firebase_remote_config.dart'; // menggunakan Firebase Remote Config
import 'package:firebase_storage/firebase_storage.dart'; // menggunakan Firebase Storage
import 'package:flutter/material.dart'; // impor library material design berisi widget dasar
import 'package:camera/camera.dart'; // untuk akses kamera
import 'package:permission_handler/permission_handler.dart'; // untuk mengatur izin
import 'package:tflite_v2/tflite_v2.dart'; // model machine learning
import 'package:path_provider/path_provider.dart'; // untuk akses direktori aplikasi

class Result { // mendefinisikan class untuk menyimpan hasil prediksi
  final String label; // label hasil prediksi
  final double confidence; // tingkat kepercayaan

  Result({
    required this.label,
    required this.confidence,
  });
}

class DeteksiView extends StatefulWidget { // mendefinisikan class
  const DeteksiView({Key? key}) : super(key: key);

  @override
  State<DeteksiView> createState() => _DeteksiViewState();
}

class _DeteksiViewState extends State<DeteksiView> {
  late CameraController _cameraController;
  bool _showResult = false; // status tampilan hasil prediksi
  bool _isLoading = false; // status sedang memuat
  bool _isCameraInitialized = false; // status kamera sudah diinisialisasi atau belum
  String _modelType = ''; // jenis model yang digunakan
  double _confidence = 0.0; // tingkat kepercayaan hasil prediksi

  @override
  void initState() {
    super.initState();
    initCamera(); // inisialisasi kamera saat memulai
    testDownload(); // unduh model dan label dari Firebase
  }

  Future<void> testDownload() async {
    setState(() {
      _isLoading = true; // set sedang memuat
    });

    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1), // waktu maksimum untuk unduh
      minimumFetchInterval: const Duration(hours: 1), // interval minimum antara unduh
    ));

    await remoteConfig.fetchAndActivate(); // ambil dan aktifkan konfigurasi

    String labelName = remoteConfig.getString('label_name'); // nama label dari remote config
    String modelName = remoteConfig.getString('model_name'); // nama model dari remote config

    String path = '/storage/emulated/0/Scanaglao'; // path untuk menyimpan model dan label
  
    await Permission.manageExternalStorage.request(); // minta izin untuk mengelola penyimpanan eksternal

    var stickDirectory = Directory(path);
    await stickDirectory.create(recursive: true); // buat direktori jika belum ada

    final storageRef = FirebaseStorage.instance.ref();

    try {
      // unduh dan simpan model
      final islandRefModel = storageRef.child("$modelName");
      final filePathModel = "${stickDirectory.path}/$modelName";
      final fileModel = File(filePathModel);
      await islandRefModel.writeToFile(fileModel);

      // unduh dan simpan label
      final islandRefLabel = storageRef.child("$labelName");
      final filePathLabel = "${stickDirectory.path}/$labelName";
      final fileLabel = File(filePathLabel);
      await islandRefLabel.writeToFile(fileLabel);

      loadModel(modelName, labelName); // muat model setelah unduh selesai
    } catch (e) {
      log('Error downloading model and label: $e'); // tangani kesalahan jika unduhan gagal
    }
  }

  Future<void> initCamera() async {
    WidgetsFlutterBinding.ensureInitialized(); // memastikan plugin Flutter telah diinisialisasi
    final cameras = await availableCameras(); // dapatkan daftar kamera yang tersedia
    if (cameras.isNotEmpty) {
      _cameraController = CameraController(cameras[0], ResolutionPreset.high); // atur resolusi kamera
      try {
        await _cameraController.initialize(); // inisialisasi kamera
        setState(() {
          _isCameraInitialized = true; // set status kamera telah diinisialisasi
        });
      } catch (e) {
        log("Error initializing camera: $e"); // menangani kesalahan jika gagal menginisialisasi kamera
      }
    } else {
      log("No cameras available"); // menangani kasus jika tidak ada kamera yang tersedia
    }
  }

  Future<void> loadModel(String modelName, String labelName) async {
    try {
      await Tflite.loadModel(
        isAsset: false, // menggunakan model yang diunduh
        model: '/storage/emulated/0/Scanaglao/$modelName', // path model yang diunduh
        labels: '/storage/emulated/0/Scanaglao/$labelName', // path label yang diunduh
      );
    } catch (e) {
      log('Error loading model: $e'); // menangani kesalahan jika gagal memuat model
    }
    setState(() {
      _isLoading = false; // set sedang memuat menjadi false
    });
  }

  Future<String> takePicture() async {
    final Directory directory = await getTemporaryDirectory(); // dapatkan direktori sementara
    final String dirPath = "${directory.path}/TANAMAN"; // path untuk menyimpan gambar
    await Directory(dirPath).create(recursive: true); // buat direktori jika belum ada
    final String filePath = "$dirPath/${DateTime.now()}.jpg"; // path untuk menyimpan foto
    try {
      final XFile? image = await _cameraController.takePicture(); // ambil foto dari kamera
      await image!.saveTo(filePath); // simpan foto ke path yang ditentukan
      return filePath;
    } catch (e) {
      log("Error : ${e.toString()}"); // tangani kesalahan jika gagal mengambil foto
      return '';
    }
  }

  Future<void> predictUsingTFLite(String imagePath) async {
    try {
      final List<dynamic>? dynamicResults = await Tflite.runModelOnImage(
        path: imagePath, // path gambar yang akan diproses
        imageMean: 0.0,
        imageStd: 255.0,
        numResults: 2,
        threshold: 0.2,
      );
      setState(() {
        if (dynamicResults != null && dynamicResults.isNotEmpty) {
          final List<Result> results = dynamicResults
              .map((dynamic result) => Result(
                    label: result['label'] as String,
                    confidence: result['confidence'] as double,
                  ))
              .toList();

          if (results.isNotEmpty) {
            _modelType = results[0].label; // set label hasil prediksi
            _confidence = results[0].confidence; // set tingkat kepercayaan hasil prediksi
            _showResult = true; // tampilkan hasil prediksi
          }
        }
      });
    } catch (e) {
      log("Error: $e"); // tangani kesalahan jika gagal melakukan prediksi
    }
  }

  Future<void> takePictureAndPredict() async {
    if (!_cameraController.value.isTakingPicture) { // pastikan kamera tidak sedang mengambil gambar
      final String pathDir = await takePicture(); // ambil gambar dari kamera
      log("hasil : ${pathDir}"); // log hasil path gambar yang diambil
      await predictUsingTFLite(pathDir); // lakukan prediksi menggunakan TensorFlow Lite
    }
  }

  void resetState() {
    setState(() {
      _showResult = false; // reset status tampilan hasil prediksi
      _modelType = ''; // reset jenis model
      _confidence = 0.0; // reset tingkat kepercayaan
    });
  }

  @override
  void dispose() {
    _cameraController.dispose(); // atur kamera agar tidak digunakan lagi
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Deteksi Jenis Aglaonema', // judul aplikasi
          style: TextStyle(color: Colors.black), // atur gaya teks
        ),
        backgroundColor: Colors.lightGreen, // atur warna latar belakang app bar
      ),
      body: Column(
        children: [
          Expanded(
            child: !_isLoading // pastikan sedang tidak memuat
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height *
                              1 /
                              (_cameraController.value.aspectRatio ?? 1.0),
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: CameraPreview(_cameraController), // tampilkan preview kamera
                        ),
                      ),
                      SizedBox(height: 20),
                      _showResult
                          ? Column(
                              children: [
                                Text(
                                  "Hasil", // judul hasil prediksi
                                  style: TextStyle(
                                    fontFamily: "InterMedium",
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height:
                                10),
                                Text(
                                  "$_modelType", // tampilkan jenis model hasil prediksi
                                  style: TextStyle(
                                    fontFamily: "InterMedium",
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "${(_confidence * 100).toStringAsFixed(2)}%", // tampilkan tingkat kepercayaan hasil prediksi
                                  style: TextStyle(
                                    fontFamily: "InterMedium",
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 20),
                                InkWell(
                                  onTap: () {
                                    resetState(); // reset status tampilan hasil prediksi
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.9,
                                    padding:
                                        EdgeInsets.symmetric(vertical: 13.5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(22),
                                      color: Colors.lightGreen,
                                    ),
                                    child: Text(
                                      "Ambil Gambar Lagi", // tombol untuk mengambil gambar lagi
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: "InterMedium",
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : InkWell(
                              onTap: takePictureAndPredict, // aksi saat tombol ditekan
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                padding: EdgeInsets.symmetric(vertical: 13.5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22),
                                  color: Colors.lightGreen,
                                ),
                                child: Text(
                                  "Ambil Gambar", // tombol untuk mengambil gambar
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "InterMedium",
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(), // indikator loading saat sedang memuat
                  ),
          ),
        ],
      ),
    );
  }
}
