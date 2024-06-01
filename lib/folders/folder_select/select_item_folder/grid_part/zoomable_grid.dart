import 'package:flutter/material.dart';

class ZoomableGrid extends StatefulWidget {
  const ZoomableGrid({super.key});

  @override
  State<ZoomableGrid> createState() => _ZoomableGridState();
}

class _ZoomableGridState extends State<ZoomableGrid> {
  double _scale = 1.0;
  double _previousScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pinch to Zoom Grid'),
      ),
      body: Center(
        child: GestureDetector(
          onScaleStart: (ScaleStartDetails details) {
            _previousScale = _scale;
          },
          onScaleUpdate: (ScaleUpdateDetails details) {
            setState(() {
              _scale = _previousScale * details.scale;
            });
          },
          onScaleEnd: (ScaleEndDetails details) {
            _previousScale = 1.0;
          },
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / _scale,
            ),
            itemCount: 20,
            itemBuilder: (context, index) {
              return Card(
                child: Center(
                  child: Text('Item $index'),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
