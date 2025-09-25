import 'package:flutter/material.dart';
import 'pages/recipe_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MakanYUK',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: RecipeListPage(),
    );
  }
}

