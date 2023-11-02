import 'package:flutter/material.dart';
import 'package:remote_photo_gallery/src/presentation/theme/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome to Clouds', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35, color: AppColors.primary),),
              SizedBox(height: 40),
              Padding(padding: EdgeInsets.all(20), child: Image(image: AssetImage('assets/images/splash-image.png'))),
            ],
          ),
        ),
      ),
    );
  }
}