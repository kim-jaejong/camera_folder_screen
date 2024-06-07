import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../custom/custom_text.dart';
import 'package:path_provider/path_provider.dart';

class GroupedImagePicker extends StatefulWidget {
  const GroupedImagePicker({super.key});

  @override
  State<GroupedImagePicker> createState() => _GroupedImagePickerState();
}

class _GroupedImagePickerState extends State<GroupedImagePicker> {
  final List<String> _selectedImages = []; // path of the original image file
  bool _isGridView = true;
  bool _isLoading = false;

  Future<void> _pickImages() async {
    setState(() {
      _isLoading = true; // Add this line
    });

    final picker = ImagePicker();
    final pickedFiles =
        await picker.pickMultiImage(maxWidth: 200, maxHeight: 200);

    for (final pickedFile in pickedFiles) {
      final file = File(pickedFile.path);
      if (!_selectedImages.contains(file.path)) {
        // Check if the image is already in the list
        _selectedImages.add(file.path); // original image file
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            '앨범 선택',
            style: TextStyle(fontSize: 12),
          ),
          actions: [
            // IconButton(
            //   icon: const Icon(Icons.photo_library),
            //   onPressed: _pickImages,
            // ),
            IconButton(
              icon: Icon(_isGridView ? Icons.list : Icons.grid_on),
              onPressed: () {
                setState(() {
                  _isGridView = !_isGridView;
                });
              },
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _selectedImages.isEmpty
                ? CustomTextButton(
                    text: '앨범 선택',
                    onPressedFunction: () {
                      _pickImages();
                    })
                : _isGridView
                    ? _buildGridView()
                    : _buildListView());
  }

  Widget _buildGridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: _selectedImages.length,
      itemBuilder: (context, index) {
        return Image.file(File(_selectedImages[index]), fit: BoxFit.cover);
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: _selectedImages.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Image.file(File(_selectedImages[index]),
              width: 50, height: 50, fit: BoxFit.cover),
          title: Text('Image ${index + 1}'),
        );
      },
    );
  }
}

Future<void> saveImage(context, file) async {
//  Save the image to the hnpna directory
  final directory = await getApplicationDocumentsDirectory();
  final path = '${directory.path}/hnpna';
  final newDirectory = await Directory(path)
      .create(recursive: true); // Creates the directory if it doesn't exist
  final newPath = '${newDirectory.path}/${file.path.split('/').last}';
  await file.copy(newPath); // Copies the image file to the new directory
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Images saved successfully!')),
  );
}
