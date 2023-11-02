import 'package:flutter/material.dart';

import '../../api/image_api_client.dart';
import '../theme/theme.dart';
import 'home_screen.dart';

class DetailsScreen extends StatelessWidget {
  DetailsScreen({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String url;

  final client = ImageApiClient();

  @override
  Widget build(BuildContext context) {
    final messanger = ScaffoldMessenger.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Image Details'),
      ),
      // ignore: avoid_unnecessary_containers
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Image.network(url),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(
                            width: 1.0, color: AppColors.primary),
                        backgroundColor: AppColors.textButtonColor,
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()));
                      },
                      child: const Text('Back'),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          side: const BorderSide(
                              width: 1.0, color: AppColors.accent),
                          backgroundColor: AppColors.accent,
                          foregroundColor: AppColors.textButtonColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                        ),
                        onPressed: () async {
                          await client.deleteImage(url).then((value) =>
                              messanger.showSnackBar(const SnackBar(
                                  content:
                                      Text('Image Deleted Successfully'))));
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()));
                        },
                        child: const Text('Delete')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
