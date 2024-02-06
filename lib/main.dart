import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:music_player_app/views/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Beats',
     theme:  ThemeData(
         fontFamily: "regular",
         appBarTheme: const AppBarTheme(
           backgroundColor: Colors.transparent,
           elevation: 0,
         )
          ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}


// Padding(
// padding: EdgeInsets.all(8.0),
// child: ListView.builder(
// physics: const BouncingScrollPhysics(),
// itemCount: 100,
// itemBuilder: (BuildContext context, int index){
// return Container(
// margin: EdgeInsets.only(bottom: 4),
// child: ListTile(
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(12),
// ),
// tileColor: bgColor,
// title: Text(
// "Music name",
// style: ourStyle(family: bold, size: 15),
// ),
// subtitle:Text(
// "Artist name",
// style: ourStyle(family: regular, size: 12),
// ),
// leading: Icon(
// Icons.music_note,
// color: whiteColor,
// size: 32,
// ),
// trailing: Icon(
// Icons.play_arrow,color: whiteColor,size: 26,
// ),
// ),
// );
// }
// ),
// )