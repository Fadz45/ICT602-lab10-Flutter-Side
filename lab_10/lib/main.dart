// main.dart

import 'package:flutter/material.dart';
import 'food_model.dart';
import 'food_api.dart';
import 'add_food_page.dart';
import 'edit_food_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 10',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Food>> foods;

  @override
  void initState() {
    super.initState();
    foods = FoodApi.fetchFoods();
  }

  Future<void> refreshFoods() async {
    setState(() {
      foods = FoodApi.fetchFoods();
    });
  }

  Future<void> deleteFood(int id) async {
    try {
      await FoodApi.deleteFood(id);
      refreshFoods();
    } catch (e) {
      print('Exception during food deletion: $e');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to delete food. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lab 10 - Foods'),
      ),
      body: RefreshIndicator(
        onRefresh: refreshFoods,
        child: FutureBuilder<List<Food>>(
          future: foods,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return FoodList(
                foods: snapshot.data!,
                onEdit: (foodId) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditFoodPage(foodId: foodId),
                    ),
                  ).then((value) => refreshFoods());
                },
                onDelete: (foodId) => deleteFood(foodId),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddFoodPage()),
          ).then((value) => refreshFoods());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class FoodList extends StatelessWidget {
  final List<Food> foods;
  final void Function(int) onEdit;
  final void Function(int) onDelete;

  FoodList({required this.foods, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: foods.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(foods[index].name),
          subtitle: Text(foods[index].description),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('\$${foods[index].price}'),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => onEdit(foods[index].id),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => onDelete(foods[index].id),
              ),
            ],
          ),
        );
      },
    );
  }
}
