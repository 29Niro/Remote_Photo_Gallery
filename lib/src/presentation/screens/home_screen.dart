import 'package:flutter/material.dart';
import 'package:remote_photo_gallery/src/presentation/screens/upload_screen.dart';
import '../../api/image_api_client.dart';
import '../theme/app_colors.dart';
import '../widgets/photo_grid_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final client = ImageApiClient();
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    client.getImages().then((value) {
      setState(() {
        imageUrls = value.map((e) => e.toString()).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: client.getImages(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<String>? imageUrls =
                snapshot.data?.map((e) => e.toString()).toList();

            return PhotoGridView(imageUrls: imageUrls);
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () async {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const UploadScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
