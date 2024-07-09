import 'package:doan_tmdt/model/classes.dart';
import 'package:doan_tmdt/screens/detail_items/rating.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';

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
  int quantitytitleProduct = 1;
  bool isFav = false;
  List<Users> users = [];

  //danh gia cua user hien tai
  TextEditingController ProductReview = TextEditingController();
  double Rate = 1;

  String getIDProduct(){
    return widget.pro.ID_Product;
  }

    DatabaseReference userRef = FirebaseDatabase.instance.ref().child('Users').child(FirebaseAuth.instance.currentUser!.uid);

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

    Review_dbRef = FirebaseDatabase.instance.ref().child('Reviews').child(widget.pro.ID_Product);
    fetchReviews();
  }

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
        backgroundColor: Colors.red,
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
          reviews = tempReviewList.where((element) => element.Status == 0,).toList();
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

  @override
  Widget build(BuildContext context) {
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: Text(""),flex: 4,),
                  Container(
                    //margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/7, 10, 0, 0),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    width: MediaQuery.of(context).size.height / 3,
                    height: MediaQuery.of(context).size.height / 3,
                    child: Image.network(widget.pro.Image_Url, fit: BoxFit.cover)
                  ),
                  IconButton(
                    onPressed: () {
                      addFavorite(widget.pro.ID_Product);
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: isFav ? Colors.red : Colors.grey,
                    )), 
                  Expanded(child: Text("")),
                ],),
                
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
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Add to cart",
                                          style: TextStyle(color: Colors.black),
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
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                              Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
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
                                                width:
                                                    sizeBtn == 0 ? 2.0 : 0.5)),
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
                                        side: MaterialStateProperty.all(
                                            BorderSide(
                                                width:
                                                    sizeBtn == 1 ? 2.0 : 0.5)),
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
                                        side: MaterialStateProperty.all(
                                            BorderSide(
                                                width:
                                                    sizeBtn == 2 ? 2.0 : 0.5)),
                                      ),
                                      child: Text("L",
                                          style:
                                              TextStyle(color: Colors.black))),
                                ],
                              )
                            ],
                          ),
                          SingleChildScrollView(
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
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10))
                              ],
                            ),
                          )),
                          // danh gia (Review)
                              Container(width:MediaQuery.of(context).size.width,child:  Text("Rating",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),
                              Container( //write review
                                child: Column(
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Text("Rate Product Quality: "),
                                          Container(
                                            child: Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: (){
                                                    setState(() {
                                                      Rate = 1.0;
                                                    });
                                                  },
                                                  child: Icon(Icons.star_rounded,color:Colors.yellow),
                                                ),
                                                GestureDetector(
                                                  onTap: (){
                                                    setState(() {
                                                      Rate = 2.0;
                                                    });
                                                  },
                                                  child: Icon(Icons.star_rounded,color: Rate >= 2.0 ? Colors.yellow: Colors.grey),
                                                ),
                                                GestureDetector(
                                                  onTap: (){
                                                    setState(() {
                                                      Rate = 3.0;
                                                    });
                                                  },
                                                  child: Icon(Icons.star_rounded,color: Rate >= 3.0 ? Colors.yellow: Colors.grey),
                                                ),
                                                GestureDetector(
                                                  onTap: (){
                                                    setState(() {
                                                      Rate = 4.0;
                                                    });
                                                  },
                                                  child: Icon(Icons.star_rounded,color: Rate >= 4.0 ? Colors.yellow: Colors.grey),
                                                ),
                                                GestureDetector(
                                                  onTap: (){
                                                    setState(() {
                                                      Rate = 5.0;
                                                    });
                                                  },
                                                  child: Icon(Icons.star_rounded,color: Rate >= 5.0 ? Colors.yellow: Colors.grey),
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
                                                color: Color.fromARGB(255, 158, 158, 158),
                                                width: 2.5
                                              )
                                            )
                                      ),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          hintText: "Review This Product"
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 20),),
                              if(reviews.isEmpty) 
                               Text("No reviews available for this product.")
                              else
                              SingleChildScrollView(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight: MediaQuery.of(context).size.height
                                  ),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: reviews.length,
                                    itemBuilder: ((context,index){
                                      return Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                                    decoration: BoxDecoration(
                                      // border: Border(
                                      //   bottom: BorderSide(
                                      //     color: Color.fromARGB(255, 158, 158, 158),
                                      //     width: 2.5
                                      //   )
                                      // )
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(child: Text(reviews[index].Username)),
                                            Text(reviews[index].Review_Date)
                                          ],
                                        ),
                                        Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 7)),
                                        Rating(rate: double.parse(reviews[index].Rating.toString())),
                                        Text(reviews[index].Comment),
                                        Divider(),
                                      ],
                                    ),
                                  );
                                    })
                                    ),
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