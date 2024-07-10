import 'dart:async';
import 'dart:io';
import 'package:doan_tmdt/model/classes.dart';
import 'package:doan_tmdt/model/dialog_notification.dart';
import 'package:doan_tmdt/model/loading.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  //khởi tại---------------------------------
  final TextEditingController nameproductText = TextEditingController();
  final TextEditingController descText = TextEditingController();

  //------------------
  String idDistributor = '';
  String cate = '';
  // get sizeS-----------------------------------------------------
  int stts = 1;
  int ImportPriceS = 0;
  int SellPriceS = 0;
  int StockS = 0;
  int DiscountS = 0;
  // get size M----------------------------------
  int sttm = 1;
  int ImportPriceM = 0;
  int SellPriceM = 0;
  int StockM = 0;
  int DiscountM = 0;
  // get size M----------------------------------
  int sttl = 1;
  int ImportPriceL = 0;
  int SellPriceL = 0;
  int StockL = 0;
  int DiscountL = 0;
  //----------
  List<String> imageUrls = [];
  //-----------------------------------------------------------
  Future<void> getSizeS() async {
    DatabaseReference userRef =
        FirebaseDatabase.instance.reference().child('Temp').child('S');
    DataSnapshot snapshot = await userRef.once().then((DatabaseEvent event) {
      return event.snapshot;
    });
    if (snapshot.value != null) {
      Map userData = snapshot.value as Map;
      setState(() {
        stts = userData['stt'] ?? 0;
        ImportPriceS = userData['ImportPrice'] ?? 0;
        SellPriceS = userData['SellPrice'] ?? 0;
        StockS = userData['Stock'] ?? 0;
        DiscountS = userData['Discount'] ?? 0;
      });
    }
  }

  Future<void> getSizeM() async {
    DatabaseReference userRef =
        FirebaseDatabase.instance.reference().child('Temp').child('M');
    DataSnapshot snapshot = await userRef.once().then((DatabaseEvent event) {
      return event.snapshot;
    });
    if (snapshot.value != null) {
      Map userData = snapshot.value as Map;
      setState(() {
        sttm = userData['stt'] ?? 0;
        ImportPriceM = userData['ImportPrice'] ?? 0;
        SellPriceM = userData['SellPrice'] ?? 0;
        StockM = userData['Stock'] ?? 0;
        DiscountM = userData['Discount'] ?? 0;
      });
    }
  }

  Future<void> getSizeL() async {
    DatabaseReference userRef =
        FirebaseDatabase.instance.reference().child('Temp').child('L');
    DataSnapshot snapshot = await userRef.once().then((DatabaseEvent event) {
      return event.snapshot;
    });
    if (snapshot.value != null) {
      Map userData = snapshot.value as Map;
      setState(() {
        sttl = userData['stt'] ?? 0;
        ImportPriceL = userData['ImportPrice'] ?? 0;
        SellPriceL = userData['SellPrice'] ?? 0;
        StockL = userData['Stock'] ?? 0;
        DiscountL = userData['Discount'] ?? 0;
      });
    }
  }

  //add product-------------------------------------------------------------------------------z
  Future<void> addProduct() async {
    getSizeS();
    getSizeM();
    getSizeL();
    //update
    final DatabaseReference _databaseReference =
        FirebaseDatabase.instance.reference();
    //
    //---------------------------------------------------
    DataSnapshot snapshot =
        await _databaseReference.child('Max').child('MaxProduct').get();

    int currentUID = snapshot.exists ? snapshot.value as int : 0;
    int newUID = currentUID + 1;
    String UIDC = 'Product$newUID';
    await _databaseReference.child('Products').child(UIDC).set({
      'ID_Product': UIDC,
      'Product_Name': nameproductText.text,
      'Description': descText.text,
      'ID_Distributor': idDistributor,
      'Category': cate,
      'Image_Url': imageUrls,
      'Status': 0
    });
    //////////////////////////////////////////////////////////////////

    if (ImportPriceS == 0) {
      await _databaseReference
          .child('ProductSizes')
          .child(UIDC)
          .child('S')
          .set({
        'Discount': DiscountS,
        'ID_Product': UIDC,
        'ImportPrice': ImportPriceS,
        'SellPrice': SellPriceS,
        'Status': 1,
        'Stock': StockS,
      });
    } else {
      await _databaseReference
          .child('ProductSizes')
          .child(UIDC)
          .child('S')
          .set({
        'Discount': DiscountS,
        'ID_Product': UIDC,
        'ImportPrice': ImportPriceS,
        'SellPrice': SellPriceS,
        'Status': 0,
        'Stock': StockS,
      });
    }

    ////////////////////////////////////////////////////////////////////
    if (ImportPriceM == 0) {
      await _databaseReference
          .child('ProductSizes')
          .child(UIDC)
          .child('M')
          .set({
        'Discount': DiscountM,
        'ID_Product': UIDC,
        'ImportPrice': ImportPriceM,
        'SellPrice': SellPriceM,
        'Status': 1,
        'Stock': StockM,
      });
    } else {
      await _databaseReference
          .child('ProductSizes')
          .child(UIDC)
          .child('M')
          .set({
        'Discount': DiscountM,
        'ID_Product': UIDC,
        'ImportPrice': ImportPriceM,
        'SellPrice': SellPriceM,
        'Status': 0,
        'Stock': StockM,
      });
    }

    ///////////////////////////////////////////////////////////////////
    if (ImportPriceL == 0) {
      await _databaseReference
          .child('ProductSizes')
          .child(UIDC)
          .child('L')
          .set({
        'Discount': DiscountL,
        'ID_Product': UIDC,
        'ImportPrice': ImportPriceL,
        'SellPrice': SellPriceL,
        'Status': 1,
        'Stock': StockL,
      });
    } else {
      await _databaseReference
          .child('ProductSizes')
          .child(UIDC)
          .child('L')
          .set({
        'Discount': DiscountL,
        'ID_Product': UIDC,
        'ImportPrice': ImportPriceL,
        'SellPrice': SellPriceL,
        'Status': 0,
        'Stock': StockL,
      });
    }

    //--------------------------------------------------------------------------
    // Cập nhật UID lớn nhất
    await _databaseReference.child('Max').child('MaxProduct').set(newUID);
    updateStt();
    //
  }

  // update lại stt
  Future<void> updateStt() async {
    getSizeS();
    getSizeM();
    getSizeL();
    final DatabaseReference _databaseReference =
        FirebaseDatabase.instance.reference();
    await _databaseReference.child('Temp').child('S').set({'stt': 1});
    await _databaseReference.child('Temp').child('M').set({'stt': 1});
    await _databaseReference.child('Temp').child('L').set({'stt': 1});
  }

//---------------------------------------list
  Query Distributors_dbRef =
      FirebaseDatabase.instance.ref().child('Distributors');

  List<Dis> dis = [];
  Dis? selected;

  @override
  void initState() {
    Distributors_dbRef.onValue.listen((event) {
      if (this.mounted) {
        setState(() {
          dis = event.snapshot.children
              .map((snapshot) {
                return Dis.fromSnapshot(snapshot);
              })
              .where((element) => element.Status == 0)
              .toList();
          select_distributor = dis.isNotEmpty ? dis[0].Distributor_Name : null;
        });
      }
    });
  }

  void loadstt() {
    getSizeS();
    getSizeM();
    getSizeL();
  }

  //------------------------------------------------------------------------------------------
  String? select_category;
  String? select_distributor;

  List<String> categorys = [
    "Adult",
    "Child",
  ];
  // lấy data tạo load
  Future<List<String>> _fetchImages() async {
    await Future.delayed(Duration(seconds: 4));
    return imageUrls;
  }

  @override
  Widget build(BuildContext context) {
    print('SIze S: ' + ImportPriceS.toString());
    print('SIze M: ' + ImportPriceM.toString());
    print('SIze L: ' + ImportPriceL.toString());
    print('-----------------------------------');
    print('stt S: ' + stts.toString());
    print('Stt M: ' + sttm.toString());
    print('Stt L: ' + sttl.toString());
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
              FutureBuilder(
                  future: _fetchImages(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return LoadingIndicator();
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No images available'));
                    } else {
                      return Container(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: imageUrls.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 78, 78, 78), // Màu viền
                                    width: 1.0, // Độ dày viền
                                  ),
                                ),
                                child: Image.network(
                                  imageUrls[index],
                                  width: 100,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  }),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: TextButton(
                    onPressed: () {
                      pickAndUploadImagesToFirebase();
                    },
                    child: Text('Upload Image')),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: nameproductText,
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
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      admin_addproduct.sizes(context);
                      loadstt();
                    },
                    child: Text(
                      'Size',
                      style:
                          TextStyle(color: const Color.fromARGB(255, 51, 0, 0)),
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
                      controller: descText,
                      obscureText: false,
                      maxLines: 3,
                      minLines: 3,
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
                        DropdownButtonFormField<Dis>(
                          value: selected,
                          onChanged: (disnew) {
                            setState(() {
                              selected = disnew!;
                            });
                          },
                          items: dis.map((Dis dis) {
                            return DropdownMenuItem<Dis>(
                              value: dis,
                              child: Text(dis.Distributor_Name),
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
                      nameproductText.clear();
                      descText.clear();
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
                      if (selected != null) {
                        idDistributor = selected!.ID_Distributor;
                      }
                      cate = select_category.toString();
                      loadstt();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Stack(
                            children: [
                              AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(27),
                                ),
                                backgroundColor: Colors
                                    .transparent, // Makes the AlertDialog background transparent
                                contentPadding:
                                    EdgeInsets.zero, // Removes default padding
                                content: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(27),
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                      stops: [0.0, 0.7, 1],
                                      transform: GradientRotation(50),
                                      colors: [
                                        Color.fromRGBO(54, 170, 237, 1),
                                        Color.fromRGBO(149, 172, 205, 1),
                                        Color.fromRGBO(244, 173, 173, 1),
                                      ],
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Notification',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(height: 16),
                                      Text(
                                          'You definitely want to add products',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16)),
                                      SizedBox(height: 24),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                updateStt();
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            const SizedBox(width: 40),
                                            ElevatedButton(
                                              onPressed: () {
                                                if (imageUrls.length == 0) {
                                                  Navigator.of(context).pop();
                                                  MsgDialog.MSG(
                                                      context,
                                                      'Notification',
                                                      'Picture has not been filled in');
                                                } else if (nameproductText
                                                    .text.isEmpty) {
                                                  Navigator.of(context).pop();
                                                  MsgDialog.MSG(
                                                      context,
                                                      'Notification',
                                                      'Product name has not been filled in');
                                                } else if (descText
                                                    .text.isEmpty) {
                                                  Navigator.of(context).pop();
                                                  MsgDialog.MSG(
                                                      context,
                                                      'Notification',
                                                      'No product description yet');
                                                } else if (cate.isEmpty) {
                                                  Navigator.of(context).pop();
                                                  MsgDialog.MSG(
                                                      context,
                                                      'Notification',
                                                      'Category has not been selected yet');
                                                } else if (idDistributor ==
                                                    '') {
                                                  Navigator.of(context).pop();
                                                  MsgDialog.MSG(
                                                      context,
                                                      'Notification',
                                                      'Distributor has not been selected yet');
                                                } else if (stts == 1 &&
                                                    sttm == 1 &&
                                                    sttl == 1) {
                                                  Navigator.of(context).pop();

                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Stack(
                                                        children: [
                                                          AlertDialog(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          27),
                                                            ),
                                                            backgroundColor:
                                                                const Color
                                                                    .fromARGB(
                                                                    0,
                                                                    255,
                                                                    255,
                                                                    255), // Makes the AlertDialog background transparent
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .zero, // Removes default padding
                                                            content: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            27),
                                                                gradient:
                                                                    LinearGradient(
                                                                  begin: Alignment
                                                                      .bottomLeft,
                                                                  end: Alignment
                                                                      .topRight,
                                                                  stops: [
                                                                    0.0,
                                                                    0.7,
                                                                    1
                                                                  ],
                                                                  transform:
                                                                      GradientRotation(
                                                                          50),
                                                                  colors: [
                                                                    Color
                                                                        .fromRGBO(
                                                                            54,
                                                                            170,
                                                                            237,
                                                                            1),
                                                                    Color
                                                                        .fromRGBO(
                                                                            149,
                                                                            172,
                                                                            205,
                                                                            1),
                                                                    Color
                                                                        .fromRGBO(
                                                                            244,
                                                                            173,
                                                                            173,
                                                                            1),
                                                                  ],
                                                                ),
                                                              ),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(20),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Text(
                                                                      'Notification',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                  SizedBox(
                                                                      height:
                                                                          16),
                                                                  Text(
                                                                      'Product size has not been selected',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              16)),
                                                                  SizedBox(
                                                                      height:
                                                                          24),
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerRight,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              const Text(
                                                                            'OK',
                                                                            style:
                                                                                TextStyle(color: Colors.black),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                } else {
                                                  addProduct();

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Added product successfully',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      backgroundColor:
                                                          Color.fromARGB(255,
                                                              125, 125, 125),
                                                    ),
                                                  );
                                                  Navigator.of(context).pop();
                                                }
                                              },
                                              child: const Text(
                                                'Yes',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
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

  // upload ảnh-------------
  Future<void> pickAndUploadImagesToFirebase() async {
    // lấy id mới nhất của product
    final DatabaseReference _databaseReferencePro =
        FirebaseDatabase.instance.reference();

    DataSnapshot snapshotProduct =
        await _databaseReferencePro.child('Max').child('MaxProduct').get();

    int ID_ProductNow =
        snapshotProduct.exists ? snapshotProduct.value as int : 0;
    int ID_ProductNew = ID_ProductNow + 1;
    String ID_ProductNewString = 'Product$ID_ProductNew';

// --------------------------------------------------------
    final List<XFile>? files = await ImagePicker().pickMultiImage();
    if (files == null || files.isEmpty) return;

    for (var file in files) {
      Uint8List imageData = await File(file.path).readAsBytes();
      String fileName =
          '$ID_ProductNewString${DateTime.now().millisecondsSinceEpoch}.png';

      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDireImages =
          referenceRoot.child('Pictures_Product').child(ID_ProductNewString);
      Reference referenceUpLoad = referenceDireImages.child(fileName);

      try {
        await referenceUpLoad.putData(
            imageData, SettableMetadata(contentType: 'image/png'));

        String downloadUrl = await referenceUpLoad.getDownloadURL();
        setState(() {
          imageUrls.add(downloadUrl);
        });
        print('Download URL: $downloadUrl');
      } catch (error) {
        print('Error uploading image to Firebase Storage: $error');
      }
    }
  }
}
