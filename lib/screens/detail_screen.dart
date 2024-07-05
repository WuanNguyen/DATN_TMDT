import 'package:doan_tmdt/model/classes.dart';
import 'package:doan_tmdt/screens/detail_items/rating.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen({super.key, required this.pro});
  Product pro;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _databaseReference = FirebaseDatabase.instance.reference();
  int currentUID = 0;
  String SizeClick = "S";
  //////////////////////////////////////////
  Query ProductSizes_dbRef =
      FirebaseDatabase.instance.ref().child('ProductSizes');
  List<ProductSize> sizes = [];

  late ProductSize size;
  int price = 0;
  int discount = 0;
  int sizeBtn = 0;
//add cart---------------------------------------------------------------
  Future<void> addProductToCart() async {
    SizeFilter();
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Lấy dữ liệu từ Firebase
      final DatabaseEvent snapshot = await _databaseReference
          .child('Max')
          .child('MaxCart')
          .child(currentUser.uid)
          .child('MaxID')
          .once();

      // Xử lý dữ liệu
      final currentValue = snapshot.snapshot.value;
      int currentID =
          currentValue != null ? int.parse(currentValue.toString()) : 0;
      final newID = currentID + 1;
      String UIDC = 'Cart$newID';

      // Lưu dữ liệu vào Firebase///////////////////////////////////////////////////////////mai sử lý
      await _databaseReference
          .child('Carts')
          .child(currentUser.uid)
          .child(UIDC)
          .set({
        'ID_Cart': UIDC,
        'ID_Product': widget.pro?.ID_Product, // Add null check
        'ID_ProductSize': SizeClick,
        'Quantity': 1,
        'Stt': 0,
      });
      // Cập nhật UID lớn nhất
      await _databaseReference
          .child('Max')
          .child('MaxCart')
          .child(currentUser.uid)
          .child('MaxID')
          .set(newID);
      // Hiển thị thông báo
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Product added to cart'),
        backgroundColor: Color.fromARGB(255, 152, 152, 152),
      ));
    } else {
      // Xử lý trường hợp người dùng chưa đăng nhập
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please sign in first'),
        backgroundColor: Colors.red,
      ));
    }
  }
// Future<void> UpdateDiscount() async {
//       //------------------------------------------------
//       //update
//       final DatabaseReference _databaseReference =
//           FirebaseDatabase.instance.reference();
//       //
//       DataSnapshot snapshot =
//           await _databaseReference.child('Max').child('MaxDiscount').get();

//       int currentUID = snapshot.exists ? snapshot.value as int : 0;
//       int newUID = currentUID + 1;
//       //
//       await _databaseReference.child('Discounts').child(newUID.toString()).set({
//         'Price': priceText.text,
//         'Description': descText.text,
//         'Required': requiredText.text,
//         'Uses': usesText,
//         'Status': 0
//       });
//       // Cập nhật UID lớn nhất
//       await _databaseReference.child('Max').child('MaxDiscount').set(newUID);

//       //

//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text(
//           'added discount successfully',
//           style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
//         ),
//         backgroundColor: Color.fromARGB(255, 125, 125, 125),
//       ));
//     }
//-----------------------------------------------------------------------------
  @override
  void initState() {
    ProductSizes_dbRef.onValue.listen((event) {
      if (this.mounted) {
        setState(() {
          sizes = event.snapshot.children.map((snapshot) {
            return ProductSize.fromSnapshot(snapshot);
          }).toList();
          size = sizes.firstWhere(
              (element) => element.L.ID_Product == widget.pro.ID_Product);
          price = size.S.SellPrice;
          discount = size.S.Discount;
        });
      }
    });
  }

  void SizeFilter() {
    if (sizeBtn == 0) {
      // size S
      price = size.S.SellPrice;
      discount = size.S.Discount;
    }
    if (sizeBtn == 1) {
      // size M
      price = size.M.SellPrice;
      discount = size.M.Discount;
    }
    if (sizeBtn == 2) {
      // size L
      price = size.L.SellPrice;
      discount = size.L.Discount;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            scrolledUnderElevation: 0.0,
            backgroundColor: const Color.fromRGBO(201, 241, 248, 1),
            leading: Container(
              decoration: BoxDecoration(
                //color:Color.fromRGBO(63, 55, 86, 0.32),
                shape: BoxShape.circle,
              ),
              child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios_new, color: Colors.black)),
            )),
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
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
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                    // hinh anh
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    width: MediaQuery.of(context).size.height / 3,
                    height: MediaQuery.of(context).size.height / 3,
                    child: Image.network(widget.pro.Image_Url,
                        fit: BoxFit.cover) //image (fit: BoxFit.cover)
                    ),
                Container(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    height: MediaQuery.of(context).size.height -
                        (MediaQuery.of(context).size.height / 3) -
                        130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50)),
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            children: [
                              Container(
                                //ten, gia tien va danh gia
                                width: MediaQuery.of(context).size.width - 197,
                                padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.pro.Product_Name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Text(
                                      "${price} VND",
                                      style: TextStyle(
                                          decoration: discount > 0
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none),
                                    ),
                                    if (discount > 0)
                                      Text(
                                        "${price - discount} VND",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromRGBO(
                                                232, 174, 17, 1)),
                                      ),
                                    Rating(rate: 3.5)

                                    //todo: rating
                                  ],
                                ),
                              ),
                              GestureDetector(
                                //button
                                onTap: () {
                                  print("Added to cart");
                                  addProductToCart();
                                },
                                child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    padding:
                                        EdgeInsets.fromLTRB(10, 12, 20, 12),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(45),
                                        color:
                                            Color.fromRGBO(239, 237, 237, 1)),
                                    child: Row(
                                      children: [
                                        Icon(Icons.add_shopping_cart_rounded),
                                        Text("Add to cart")
                                      ],
                                    )),
                              )
                            ],
                          ),
                          Column(
                            // size
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Size",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                              Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
                              Row(
                                // size button
                                children: [
                                  OutlinedButton(
                                      onPressed: () {
                                        SizeClick = "S";
                                        setState(() {
                                          sizeBtn = 0;
                                          SizeFilter();
                                        });
                                      },
                                      style: ButtonStyle(
                                        side: WidgetStatePropertyAll(BorderSide(
                                            width: sizeBtn == 0 ? 2.0 : 0.5)),
                                      ),
                                      child: Text("S",
                                          style:
                                              TextStyle(color: Colors.black))),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  ),
                                  OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          SizeClick = "M";
                                          sizeBtn = 1;
                                          SizeFilter();
                                        });
                                      },
                                      style: ButtonStyle(
                                        side: WidgetStatePropertyAll(BorderSide(
                                            width: sizeBtn == 1 ? 2.0 : 0.5)),
                                      ),
                                      child: Text("M",
                                          style:
                                              TextStyle(color: Colors.black))),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  ),
                                  OutlinedButton(
                                      onPressed: () {
                                        SizeClick = "L";
                                        setState(() {
                                          sizeBtn = 2;
                                          SizeFilter();
                                        });
                                      },
                                      style: ButtonStyle(
                                        side: WidgetStatePropertyAll(BorderSide(
                                            width: sizeBtn == 2 ? 2.0 : 0.5)),
                                      ),
                                      child: Text("L",
                                          style:
                                              TextStyle(color: Colors.black))),
                                ],
                              )
                            ],
                          ),
                          SingleChildScrollView(
                              //phan mo ta
                              physics: NeverScrollableScrollPhysics(),
                              child: Container(
                                margin: EdgeInsets.fromLTRB(0, 15, 7, 0),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Description",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    Text(widget.pro.Description),
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 10))
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ));
  }
}
