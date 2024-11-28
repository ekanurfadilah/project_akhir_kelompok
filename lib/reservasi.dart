import 'package:flutter/material.dart';
import 'api_service.dart';
import 'profil.dart';
import 'informasi.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainPage(),
  ));
}

class ReservasiData {
  static List<String> unavailableTimes = []; // Menyimpan waktu yang sudah penuh
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    CafeInfoApp(),
    ProfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Menampilkan halaman berdasarkan index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex =
                index; // Mengubah halaman berdasarkan index yang dipilih
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notes),
            label: 'Informasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _selectedTimeZone = 'Pilih Zona Waktu';
  String _convertedTime = '';

  // Define the reference time as 11:00 WIB (Waktu Indonesia Barat)
  final TimeOfDay _referenceTimeWIB = TimeOfDay(hour: 11, minute: 0);

  // Function to convert time based on selected timezone
  void _convertTime() {
    setState(() {
      // TimeZone conversion based on selection
      if (_selectedTimeZone == 'WIT') {
        _convertedTime = _convertToWIT(_referenceTimeWIB);
      } else if (_selectedTimeZone == 'WITA') {
        _convertedTime = _convertToWITA(_referenceTimeWIB);
      } else if (_selectedTimeZone == 'London') {
        _convertedTime = _convertToLondon(_referenceTimeWIB);
      }
    });
  }

  // Convert to WIT (Waktu Indonesia Timur) - WIT is 2 hours ahead of WIB
  String _convertToWIT(TimeOfDay timeWIB) {
    final hour = (timeWIB.hour + 2) % 24; // Add 2 hours for WIT
    return _formatTime(hour, timeWIB.minute);
  }

  // Convert to WITA (Waktu Indonesia Tengah) - WITA is 1 hour ahead of WIB
  String _convertToWITA(TimeOfDay timeWIB) {
    final hour = (timeWIB.hour + 1) % 24; // Add 1 hour for WITA
    return _formatTime(hour, timeWIB.minute);
  }

  // Convert to London time - London is 7 hours behind WIB
  String _convertToLondon(TimeOfDay timeWIB) {
    final hour = (timeWIB.hour - 7 + 24) %
        24; // Subtract 7 hours for London, handle negative hours
    return _formatTime(hour, timeWIB.minute);
  }

  // Helper function to format TimeOfDay to HH:mm format
  String _formatTime(int hour, int minute) {
    final formattedHour = hour < 10 ? '0$hour' : '$hour';
    final formattedMinute = minute < 10 ? '0$minute' : '$minute';
    return '$formattedHour:$formattedMinute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 255, 0, 191),
              const Color.fromARGB(255, 255, 255, 255)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Selamat Datang ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Cafe buka dari 11:00 WIB',
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReservasiPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 8,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.restaurant_menu, color: Colors.black),
                    SizedBox(width: 10),
                    Text(
                      'Mulai Reservasi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              // Time zone conversion UI
              Text(
                'Lihat Konversi Waktu Jam Buka Cafe',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              DropdownButton<String>(
                value: _selectedTimeZone,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTimeZone = newValue!;
                    _convertTime(); // Trigger conversion after changing selection
                  });
                },
                items: <String>['Pilih Zona Waktu', 'WIT', 'WITA', 'London']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                iconEnabledColor: Colors.white, // Change dropdown icon color
                underline: Container(),
              ),
              SizedBox(height: 20),
              // Display converted times
              if (_selectedTimeZone != 'Pilih Zona Waktu') ...[
                Text(
                  'Konversi waktu 11:00 WIB ke $_selectedTimeZone:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Jam: $_convertedTime',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ReservasiPage extends StatefulWidget {
  @override
  _ReservasiPageState createState() => _ReservasiPageState();
}

class _ReservasiPageState extends State<ReservasiPage> {
  final _formKey = GlobalKey<FormState>();
  String? _namaPemesan, _noHP, _jumlahOrang, _waktuReservasi;
  bool _isPaymentPage = false;

  final List<Map<String, String>> waktuReservasi = [
    {'waktu': '11.00 - 13.30', 'status': 'available'},
    {'waktu': '13.35 - 16.05', 'status': 'available'},
    {'waktu': '16.10 - 18.40', 'status': 'available'},
    {'waktu': '18.45 - 21.15', 'status': 'available'},
  ];

  List<Widget> _buildAvailableTimes() {
    List<Widget> list = [];
    for (var waktu in waktuReservasi) {
      if (ReservasiData.unavailableTimes.contains(waktu['waktu'])) {
        list.add(ListTile(
          title: Text(
            waktu['waktu']!,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'Tidak Tersedia\n${waktu['waktu']}',
            style: TextStyle(color: Colors.red),
          ),
          trailing: Icon(Icons.close, color: Colors.red, size: 30),
        ));
      } else {
        list.add(ListTile(
          title: Text(
            waktu['waktu']!,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'Tersedia\n${waktu['waktu']}',
            style: TextStyle(color: Colors.green),
          ),
          trailing: Icon(Icons.check, color: Colors.green, size: 30),
        ));
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isPaymentPage
          ? _buildPaymentPage(context)
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Reservasi Hanya Dapat Dilakukan Dari 1 Hari Sebelumnya',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      _showReservasiForm(context);
                    },
                    child: Text('Pilih Waktu Reservasi',
                        style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF007BFF),
                      padding:
                          EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 6,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _showAvailableTimes(context);
                    },
                    child: Text('Lihat Waktu Tersedia',
                        style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                      padding:
                          EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 6,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MainPage()),
                        (route) => false, // Menghapus semua rute sebelumnya
                      );
                    },
                    icon: Icon(Icons.arrow_back,
                        size: 20,
                        color: Colors.white), // Ikon back dengan warna putih
                    label: Text(
                      'Kembali',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ), // Teks putih dan bold
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          Colors.transparent, // Teks dan ikon menjadi putih
                      padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8), // Ukuran tombol lebih kecil
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20), // Bentuk tombol lebih unik
                      ),
                      elevation: 0, // Menghilangkan bayangan
                    ),
                  ),
                ],
              ),
            ),
      backgroundColor: Colors.black87,
    );
  }

  void _showReservasiForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Pilih Waktu Reservasi',
          style: TextStyle(
            color: Color(0xFF007BFF),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nama Pemesan',
                    labelStyle: TextStyle(color: Colors.black87),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF007BFF)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  onSaved: (value) => _namaPemesan = value,
                  validator: (value) {
                    if (value!.isEmpty) return 'Nama Pemesan wajib diisi';
                    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                      return 'Nama Pemesan hanya boleh berisi huruf';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'No HP',
                    labelStyle: TextStyle(color: Colors.black87),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF007BFF)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  onSaved: (value) => _noHP = value,
                  validator: (value) {
                    if (value!.isEmpty) return 'No HP wajib diisi';
                    if (!RegExp(r'^\d+$').hasMatch(value)) {
                      return 'No HP hanya boleh berisi angka';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Jumlah Orang (3-10)',
                    labelStyle: TextStyle(color: Colors.black87),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF007BFF)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _jumlahOrang = value,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Jumlah orang wajib diisi';
                    }
                    final intVal = int.tryParse(value);
                    if (intVal == null) {
                      return 'Jumlah orang harus berupa angka';
                    }
                    if (intVal < 3 || intVal > 10) {
                      return 'Jumlah orang harus antara 3-10';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Pilih Waktu Reservasi',
                    labelStyle: TextStyle(color: Colors.black87),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF007BFF)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  value: _waktuReservasi,
                  onChanged: (newValue) => setState(() {
                    _waktuReservasi = newValue;
                  }),
                  items: [
                    '11.00 - 13.30',
                    '13.35 - 16.05',
                    '16.10 - 18.40',
                    '18.45 - 21.15'
                  ]
                      .map((e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      if (ReservasiData.unavailableTimes
                          .contains(_waktuReservasi)) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Waktu Tidak Tersedia'),
                            content: Text('Ganti waktu, waktu tidak tersedia.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        ReservasiData.unavailableTimes.add(_waktuReservasi!);
                        setState(() {
                          _isPaymentPage = true;
                        });
                      }
                    }
                  },
                  child: Text('Selanjutnya'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 35, 89, 169),
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rincian Reservasi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 8,
            shadowColor: Colors.black26,
            color: Color.fromARGB(255, 255, 255, 255),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    icon: Icons.person,
                    label: 'Nama Pemesan',
                    value: '$_namaPemesan',
                  ),
                  Divider(color: Colors.white24, thickness: 1),
                  _buildInfoRow(
                    icon: Icons.phone,
                    label: 'No HP',
                    value: '$_noHP',
                  ),
                  Divider(color: Colors.white24, thickness: 1),
                  _buildInfoRow(
                    icon: Icons.group,
                    label: 'Jumlah Orang',
                    value: '$_jumlahOrang',
                  ),
                  Divider(color: Colors.white24, thickness: 1),
                  _buildInfoRow(
                    icon: Icons.access_time,
                    label: 'Waktu Reservasi',
                    value: '$_waktuReservasi',
                  ),
                ],
              ),
            ),
          ),
          Text(
            '\n Berikan Nama Pemesan dan No HP kepada Petugas Restoran, Saat Akan Mengajukan Pemesanan Reservasi!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the "Pesan Makanan" page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PesanMakananPage()),
                );
              },
              child: Text(
                'Pesan Makanan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFF007BFF),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: Color.fromARGB(255, 0, 0, 0), size: 28),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: Color(0xFF007BFF),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAvailableTimes(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Waktu Tersedia dan Tidak Tersedia',
          style:
              TextStyle(color: Color(0xFF007BFF), fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
            child: Column(children: _buildAvailableTimes())),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Tutup', style: TextStyle(color: Color(0xFF007BFF))),
          ),
        ],
      ),
    );
  }
}

class PesanMakananPage extends StatefulWidget {
  @override
  _PesanMakananPageState createState() => _PesanMakananPageState();
}

class _PesanMakananPageState extends State<PesanMakananPage> {
  List<Map<String, dynamic>> menuList = [];
  List<Map<String, dynamic>> orderedFood = [];

  @override
  void initState() {
    super.initState();
    ApiService().fetchMenu().then((menu) {
      setState(() {
        menuList = menu;
      });
    });
  }

  void _onItemSelected(Map<String, dynamic> item, bool selected) {
    setState(() {
      if (selected) {
        // Add item with default quantity 1
        orderedFood.add({...item, 'quantity': 1});
      } else {
        // Remove item if it is deselected
        orderedFood
            .removeWhere((orderedItem) => orderedItem['name'] == item['name']);
      }
    });
  }

  void showQuantityDialog(Map<String, dynamic> item) {
    TextEditingController quantityController = TextEditingController();
    quantityController.text = item['quantity'].toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Masukkan Jumlah untuk ${item['name']}'),
          content: TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Jumlah'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  // Update kuantitas item di orderedFood
                  int newQuantity = int.tryParse(quantityController.text) ?? 0;

                  // Update item in orderedFood by matching the item 'name'
                  var index = orderedFood.indexWhere(
                      (orderedItem) => orderedItem['name'] == item['name']);
                  if (index != -1) {
                    // If item exists in orderedFood, update its quantity
                    orderedFood[index]['quantity'] = newQuantity;
                  } else {
                    // If the item is not found, add it with the new quantity
                    orderedFood.add({...item, 'quantity': newQuantity});
                  }
                });
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Simpan'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without changes
              },
              child: Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Pilih Makanan',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: menuList.length,
                itemBuilder: (context, index) {
                  final item = menuList[index];
                  bool isSelected = orderedFood.any(
                      (orderedItem) => orderedItem['name'] == item['name']);
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading:
                          Image.network(item['image'], width: 50, height: 50),
                      title: Text(item['name']),
                      subtitle: Text('Rp ${item['price']}'),
                      trailing: Checkbox(
                        value: isSelected,
                        onChanged: (selected) {
                          _onItemSelected(item, selected ?? false);
                        },
                      ),
                      onTap: () {
                        if (isSelected) {
                          showQuantityDialog(item);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the reservation/payment page and pass orderedFood
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentPage(orderedFood: orderedFood),
                  ),
                );
              },
              child: Text('Simpan pesanan'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFF007BFF),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentPage extends StatelessWidget {
  final List<Map<String, dynamic>> orderedFood;

  PaymentPage({required this.orderedFood});

  @override
  Widget build(BuildContext context) {
    // Calculate the total cost of the food
    int totalFoodCost = orderedFood.fold(0, (total, item) {
      // Ensure 'price' and 'quantity' are both valid integers
      int price = item['price'] is int ? item['price'] : 0;
      int quantity = item['quantity'] is int ? item['quantity'] : 0;
      return total + (price * quantity);
    });

    // Fixed reservation fee
    int reservationFee = 85000;

    // Total payment including reservation fee
    int totalPayment = totalFoodCost + reservationFee;

    return Scaffold(
      appBar: AppBar(
        title: Text('Rincian Pembayaran'),
        backgroundColor: Color(0xFF007BFF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rincian Pesanan',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: orderedFood.length,
                itemBuilder: (context, index) {
                  final item = orderedFood[index];
                  // Make sure 'quantity' is available, otherwise default to 1
                  int quantity = item['quantity'] ?? 1;
                  return ListTile(
                    title: Text(item['name']),
                    subtitle: Text('Rp ${item['price']} x $quantity'),
                    trailing: Text('Rp ${item['price'] * quantity}'),
                  );
                },
              ),
            ),
            Divider(),
            // Display total food cost
            Text('Total Makanan: Rp $totalFoodCost',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            // Reservation fee
            Text('Biaya Reservasi Tempat: Rp $reservationFee',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            // Display the total payment including reservation fee
            Text('Total Pembayaran: Rp $totalPayment',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the currency conversion page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CurrencyConversionPage(totalPayment: totalPayment),
                  ),
                );
              },
              child: Text('Proses Pembayaran'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFF007BFF),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurrencyConversionPage extends StatefulWidget {
  final int totalPayment;

  CurrencyConversionPage({required this.totalPayment});

  @override
  _CurrencyConversionPageState createState() => _CurrencyConversionPageState();
}

class _CurrencyConversionPageState extends State<CurrencyConversionPage> {
  // Conversion rates from Rupiah (IDR) to other currencies
  final Map<String, double> conversionRates = {
    'MYR': 0.00029, // Malaysian Ringgit
    'USD': 0.000066, // US Dollar
    'SAR': 0.00025, // Saudi Riyal
    'KRW': 0.088, // South Korean Won
    'CNY': 0.00046, // Chinese Yuan
  };

  String selectedCurrency = 'MYR';
  double convertedAmount = 0.0;

  @override
  void initState() {
    super.initState();
    // Initial conversion
    convertedAmount = widget.totalPayment * conversionRates[selectedCurrency]!;
  }

  void updateConvertedAmount(String currency) {
    setState(() {
      selectedCurrency = currency;
      convertedAmount = widget.totalPayment * conversionRates[currency]!;
    });
  }

  void showPaymentSuccess(BuildContext context) {
    // Show success notification
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pembayaran Berhasil!'),
        duration: Duration(seconds: 2),
      ),
    );

    // Navigate to ReservasiPage after the notification
    Future.delayed(Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReservasiPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Proses Pembayaran'),
        backgroundColor: Color(0xFF007BFF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Pembayaran: Rp ${widget.totalPayment}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Konversi ke: $selectedCurrency',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Jumlah: ${convertedAmount.toStringAsFixed(2)} $selectedCurrency',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedCurrency,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  updateConvertedAmount(newValue);
                }
              },
              items: conversionRates.keys
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            // Card with Mandiri account details
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.account_balance, color: Color(0xFF007BFF)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Transfer ke Mandiri No Rek 002100124220088',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Button for confirming payment
            ElevatedButton(
              onPressed: () => showPaymentSuccess(context),
              child: Text('Sudah Bayar'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFF007BFF),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
