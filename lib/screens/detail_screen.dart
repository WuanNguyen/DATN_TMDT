import 'package:doan_tmdt/model/product_class.dart';
import 'package:doan_tmdt/screens/detail_items/rating.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen({super.key,required this.pro});
  Product pro;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int size = 0;
  String desc = "The quick, brown fox jumps over a lazy dog. DJs flock by when MTV ax quiz prog. Junk MTV quiz graced by fox whelps. Bawds jog, flick quartz, vex nymphs. Waltz, bad nymph, for quick jigs vex! Fox nymphs grab quick-jived waltz. Brick quiz whangs jumpy veldt fox. Bright vixens jump; dozy fowl quack. Quick wafting zephyrs vex bold Jim. Quick zephyrs blow, vexing daft Jim. Sex-charged fop blew my junk TV quiz. How quickly daft jumping zebras vex. Two driven jocks help fax my big quiz. Quick, Baz, get my woven flax jodhpurs!  my brave ghost pled. Five quacking zephyrs jolt my wax bed. Flummoxed by job, kvetching W. zaps Iraq. Cozy sphinx waves quart jug of bad milk. A very bad quack might jinx zippy fowls. Few quips galvanized the mock jury box. Quick brown dogs jump over the lazy fox. The jay, pig, fox, zebra, and my wolves quack! Blowzy red vixens fight for a quick jump. Joaquin Phoenix was gazed by MTV for luck. A wizard’s job is to vex chumps quickly in fog. Watch , Alex Trebek's fun TV quiz game. Woven silk pyjamas exchanged for blue quartz. Brawny gods just";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor:const Color.fromRGBO(201, 241, 248, 1),
        leading: Container(
          decoration: BoxDecoration(
            //color:Color.fromRGBO(63, 55, 86, 0.32),
            shape: BoxShape.circle,
          ),
          child: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child:Icon(Icons.arrow_back_ios_new,color:Colors.black)
          ),
        )
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height:MediaQuery.of(context).size.height,
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
            Container(// hinh anh
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              width: MediaQuery.of(context).size.height / 3,
              height: MediaQuery.of(context).size.height / 3,
              child: Image.network(widget.pro.img,fit:BoxFit.cover)//image (fit: BoxFit.cover)
            ),
            Container(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              height: MediaQuery.of(context).size.height - (MediaQuery.of(context).size.height / 3) - 76,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50)),
                color:Colors.white,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row( 
                      children: [
                        Container( //ten, gia tien va danh gia
                          width: MediaQuery.of(context).size.width - 197,
                          padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.pro.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                              Text("${widget.pro.price} VND"),
                              Rating(rate:3.5)
                              
                              //todo: rating
                            ],
                          ),
                        ),
                        GestureDetector( //button
                          onTap: (){
                            print("Added to cart");
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            padding: EdgeInsets.fromLTRB(10, 12, 20, 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(45),
                              color: Color.fromRGBO(239, 237, 237, 1)
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.add_shopping_cart_rounded),
                                Text("Add to cart")
                              ],
                            )
                          ),
                        )
                      ],
                    ),
                    Column( // size
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Size",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                        Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
                        Row(// size button
                          children: [
                            OutlinedButton(
                              onPressed: (){
                                setState(() {
                                  size = 0;
                                });
                              }, 
                              style: ButtonStyle(
                                side: WidgetStatePropertyAll(
                                  BorderSide(width: size==0?2.0:0.5)
                                  ),
                              ),
                              child: Text("S",style:TextStyle(color: Colors.black))
                            ),
                            Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0),),
                            OutlinedButton(
                              onPressed: (){
                                setState(() {
                                  size = 1;
                                });
                              }, 
                              style: ButtonStyle(
                                side: WidgetStatePropertyAll(
                                  BorderSide(width: size==1?2.0:0.5)
                                  ),
                              ),
                              child: Text("M",style:TextStyle(color: Colors.black))
                            ),
                            Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0),),
                            OutlinedButton(
                              onPressed: (){
                                setState(() {
                                  size = 2;
                                });
                              }, 
                              style: ButtonStyle(
                                side: WidgetStatePropertyAll(
                                  BorderSide(width: size==2?2.0:0.5)
                                  ),
                              ),
                              child: Text("L",style:TextStyle(color: Colors.black))
                            ),
                          ],
                        )
                      ],
                    ),
                    SingleChildScrollView(//phan mo ta
                      physics: NeverScrollableScrollPhysics(),
                      child: Container(
                      margin: EdgeInsets.fromLTRB(0, 15, 7, 0),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Description",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                          Text(desc),
                          Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10))
                        ],
                      ),
                    )
                  )
                ],
              ),
              )
            )
          ],
        ),
      )
    );
  }
}