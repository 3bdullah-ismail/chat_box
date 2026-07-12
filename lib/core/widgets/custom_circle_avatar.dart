import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {
  final String imagePath;
  final double radius;
  final Color? backgroundColor;

  const CustomCircleAvatar({
    super.key,
    required this.imagePath,
    this.radius = 27,
    this.backgroundColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ClipOval(
          child: imagePath.startsWith('http')
              ? Image.network(
                  imagePath,
                  width: radius * 2,
                  height: radius * 2,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.person),
                )
              : Image.asset(
                  imagePath,
                  width: radius * 2,
                  height: radius * 2,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
        ),
      ),
    );
  }
}
