import 'package:flutter/material.dart';
import 'package:remote_photo_gallery/src/presentation/screens/upload_screen.dart';
import '../../models/photo.dart';
import '../theme/app_colors.dart';
import '../widgets/photo_grid_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Photo> photoFiles = [
    Photo(
      url: 'assets/images/image-1.jpg',
      title: 'Image 1',
      id: 1, 
      thumbnailUrl: '',
    ),
    Photo(
      url: 'assets/images/image-2.jpg',
      title: 'Image 2',
      id: 2, 
      thumbnailUrl: '',
    ),
    Photo(
      url: 'assets/images/image-3.jpg',
      title: 'Image 3',
      id: 3, 
      thumbnailUrl: '',
    ),
    Photo(
      url: 'assets/images/image-4.jpg',
      title: 'Image 4',
      id: 4, 
      thumbnailUrl: '',
    ),
    Photo(
      url: 'assets/images/image-5.jpg',
      title: 'Image 5',
      id: 5, 
      thumbnailUrl: '',
    ),
    Photo(
      url: 'assets/images/image-6.jpg',
      title: 'Image 6',
      id: 6, 
      thumbnailUrl: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoGridView(photoFiles: photoFiles),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const UploadScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
