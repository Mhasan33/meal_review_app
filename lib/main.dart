import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'my_translations.dart';
import 'on_boarding_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
   url: 'https://iyhevaeqtlfxnbajwjjv.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml5aGV2YWVxdGxmeG5iYWp3amp2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjgxMjU2ODMsImV4cCI6MjA0MzcwMTY4M30.ZBQVTTS5VJBLwsmwhjDG9G4tblBNAMNT2DDk0giSHPI',
  );
  runApp( const MealApp());
}

final cloud = Supabase.instance.client;
List<int> ratingCalculator=[];

double getAverageRatingCalculator(List<int> ratingCalculator) {
  if (ratingCalculator.isEmpty) return 0; // Handle empty list case

  int sum = ratingCalculator.reduce((a, b) => a + b) ;
  return sum / ratingCalculator.length;
}

//var ratingCalculatorFinal = getAverageRatingCalculator(ratingCalculator).obs;

class MealApp extends StatelessWidget {
  const MealApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: MyTranslations(),
      //locale: Locale('ar'),
      debugShowCheckedModeBanner: false,
      title: 'Meal Review App',
      home:  OnboardingPage(),
    );
  }
}