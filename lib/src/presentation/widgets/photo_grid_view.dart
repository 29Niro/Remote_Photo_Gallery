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
        automaticallyImplyLeading: false,
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
                  // onPressed: () {
                  //   client.deleteImages(selectedPhotos);
                  //   setState(() {
                  //     widget.imageUrls?.removeWhere((photo) {
                  //       return selectedPhotos.contains(photo);
                  //     });
                  //     selectedPhotos = [];
                  //   });
                  // },
                  onPressed: () {
                    _showAlertDialog(context);
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

  void _showAlertDialog(BuildContext context) {
    final messanger = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var height = MediaQuery.of(context).size.height;
        var width = MediaQuery.of(context).size.width;
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(
                width: 10,
              ),
              const Text(
                'ALERT',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          content: SizedBox(
            height: height * 0.16,
            child: Column(
              children: [
                const Text(
                  'Are you sure you want to delete?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.text,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () async {
                          await client
                              .deleteImages(selectedPhotos)
                              .then((value) =>
                                  messanger.showSnackBar(const SnackBar(
                                    content: Text('Images Deleted Successfully'),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: AppColors.success,
                                  )))
                              .onError((error, stackTrace) =>
                                  messanger.showSnackBar(const SnackBar(
                                    content: Text(
                                        'Something went wrong. Check your network!'),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: AppColors.error,
                                  )))
                              .then((value) {
                            setState(() {
                              widget.imageUrls?.removeWhere((photo) {
                                return selectedPhotos.contains(photo);
                              });
                              selectedPhotos = [];
                            });
                          }).then((value) => Navigator.pop(context));
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                              side: BorderSide(
                                color: AppColors.primary,
                              )),
                          minimumSize: const Size(80, 40),
                        ),
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textButtonColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.05,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.textButtonColor,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                              side: BorderSide(
                                color: AppColors.primary,
                              )),
                          minimumSize: const Size(80, 40),
                        ),
                        child: const Text(
                          'No',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
