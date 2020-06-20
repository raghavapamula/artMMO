import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;

import 'globals.dart' as globals;

// Frame Class
class Frame extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FrameState();
  }
}

class _FrameState extends State<Frame> {
  Painting p = new Painting();

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
          title: Text(
        "artMMO",
        textDirection: TextDirection.ltr,
      )),
      body: Center(
          child: Container(
        child: p,
        decoration: decor(),
      )));
}

BoxDecoration decor() {
  return BoxDecoration(
    border: Border.all(
      width: 5,
      color: Colors.brown,
    ),
  );
}

// Painting Class
class Painting extends StatefulWidget {
  Painting();

  @override
  State<StatefulWidget> createState() => _PaintingState();
}

class _PaintingState extends State<Painting> {
  final dir = _localPath;
  String path = 'PaintingNO${globals.numPaintings}.png';
  var img;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Image>(
        future: _generate(path),
        builder: (context, AsyncSnapshot<Image> snapshot) {
          RaisedButton btn = RaisedButton(
            onPressed: () {
              setState(() {});
            },
          );
          if (snapshot.hasData) {
            return snapshot.data;
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

// generate random image
Future<Image> _generate(path, {List<double> size}) async {
  //Update Total Image Count
  globals.numPaintings += 1;

  //Default Image Size
  if (size == null) size = [305.0, 305.0];

  PictureRecorder pr = new PictureRecorder();
  Canvas c = new Canvas(pr);

  List<List<Offset>> points =
      List.generate(Colors.primaries.length, (index) => []);
  var random = new Random(DateTime.now().millisecondsSinceEpoch);

  for (int i = 0; i < size[0]; i += 10) {
    for (int j = 0; j < size[1]; j += 10) {
      int n = random.nextInt(Colors.primaries.length);
      points[n].add(Offset(i.toDouble(), j.toDouble()));
    }
  }

  for (int i = 0; i < Colors.primaries.length; i++) {
    var paint = Paint()
      ..color = Colors.primaries[i]
      ..strokeWidth = 6
      ..blendMode = BlendMode.screen;
    print(paint.color);
    c.drawPoints(PointMode.points, points[i], paint);
  }

  Picture pic = pr.endRecording();
  var pngBytes = await pic.toImage(size[0].toInt(), size[1].toInt());
  ByteData a = await pngBytes.toByteData(format: ImageByteFormat.png);
  Image img = Image.memory(a.buffer.asUint8List());
  return img;
}
