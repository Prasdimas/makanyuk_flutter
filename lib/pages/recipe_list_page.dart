import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/api_service.dart';
import 'recipe_detail_page.dart';
import '../widgets/recipe_card.dart'; 

class RecipeListPage extends StatefulWidget {
  @override
  _RecipeListPageState createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  final ApiService _api = ApiService();

  late Future<List<Recipe>> _futureRecipes;
  List<Recipe> _allRecipes = [];
  List<Recipe> _filteredRecipes = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureRecipes = _api.fetchRecipes();
    _futureRecipes.then((recipes) {
      setState(() {
        _allRecipes = recipes;
        _filteredRecipes = recipes;
      });
    });

    _searchController.addListener(() {
      _filterRecipes();
    });
  }

  void _filterRecipes() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filteredRecipes = _allRecipes;
      } else {
        _filteredRecipes = _allRecipes.where((recipe) {
          return recipe.name.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 36, 3, 126),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'MakanYuk',
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Pencarian ...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Recipe>>(
              future: _futureRecipes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Tidak ada resep'));
                } else {
                  if (_filteredRecipes.isEmpty) {
                    return Center(child: Text('Resep tidak ditemukan'));
                  }
                  return ListView.builder(
                    itemCount: _filteredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = _filteredRecipes[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeDetailPage(recipeId: recipe.id),
                            ),
                          );
                        },
                        child: RecipeCard(
                          title: recipe.name,
                          cookTime: '${recipe.cookTimeMinutes} mins',
                          rating: recipe.rating.toString(),
                          thumbnailUrl: recipe.image,
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
