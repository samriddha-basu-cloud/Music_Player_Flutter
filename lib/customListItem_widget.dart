import 'package:flutter/material.dart';

Widget customListItem(
  {
    required String title,
    required String singer,
    required String cover,
    onTap,
  }
) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(
        8,
      ),
    child: Row(children: [
      Container(height: 80,width: 80,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(
        16,
        ), 
        image: DecorationImage(image: NetworkImage(cover,),),
        ),
        ),
        const SizedBox(width:10,),
        Column(children: [
          Text(title,style:const TextStyle(fontSize: 18,fontWeight: FontWeight.w600,),),
          const SizedBox(height: 5,),
          Text(singer,style:const TextStyle(color:Colors.grey,fontSize: 16,),),
          
        ],)
    ],)
  )
  );
}
