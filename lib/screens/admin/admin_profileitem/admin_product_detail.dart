import 'package:doan_tmdt/model/dialog_notification.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:doan_tmdt/model/classes.dart';
import 'package:intl/intl.dart';

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

  // Quản lý kho nhập------------------------------------
  Future<void> addInventory_in(
      String idpro,
      String proname,
      String cate,
      String iddis,
      int impr,
      int selpr,
      int qtity,
      String siz,
      String maxinven) async {
    final DatabaseReference _databaseReference =
        FirebaseDatabase.instance.reference();

    DataSnapshot snapshot = await _databaseReference
        .child('Max')
        .child('MaxInventory_in')
        .child(maxinven)
        .get();

    int currentUID = snapshot.exists ? snapshot.value as int : 0;
    int newUID = currentUID + 1;
    String UIDC = 'in_$siz$newUID';
    await _databaseReference
        .child('Warehouse')
        .child('Inventory_in')
        .child(UIDC)
        .set(
      {
        'ID_Product': idpro,
        'Product_Name': proname,
        'Date_In': DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
        'Distributor_Name': iddis,
        'Category': cate,
        'Import_Price': impr,
        'Sell_Price': selpr,
        'Quantity': qtity,
        'size': siz
      },
    );
    await _databaseReference
        .child('Max')
        .child('MaxInventory_in')
        .child(maxinven)
        .set(newUID);
  }

  // Quản lý xuất kho------------------------------------
  Future<void> addInventory_out(
    String idpro,
    String proname,
    String cate,
    String iddis,
    int impr,
    int selpr,
    int qtity,
    String siz,
  ) async {
    final DatabaseReference _databaseReference =
        FirebaseDatabase.instance.reference();

    DataSnapshot snapshot =
        await _databaseReference.child('Max').child('MaxInventory_out').get();

    int currentUID = snapshot.exists ? snapshot.value as int : 0;
    int newUID = currentUID + 1;
    String UIDC = 'out_$siz$newUID';
    await _databaseReference
        .child('Warehouse')
        .child('Inventory_out')
        .child(UIDC)
        .set(
      {
        'ID_Product': idpro,
        'Product_Name': proname,
        'Date_In': DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
        'Distributor_Name': iddis,
        'Category': cate,
        'Import_Price': impr,
        'Sell_Price': selpr,
        'Quantity': qtity,
        'size': siz
      },
    );
    await _databaseReference.child('Max').child('MaxInventory_out').set(newUID);
  }

  //------------------------------------tồn kho
  Future<void> updateInventory(
      String idpro,
      String proname,
      String cate,
      String iddis,
      int impr,
      int selpr,
      int stock,
      String siz,
      String maxinven) async {
    final DatabaseReference _databaseReference =
        FirebaseDatabase.instance.reference();

    // Tạo ID tồn kho dựa trên ID sản phẩm và kích thước
    maxinven = '$idpro' '_' '$siz';

    // Cập nhật thông tin tồn kho
    await _databaseReference
        .child('Warehouse')
        .child('Inventory')
        .child(maxinven)
        .update({
      'Import_Price': impr,
      'Sell_Price': selpr,
      'Quantity': stock,
    });
  }

  // lấy nhà phân phối
  Future<Distributors> getDistributorInfo(String distributorId) async {
    DatabaseReference distributorRef = FirebaseDatabase.instance
        .ref()
        .child('Distributors')
        .child(distributorId);
    DataSnapshot snapshot = await distributorRef.get();

    if (snapshot.exists) {
      return Distributors.fromSnapshot(snapshot);
    } else {
      throw Exception("Distributor not found");
    }
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

    // Lấy thông tin chi tiết kích thước hiện tại
    ProductSizeDetail currentSize = sizeKey == 'S'
        ? productSize.S
        : sizeKey == 'M'
            ? productSize.M
            : productSize.L;

    // Cập nhật chi tiết kích thước sản phẩm
    await sizeRef.update({
      'SellPrice': newSize.SellPrice,
      'Discount': newSize.Discount,
      'Stock': newSize.Stock,
      'ImportPrice': newSize.ImportPrice,
      'Status': newSize.Status,
    });
    var distributorInfo = await getDistributorInfo(
      widget.product.ID_Distributor,
    );
    // Kiểm tra và xử lý thêm hoặc xuất kho
    if (newSize.Stock > currentSize.Stock) {
      int quantityToAdd = newSize.Stock - currentSize.Stock;
      await addInventory_in(
        widget.product.ID_Product,
        widget.product.Product_Name,
        widget.product.Category,
        distributorInfo.Distributor_Name,
        newSize.ImportPrice,
        newSize.SellPrice,
        quantityToAdd,
        sizeKey,
        'in_$sizeKey',
      );
    } else if (newSize.Stock < currentSize.Stock) {
      int quantityToRemove = currentSize.Stock - newSize.Stock;
      await addInventory_out(
        widget.product.ID_Product,
        widget.product.Product_Name,
        widget.product.Category,
        distributorInfo.Distributor_Name,
        newSize.ImportPrice,
        newSize.SellPrice,
        quantityToRemove,
        sizeKey,
      );
    }

    // Cập nhật lại thông tin kích thước sản phẩm trong tồn kho
    await updateInventory(
        widget.product.ID_Product,
        widget.product.Product_Name,
        widget.product.Category,
        distributorInfo
            .Distributor_Name, // Thay 'distributorId' bằng ID nhà phân phối thực tế
        newSize.ImportPrice,
        newSize.SellPrice,
        newSize.Stock,
        sizeKey,
        'maxInventoryId' // Thay 'maxInventoryId' bằng ID thực tế của MaxInventory
        );

    // Cập nhật lại thông tin kích thước sản phẩm
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

  String formatCurrency(int value) {
    final formatter = NumberFormat.decimalPattern('vi');
    return formatter.format(value);
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
          : Container(
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
                  Text(
                    'Product Name: ${widget.product.Product_Name}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text('Category: ${widget.product.Category}'),
                  Text(
                    'Description: ${widget.product.Description}',
                    maxLines: 8,
                  ),
                  SizedBox(height: 20),
                  Text('Sizes:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView(
                      children: [
                        if (productSize.S.Status == 0)
                          buildSizeDetail('S', productSize.S),
                        if (productSize.M.Status == 0)
                          buildSizeDetail('M', productSize.M),
                        if (productSize.L.Status == 0)
                          buildSizeDetail('L', productSize.L),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildSizeDetail(String sizeKey, ProductSizeDetail sizeDetail) {
    return Card(
      color: Color.fromARGB(84, 255, 255, 255),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text('Size $sizeKey'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Import Price: ${formatCurrency(sizeDetail.ImportPrice)} VND'),
            Text('Sell Price: ${formatCurrency(sizeDetail.SellPrice)} VND'),
            Text('Discount: ${formatCurrency(sizeDetail.Discount)} VND'),
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
