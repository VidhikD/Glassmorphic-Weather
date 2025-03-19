import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedBackground extends StatefulWidget {
  final String weatherCondition;

  const AnimatedBackground({super.key, required this.weatherCondition});

  @override
  _AnimatedBackgroundState createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  final List<Color> _clearWeatherColors = [
    Color(0xFF6EC6FF), // Vibrant Sky Blue
    Color(0xFFFFCC80), // Warm Golden
    Color(0xFF40C4FF), // Cool Aqua
  ];

  final List<Color> _rainyWeatherColors = [
    Color(0xFF232526), // Dark Navy
    Color(0xFF414345), // Electric Blue Grey
    Color(0xFF636363), // Soft Cyan
  ];

  final List<Color> _snowyWeatherColors = [
    Color(0xFFE0EAFC), // Ice White
    Color(0xFFCFDEF3), // Silver Blue
    Color(0xFFB6E3F7), // Arctic Teal
  ];

  final List<Color> _cloudyWeatherColors = [
    Color(0xFF434343), // Deep Charcoal
    Color(0xFF616161), // Muted Grey-Blue
    Color(0xFF757F9A), // Cool Steel
  ];

  List<Color> _getColorsForWeather() {
    switch (widget.weatherCondition.toLowerCase()) {
      case 'rain':
        return _rainyWeatherColors;
      case 'snow':
        return _snowyWeatherColors;
      case 'clouds':
        return _cloudyWeatherColors;
      default:
        return _clearWeatherColors;
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 500), // Make animation super slow
    )..repeat();

    _colorAnimation = TweenSequence<Color?>(
      _getColorsForWeather().map((color) {
        return TweenSequenceItem(
          tween: ColorTween(begin: color, end: color),
          weight: 1, // Equal weight for smooth transitions
        );
      }).toList(),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear, // Keeps it uniform and slow
    ));
  }

  void _updateAnimation() {
    _colorAnimation = TweenSequence<Color?>(
      _getColorsForWeather().map((color) {
        return TweenSequenceItem(
          tween: ColorTween(begin: color, end: color.withOpacity(0.8)),
          weight: 1,
        );
      }).toList(),
    ).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant AnimatedBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.weatherCondition != widget.weatherCondition) {
      setState(() {
        _updateAnimation();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _colorAnimation.value ?? Colors.black,
                _colorAnimation.value?.withOpacity(0.8) ?? Colors.black,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: CustomPaint(
            painter: ParticlePainter(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ParticlePainter extends CustomPainter {
  final Random _random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.5);

    for (int i = 0; i < 30; i++) {
      double dx = _random.nextDouble() * size.width;
      double dy = _random.nextDouble() * size.height;
      double radius = _random.nextDouble() * 4 + 2;

      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
