import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meal_review_app/ingredient_rating_page4.dart';


class AdminLoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Login'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, Admin'.tr,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'User Name'.tr,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password'.tr,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add your login logic here
                String name = emailController.text;
                String password = passwordController.text;
if(name=='admin' && password=='admin'){ Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => IngredientRatingPage4()),
);
}else if(name.isEmpty || password.isEmpty){ ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Please fill in all fields'.tr),backgroundColor: Colors.red),
);}else {
    // Proceed with login logic
    // For example, validate credentials against a server
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Wrong Name Or Password...'.tr),backgroundColor: Colors.red),
    );}

              },
              child: Text('Login'.tr),
            ),
          ],
        ),
      ),
    );
  }
}