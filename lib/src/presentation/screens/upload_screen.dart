import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:remote_photo_gallery/src/presentation/screens/home_screen.dart';

import '../../api/image_api_client.dart';
import '../theme/theme.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _imageFile;
  final client = ImageApiClient();

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      try {
        setState(() {
          File imageFile = File(pickedImage.path);
          _imageFile = imageFile;
          // print('Image picked.');
        });
      } on FileSystemException catch (_, e) {
        setState(() {
          _imageFile = null;
        });
        if (kDebugMode) {
          print('Could not pick image: $e');
        }
      }
    } else {
      setState(() {
        _imageFile = null;
      });
      // print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final messanger = ScaffoldMessenger.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Upload Image'),
      ),
      // ignore: avoid_unnecessary_containers
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: _imageFile != null
                    ? Image.file(_imageFile!)
                    : Image.asset('assets/images/upload.png'),
              ),
            ),
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
                            width: 1.0, color: AppColors.primary),
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textButtonColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                      ),
                      onPressed: () async {
                        if (_imageFile != null) {
                          await client.uploadImage(_imageFile!).then((value) {
                            // print('value: $value');
                            messanger.showSnackBar(const SnackBar(
                                content: Text('Image Uploaded Successfully')));
                          }).then((value) => setState(() {
                                _imageFile = null;
                              }));
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const HomeScreen()));
                          if (kDebugMode) {
                            print('Image uploaded.');
                          }
                        } else {
                          _showImageSource(context);
                        }
                      },
                      child: _imageFile != null
                          ? const Text('Upload Image')
                          : const Text('Pick Image'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showImageSource(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: ((context) {
        return Container(
          height: 200,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
