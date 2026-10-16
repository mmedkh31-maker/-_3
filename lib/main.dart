import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

void main() => runApp(const CompassApp());

class CompassApp extends StatelessWidget {
  const CompassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const CompassPage(),
    );
  }
}

class CompassPage extends StatelessWidget {
  const CompassPage({super.key});

  String direction(double d) {
    const names = [
      'شمال', 'شمال شرق', 'شرق', 'جنوب شرق',
      'جنوب', 'جنوب غرب', 'غرب', 'شمال غرب'
    ];
    return names[((d + 22.5) % 360 ~/ 45)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('بوصلة'), centerTitle: true),
      body: StreamBuilder<CompassEvent>(
        stream: FlutterCompass.events,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('خطأ في الحساس'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final heading = snapshot.data?.heading;
          if (heading == null) {
            return const Center(child: Text('الجهاز لا يدعم البوصلة'));
          }
          final deg = (heading + 360) % 360;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${deg.toStringAsFixed(0)}°',
                    style: const TextStyle(
                        fontSize: 48, fontWeight: FontWeight.bold)),
                Text(direction(deg), style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 32),
                Transform.rotate(
                  angle: -deg * math.pi / 180,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 260,
                        height: 260,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 4, color: Colors.white54),
                        ),
                      ),
                      const Positioned(
                        top: 12,
                        child: Text('N',
                            style: TextStyle(
                                fontSize: 28,
                                color: Colors.red,
                                fontWeight: FontWeight.bold)),
                      ),
                      const Icon(Icons.navigation, size: 120, color: Colors.red),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}