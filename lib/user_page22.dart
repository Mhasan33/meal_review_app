import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meal_review_app/meal_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'm_meal_details.dart';
import 'main.dart';

class UserPage22 extends StatefulWidget {
  @override
  State<UserPage22> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage22> {
  // Define meals as an observable list
  final RxList<Meals> meals = <Meals>[].obs;

  @override
  void initState() {
    super.initState();
    loadMeals();
  }

  Future<void> loadMeals() async {
    // Load meals from Supabase
    final temp = await Supabase.instance.client.from('Meals_duplicate').select().withConverter(Meals.converter);
    meals.value = temp;  // Assign the loaded data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text('Meal Review App'.tr),
        actions: [

          ElevatedButton
          (onPressed: (){
            getAverageRatingCalculator(ratingCalculator);

            print(ratingCalculator);

            if(getAverageRatingCalculator(ratingCalculator) ==0 )   {showMessageDialog(context,'Choose rating. thanks');}
          if(getAverageRatingCalculator(ratingCalculator) >0 && getAverageRatingCalculator(ratingCalculator) <2 )   {showMessageDialog(context,'Sorry we will make more to make you happy');}
          else if (getAverageRatingCalculator(ratingCalculator) > 2 && getAverageRatingCalculator(ratingCalculator) < 5){showMessageDialog(context,'thanks for you. hope to see you again');}
          else if (getAverageRatingCalculator(ratingCalculator) == 5){showMessageDialog(context,'You are special guest thank you.');}
print(getAverageRatingCalculator(ratingCalculator));
        }, child: Text('Finish'.tr,))],


      ),
      body: Obx(
            () {
          // Check the length of the meals list to decide what to display
          return meals.isEmpty
              ? Center(child: CircularProgressIndicator())  // Loading indicator
              : LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                // Use GridView for desktop
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  padding: const EdgeInsets.all(10),
                  itemCount: meals.length,
                  itemBuilder: (ctx, index) {
                    return buildMealCard(context, index);
                  },
                );
              } else {
                // Use ListView for mobile
                return ListView.builder(
                  itemCount: meals.length,
                  itemBuilder: (ctx, index) => buildMealListTile(context, index),
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget buildMealCard(BuildContext context, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MealDetailPage(meal: meals[index]),
            ),
          );
        },
        child: Column(
          children: [
            Expanded(
              flex: 8,  // 80% for image
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: FutureBuilder(
                  future: _loadImage('${meals[index].mealImage}'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Center(child: Text('No Image')); // Fallback for image errors
                      }
                      return Image.network(
                        '${meals[index].mealImage}',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity, // Make image fill the space
                      );
                    } else {
                      return Center(child: CircularProgressIndicator()); // Loading indicator
                    }
                  },
                ),
              ),
            ),
            Expanded(
              flex: 2,  // 20% for meal name
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8), // Add some vertical padding
                child: Text(
                  meals[index].mealName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildMealListTile(BuildContext context, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      elevation: 4,
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: FutureBuilder(
            future: _loadImage('${meals[index].mealImage}'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text('No Image');
                }
                return Image.network(
                  '${meals[index].mealImage}',
                  fit: BoxFit.cover,
                  width: 60,
                  height: 60,
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
        title: Text(
          meals[index].mealName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MealDetailPage(meal: meals[index]),
            ),
          );
        },
      ),
    );
  }

  Future<void> _loadImage(String imageUrl) async {
    try {
      await NetworkImage(imageUrl).obtainKey(const ImageConfiguration());
      return Future.value();
    } catch (e) {
      print('Failed to load image: $e');
      throw Exception('Failed to load image: $e');
    }
  }

  void showMessageDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), // Rounded corners
          ),

          content: Text(message), // Use the provided message
        );
      },
    );

    // Automatically dismiss the dialog after 2 seconds
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pop(); // Close the dialog
      Navigator.of(context).pop(); // back to main screen
    });

  }


}
