import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'meal_model.dart'; // Import your Meals model

class IngredientRatingPage4 extends StatefulWidget {
  @override
  _IngredientRatingPageState createState() => _IngredientRatingPageState();
}

class _IngredientRatingPageState extends State<IngredientRatingPage4> {
  List<Meals> meals = [];
  bool isLoading = false;
  String? errorMessage;
  int? expandedIndex; // To track the currently expanded item

  @override
  void initState() {
    super.initState();
    fetchIngredientRatings();
  }

  Future<void> fetchIngredientRatings() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await Supabase.instance.client
          .from('Meals_duplicate') // Fetch from the Meals_duplicate table
          .select() // Select relevant columns
          .withConverter(Meals.converter); // Use the converter

      setState(() {
        meals = response;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
      showErrorDialog(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  double calculateAverageRating(List<dynamic> ratings) {
    if (ratings.isEmpty) return 0.0;

    List<double> convertedRatings = ratings.map((rating) {
      return rating is int
          ? rating.toDouble()
          : (rating is double ? rating : 0.0);
    }).toList();

    return convertedRatings.reduce((a, b) => a + b) / convertedRatings.length;
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meals Reporting'.tr),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue[800], // Professional color for the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : meals.isEmpty && errorMessage == null
            ? Center(
          child: Text(
            'No meals available.',
            style: TextStyle(
                fontSize: 18.0,
                fontStyle: FontStyle.italic,
                color: Colors.grey[700]),
          ),
        )
            : Column(
          children: [
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Error: $errorMessage',
                  style: TextStyle(color: Colors.red, fontSize: 16.0),
                ),
              ),
            Expanded(
              child: ListView(
                children: [
                  ExpansionPanelList(
                    expansionCallback: (panelIndex, isExpanded) {
                      setState(() {
                        expandedIndex = isExpanded ? null : panelIndex;
                      });
                    },
                    children: meals.map<ExpansionPanel>((meal) {
                      final index = meals.indexOf(meal);
                      double averageRating =
                      calculateAverageRating(meal.ingredientReviews);
                      int numberReviews = meal.reviewNum;

                      return ExpansionPanel(
                        headerBuilder:
                            (BuildContext context, bool isExpanded) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                expandedIndex = expandedIndex == index
                                    ? null
                                    : index;
                              });
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    meal.mealImage ?? 'https://via.placeholder.com/150'), // Provide a default image if the URL is null
                                radius: 24.0, // Adjust the size of the image
                              ),
                              title: Text(
                                meal.mealName,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                ),
                              ),
                              subtitle: Text(
                                'Overall Rating: ${averageRating.toStringAsFixed(1)}',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.teal[700],
                                ),
                              ),
                              trailing: Text(
                                '$numberReviews reviews',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          );
                        },
                        body: expandedIndex == index
                            ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ingredients & Ratings:'.tr,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              meal.ingredients.isNotEmpty &&
                                  meal.ingredientReviews
                                      .isNotEmpty
                                  ? Card(
                                margin: const EdgeInsets
                                    .symmetric(
                                    vertical: 10.0),
                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius
                                      .circular(12.0),
                                ),
                                elevation: 3.0,
                                child: Padding(
                                  padding:
                                  const EdgeInsets
                                      .all(12.0),
                                  child: Column(
                                    children: List.generate(
                                        meal.ingredients
                                            .length, (i) {
                                      if (i <
                                          meal.ingredientReviews
                                              .length) {
                                        return Padding(
                                          padding: const EdgeInsets
                                              .symmetric(
                                              vertical:
                                              4.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Text(
                                                meal.ingredients[
                                                i],
                                                style: TextStyle(
                                                    fontSize:
                                                    16.0),
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .star,
                                                    color:
                                                    Colors.amber,
                                                    size:
                                                    18.0,
                                                  ),
                                                  SizedBox(
                                                      width:
                                                      4.0),
                                                  Text(
                                                    '${meal.ingredientReviews[i]}',
                                                    style:
                                                    TextStyle(
                                                      fontSize:
                                                      16.0,
                                                      color:
                                                      Colors.grey[800],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return SizedBox
                                            .shrink();
                                      }
                                    }),
                                  ),
                                ),
                              )
                                  : Padding(
                                padding:
                                const EdgeInsets.only(
                                    top: 8.0),
                                child: Text(
                                  'No ingredients or ratings available.',
                                  style: TextStyle(
                                    color:
                                    Colors.grey[600],
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.grey[400],
                                thickness: 1.0,
                                height: 30.0,
                              ),
                              Text(
                                'Comments:'.tr,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              meal.userComments.isNotEmpty
                                  ? Column(
                                children: meal.userComments
                                    .map((comment) {
                                  return Padding(
                                    padding:
                                    const EdgeInsets
                                        .symmetric(
                                        vertical:
                                        4.0),
                                    child: Card(
                                      shape:
                                      RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius
                                            .circular(
                                            10.0),
                                      ),
                                      elevation: 2.0,
                                      color: Colors
                                          .grey[200],
                                      child: ListTile(
                                        leading: Icon(
                                          Icons
                                              .comment_outlined,
                                          color: Colors
                                              .blue[800],
                                          size: 22.0,
                                        ),
                                        title: Text(
                                          comment,
                                          style:
                                          TextStyle(
                                            fontSize:
                                            14.0,
                                            color: Colors
                                                .grey[800],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              )
                                  : Padding(
                                padding:
                                const EdgeInsets.only(
                                    top: 8.0),
                                child: Text(
                                  'No comments available.',
                                  style: TextStyle(
                                    color:
                                    Colors.grey[600],
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                            : SizedBox.shrink(),
                        isExpanded: expandedIndex == index,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
