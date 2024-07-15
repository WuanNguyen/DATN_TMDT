import 'dart:io';
import 'dart:typed_data';

import 'package:doan_tmdt/model/classes.dart';
import 'package:doan_tmdt/screens/admin/admin_bottomnav.dart';
import 'package:doan_tmdt/screens/admin/admin_profileitem/admin_product_detail.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminListproduct extends StatefulWidget {
  const AdminListproduct({super.key});

  @override
  State<AdminListproduct> createState() => _AdminListproductState();
}

class _AdminListproductState extends State<AdminListproduct> {
  List<Product> products = [];
  Map<String, String> distributors = {};
  bool isLoading = true;
  String sortBy = 'Product_Name';
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
    fetchDistributors();
    sortProducts();
  }

  void sortProducts() {
    if (sortBy == 'Product_Name') {
      products.sort((a, b) => a.Product_Name!.compareTo(b.Product_Name!));
    } else if (sortBy == 'Category') {
      products.sort((a, b) => a.Category!.compareTo(b.Category!));
    } else if (sortBy == 'ID_Distributor') {
      products.sort((a, b) => a.ID_Distributor!.compareTo(b.ID_Distributor!));
    }
  }

  Future<void> fetchProducts() async {
    DatabaseReference productsRef =
        FirebaseDatabase.instance.ref().child('Products');

    DataSnapshot productsSnapshot = await productsRef.get();

    List<Product> tempProducts = [];
    for (var child in productsSnapshot.children) {
      tempProducts.add(Product.fromSnapshot(child));
    }

    setState(() {
      products = tempProducts;
      isLoading = false;
    });
  }

  Future<void> fetchDistributors() async {
    DatabaseReference distributorsRef =
        FirebaseDatabase.instance.ref().child('Distributors');

    DataSnapshot distributorsSnapshot = await distributorsRef.get();

    Map<String, String> tempDistributors = {};
    for (var child in distributorsSnapshot.children) {
      String id = child.key!;
      String name = child.child('Distributor_Name').value.toString();
      tempDistributors[id] = name;
    }

    setState(() {
      distributors = tempDistributors;
    });
  }

  Future<void> deleteProduct(String productId) async {
    DatabaseReference productRef =
        FirebaseDatabase.instance.ref().child('Products').child(productId);

    await productRef.update({'Status': 1});

    setState(() {
      products.removeWhere((product) => product.ID_Product == productId);
    });
  }

  Future<void> updateProductImage(
      String productId, List<String> imageUrl) async {
    DatabaseReference productRef =
        FirebaseDatabase.instance.ref().child('Products').child(productId);

    await productRef.update({'Image_Url': imageUrl});

    setState(() {
      int index =
          products.indexWhere((product) => product.ID_Product == productId);
      if (index != -1) {
        products[index].Image_Url = imageUrl;
      }
    });
  }

  Future<void> pickAndUploadImage(String productId) async {
    List<String> imageUrl = await pickAndUploadImagesToFirebase(productId);
    if (imageUrl.isNotEmpty) {
      await updateProductImage(productId, imageUrl);
    }
  }

  // upload ảnh-------------
  Future<List<String>> pickAndUploadImagesToFirebase(String idproduct) async {
    final List<XFile>? files = await ImagePicker().pickMultiImage();
    if (files == null || files.isEmpty) return [];

    List<String> newImageUrls = [];

    for (var file in files) {
      Uint8List imageData = await File(file.path).readAsBytes();
      String fileName =
          '$idproduct${DateTime.now().millisecondsSinceEpoch}.png';

      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDireImages =
          referenceRoot.child('Pictures_Product').child(idproduct);
      Reference referenceUpLoad = referenceDireImages.child(fileName);

      try {
        await referenceUpLoad.putData(
            imageData, SettableMetadata(contentType: 'image/png'));

        String downloadUrl = await referenceUpLoad.getDownloadURL();
        newImageUrls.add(downloadUrl);

        // Cập nhật trạng thái của widget chỉ khi widget vẫn còn tồn tại
        if (mounted) {
          setState(() {
            imageUrls.add(downloadUrl);
          });
        }
        print('Download URL: $downloadUrl');
      } catch (error) {
        print('Error uploading image to Firebase Storage: $error');
      }
    }

    return newImageUrls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products Management'),
        scrolledUnderElevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AdminBottomnav(index: 2)),
            );
          },
        ),
        backgroundColor: Color.fromRGBO(201, 241, 248, 1),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(201, 241, 248, 1),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 20),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        sortBy = 'Product_Name';
                        products.sort((a, b) =>
                            a.Product_Name!.compareTo(b.Product_Name!));
                      });
                    },
                    child: const Text('Sort by name'),
                  ),
                  const SizedBox(width: 5),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        sortBy = 'ID_Distributor';
                        sortProducts();
                      });
                    },
                    child: const Text('Sort by distributor'),
                  ),
                  const SizedBox(width: 5),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        sortBy = 'Category';
                        sortProducts();
                      });
                    },
                    child: const Text('Sort by Category'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
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
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        Product product = products[index];
                        String distributorName =
                            distributors[product.ID_Distributor] ?? 'Unknown';
                        return Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(59, 179, 177, 177),
                            border: Border.all(
                                color: Color.fromARGB(255, 131, 131, 131)),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if (product.Image_Url[0] != null)
                                    Image.network(
                                      product.Image_Url[0]!,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  const SizedBox(width: 120),
                                  TextButton(
                                    onPressed: () async {
                                      await pickAndUploadImage(
                                          product.ID_Product);
                                    },
                                    child: Text(
                                      'Edit Picture',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text('Product Name: ${product.Product_Name}',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text('Category: ${product.Category}'),
                              Text('Distributor: $distributorName'),
                              Text('___________________________'),
                              Text(
                                'Description: ${product.Description}',
                                maxLines: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailScreen(
                                                    product: product)),
                                      );
                                    },
                                    child: Text(
                                      'Details',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await deleteProduct(product.ID_Product);
                                    },
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
