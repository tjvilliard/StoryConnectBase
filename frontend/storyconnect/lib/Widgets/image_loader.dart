import 'package:flutter/material.dart';

/// A button with a filled background.
class ImageLoader extends StatelessWidget {
  final String url;
  final BoxConstraints? constraints;
  final BoxFit? fit;

  const ImageLoader({super.key, required this.url, this.constraints, this.fit});

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: constraints,
        child: Image.network(
          url,
          fit: fit ?? BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
            // You can add your custom error widget here
            return const Text('Error loading image');
          },
        ));
  }
}
