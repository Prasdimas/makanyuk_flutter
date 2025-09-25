import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/api_service.dart';

class RecipeDetailPage extends StatefulWidget {
  final int recipeId;

  const RecipeDetailPage({required this.recipeId});

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  final ApiService _api = ApiService();
  late Future<Recipe> _futureRecipe;

  @override
  void initState() {
    super.initState();
    _futureRecipe = _api.fetchRecipeDetail(widget.recipeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: const Color.fromARGB(255, 36, 3, 126),
           iconTheme: IconThemeData(color: Colors.white), 
       title: Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Icon(Icons.restaurant_menu, color: Colors.white), 
    SizedBox(width: 10),
    Text(
      'Detail',
      style: TextStyle(
        fontSize: 25,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  ],
),
        ),
      body: FutureBuilder<Recipe>(
        future: _futureRecipe,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));

          final recipe = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
Padding(
  padding: const EdgeInsets.all(16),
  child: _imageWithTitle(recipe.image, recipe.name),
),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(height: 1),
                      
                      Row(
  children: [
    Expanded(
      child: _infoRow("Rating", recipe.rating.toString(), Icons.star),
    ),
    Expanded(
      child: _infoRow("Prep Time", "${recipe.prepTimeMinutes} mins", Icons.timer),
    ),
  ],
),
SizedBox(height: 8),
Row(
  children: [
    Expanded(
      child: _infoRow("Cook Time", "${recipe.cookTimeMinutes} mins", Icons.local_fire_department),
    ),
    Expanded(
      child: _infoRow("Servings", recipe.servings.toString(), Icons.restaurant),
    ),
  ],
),

                      _faqSection("Ingredients", recipe.ingredients),
                      _faqSection("Instructions", recipe.instructions),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

Widget _imageWithTitle(String imageUrl, String title) {
  return Stack(
    children: [
      // Background image
      AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            imageUrl,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.error),
          ),
        ),
      ),
      // Gradient overlay at bottom
      Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 60,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black54,
                ],
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(15),
              ),
            ),
          ),
        ),
      ),
      // Title text
      Positioned(
        bottom: 15,
        left: 20,
        right: 20,
        child:       Container(
  padding: const EdgeInsets.all(7),
  margin: const EdgeInsets.all(10),
  decoration: BoxDecoration(
    color: Colors.black.withOpacity(0.4),
    borderRadius: BorderRadius.circular(15),
  ),
  child: Row(
    children: [
      SizedBox(width: 8),
      Expanded(
        child: Text(
           title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255),
            shadows: [
              Shadow(
                offset: Offset(0, 1),
                blurRadius: 2,
                color: Color.fromARGB(221, 194, 192, 192),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
)


      ),
    ],
  );
}


Widget _infoRow(String label, String value, IconData icon) {
  return Card(
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    margin: EdgeInsets.symmetric(horizontal: 4),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Row(
        children: [
          Icon(icon, size: 23, color: Colors.deepPurple),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Text(value, style: TextStyle(fontSize: 16)),
            ],
          )
        ],
      ),
    ),
  );
}

Widget _faqSection(String title, List<String> items) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8),
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        splashColor: Colors.deepPurple.withOpacity(0.1),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        iconColor: Colors.deepPurple,
        collapsedIconColor: Colors.deepPurple,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        children: items
            .map(
              (item) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("• ", style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    ),
  );
}

}
