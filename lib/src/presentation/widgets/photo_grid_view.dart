import 'package:flutter/material.dart';
import 'package:remote_photo_gallery/src/presentation/theme/app_colors.dart';

import '../../api/image_api_client.dart';
import '../screens/details_screen.dart';

class PhotoGridView extends StatefulWidget {
  const PhotoGridView({super.key, required this.imageUrls});
  final List<String>? imageUrls;

  @override
  State<PhotoGridView> createState() => _PhotoGridViewState();
}

class _PhotoGridViewState extends State<PhotoGridView> {
  List<String> selectedPhotos = [];

  final client = ImageApiClient();

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Photo Gallery'),
        actions: [
          if (selectedPhotos.isNotEmpty)
            Row(
              children: [
                TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textButtonColor,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedPhotos = [];
                      });
                    },
                    child: const Text('Unselect All')),
                IconButton(
                  onPressed: () {
                    client.deleteImages(selectedPhotos);
                    setState(() {
                      widget.imageUrls?.removeWhere((photo) {
                        return selectedPhotos.contains(photo);
                      });
                      selectedPhotos = [];
                    });
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: widget.imageUrls?.length,
          itemBuilder: (context, index) {
            final photo = widget.imageUrls![index];

            return GestureDetector(
              onTap: () {
                if (selectedPhotos.isNotEmpty) {
                  setState(() {
                    if (selectedPhotos.contains(photo)) {
                      selectedPhotos.remove(photo);
                    } else {
                      selectedPhotos.add(photo);
                    }
                  });
                } else {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailsScreen(
                                url: photo,
                              )));
                }
              },
              onLongPress: () {
                setState(() {
                  if (selectedPhotos.contains(photo)) {
                    selectedPhotos.remove(photo);
                  } else {
                    selectedPhotos.add(photo);
                  }
                });
              },
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: NetworkImage(photo),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (selectedPhotos.contains(photo))
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.black.withOpacity(0.5),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
