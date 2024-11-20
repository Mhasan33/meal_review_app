import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meal_review_app/user_page22.dart';

import 'admin_login_page.dart';

class OnboardingPage extends StatefulWidget {
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        backgroundColor: Colors.white,
        actions: [
          Text(
            'Language'.tr, // Using .tr for localization
            style: TextStyle(color: Colors.blue, fontSize: 16),
          ),
          SizedBox(width: 10,),
          DropdownButton<String>(
            value: Get.locale?.languageCode ?? 'en', // Default to 'en'

            icon: Icon(Icons.language, color: Colors.blue),
            dropdownColor: Colors.blue[50],
            onChanged: (String? newValue) {
              if (newValue != null) {
                Get.updateLocale(Locale(newValue));
              }
            },
            items: <String>['en', 'ar'].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value == 'en' ? 'English' : 'عربي',
                  style: TextStyle(color: Colors.blue),
                ),
              );
            }).toList(),
          ),
          SizedBox(width: 16), // Space between dropdown and the edge of the app bar
        ],
      ),


      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              width: Get.width*.40,
              fit: BoxFit.cover,
                'https://static.vecteezy.com/system/resources/previews/024/218/698/non_2x/enjoy-your-meal-illustration-a-variety-of-delicious-food-in-home-or-restaurant-in-flat-cartoon-hand-drawn-landing-page-background-templates-vector.jpg'),
            Text(
              'Welcome to Meal Review App!'.tr,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                // Navigate to User Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserPage22()),
                );
              },
              child: Text('Continue as Guest'.tr),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Admin Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminLoginPage()),
                );
              },
              child: Text('Continue as Admin'.tr),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue, // Change color for admin button
              ),
            ),
          ],
        ),
      ),
    );
  }
}
