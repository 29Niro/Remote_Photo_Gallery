import 'package:flutter/material.dart';
import 'package:remote_photo_gallery/src/presentation/theme/app_colors.dart';

import '../../models/photo.dart';
import '../screens/details_screen.dart';

class PhotoGridView extends StatefulWidget {
  const PhotoGridView({super.key, required this.photoFiles});
  final List<Photo>? photoFiles;

  @override
  State<PhotoGridView> createState() => _PhotoGridViewState();
}

class _PhotoGridViewState extends State<PhotoGridView> {

  List<Photo> selectedPhotos = [];

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
                    setState(() {
                      widget.photoFiles?.removeWhere((photo) {
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
          itemCount: widget.photoFiles?.length,
          itemBuilder: (context, index) {
            final photo = widget.photoFiles?[index];

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(
                        url: photo.url,
                        title: photo.title,
                      ),
                    ),
                  );
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
                        image: AssetImage(photo!.url),
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
