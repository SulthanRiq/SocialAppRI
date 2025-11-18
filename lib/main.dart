import 'package:flutter/material.dart';

void main() {
  // Fungsi utama yang pertama kali dijalankan
  runApp(const MyApp()); // Menjalankan widget MyApp
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Widget utama dari aplikasi
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Judul aplikasi
      title: 'Flutter Demo',

      // Tema aplikasi
      theme: ThemeData(
        // Membuat warna tema berdasarkan seedColor
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true, // Menggunakan Material Design versi 3
      ),

      // Halaman pertama yang ditampilkan saat aplikasi dibuka
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // Variabel title untuk ditampilkan di AppBar
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// State dari MyHomePage → tempat menyimpan data yang bisa berubah
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0; // Variabel untuk menyimpan angka

  // Fungsi untuk menambah angka counter
  void _incrementCounter() {
    setState(() {
      // setState memberi tahu Flutter agar UI di-update
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Membangun UI halaman
    return Scaffold(
      // BAGIAN ATAS APLIKASI
      appBar: AppBar(
        // Warna background AppBar berdasarkan tema
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        // Judul AppBar berasal dari widget.title
        title: Text(widget.title),
      ),

      // BAGIAN TENGAH / BODY APLIKASI
      body: Center(
        // Center = meletakkan child di tengah
        child: Column(
          // Column = menata widget secara vertikal
          mainAxisAlignment: MainAxisAlignment.center, // posisi di tengah
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),

            // Menampilkan angka counter
            Text(
              '$_counter', // Mengambil nilai counter
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),

      // TOMBOL BULAT DI KANAN BAWAH
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter, // Jalankan fungsi tambah counter
        tooltip: 'Increment', // Tooltip saat tombol ditekan
        child: const Icon(Icons.add), // Ikon tanda +
      ),
    );
  }
}
