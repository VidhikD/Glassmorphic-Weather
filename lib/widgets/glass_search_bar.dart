import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class GlassSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;

  const GlassSearchBar({super.key, required this.controller, required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 50,
      borderRadius: 10,
      blur: 15,
      border: 1.5,
      linearGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1)],
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: "Search city...",
          hintStyle: TextStyle(color: Colors.white54),
          prefixIcon: Icon(Icons.search, color: Colors.white),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 15),
        ),
        onSubmitted: onSubmitted,
      ),
    );
  }
}
