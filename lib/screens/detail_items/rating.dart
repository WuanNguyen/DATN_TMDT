import 'package:flutter/material.dart';

class Rating extends StatefulWidget {
  Rating({super.key,required this.rate});
  double rate;
  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Icon(widget.rate < 1 && widget.rate >= 0.5?Icons.star_half_rounded:Icons.star_rounded,color: widget.rate>=0.5?Colors.yellow:Colors.grey,),
          Icon(widget.rate < 2 && widget.rate >= 1.5?Icons.star_half_rounded:Icons.star_rounded,color: widget.rate>=1.5?Colors.yellow:Colors.grey,),
          Icon(widget.rate < 3 && widget.rate >= 2.5?Icons.star_half_rounded:Icons.star_rounded,color: widget.rate>=2.5?Colors.yellow:Colors.grey,),
          Icon(widget.rate < 4 && widget.rate >= 3.5?Icons.star_half_rounded:Icons.star_rounded,color: widget.rate>=3.5?Colors.yellow:Colors.grey,),
          Icon(widget.rate < 5 && widget.rate >= 4.5?Icons.star_half_rounded:Icons.star_rounded,color: widget.rate>=4.5?Colors.yellow:Colors.grey,),
        ],
      ),
    );
  }
}