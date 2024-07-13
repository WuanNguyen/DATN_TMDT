import 'package:doan_tmdt/model/classes.dart';
import 'package:doan_tmdt/screens/detail_items/rating.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen({super.key, required this.pro});
  Product pro;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final TextEditingController Rev = TextEditingController();
  Future<Users>? _futureUser;
  bool check = false; // Khai báo biến check ở cấp độ lớp
  bool checkrw = false; // Khai báo biến checkrw ở cấp độ lớp
  final _databaseReference = FirebaseDatabase.instance.reference();
  int currentUID = 0;
  String SizeClick = "S";
  int quantitytitleProduct = 1;
  bool isFav = false;
  List<Users> users = [];

  //danh gia cua user hien tai
  TextEditingController ProductReview = TextEditingController();
  double Rate = 1;

  String getIDProduct() {
    return widget.pro.ID_Product;
  }

  DatabaseReference userRef = FirebaseDatabase.instance
      .ref()
      .child('Users')
      .child(FirebaseAuth.instance.currentUser!.uid);

  //////////////////////////////////////////
  Query ProductSizes_dbRef =
      FirebaseDatabase.instance.ref().child('ProductSizes');
  late DatabaseReference Review_dbRef;
  List<ProductSize> sizes = [];

  List<Review> reviews = [];

  late ProductSize size;
  int price = 0;
  int discount = 0;
  int sizeBtn = 0;

  // đánh giá----------------------------------------------------

  //bool danhgia = false;

  //--------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
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

    Review_dbRef = FirebaseDatabase.instance
        .ref()
        .child('Reviews')
        .child(widget.pro.ID_Product);
    fetchReviews();

    //dánh giá-------------------------
    String idpro = getIDProduct();
    String id = getUserUID();
    print(id + idpro);

    // Gọi hàm kiểm tra trạng thái đã mua sản phẩm và đã đánh giá
    checkPurchaseStatus(id, idpro);
    checkReviewStatus(id, idpro);
    //---------------------------------
    _futureUser = getUserInfo(id);
  }

  Future<Users> getUserInfo(String userId) async {
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('Users').child(userId);
    DataSnapshot snapshot = await userRef.get();
    return Users.fromSnapshot(snapshot);
  }

  // Hàm kiểm tra đã mua sản phẩm
  Future<void> checkPurchaseStatus(String id, String idpro) async {
    bool hasPurchased = await _hasUserPurchasedProduct(id, idpro);
    if (mounted) {
      setState(() {
        check = hasPurchased;
      });
    }
  }

  // Hàm kiểm tra đã đánh giá sản phẩm
  Future<void> checkReviewStatus(String id, String idpro) async {
    bool hasReviewed = await _hasUserReviewedProduct(id, idpro);
    if (mounted) {
      setState(() {
        checkrw = hasReviewed;
      });
    }
  }

  // Hàm kiểm tra người dùng đã mua sản phẩm hay chưa
  Future<bool> _hasUserPurchasedProduct(String userId, String productId) async {
    DatabaseReference orderRef = FirebaseDatabase.instance.ref().child('Order');
    DataSnapshot snapshot =
        await orderRef.orderByChild('ID_User').equalTo(userId).get();

    for (var order in snapshot.children) {
      String orderId = order.key!;
      DataSnapshot orderSnapshot = await orderRef.child(orderId).get();

      if (orderSnapshot.child('Order_Status').value == 'dagiao') {
        DataSnapshot orderDetailSnapshot = await FirebaseDatabase.instance
            .ref()
            .child('OrderDetail')
            .child(orderId)
            .get();

        for (var orderDetail in orderDetailSnapshot.children) {
          if (orderDetail.child('ID_Product').value == productId) {
            return true;
          }
        }
      }
    }
    return false;
  }

  // Hàm kiểm tra người dùng đã đánh giá sản phẩm hay chưa
  Future<bool> _hasUserReviewedProduct(String userId, String productId) async {
    DatabaseReference orderRef = FirebaseDatabase.instance.ref().child('Order');
    DataSnapshot snapshot =
        await orderRef.orderByChild('ID_User').equalTo(userId).get();

    for (var order in snapshot.children) {
      DataSnapshot reviwesSnapshot = await FirebaseDatabase.instance
          .ref()
          .child('Reviews')
          .child(productId)
          .get();

      for (var review in reviwesSnapshot.children) {
        if (review.child('ID_User').value == userId) {
          return true;
        }
      }
    }
    return false;
  }

  //--------------------------------Push data Reviews
  Future<void> addReview(
      String idpro, String comm, String idu, int rat, String nameu) async {
    //------------------------------------------------
    //update
    final DatabaseReference _databaseReference =
        FirebaseDatabase.instance.reference();
    //
    DataSnapshot snapshot = await _databaseReference
        .child('Max')
        .child('Review')
        .child(idpro)
        .get();

    int currentUID = snapshot.exists ? snapshot.value as int : 0;
    int newUID = currentUID + 1;
    String UIDC = 'Review$newUID';
    //
    await _databaseReference.child('Reviews').child(idpro).child(UIDC).set({
      'Comment': comm,
      'ID_Product': idpro,
      'ID_Review': UIDC,
      'ID_User': idu,
      'Rating': rat,
      'Review_Date': DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
      'Status': 0,
      'Username': nameu
    });
    // Cập nhật UID lớn nhất
    await _databaseReference
        .child('Max')
        .child('Review')
        .child(idpro)
        .set(newUID);

    //

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Successful product reviews',
        style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
      ),
      backgroundColor: Color.fromARGB(255, 125, 125, 125),
    ));
  }
  //0-----------------------------------------------------------------

  // Các phương thức khác của widget

  //--------------------------------------------

  Future<void> _checkIfFavorite() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final favoriteSnapshot = await _databaseReference
          .child('Favorites')
          .child(currentUser.uid)
          .child(widget.pro.ID_Product)
          .get();

      if (favoriteSnapshot.exists) {
        setState(() {
          isFav = true;
        });
      }
    }
  }

  Future<void> addFavorite(String idproduct) async {
    String id_user = getUserUID();
    if (isFav) {
      await _databaseReference
          .child('Favorites')
          .child(id_user)
          .child(idproduct)
          .remove();
      setState(() {
        isFav = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Removed from favorites'),
        backgroundColor: const Color.fromARGB(255, 153, 153, 153),
      ));
    } else {
      final DatabaseReference _databaseReference =
          FirebaseDatabase.instance.reference();
      //
      DataSnapshot snapshot = await _databaseReference
          .child('Max')
          .child('MaxFavorite')
          .child(id_user)
          .child('MaxID')
          .get();

      int currentUID = snapshot.exists ? snapshot.value as int : 0;
      int newUID = currentUID + 1;
      String UIDC = 'Favorite$newUID';
      //
      await _databaseReference
          .child('Favorites')
          .child(id_user)
          .child(idproduct)
          .set({
        'ID_Product': idproduct,
        'Status': 0,
      });
      // Cập nhật UID lớn nhất
      await _databaseReference
          .child('Max')
          .child('MaxFavorite')
          .child(id_user)
          .child('MaxID')
          .set(newUID);

      setState(() {
        isFav = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Successfully added to favorites',
          style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: Color.fromARGB(255, 125, 125, 125),
      ));
    }
  }

  String getUserUID() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) return user.uid.toString();
    return "";
  }

  Future<void> addProductToCart() async {
    SizeFilter();
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      bool isOutOfStock = false;
      if (sizeBtn == 0 && (size.S.Stock == 0 || size.S.Status == 1)) {
        isOutOfStock = true;
      } else if (sizeBtn == 1 && (size.M.Stock == 0 || size.M.Status == 1)) {
        isOutOfStock = true;
      } else if (sizeBtn == 2 && (size.L.Stock == 0 || size.L.Status == 1)) {
        isOutOfStock = true;
      }

      if (isOutOfStock) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Selected size is out of stock'),
          backgroundColor: const Color.fromARGB(255, 124, 124, 124),
        ));
        return;
      }

      final cartSnapshot = await _databaseReference
          .child('Carts')
          .child(currentUser.uid)
          .orderByChild('ID_Product')
          .equalTo(widget.pro.ID_Product)
          .once();

      bool productExists = false;
      String existingCartId = '';
      int existingQuantity = 0;

      if (cartSnapshot.snapshot.exists) {
        for (var child in cartSnapshot.snapshot.children) {
          if (child.child('ID_ProductSize').value == SizeClick) {
            productExists = true;
            existingCartId = child.child('ID_Cart').value as String;
            existingQuantity = child.child('Quantity').value as int;
            break;
          }
        }
      }

      if (productExists) {
        await _databaseReference
            .child('Carts')
            .child(currentUser.uid)
            .child(existingCartId)
            .update({
          'Quantity': existingQuantity + 1,
        });
      } else {
        final DatabaseEvent snapshot = await _databaseReference
            .child('Max')
            .child('MaxCart')
            .child(currentUser.uid)
            .child('MaxID')
            .once();

        final currentValue = snapshot.snapshot.value;
        int currentID =
            currentValue != null ? int.parse(currentValue.toString()) : 0;
        final newID = currentID + 1;
        String UIDC = 'Cart$newID';

        await _databaseReference
            .child('Carts')
            .child(currentUser.uid)
            .child(UIDC)
            .set({
          'ID_Cart': UIDC,
          'ID_Product': widget.pro.ID_Product,
          'ID_ProductSize': SizeClick,
          'Quantity': quantitytitleProduct,
          'Stt': 0,
        });

        await _databaseReference
            .child('Max')
            .child('MaxCart')
            .child(currentUser.uid)
            .child('MaxID')
            .set(newID);
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Product added to cart'),
        backgroundColor: Color.fromARGB(255, 152, 152, 152),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please sign in first'),
        backgroundColor: const Color.fromARGB(255, 158, 158, 158),
      ));
    }
  }

  void fetchReviews() async {
    try {
      DatabaseEvent event = await Review_dbRef.once();
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.exists) {
        List<Review> tempReviewList = [];

        for (var child in snapshot.children) {
          tempReviewList.add(Review.fromSnapshot(child));
        }

        setState(() {
          reviews = tempReviewList
              .where(
                (element) => element.Status == 0,
              )
              .toList();
        });
      } else {
        print('No reviews available for this product.');
      }
    } catch (e) {
      print('An error occurred: $e');
      // Handle the error, e.g., show a message to the user
    }
  }

  void SizeFilter() {
    if (sizeBtn == 0) {
      price = size.S.SellPrice;
      discount = size.S.Discount;
    }
    if (sizeBtn == 1) {
      price = size.M.SellPrice;
      discount = size.M.Discount;
    }
    if (sizeBtn == 2) {
      price = size.L.SellPrice;
      discount = size.L.Discount;
    }
  }

  double calculateAverageRating() {
    if (reviews.isEmpty) {
      return 0.0;
    }

    double sum = 0.0;
    for (var review in reviews) {
      sum += double.parse(review.Rating.toString());
    }

    return sum / reviews.length;
  }

  String formatCurrency(int value) {
    final formatter = NumberFormat.decimalPattern('vi');
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    String idp = getIDProduct();
    String idus = getUserUID();

    print('_________________________________');
    print('check da danh gia');
    print(checkrw);
    print('check da mua: ');
    print(check);

    return Scaffold(
        appBar: AppBar(
            scrolledUnderElevation: 0.0,
            backgroundColor: const Color.fromRGBO(201, 241, 248, 1),
            leading: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios_new, color: Colors.black)),
            )),
        body: check == true && checkrw == false
            ? SingleChildScrollView(
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(""),
                            flex: 4,
                          ),
                          Container(
                              //margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/7, 10, 0, 0),
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              width: MediaQuery.of(context).size.height / 3,
                              height: MediaQuery.of(context).size.height / 3,
                              child: Image.network(widget.pro.Image_Url[0]!,
                                  fit: BoxFit.cover)),
                          IconButton(
                              onPressed: () {
                                addFavorite(widget.pro.ID_Product);
                              },
                              icon: Icon(
                                Icons.favorite,
                                color: isFav ? Colors.red : Colors.grey,
                              )),
                          Expanded(child: Text("")),
                        ],
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
                            color: Color.fromARGB(59, 179, 177, 177),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          197,
                                      padding:
                                          EdgeInsets.fromLTRB(0, 30, 0, 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.pro.Product_Name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            "${formatCurrency(price)} VND",
                                            style: TextStyle(
                                                decoration: discount > 0
                                                    ? TextDecoration.lineThrough
                                                    : TextDecoration.none),
                                          ),
                                          if (discount > 0)
                                            Text(
                                              "${formatCurrency(price - discount)} VND",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromRGBO(
                                                      232, 174, 17, 1)),
                                            ),
                                          Rating(rate: calculateAverageRating())
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (quantitytitleProduct > 1)
                                                    quantitytitleProduct -= 1;
                                                });
                                              },
                                              icon: Icon(Icons.remove),
                                            ),
                                            Container(
                                              width: 20,
                                              child: Text(
                                                quantitytitleProduct.toString(),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (sizeBtn == 0) {
                                                    if (quantitytitleProduct <
                                                        size.S.Stock)
                                                      quantitytitleProduct += 1;
                                                  } else if (sizeBtn == 1) {
                                                    if (quantitytitleProduct <
                                                        size.M.Stock)
                                                      quantitytitleProduct += 1;
                                                  } else {
                                                    if (quantitytitleProduct <
                                                        size.L.Stock)
                                                      quantitytitleProduct += 1;
                                                  }
                                                });
                                              },
                                              icon: Icon(Icons.add),
                                            ),
                                          ],
                                        ),
                                        ElevatedButton(
                                          onPressed: (sizeBtn == 0 &&
                                                      (size.S.Stock == 0 ||
                                                          size.S.Status ==
                                                              1)) ||
                                                  (sizeBtn == 1 &&
                                                      (size.M.Stock == 0 ||
                                                          size.M.Status ==
                                                              1)) ||
                                                  (sizeBtn == 2 &&
                                                      (size.L.Stock == 0 ||
                                                          size.L.Status == 1))
                                              ? null
                                              : () {
                                                  print("Added to cart");
                                                  addProductToCart();
                                                },
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 20),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Add to cart",
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 104, 104, 104)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Size",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 5, 0, 0)),
                                    Row(
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
                                              side: MaterialStateProperty.all(
                                                  BorderSide(
                                                      width: sizeBtn == 0
                                                          ? 2.0
                                                          : 0.5)),
                                            ),
                                            child: Text("S",
                                                style: TextStyle(
                                                    color: Colors.black))),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 10, 0),
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
                                              side: MaterialStateProperty.all(
                                                  BorderSide(
                                                      width: sizeBtn == 1
                                                          ? 2.0
                                                          : 0.5)),
                                            ),
                                            child: Text("M",
                                                style: TextStyle(
                                                    color: Colors.black))),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 10, 0),
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
                                              side: MaterialStateProperty.all(
                                                  BorderSide(
                                                      width: sizeBtn == 2
                                                          ? 2.0
                                                          : 0.5)),
                                            ),
                                            child: Text("L",
                                                style: TextStyle(
                                                    color: Colors.black))),
                                      ],
                                    )
                                  ],
                                ),
                                SingleChildScrollView(
                                    child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 15, 7, 0),
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Description",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      Text(
                                        widget.pro.Description,
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 5, 5, 5)),
                                      ),
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 10))
                                    ],
                                  ),
                                )),
                                // danh gia (Review)
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Rating",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                                Container(
                                  //write review
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            Text(
                                              "Rate Product Quality: ",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            Container(
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        Rate = 1.0;
                                                      });
                                                    },
                                                    child: Icon(
                                                        Icons.star_rounded,
                                                        color: Colors.yellow),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        Rate = 2.0;
                                                      });
                                                    },
                                                    child: Icon(
                                                        Icons.star_rounded,
                                                        color: Rate >= 2.0
                                                            ? Colors.yellow
                                                            : Colors.grey),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        Rate = 3.0;
                                                      });
                                                    },
                                                    child: Icon(
                                                        Icons.star_rounded,
                                                        color: Rate >= 3.0
                                                            ? Colors.yellow
                                                            : Colors.grey),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        Rate = 4.0;
                                                      });
                                                    },
                                                    child: Icon(
                                                        Icons.star_rounded,
                                                        color: Rate >= 4.0
                                                            ? Colors.yellow
                                                            : Colors.grey),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        Rate = 5.0;
                                                      });
                                                    },
                                                    child: Icon(
                                                        Icons.star_rounded,
                                                        color: Rate >= 5.0
                                                            ? Colors.yellow
                                                            : Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 158, 158, 158),
                                              width: 2.5,
                                            ),
                                          ),
                                        ),
                                        child: TextField(
                                          controller: Rev,
                                          decoration: InputDecoration(
                                            hintText: "Review This Product",
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                getUserInfo(idus).then((user) {
                                                  addReview(
                                                    idp,
                                                    Rev.text,
                                                    idus,
                                                    Rate.toInt(),
                                                    user.Username,
                                                  ).then((_) {
                                                    // Sau khi thêm đánh giá xong, điều hướng đến DetailScreen
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailScreen(
                                                          pro: widget.pro,
                                                        ),
                                                      ),
                                                    );
                                                  }).catchError((error) {
                                                    print(
                                                        'Error adding review: $error');
                                                    // Xử lý khi có lỗi xảy ra trong quá trình thêm đánh giá
                                                  });
                                                }).catchError((error) {
                                                  print(
                                                      'Error fetching user data: $error');
                                                  // Xử lý khi có lỗi xảy ra trong quá trình lấy dữ liệu người dùng
                                                });
                                              },
                                              icon: Icon(
                                                  Icons.send), // Icon cho nút
                                              splashColor: Colors
                                                  .transparent, // Màu hiệu ứng khi nhấn
                                              highlightColor: Colors
                                                  .transparent, // Màu khi hover
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                ),
                                if (reviews.isEmpty)
                                  Text("No reviews available for this product.")
                                else
                                  SingleChildScrollView(
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxHeight: MediaQuery.of(context)
                                              .size
                                              .height),
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: reviews.length,
                                          itemBuilder: ((context, index) {
                                            return Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 0),
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 15),
                                              decoration: BoxDecoration(
                                                  // border: Border(
                                                  //   bottom: BorderSide(
                                                  //     color: Color.fromARGB(255, 158, 158, 158),
                                                  //     width: 2.5
                                                  //   )
                                                  // )
                                                  ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                              reviews[index]
                                                                  .Username)),
                                                      Text(reviews[index]
                                                          .Review_Date)
                                                    ],
                                                  ),
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 0, 7)),
                                                  Rating(
                                                      rate: double.parse(
                                                          reviews[index]
                                                              .Rating
                                                              .toString())),
                                                  Text(reviews[index].Comment),
                                                  Divider(),
                                                ],
                                              ),
                                            );
                                          })),
                                    ),
                                  ),
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              )
            : SingleChildScrollView(
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(""),
                            flex: 4,
                          ),
                          Container(
                              //margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/7, 10, 0, 0),
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              width: MediaQuery.of(context).size.height / 3,
                              height: MediaQuery.of(context).size.height / 3,
                              child: widget.pro.Image_Url.isNotEmpty
                                  ? CarouselSlider(
                                      options: CarouselOptions(
                                        height: 400.0,
                                        enlargeCenterPage: true,
                                        autoPlay:
                                            true, //tự động chuyển sang hình khác
                                        aspectRatio: 16 / 9, // tỉ lệ khung hình
                                        autoPlayInterval: Duration(
                                            seconds:
                                                2), //thời gian trước khi chuyển sang hình khác
                                        autoPlayAnimationDuration: Duration(
                                            milliseconds:
                                                750), //thời gian cần để chuyển sang hình khác
                                        autoPlayCurve: Curves
                                            .fastOutSlowIn, // animation cuôn
                                        enableInfiniteScroll:
                                            false, //cuộn vĩnh viễn
                                        viewportFraction:
                                            1.0, // % hình trong khung hình, 0.8 sẽ hiển thị rìa của hình kế bên
                                        pauseAutoPlayOnTouch: true, //
                                        scrollDirection: Axis.horizontal,
                                      ),
                                      items: widget.pro.Image_Url
                                          .map((item) => Container(
                                                //items là danh sách hình
                                                child: Center(
                                                  child: Image.network(item,
                                                      fit: BoxFit.contain,
                                                      width: 1000),
                                                ),
                                              ))
                                          .toList(),
                                    )
                                  : Icon(Icons.image_not_supported)),
                          IconButton(
                              onPressed: () {
                                addFavorite(widget.pro.ID_Product);
                              },
                              icon: Icon(
                                Icons.favorite,
                                color: isFav ? Colors.red : Colors.grey,
                              )),
                          Expanded(child: Text("")),
                        ],
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
                            color: Color.fromARGB(59, 179, 177, 177),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          197,
                                      padding:
                                          EdgeInsets.fromLTRB(0, 30, 0, 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.pro.Product_Name,
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            "${formatCurrency(price)} VND",
                                            style: TextStyle(
                                                decoration: discount > 0
                                                    ? TextDecoration.lineThrough
                                                    : TextDecoration.none),
                                          ),
                                          if (discount > 0)
                                            Text(
                                              "${formatCurrency(price - discount)} VND",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromRGBO(
                                                      232, 174, 17, 1)),
                                            ),
                                          Rating(rate: calculateAverageRating())
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (quantitytitleProduct > 1)
                                                    quantitytitleProduct -= 1;
                                                });
                                              },
                                              icon: Icon(Icons.remove),
                                            ),
                                            Container(
                                              width: 20,
                                              child: Text(
                                                quantitytitleProduct.toString(),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (sizeBtn == 0) {
                                                    if (quantitytitleProduct <
                                                        size.S.Stock)
                                                      quantitytitleProduct += 1;
                                                  } else if (sizeBtn == 1) {
                                                    if (quantitytitleProduct <
                                                        size.M.Stock)
                                                      quantitytitleProduct += 1;
                                                  } else {
                                                    if (quantitytitleProduct <
                                                        size.L.Stock)
                                                      quantitytitleProduct += 1;
                                                  }
                                                });
                                              },
                                              icon: Icon(Icons.add),
                                            ),
                                          ],
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            print("Added to cart");
                                            addProductToCart();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 20),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Add to cart",
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 104, 104, 104)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Size",
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 5, 5, 5),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 5, 0, 0)),
                                    Row(
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
                                              side: MaterialStateProperty.all(
                                                  BorderSide(
                                                      width: sizeBtn == 0
                                                          ? 2.0
                                                          : 0.5)),
                                            ),
                                            child: Text("S",
                                                style: TextStyle(
                                                    color: Colors.black))),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 10, 0),
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
                                              side: MaterialStateProperty.all(
                                                  BorderSide(
                                                      width: sizeBtn == 1
                                                          ? 2.0
                                                          : 0.5)),
                                            ),
                                            child: Text("M",
                                                style: TextStyle(
                                                    color: Colors.black))),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 10, 0),
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
                                              side: MaterialStateProperty.all(
                                                  BorderSide(
                                                      width: sizeBtn == 2
                                                          ? 2.0
                                                          : 0.5)),
                                            ),
                                            child: Text("L",
                                                style: TextStyle(
                                                    color: Colors.black))),
                                      ],
                                    )
                                  ],
                                ),
                                SingleChildScrollView(
                                    child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 15, 7, 0),
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Description",
                                        style: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      Text(
                                        widget.pro.Description,
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 5, 5, 5)),
                                      ),
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 10))
                                    ],
                                  ),
                                )),
                                // danh gia (Review)
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Rating",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 5, 5, 5),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),

                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                ),
                                if (reviews.isEmpty)
                                  Text("No reviews available for this product.")
                                else
                                  SingleChildScrollView(
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxHeight: MediaQuery.of(context)
                                              .size
                                              .height),
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: reviews.length,
                                          itemBuilder: ((context, index) {
                                            return Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 0),
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 15),
                                              decoration: BoxDecoration(
                                                  // border: Border(
                                                  //   bottom: BorderSide(
                                                  //     color: Color.fromARGB(255, 158, 158, 158),
                                                  //     width: 2.5
                                                  //   )
                                                  // )
                                                  ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                              reviews[index]
                                                                  .Username)),
                                                      Text(reviews[index]
                                                          .Review_Date)
                                                    ],
                                                  ),
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 0, 7)),
                                                  Rating(
                                                      rate: double.parse(
                                                          reviews[index]
                                                              .Rating
                                                              .toString())),
                                                  Text(reviews[index].Comment),
                                                  Divider(),
                                                ],
                                              ),
                                            );
                                          })),
                                    ),
                                  ),
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              ));
  }
}
