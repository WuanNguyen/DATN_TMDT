import 'package:flutter/material.dart';

class AddDistributor extends StatefulWidget {
  const AddDistributor({super.key});

  @override
  State<AddDistributor> createState() => _AddDistributorState();
}

class _AddDistributorState extends State<AddDistributor> {
  final List<Map<String, String>> distributors = [
    {
      'name': 'Ecom',
      'gmail': 'ecom@gmail.com',
      'address': 'Q1,HCM',
      'phone': '0335242444'
    },
    {
      'name': 'Ecom',
      'gmail': 'ecom@gmail.com',
      'address': 'Q1,HCM',
      'phone': '0335242444'
    },
    {
      'name': 'Ecom',
      'gmail': 'ecom@gmail.com',
      'address': 'Q1,HCM',
      'phone': '0335242444'
    },
    {
      'name': 'Ecom',
      'gmail': 'ecom@gmail.com',
      'address': 'Q1,HCM',
      'phone': '0335242444'
    },
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
      child: Container(
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
                  itemCount: distributors.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 233, 249, 255),
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
                                distributors[index]['name']!,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                distributors[index]['gmail']!,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                distributors[index]['address']!,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                distributors[index]['phone']!,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                            ],
                          ),
                          Column(
                            children: [
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
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Hành động khi nhấn nút
                                  //print('Button ${distributors[index]['title']} pressed');
                                },
                                child: const Text(
                                  'Edit',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          )
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
                      'Add Distributor',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
