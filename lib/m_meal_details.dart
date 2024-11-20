import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meal_review_app/user_page22.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Make sure to include the Supabase package
import 'main.dart';
import 'meal_model.dart';

class MealDetailPage extends StatefulWidget {
  final Meals meal;



  MealDetailPage({required this.meal});

  @override
  _MealDetailPageState createState() => _MealDetailPageState();
}

class _MealDetailPageState extends State<MealDetailPage> {
  List<double> ingredientRatings = [];
  var  userText=TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the ratings list with zeros
    ingredientRatings = List.filled(widget.meal.ingredients.length, 0.0);
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text(widget.meal.mealName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  '${widget.meal.mealImage}',
                  height: 250,
                  width: Get.width*.60,
                  fit: BoxFit.fill,
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return Text("NO Image");}
                ),


              ),
              SizedBox(height: 20),
              Text(
                'Ingredients:'.tr,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListView.builder(
                itemCount: widget.meal.ingredients.length,
                shrinkWrap: true, // Prevent infinite height issues
                physics: NeverScrollableScrollPhysics(), // Disable scrolling for the ListView
                itemBuilder: (ctx, index) => IngredientRating(
                  ingredient: widget.meal.ingredients[index],
                  onRatingChanged: (rating) {
                    ingredientRatings[index] = rating; // Update rating
                  },
                ),
              ),
              SizedBox(height: 30),
        
              customTextField('Add Your Comment Here...'.tr,userText),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveRating,
                child: Text('Save Rating'.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveRating() async {
    // Prepare the data for saving as an array of integers
    List<int> ingredientReviews = ingredientRatings.map((rating) {
      // If the rating is not set, default to 3
      return rating == 0.0 ? 3 : rating.round();
    }).toList();

    try {
      // Fetch the existing user comments, ingredient reviews, and review_num from the Meals_duplicate table
      final response = await Supabase.instance.client
          .from('Meals_duplicate')
          .select('user_comments, ingredient_reviews, review_num')
          .eq('id', widget.meal.id)
          .single();

      // If the response is valid and user_comments exist
      if (response != null) {
        // Retrieve existing comments and ingredient reviews
        List<String> existingComments = List<String>.from(response['user_comments'] ?? []);
        List<int> existingRatings = List<int>.from(response['ingredient_reviews'] ?? []);
        int currentReviewNum = response['review_num'] ?? 0;

        // Add the new comment if it exists
        if (userText.text.isNotEmpty) {
          existingComments.add(userText.text);
        }

        // Append new ratings to existing ratings
        for (int i = 0; i < ingredientReviews.length; i++) {
          if (i < existingRatings.length) {
            // Update existing rating by averaging old and new
            existingRatings[i] = ((existingRatings[i] + ingredientReviews[i]) / 2).round();
          } else {
            // Add new ratings if they don't exist
            existingRatings.add(ingredientReviews[i]);
          }
        }

        // Increment review number
        int updatedReviewNum = currentReviewNum + 1;

        // Prepare the update data as a map
        final updateData = Meals.update(
          id: widget.meal.id,
          ingredients: widget.meal.ingredients,
          reviewNum: updatedReviewNum, // Incremented review number
          userComments: existingComments, // Updated comments list
          ingredientReviews: existingRatings, // Updated ratings list
        );

        // Create a map from the updated Meal
        final updateMap = {
          'ingredients': updateData['ingredients'],
          'user_comments': updateData['user_comments'],
          'ingredient_reviews': updateData['ingredient_reviews'],
          'review_num': updatedReviewNum, // Pass the incremented review number
        };

        // Update the Supabase database using the map
        final updateResponse = await Supabase.instance.client
            .from('Meals_duplicate')
            .update(updateMap)
            .eq('id', widget.meal.id); // Use 'id' to identify the correct row


        //get the average of ingredientRatings
        ratingCalculator.addAll(ingredientReviews);
        getAverageRatingCalculator;
        //getAverageRatingCalculator(ingredientRatings);




        // Check for success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Rating and comment updated successfully!'.tr),
            backgroundColor: Colors.blue,
          ),
        );


        Navigator.pop(context);
      }
    } catch (e) {
      // Handle exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $e')),
      );
    }
  }

 /* double getAverage(List<double> ingredientRatings) {
    if (ingredientRatings.isEmpty) return 0; // Handle empty list case
    double sum = ingredientRatings.reduce((a, b) => a + b);
    return sum / ingredientRatings.length;
  }*/


  Widget customTextField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: hint,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
      ),
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
      cursorColor: Colors.blue,
      textInputAction: TextInputAction.done, // Customize as needed
    );
  }


}

class IngredientRating extends StatefulWidget {
  final String ingredient;
  final Function(double) onRatingChanged; // Callback to notify parent

  IngredientRating({required this.ingredient, required this.onRatingChanged});

  @override
  _IngredientRatingState createState() => _IngredientRatingState();
}

class _IngredientRatingState extends State<IngredientRating> {
  double _rating = 0.0; // Use double for finer control with a slider

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.ingredient),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Star rating
          ...List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                index < _rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
              ),
              onPressed: () {
                setState(() {
                  _rating = index + 1.0; // Store rating as a double
                  widget.onRatingChanged(_rating); // Notify parent
                });
              },
            );
          }),
          // Display the rating value
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text('${_rating.toStringAsFixed(1)}'), // Show rating as 1 decimal
          ),
        ],
      ),
    );
  }
}
