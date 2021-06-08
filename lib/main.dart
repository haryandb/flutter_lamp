import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lamp Dimmer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Lamp Dimmer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _counter = 0;

  Future<void> sendToArduino(double value) async {
    var url = Uri.http('192.168.4.1', '/lamp', {'value': '$value'});
    print(url.toString());
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        print(response.body);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    String lampTransparant = (_counter / 255.0).toStringAsFixed(3);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title!),
      // ),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Text(
            //   _counter.toString(),
            //   style: Theme.of(context).textTheme.headline4,
            // ),
            SvgPicture.string('''<svg viewBox="50 90 80 130"
              xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                <defs
                  id="defs843" />
                <g
                  inkscape:label="Layer 1"
                  inkscape:groupmode="layer"
                  id="layer1">
                  <g
                    id="g925"
                    transform="matrix(0.26458333,0,0,0.26458333,21.469048,82.701194)">
                    <path
                      d="m 200,424 h 112 v 48 a 16,16 0 0 1 -16,16 h -80 a 16,16 0 0 1 -16,-16 z"
                      fill="#dcdee0"
                      style="opacity:1;fill:#dcdee0;fill-opacity:$lampTransparant" />
                      id="path882" />
                    <path
                      d="m 200.24366,330.52538 v 32 h 112 v -32 c 0,-40 80,-72 80,-168 a 136,136 0 0 0 -272,0 c 0,88 80,128 80,168 z"
                      fill="#fbe36a"
                      id="path884"
                      style="opacity:1;fill:#fbe36a;fill-opacity:$lampTransparant" />
                    <path
                      d="m 176,360 h 160 v 64 H 176 Z"
                      fill="#e9eef2"
                      style="opacity:1;fill:#e9eef2;fill-opacity:$lampTransparant"
                      id="path888" />
                    <path
                      d="m 176,384 h 160 v 16 H 176 Z"
                      fill="#dcdee0"
                      style="opacity:1;fill:#dcdee0;fill-opacity:$lampTransparant"
                      id="path890" />
                  </g>
                </g>
            </svg>'''),
            Slider(
              value: _counter,
              min: 0,
              max: 255,
              label: _counter.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _counter = value;
                });
              },
              onChangeEnd: (double newValue) {
                print('Ended change on $newValue');
                sendToArduino(newValue);
              },
            )
          ],
        ),
      ),
    );
  }
}
