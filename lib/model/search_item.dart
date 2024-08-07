import 'package:doan_tmdt/model/classes.dart';
import 'package:doan_tmdt/screens/detail_items/rating.dart';
import 'package:doan_tmdt/screens/detail_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchItem extends StatefulWidget {
  SearchItem({Key? key, required this.pro}) : super(key: key);

  final Product pro;

  @override
  State<SearchItem> createState() => _SearchItemState();
}

String formatCurrency(int value) {
  final formatter = NumberFormat.decimalPattern('vi');
  return formatter.format(value);
}

class _SearchItemState extends State<SearchItem> {
  final Query productSizesDbRef =
      FirebaseDatabase.instance.ref().child('ProductSizes');

  List<ProductSize> sizes = [];
  late DatabaseReference Review_dbRef;
  List<Review> reviews = [];

  @override
  void initState() {
    super.initState();
    productSizesDbRef.onValue.listen((event) {
      if (this.mounted) {
        setState(() {
          sizes = event.snapshot.children
              .map((snapshot) => ProductSize.fromSnapshot(snapshot))
              .where((element) =>
                  element.S.Status == 0 ||
                  element.M.Status == 0 ||
                  element.L.Status == 0)
              .toList();
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

  int getPrice(int sellPrice, int discount) {
    return sellPrice - discount;
  }

  @override
  Widget build(BuildContext context) {
    ProductSize filteredSize = sizes.isNotEmpty
        ? sizes.firstWhere(
            (element) => element.L.ID_Product == widget.pro.ID_Product)
        : ProductSize(
            L: ProductSizeDetail(
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
            S: ProductSizeDetail(
                ID_Product: "",
                Stock: 0,
                ImportPrice: 0,
                SellPrice: 0,
                Discount: 0,
                Status: 0),
          );

    return Container(
      width: double.infinity,
      height: 150,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(pro: widget.pro),
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(20, 10, 10, 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 1.0, color: Colors.grey),
              ),
              clipBehavior: Clip.antiAlias,
              width: 100,
              height: 100,
              child: Image.network(
                widget.pro.Image_Url[0],
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.pro.Product_Name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.pro.Category,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      "${formatCurrency(getPrice(filteredSize.S.SellPrice, filteredSize.S.Discount))} - ${formatCurrency(getPrice(filteredSize.L.SellPrice, filteredSize.L.Discount))} VND",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: Colors.yellow,
                        ),
                        Text(
                          calculateAverageRating().toString(),
                        ),
                        SizedBox(width: 40),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailScreen(pro: widget.pro),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 30), // Adjust padding here
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              "View",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
