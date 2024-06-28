import 'package:flutter/material.dart';

class AddDiscount extends StatefulWidget {
  const AddDiscount({super.key});

  @override
  State<AddDiscount> createState() => _AddDiscountState();
}

class _AddDiscountState extends State<AddDiscount> {
  final List<Map<String, String>> discounts = [
    {'price': '1000', 'description': 'giảm 1k khi mua đơn từ 50k'},
    {'price': '2000', 'description': 'giảm 2k khi mua đơn từ 1000k'},
    {'price': '3000', 'description': 'giảm 3k khi mua đơn từ 150k'},
    {'price': '4000', 'description': 'giảm 4k khi mua đơn từ 200k'},
    {'price': '5000', 'description': 'giảm 5k khi mua đơn từ 250k'},
  ];

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: discounts.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 233, 249, 255),
                      border: Border.all(
                          color: const Color.fromARGB(255, 203, 202, 202)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              discounts[index]['price']!,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              discounts[index]['description']!,
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Hành động khi nhấn nút
                            //print('Button ${distributors[index]['title']} pressed');
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Add discount',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
