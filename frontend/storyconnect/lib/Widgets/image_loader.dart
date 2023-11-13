import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageLoader extends StatefulWidget {
  final String url;

  ImageLoader({required this.url});

  @override
  _ImageLoaderState createState() => _ImageLoaderState();
}

class _ImageLoaderState extends State<ImageLoader> {
  Image? image;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      final response = await http.get(Uri.parse(widget.url));
      if (response.statusCode == 200) {
        setState(() {
          image = Image.memory(response.bodyBytes);
        });
      } else {
        // Handle the case when the image is not found or any other error
        print('Failed to load image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors
      print('Error occurred while loading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: image == null ? CircularProgressIndicator() : image!,
    );
  }
}
