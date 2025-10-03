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

  List<String> _tags = [];
  String? _selectedTag;

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

    _api.fetchRecipeTags().then((tags) {
      setState(() {
        _tags = tags;
      });
    });

    _searchController.addListener(() {
      _applyFilters();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    String query = "";
    try {
      query = _searchController.text.toLowerCase();
    } catch (e) {
      query = "";
    }

    List<Recipe> temp = _allRecipes;

    if (_selectedTag != null) {
      temp = temp.where((recipe) {
        return recipe.tags.contains(_selectedTag);
      }).toList();
    }

    if (query.isNotEmpty) {
      temp = temp.where((recipe) {
        return recipe.name.toLowerCase().contains(query);
      }).toList();
    }

    setState(() {
      _filteredRecipes = temp;
    });
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
          // search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari resep...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          // tag cards
          Container(
            height: 43,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView.separated(
   scrollDirection: Axis.horizontal,
              itemCount: _tags.length + 1,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                String tag;
                if (index == 0) {
                  tag = 'Semua';
                } else {
                  tag = _tags[index - 1];
                }
                bool isSelected = (tag == 'Semua' && _selectedTag == null) || (tag == _selectedTag);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (tag == 'Semua') {
                        _selectedTag = null;
                      } else {
                        _selectedTag = tag;
                      }
                    });
                    _applyFilters();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.deepPurple : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? Colors.deepPurple : Colors.grey,
                      ),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // daftar resep
          Expanded(
            child: FutureBuilder<List<Recipe>>(
              future: _futureRecipes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Tidak ada resep'));
                } else {
                  if (_filteredRecipes.isEmpty) {
                    return const Center(child: Text('Resep tidak ditemukan'));
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

