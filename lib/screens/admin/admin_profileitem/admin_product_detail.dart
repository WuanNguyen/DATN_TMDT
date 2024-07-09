import 'package:doan_tmdt/model/dialog_notification.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:doan_tmdt/model/classes.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late ProductSize productSize;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProductSize();
  }

  Future<void> fetchProductSize() async {
    DatabaseReference productSizeRef = FirebaseDatabase.instance
        .ref()
        .child('ProductSizes')
        .child(widget.product.ID_Product);

    DataSnapshot productSizeSnapshot = await productSizeRef.get();

    setState(() {
      productSize = ProductSize.fromSnapshot(productSizeSnapshot);
      isLoading = false;
    });
  }

  Future<void> updateProductSize(
      String sizeKey, ProductSizeDetail newSize) async {
    DatabaseReference sizeRef = FirebaseDatabase.instance
        .ref()
        .child('ProductSizes')
        .child(widget.product.ID_Product)
        .child(sizeKey);

    await sizeRef.update({
      'SellPrice': newSize.SellPrice,
      'Discount': newSize.Discount,
      'Stock': newSize.Stock,
      'ImportPrice': newSize.ImportPrice,
      'Status': newSize.Status,
    });

    setState(() {
      if (sizeKey == 'S') {
        productSize.S = newSize;
      } else if (sizeKey == 'M') {
        productSize.M = newSize;
      } else if (sizeKey == 'L') {
        productSize.L = newSize;
      }
    });
  }

  Future<void> deleteProductSize(String sizeKey) async {
    DatabaseReference sizeRef = FirebaseDatabase.instance
        .ref()
        .child('ProductSizes')
        .child(widget.product.ID_Product)
        .child(sizeKey);

    await sizeRef.update({'Status': 1});

    setState(() {
      if (sizeKey == 'S') {
        productSize.S.Status = 1;
      } else if (sizeKey == 'M') {
        productSize.M.Status = 1;
      } else if (sizeKey == 'L') {
        productSize.L.Status = 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        title: Text(widget.product.Product_Name),
        backgroundColor:
            const Color.fromRGBO(201, 241, 248, 1), // Custom app bar color
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Product Name: ${widget.product.Product_Name}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    Text('Category: ${widget.product.Category}'),
                    Text('Description: ${widget.product.Description}'),
                    SizedBox(height: 20),
                    Text('Sizes:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    if (productSize.S.Status == 0)
                      buildSizeDetail('S', productSize.S),
                    if (productSize.M.Status == 0)
                      buildSizeDetail('M', productSize.M),
                    if (productSize.L.Status == 0)
                      buildSizeDetail('L', productSize.L),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildSizeDetail(String sizeKey, ProductSizeDetail sizeDetail) {
    return Card(
      color: Color.fromARGB(255, 229, 249, 255),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text('Size $sizeKey'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Import Price: ${sizeDetail.ImportPrice}'),
            Text('Sell Price: ${sizeDetail.SellPrice}'),
            Text('Discount: ${sizeDetail.Discount}'),
            Text('Stock: ${sizeDetail.Stock}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                ProductSizeDetail? newSizeDetail =
                    await admin_showPro.showEditDialog(context, sizeDetail);
                if (newSizeDetail != null) {
                  await updateProductSize(sizeKey, newSizeDetail);
                }
              },
            ),
            TextButton(
              onPressed: () async {
                await deleteProductSize(sizeKey);
              },
              child: Text(
                'Delete',
                style: TextStyle(
                    color: Colors.black), // Custom color for delete text
              ),
            ),
          ],
        ),
      ),
    );
  }
}
