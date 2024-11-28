import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  // List nama dan harga yang sesuai dengan gambar
  final List<String> menuNames = [
    'Steak jumbo',
    'Ayam Pop',
    'Ice cream',
    'Steak medium',
    'Panino',
    'Kentang Goreng',
    'Steak Ayam',
    'Sushi',
    'Paket sehat',
    'Ratatouille',
    'salted egg chicken rice',
    'Paket arab',
    'pancake',
    'Rendang'
  ];

  final List<int> menuPrices = [
    140000,
    45000,
    25000,
    100000,
    50000,
    40000,
    50000,
    40000,
    60000,
    100000,
    50000,
    150000,
    40000,
    60000
  ];

  Future<List<Map<String, dynamic>>> fetchMenu() async {
    final response = await http.get(Uri.parse('$_baseUrl/categories.php'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> categories = data['categories'];

      // Pastikan jumlah gambar tidak lebih banyak dari jumlah nama dan harga
      final List<Map<String, dynamic>> menu = [];

      for (int i = 0; i < categories.length && i < menuNames.length; i++) {
        menu.add({
          'name': menuNames[i], // Menggunakan nama dari list menuNames
          'image': categories[i]['strCategoryThumb'], // Gambar diambil dari API
          'price': menuPrices[i], // Menggunakan harga dari list menuPrices
        });
      }

      return menu;
    } else {
      throw Exception('Failed to load menu');
    }
  }
}
