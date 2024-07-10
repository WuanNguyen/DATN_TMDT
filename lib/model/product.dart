import 'package:doan_tmdt/model/classes.dart';
import 'package:doan_tmdt/screens/detail_items/rating.dart';
import 'package:doan_tmdt/screens/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class ProductItem extends StatefulWidget {
  ProductItem({super.key, required this.pro});
  Product pro;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  Query ProductSizes_dbRef =
      FirebaseDatabase.instance.ref().child('ProductSizes');
  late DatabaseReference Review_dbRef;
  List<Review> reviews = [];
  List<ProductSize> sizes = [];

  String formatCurrency(int value) {
    final formatter = NumberFormat.decimalPattern('vi');
    return formatter.format(value);
  }

  ProductSize size = ProductSize(
      S: ProductSizeDetail(
          ID_Product: "",
          Stock: 0,
          ImportPrice: 0,
          SellPrice: 0,
          Discount: 0,
          Status: 0),
      M: ProductSizeDetail(
          ID_Product: "",
          Stock: 0,
          ImportPrice: 0,
          SellPrice: 0,
          Discount: 0,
          Status: 0),
      L: ProductSizeDetail(
          ID_Product: "",
          Stock: 0,
          ImportPrice: 0,
          SellPrice: 0,
          Discount: 0,
          Status: 0));

  @override
  void initState() {
    ProductSizes_dbRef.onValue.listen((event) {
      if (this.mounted) {
        setState(() {
          sizes = event.snapshot.children.map((snapshot) {
            return ProductSize.fromSnapshot(snapshot);
          }).toList();
          size = sizes.firstWhere((element) =>
              element.L.ID_Product == widget.pro.ID_Product ||
              element.M.ID_Product == widget.pro.ID_Product ||
              element.S.ID_Product == widget.pro.ID_Product);
        });
      }
    });

    Review_dbRef = FirebaseDatabase.instance
        .ref()
        .child('Reviews')
        .child(widget.pro.ID_Product);
    fetchReviews();
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
    print(widget.pro.Image_Url.length);
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => new DetailScreen(
                      pro: widget.pro,
                    )));
      }, //qua trang san pham
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
        width: 167,
        height: 300,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(padding: EdgeInsets.all(11)),
            Container(
                clipBehavior:
                    Clip.antiAlias, // cho hinh anh vao trong container
                width: 125,
                height: 125,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: const Color.fromARGB(255, 57, 46, 46),
                        width: 2.0),
                    color: Colors.white),
                child: widget.pro.Image_Url.isNotEmpty
                    ? Image.network(widget.pro.Image_Url[0]!)
                    : Icon(Icons
                        .image_not_supported) // hoặc sử dụng hình ảnh mặc định//image (fit: BoxFit.cover)
                ),
            Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),

            //name
            Text(
              widget.pro.Product_Name,
              style: const TextStyle(
                  color: Color.fromARGB(255, 48, 50, 52),
                  fontWeight: FontWeight.bold),
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 0)),

            //price
            Text(
                "${formatCurrency(size.S.SellPrice - size.S.Discount)} - ${formatCurrency(size.L.SellPrice - size.L.Discount)} VND",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Padding(padding: EdgeInsets.fromLTRB(0, 3, 0, 0)),

            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Rating(rate: calculateAverageRating()),
            ),

            //button
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new DetailScreen(
                              pro: widget.pro,
                            )));
              },
              child: Container(
                width: 126,
                height: 46,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 215, 215, 215),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.3),
                          blurRadius: 2,
                          offset: Offset(0, 1))
                    ]),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "View",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
