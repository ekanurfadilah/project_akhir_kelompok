import 'package:flutter/material.dart';

void main() {
  runApp(CafeInfoApp());
}

class CafeInfoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CafeInfoPage(),
    );
  }
}

class CafeInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Informasi Cafe",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoTile(
              icon: Icons.access_time,
              title: "Jam Buka Cafe",
              subtitle: "11.00 WIB - 21.30 WIB",
            ),
            Divider(color: Colors.grey[300]),
            _buildInfoTile(
              icon: Icons.calendar_today,
              title: "Reservasi",
              subtitle:
                  "Reservasi hanya bisa mulai dilakukan 1 hari sebelum reservasi.",
            ),
            Divider(color: Colors.grey[300]),
            _buildInfoTile(
              icon: Icons.timer,
              title: "Durasi Reservasi",
              subtitle:
                  "Waktu reservasi adalah 2 jam 30 menit. Jika lebih dari itu, reservasi di jam berikutnya.",
            ),
            Divider(color: Colors.grey[300]),
            _buildInfoTile(
              icon: Icons.restaurant_menu,
              title: "Syarat Reservasi",
              subtitle:
                  "Customer harus memesan makanan juga untuk syarat reservasi.",
            ),
            Spacer(),
            Center(
              child: Text(
                "Selamat menikmati pelayanan kami!",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(
      {required IconData icon,
      required String title,
      required String subtitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.black, size: 28),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
