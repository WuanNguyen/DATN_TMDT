import 'package:flutter/material.dart';

class FavoritesList extends StatefulWidget {
  const FavoritesList({super.key});

  @override
  State<FavoritesList> createState() => _FavoritesListState();
}

class _FavoritesListState extends State<FavoritesList> {
  final List<Map<String, String>> favorites = [
    {
      'nameproduct': 'HD Klorist',
      'category': 'Adult',
      'price': '100000',
      'image':
          'https://i.pinimg.com/736x/e9/3c/2a/e93c2ac0194c53610dfeea86edd1e702.jpg'
    },
    {
      'nameproduct': 'LiverPool2024',
      'category': 'Adult',
      'price': '200000',
      'image':
          'https://i.pinimg.com/736x/e9/3c/2a/e93c2ac0194c53610dfeea86edd1e702.jpg'
    },
    {
      'nameproduct': 'HD Klorist',
      'category': 'Adult',
      'price': '100000',
      'image':
          'https://i.pinimg.com/736x/e9/3c/2a/e93c2ac0194c53610dfeea86edd1e702.jpg'
    },
    {
      'nameproduct': 'LiverPool2024',
      'category': 'Adult',
      'price': '200000',
      'image':
          'https://i.pinimg.com/736x/e9/3c/2a/e93c2ac0194c53610dfeea86edd1e702.jpg'
    },
    {
      'nameproduct': 'HD Klorist',
      'category': 'Adult',
      'price': '100000',
      'image':
          'https://i.pinimg.com/736x/e9/3c/2a/e93c2ac0194c53610dfeea86edd1e702.jpg'
    },
    {
      'nameproduct': 'LiverPool2024',
      'category': 'Adult',
      'price': '200000',
      'image':
          'https://i.pinimg.com/736x/e9/3c/2a/e93c2ac0194c53610dfeea86edd1e702.jpg'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorites list',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromRGBO(201, 241, 248, 1),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1, 0.8, 1],
                colors: <Color>[
                  Color.fromRGBO(201, 241, 248, 1),
                  Color.fromRGBO(231, 230, 233, 1),
                  Color.fromRGBO(231, 227, 230, 1),
                ],
                tileMode: TileMode.mirror,
              ),
            ),
            child: Container(
              width: double.infinity,
              child: ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 233, 249, 255),
                      border: Border.all(
                          color: const Color.fromARGB(255, 203, 202, 202)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.network(
                            favorites[index]['image']!,
                            height: 100,
                            width: 100,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  favorites[index]['nameproduct']!,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  favorites[index]['category']!,
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  favorites[index]['price']!,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Hành động khi nhấn nút
                                  //print('Button ${distributors[index]['title']} pressed');
                                },
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Hành động khi nhấn nút
                                  //print('Button ${distributors[index]['title']} pressed');
                                },
                                child: const Icon(
                                  Icons.add_shopping_cart,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
