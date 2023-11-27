import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MusicItem extends StatelessWidget {
 final String title;
 final Color color;



   const MusicItem({Key? key,required this.title,required this.color,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 10,),
          Container(
           height: 56,
            width: double.infinity,
            child: Row(children: [
              SizedBox(width: 5,),
              Image.asset("assets/images/img.png"),
              SizedBox(width: 10,),
              Text(title, style: TextStyle(color: Colors.white),)
            ],),
          ),
        ],
      ),
    );
  }
}
