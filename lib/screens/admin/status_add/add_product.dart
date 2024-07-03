import 'package:doan_tmdt/model/classes.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  Query Distributors_dbRef = FirebaseDatabase.instance.ref().child('Distributors');

  List<Distributors> distributors = [];

  String? select_category;
  String? select_distributor;
  int curDisID = 0;

  @override
  void initState(){
    Distributors_dbRef.onValue.listen((event) {
      if(this.mounted){
        setState(() {
          distributors = event.snapshot.children.map((snapshot){
            return Distributors.fromSnapshot(snapshot);
          }).where((element) => element.Status == false).toList();
          select_distributor = distributors.isNotEmpty? distributors[0].Distributor_Name : null;
        });
      }
    });
  }



  List<String> categorys = [
    "Adult",
    "Children",
  ];
  //List<String> Distributors = ["Ecom", "Yong Yong"];

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
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: InkWell(
                  onTap: () {},
                  child: Image.network(
                    'https://firebasestorage.googleapis.com/v0/b/tmdt-bangiay.appspot.com/o/images%2Fcat.jpg?alt=media&token=ee7848ba-9db3-4dfd-8109-7dff8eebc416',
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      obscureText: false,
                      decoration: const InputDecoration(
                        labelText: "Enter product name",
                        labelStyle: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(
                            20), // Giới hạn 20 ký tự
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          obscureText: false,
                          decoration: const InputDecoration(
                            labelText: "Price",
                            labelStyle: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(
                                20), // Giới hạn 20 ký tự
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          obscureText: false,
                          decoration: const InputDecoration(
                            labelText: "size",
                            labelStyle: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          obscureText: false,
                          decoration: const InputDecoration(
                            labelText: "Quantity",
                            labelStyle: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      obscureText: false,
                      decoration: const InputDecoration(
                        labelText: "Description",
                        labelStyle: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(
                            200), // Giới hạn 20 ký tự
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<String>(
                          value: select_category,
                          onChanged: (catenew) {
                            setState(() {
                              select_category = catenew!;
                            });
                          },
                          items: categorys.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            labelText: "Category",
                            labelStyle: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<String>(
                          value: select_distributor,
                          onChanged: (disnew) {
                            setState(() {
                              select_distributor = disnew!;
                              print("Distrubutos Name: ${(distributors.firstWhere((element) => element.Distributor_Name.toString() == select_distributor).Distributor_Name.toString())}"); 
                              print("Distrubutos ID: ${int.parse(distributors.firstWhere((element) => element.Distributor_Name.toString() == select_distributor).ID_Distributor.toString())}");                             
                            });
                          },
                          items: distributors.map((Distributors distributor) {
                            return DropdownMenuItem<String>(
                              value: distributor.Distributor_Name,
                              child: Text(distributor.Distributor_Name),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            labelText: "Distributor",
                            labelStyle: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      obscureText: false,
                      decoration: const InputDecoration(
                        labelText: "Discount",
                        labelStyle: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(
                            20), // Giới hạn 20 ký tự
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(150, 50),
                        elevation: 8,
                        shadowColor: Colors.white),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => const LoginScreen()),
                      // );
                    },
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(150, 50),
                        elevation: 8,
                        shadowColor: Colors.white),
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => const RegisterScreen()),
                      // );
                    },
                  )
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
