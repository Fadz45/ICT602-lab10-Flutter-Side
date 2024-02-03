// edit_food_page.dart

import 'package:flutter/material.dart';
import 'food_api.dart';

class EditFoodPage extends StatelessWidget {
  final int foodId;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  EditFoodPage({required this.foodId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Food'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: FoodApi.fetchFoodById(foodId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final food = snapshot.data!;
            nameController.text = food['name'];
            descriptionController.text = food['description'];
            priceController.text = food['price'].toString();

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                  TextField(
                    controller: priceController,
                    decoration: InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await FoodApi.updateFood(
                        foodId,
                        {
                          'name': nameController.text,
                          'description': descriptionController.text,
                          'price': priceController.text,
                        },
                      );

                      Navigator.of(context).pop(); // Close the page after updating
                    },
                    child: Text('Update Food'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
