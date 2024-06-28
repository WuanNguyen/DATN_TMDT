import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Delivery extends StatelessWidget {
  const Delivery({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> status_orders = [
      {
        'nameproduct': 'HD Klorist',
        'category': 'Adult',
        'price': '100000',
        'image':
            'https://i.pinimg.com/736x/e9/3c/2a/e93c2ac0194c53610dfeea86edd1e702.jpg',
        'date': 'February 2 at 11:29'
      },
    ];

    return Container(
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
          itemCount: status_orders.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 233, 249, 255),
                border:
                    Border.all(color: const Color.fromARGB(255, 203, 202, 202)),
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
                      status_orders[index]['image']!,
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
                            status_orders[index]['nameproduct']!,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            status_orders[index]['category']!,
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            status_orders[index]['price']!,
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
                        const SizedBox(
                          height: 70,
                        ),
                        Text(
                          status_orders[index]['date']!,
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
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
    );
  }
}
