import 'dart:math';

import 'package:animated_layout/animated_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Layout Builder Demo',
      home: MyHomePage(title: 'Animated Layout Builder Demo'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AnimatedLayoutController _layoutController;
  TextEditingController divisionsController = TextEditingController(text: '3');
  List<int> divisions = [100, 100, 50];

  int get numOfDivisions => divisions.length;

  List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
  ];

  @override
  void initState() {
    _layoutController = AnimatedLayoutController(
      duration: Duration(milliseconds: 500),
      initialDivisions: List.from(divisions),
      children: <Widget>[
        for (var i = 0; i < divisions.length; ++i)
          Card(
            child: Container(
              height: double.infinity,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Text('Current Width: ${constraints.maxWidth.toInt()}');
                },
              ),
              color: colors[i],
            ),
          ),
      ],
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 3,
      ),
      body: Stack(
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: AnimatedLayout(
              direction: Axis.horizontal,
              controller: _layoutController,
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Card(
                child: Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: SizedBox(
                          height: 40,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            children: <Widget>[
                              for (var i = 0; i < numOfDivisions; ++i)
                                Container(
                                  constraints: BoxConstraints(maxWidth: 80),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: TextField(
                                      maxLength: 3,
                                      maxLengthEnforced: true,
                                      decoration: InputDecoration(
                                        hintText: '${divisions[i]}',
                                        border: OutlineInputBorder(),
                                        counterText: '',
                                      ),
                                      inputFormatters: [
                                        WhitelistingTextInputFormatter
                                            .digitsOnly
                                      ],
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        if (value.isNotEmpty &&
                                            int.parse(value) > 0) {
                                          divisions[i] = int.parse(value);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              OutlineButton(
                                child: Text('Set to 20%, 60%, 20%'),
                                onPressed: () {
                                  _layoutController.animateTo([2, 6, 2]);
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                              ),
                              OutlineButton(
                                child: Text(
                                  'Set to 30%, 30%, 30%\n (Evenly Spaced)',
                                  textAlign: TextAlign.center,
                                ),
                                onPressed: () {
                                  _layoutController.animateTo([1, 1, 1]);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      FlatButton.icon(
                        icon: Icon(Icons.check),
                        label: Text('Set'),
                        onPressed: () {
                          _layoutController.animateTo(divisions);
                        },
                      )
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Color getRandColor() => colors[Random().nextInt(colors.length - 1)];
}
