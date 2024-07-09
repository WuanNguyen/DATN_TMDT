import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        title: const Text("Abous Us"),
        backgroundColor: const Color.fromRGBO(201, 241, 248, 1),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
      ),
      body: Container(
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
              Color.fromRGBO(231, 227, 227, 1),
            ],
            tileMode: TileMode.mirror,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(// about us
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: Image.asset("assets/img/AboutUs.png"),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                child: Column(
                  children: [
                    RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        height: 1.3
                      ),
                      children: [
                        TextSpan(
                          text: "Welcome to ",
                          //style: TextStyle(color: Colors.black,fontSize: 20)
                        ),
                        TextSpan(
                          text: "HuViz ",
                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20)
                        ),
                        TextSpan(
                          text: "your ultimate mobile app for discovering and shopping the latest fashion trends!\n",
                          //style: TextStyle(color: Colors.black,fontSize: 20)
                        ),
                        TextSpan(
                          text: "At ",
                          //style: TextStyle(color: Colors.black,fontSize: 20)
                        ),
                        TextSpan(
                          text: "HuViz ",
                          //style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20)
                        ),
                        TextSpan(
                          text: "we believe that fashion should be accessible, enjoyable, and uniquely tailored to each individual. Our mission is to transform your shopping experience by offering a seamless, personalized, and engaging platform for all your fashion needs.\n",
                          //style: TextStyle(color: Colors.black,fontSize: 20)
                        ),
                      ]
                    )),
                  ],
                )
              ),

              Container(// Who We Are
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: Image.asset("assets/img/WhoAreWe_Tranparent.png"),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          height: 1.3
                        ),
                        children: [
                          TextSpan(
                            text: "Who We Are\n",
                            style: TextStyle(fontWeight: FontWeight.bold)
                          ),
                          TextSpan(
                            text: "We are a dedicated team of fashion enthusiasts, tech innovators, and customer service professionals committed to revolutionizing the way you shop. Combining our expertise in fashion design, technology, and e-commerce, we aim to create an app that caters to your personal style and preferences.\n",
                          ),
                        ]
                      ),
                    )
                  ],
                ),
              ),

              Container(// What We Offer
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: Image.asset("assets/img/WhatWeOffer.png"),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text:const TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          height: 1.3
                        ),
                        children: [
                          TextSpan(
                            text: "What We Offer\n",
                            style: TextStyle(fontWeight: FontWeight.bold)
                          ),
                          TextSpan(
                            text: "• Curated Collections: ",
                            style: TextStyle(fontWeight: FontWeight.bold)
                          ),
                          TextSpan(
                            text:"Explore carefully selected collections from top designers and popular brands, tailored specifically to your tastes.\n"
                          ),

                          TextSpan(
                            text: "• Personalized Recommendations: ",
                            style: TextStyle(fontWeight: FontWeight.bold)
                          ),
                          TextSpan(
                            text:"Explore carefully selected collections from top designers and popular brands, tailored specifically to your tastes.\n"
                          ),

                          TextSpan(
                            text: "• User-Friendly Interface: ",
                            style: TextStyle(fontWeight: FontWeight.bold)
                          ),
                          TextSpan(
                            text:"Easily navigate our intuitive app, explore various categories, and find exactly what you’re looking for in just a few taps.\n"
                          )
                        ]
                      ),
                    )
                  ],
                ),
              ),

              Container(// Our Commitment
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: Image.asset("assets/img/OurCommitment.png"),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          height: 1.3
                        ),
                        children: [
                          TextSpan(
                            text: "Our Commitment\n",
                            style: TextStyle(fontWeight: FontWeight.bold)
                          ),
                          TextSpan(
                            text: "At ",
                          ),
                          TextSpan(
                            text:"HuViz",
                            style: TextStyle(fontWeight: FontWeight.bold)
                          ),

                          TextSpan(
                            text: ", we are dedicated to sustainability and ethical fashion. We partner with brands that prioritize eco-friendly practices and fair trade, ensuring that your fashion choices are not only stylish but also responsible.\n",
                          ),
                          
                        ]
                      ),
                    ),
                    
                  ],
                ),
              ),
              Container(// Join Our Community
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: Image.asset("assets/img/JoinOurCommunity.png",width: MediaQuery.of(context).size.width,),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          height: 1.3
                        ),
                        children: [
                          TextSpan(
                            text: "Join Our Community\n",
                            style: TextStyle(fontWeight: FontWeight.bold)
                          ),
                          TextSpan(
                            text: "Become a part of our growing community of fashion-forward individuals who are redefining their shopping experience. Share your favorite looks, get inspired by others, and stay updated with the latest trends through our interactive platform.\n",
                          ),
                          TextSpan(
                            text:"Thank you for choosing ",
                            
                          ),

                          TextSpan(
                            text: "HuViz ",
                            style: TextStyle(fontWeight: FontWeight.bold)
                          ),
                          TextSpan(
                            text: "as your fashion companion. We are excited to help you express your unique style and make every shopping experience a delightful one.\n\n"
                          ),
                          TextSpan(
                            text: "Happy Shopping!\n\n"
                          ),
                          TextSpan(
                            text:"The "
                          ),
                          TextSpan(
                            text:"HuViz ",
                            style: TextStyle(fontWeight: FontWeight.bold)
                          ),
                          TextSpan(
                            text:"Team\n"
                          )
                          
                        ]
                      ),
                    )
                  ],
                ),
              ),
              
            ]
          )
        ),
      )
    );
  }
}