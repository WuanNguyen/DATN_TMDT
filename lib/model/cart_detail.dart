import 'package:doan_tmdt/model/bottom_navigation.dart';
import 'package:doan_tmdt/model/classes.dart';
import 'package:doan_tmdt/model/dialog_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartDetails extends StatefulWidget {
  CartDetails(
      {Key? key,
      required this.TotalPrice,
      required this.Discount,
      required this.idDiscount})
      : super(key: key);
  int TotalPrice; // tong tien
  int Discount; // ap dung giam gia
  String idDiscount;

  @override
  State<CartDetails> createState() => _CartDetailState();
}

class _CartDetailState extends State<CartDetails> {
  final TextEditingController nameUS = TextEditingController();
  final TextEditingController addressUS = TextEditingController();
  final TextEditingController phoneUS = TextEditingController();
  String _nameus = '';
  String _addressus = '';
  String _phongus = '';
  int selectedRadio = 1;
  void setSelectedRadio(int value) {
    setState(() {
      selectedRadio = value;
    });
  }

  String image =
      "https://firebasestorage.googleapis.com/v0/b/datn-sporthuviz-bf24e.appspot.com/o/images%2Favatawhile.png?alt=media&token=8219377d-2c30-4a7f-8427-626993d78a3a";
  Map<String, Product> productCache = {};
  Map<String, ProductSize> sizeCache = {};

  String getUserUID() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) return user.uid.toString();
    return "";
  }

  Future<Product> getProInfo(String proID) async {
    DatabaseReference proRef =
        FirebaseDatabase.instance.ref().child('Products').child(proID);
    DataSnapshot snapshot = await proRef.get();
    return Product.fromSnapshot(snapshot);
  }

  Future<Users> getUserInfo(String userId) async {
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('Users').child(userId);
    DataSnapshot snapshot = await userRef.get();
    return Users.fromSnapshot(snapshot);
  }

  Future<ProductSize> getSizeInfo(String sizeID) async {
    DatabaseReference sizeRef =
        FirebaseDatabase.instance.ref().child('ProductSizes').child(sizeID);
    DataSnapshot snapshot = await sizeRef.get();
    return ProductSize.fromSnapshot(snapshot);
  }

  List<CartDetail> _cartdetail = [];
  Users? currentUser;

  @override
  void initState() {
    super.initState();
    String ID = getUserUID();

    final DatabaseReference CartDetail_dbRef =
        FirebaseDatabase.instance.ref().child('Carts').child(ID);

    CartDetail_dbRef.onValue.listen((event) {
      if (mounted) {
        setState(() {
          _cartdetail = event.snapshot.children
              .map((snapshot) {
                return CartDetail.fromSnapshot(snapshot);
              })
              .where((element) => element.Stt == 0)
              .toList();
        });

        for (var Proitem in _cartdetail) {
          if (!productCache.containsKey(Proitem.ID_Product)) {
            getProInfo(Proitem.ID_Product!).then((proInfo) {
              setState(() {
                productCache[Proitem.ID_Product!] = proInfo;
              });
            });
          }
        }

        for (var Sizeitem in _cartdetail) {
          if (!productCache.containsKey(Sizeitem.ID_Product)) {
            getSizeInfo(Sizeitem.ID_Product!).then((sizeInfo) {
              setState(() {
                sizeCache[Sizeitem.ID_Product!] = sizeInfo;
              });
            });
          }
        }

        getUserInfo(ID).then((userInfo) {
          setState(() {
            currentUser = userInfo;
          });
        });
      }
    });
  }

  int getProPrice(int SellPrice, int Discount) {
    return SellPrice - Discount;
  }

  Future<void> addOrder(String nameuser, String addressuser, String phoneuser,
      dis, String paym, int ttprice, String iddiscount) async {
    String id_user = getUserUID();

    final DatabaseReference _databaseReference =
        FirebaseDatabase.instance.reference();

    final DatabaseEvent snapshot =
        await _databaseReference.child('Max').child('MaxOrder').once();

    final currentValue = snapshot.snapshot.value;
    int currentID =
        currentValue != null ? int.parse(currentValue.toString()) : 0;
    final newID = currentID + 1;
    String UIDC = 'Order$newID';
    // Chuyển đổi DateTime thành chuỗi
    String orderDate = DateTime.now().toIso8601String();

    await _databaseReference.child('Order').child(UIDC).set({
      'NameUser': nameuser,
      'AddressUser': addressuser,
      'PhoneUser': phoneuser,

      'Discount': dis,
      'ID_Order': UIDC, // Add null check
      'ID_User': id_user,
      'Order_Date': DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
      'Order_Status': 'xacnhan',
      'Payment': paym,
      'Total_Price': ttprice
    });

    await _databaseReference.child('Max').child('MaxOrder').set(newID);

    // đơn phụ
    for (var cartItem in _cartdetail) {
      String productId = cartItem.ID_Product!;
      String productSize = cartItem.ID_ProductSize!;
      int price = getSizePrice(
          productId, productSize); // Tính toán giá của size sản phẩm
      int quantity = cartItem.Quantity ?? 1;
      //
      await addOrderDetail(UIDC, productId, productSize, price,
          quantity); // Số lượng sản phẩm trong đơn hàng
      //thiếu cập nhật stock sp
      // Cập nhật stock sản phẩm size
      ProductSize? sizeInfo = sizeCache[productId];
      if (sizeInfo != null) {
        int? newStock;
        if (productSize == 'S' && sizeInfo.S.Stock != null) {
          newStock = sizeInfo.S.Stock! - quantity;
          _updateStockProductSize(productId, 'S', newStock);
        } else if (productSize == 'M' && sizeInfo.M.Stock != null) {
          newStock = sizeInfo.M.Stock! - quantity;
          _updateStockProductSize(productId, 'M', newStock);
        } else if (productSize == 'L' && sizeInfo.L.Stock != null) {
          newStock = sizeInfo.L.Stock! - quantity;
          _updateStockProductSize(productId, 'L', newStock);
        }
      }

      //và xóa giỏ hàng
      // Xóa sản phẩm khỏi giỏ hàng---------------------------------------------Lệnh đang thử nghiệm
      await _databaseReference.child('Carts').child(id_user).remove();
    }
    _updateUsesDiscount(iddiscount);
    addNotification(id_user, UIDC);
  }

  void _updateStockProductSize(String productId, String size, int newStock) {
    final DatabaseReference ProductSz_dbRef = FirebaseDatabase.instance
        .reference()
        .child('ProductSizes')
        .child(productId);

    ProductSz_dbRef.child(size).update({'Stock': newStock}).then((_) {
      print("Successfully updated Stock for $size");
    }).catchError((error) {
      print("Failed to update Stock: $error");
    });
  }

  //--------------------------------------------
  Future<Discount> getDiscount(String idDiss) async {
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('Discounts').child(idDiss);
    DataSnapshot snapshot = await userRef.get();
    return Discount.fromSnapshot(snapshot);
  }

  void _updateUsesDiscount(String idDis) async {
    try {
      Discount discount = await getDiscount(idDis);

      final DatabaseReference updateDiscount_dbRef =
          FirebaseDatabase.instance.reference().child('Discounts').child(idDis);

      int updatedUses = discount.Uses - 1;

      await updateDiscount_dbRef.update({'Uses': updatedUses});
      print("Successfully updated Uses");
    } catch (error) {
      print("Failed to update Uses: $error");
    }
  }

  Future<void> addOrderDetail(
      String idorder, String idproduct, String prosize, int pri, int qu) async {
    final DatabaseReference _databaseReference =
        FirebaseDatabase.instance.reference();

    //them orderDetail
    final DatabaseEvent snapshot = await _databaseReference
        .child('Max')
        .child('MaxOrderDetail')
        .child(idorder)
        .child('MaxID')
        .once();

    final currentValue = snapshot.snapshot.value;
    int currentID =
        currentValue != null ? int.parse(currentValue.toString()) : 0;
    final newID = currentID + 1;
    String UIDC = 'OrderDetail$newID';

    await _databaseReference
        .child('OrderDetail')
        .child(idorder)
        .child(UIDC)
        .set({
      'ID_Product': idproduct,
      'ID_ProductSize': prosize, // Add null check
      'Price': pri,
      'Quantity': qu,
    });
    //cập nhật danh sách
    await _databaseReference
        .child('Max')
        .child('MaxOrderDetail')
        .child(idorder)
        .child('MaxID')
        .set(newID);
  }

// Phương thức này dùng để lấy giá của size sản phẩm từ cache
  int getSizePrice(String productId, String productSize) {
    ProductSize? sizeInfo = sizeCache[productId];
    if (sizeInfo != null) {
      switch (productSize) {
        case 'S':
          return sizeInfo.S.SellPrice ?? 0;
        case 'M':
          return sizeInfo.M.SellPrice ?? 0;
        case 'L':
          return sizeInfo.L.SellPrice ?? 0;
        default:
          return 0;
      }
    }
    return 0;
  }

  //kiểm tra sdt
  bool isValidPhoneNumber(String input) {
    final RegExp regex = RegExp(r'^0\d{9}$');
    return regex.hasMatch(input);
  }

  bool isValidGmail(String input) {
    // Biểu thức chính quy kiểm tra xem chuỗi là địa chỉ email Gmail hợp lệ hay không
    final RegExp regex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
    return regex.hasMatch(input);
  }

  String formatCurrency(int value) {
    final formatter = NumberFormat.decimalPattern('vi');
    return formatter.format(value);
  }

  // add notification
  Future<void> addNotification(String ID_user, String idorder) async {
    final DatabaseReference _databaseReference =
        FirebaseDatabase.instance.reference();

    //them orderDetail
    final DatabaseEvent snapshot = await _databaseReference
        .child('Max')
        .child('MaxNotification')
        .child(ID_user)
        .child('MaxID')
        .once();

    final currentValue = snapshot.snapshot.value;
    int currentID =
        currentValue != null ? int.parse(currentValue.toString()) : 0;
    final newID = currentID + 1;
    String UIDC = 'Notification$newID';

    await _databaseReference
        .child('Notifications')
        .child(ID_user)
        .child(UIDC)
        .set({
      'ID_Notification': UIDC,
      'Message': 'You have placed your order successfully', // Add null check
      'ID_Order': idorder,
      'Date_time': DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
      'Status': 0
    });
    //cập nhật danh sách
    await _databaseReference
        .child('Max')
        .child('MaxNotification')
        .child(ID_user)
        .child('MaxID')
        .set(newID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'order details',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Color.fromRGBO(201, 241, 248, 1),
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
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
              child: Column(
                children: [
                  ListView.builder(
                    itemCount: _cartdetail.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = _cartdetail[index];
                      final namePro =
                          productCache[item.ID_Product]?.Product_Name ??
                              'Loading...';
                      final picture =
                          productCache[item.ID_Product]?.Image_Url[0] ?? image;
                      final sizePrice = item.ID_ProductSize == "S"
                          ? sizeCache[item.ID_Product]?.S != null
                              ? formatCurrency(
                                      sizeCache[item.ID_Product]!.S.SellPrice)
                                  .toString()
                              : 'Loading...'
                          : item.ID_ProductSize == "M"
                              ? sizeCache[item.ID_Product]?.M != null
                                  ? formatCurrency(sizeCache[item.ID_Product]!
                                          .M
                                          .SellPrice)
                                      .toString()
                                  : 'Loading...'
                              : sizeCache[item.ID_Product]?.L != null
                                  ? formatCurrency(sizeCache[item.ID_Product]!
                                          .L
                                          .SellPrice)
                                      .toString()
                                  : 'Loading...';

                      return Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 5.0),
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        color: Colors.black, width: 2),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      picture,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Name Product: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        TextSpan(
                                          text: namePro,
                                          style: TextStyle(
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5.0),
                                  RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Size: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        TextSpan(
                                          text: item.ID_ProductSize,
                                          style: TextStyle(
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5.0),
                                  RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Price: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        TextSpan(
                                          text: sizePrice,
                                          style: TextStyle(
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5.0),
                                  RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Quantity: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        TextSpan(
                                          text: item.Quantity.toString(),
                                          style: TextStyle(
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5.0),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.all(15),
                          height: MediaQuery.of(context).size.height / 2.5,
                          width: double.infinity,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      _nameus == ''
                                                          ? currentUser
                                                                  ?.Username ??
                                                              'Loading...'
                                                          : _nameus,
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      _phongus == ''
                                                          ? currentUser
                                                                  ?.Phone ??
                                                              'Loading...'
                                                          : _phongus,
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      _addressus == ''
                                                          ? currentUser
                                                                  ?.Address ??
                                                              'Loading...'
                                                          : _addressus,
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    // Các widget khác trong column bên trái
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      CartEdit.infoUser(
                                                        context,
                                                        _nameus, // giá trị hiện tại
                                                        _addressus,
                                                        _phongus,
                                                        (update) {
                                                          if (isValidPhoneNumber(
                                                                      _phongus) ==
                                                                  false &&
                                                              _phongus != '') {
                                                            MsgDialog.MSG(
                                                                context,
                                                                'Notification',
                                                                'Invalid phone number');
                                                          } else {
                                                            setState(() {
                                                              _nameus = update[
                                                                  'name']!;
                                                              _addressus = update[
                                                                  'address']!;
                                                              _phongus = update[
                                                                  'phone']!;
                                                            });
                                                          }

                                                          print(_nameus);
                                                        },
                                                        () {
                                                          // handle cancel if needed
                                                        },
                                                      );
                                                    },
                                                    child: const Text(
                                                      'Edit',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  // Các widget khác trong column bên phải
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text("Total Price: ",
                                              style: TextStyle(
                                                fontSize: 18,
                                              )),
                                          Expanded(child: Container()),
                                          Text(
                                              formatCurrency(widget.TotalPrice)
                                                      .toString() +
                                                  " VND",
                                              style: TextStyle(
                                                fontSize: 18,
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text("Discount: ",
                                              style: TextStyle(
                                                fontSize: 18,
                                              )),
                                          Expanded(child: Container()),
                                          Text(
                                              formatCurrency(widget.Discount)
                                                      .toString() +
                                                  " VND",
                                              style: TextStyle(
                                                fontSize: 18,
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text("Pay: ",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                          Expanded(child: Container()),
                                          Text(
                                              "${formatCurrency(widget.TotalPrice - widget.Discount)} VND",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text("Payment:",
                                        style: TextStyle(
                                          fontSize: 18,
                                        )),
                                    Radio(
                                      value: 1,
                                      groupValue: selectedRadio,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedRadio = value as int;
                                        });
                                      },
                                    ),
                                    Text(
                                      'Cash',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Radio(
                                      value: 2,
                                      groupValue: selectedRadio,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedRadio = value as int;
                                        });
                                      },
                                    ),
                                    Text(
                                      'Momo',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.8,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      String payme = '';
                                      if (selectedRadio == 1)
                                        payme = 'Cash';
                                      else if (selectedRadio == 2)
                                        payme == 'Momo';
                                      //Thêm add order
                                      NotiDialog.show(context, 'Notification',
                                          'order confirmation', () {
                                        addOrder(
                                            _nameus == ''
                                                ? currentUser!.Username
                                                : _nameus,
                                            //
                                            _addressus == ''
                                                ? currentUser!.Address
                                                : _addressus,
                                            //
                                            _phongus == ''
                                                ? currentUser!.Phone
                                                : _phongus,
                                            widget.Discount,
                                            payme,
                                            widget.TotalPrice - widget.Discount,
                                            widget.idDiscount);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const BottomNavigation(
                                                      index: 2)),
                                        );
                                      }, () {});
                                    },
                                    child: Text(
                                      'Buy',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
