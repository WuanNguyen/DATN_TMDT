import 'package:flutter/material.dart';

class SizeButton extends StatefulWidget {
  SizeButton({super.key,required this.size,required this.selected});
  String size;
  String selected;
  @override
  State<SizeButton> createState() => _SizeButtonState();
}

class _SizeButtonState extends State<SizeButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
      decoration: BoxDecoration(
        
      ),
      child: ElevatedButton(
        onPressed: (){
          
        }, 
        child: Text(widget.size.toUpperCase())
      ),
    );
  }
}