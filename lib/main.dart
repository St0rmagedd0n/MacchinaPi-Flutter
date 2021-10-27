import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MacchinaPi',
      theme: ThemeData(
        primarySwatch: Colors.green,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.teal,
            onPrimary: Colors.white,
            //padding: EdgeInsets.symmetric(horizontal: 10.0),
            shape: const BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
          ),
        ),
      ),
      home: MyHomePage(title: 'MacchinaPi'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final myController = TextEditingController();
  String new_url = "";

  void dispose() {
    myController.dispose();
    super.dispose();
  }

  void _get(String pagina) {
    var url = Uri.parse("$new_url:8000/$pagina");
    try {
      var response = http.get(url);
    } on Exception catch (_) {
      print("Errore non raggiungo " + url.toString());
    }
  }

  void _avanti() {
    setState(() {
      _get("up_side");
    });
  }

  void _indietro() {
    setState(() {
      _get("down_side");
    });
  }

  void _sinistra() {
    setState(() {
      _get("left_side");
    });
  }

  void _destra() {
    setState(() {
      _get("right_side");
    });
  }

  void _stop() {
    setState(() {
      if (myController.text == "") {
        new_url = "http://192.168.1.108";
      } else {
        new_url = myController.text;
      }
      _get("stop");
    });
  }

  void _spegni() {
    setState(() {
      //_get("halt");
      custumSympleDialog(context);
    });
  }

  void custumSympleDialog(BuildContext context) {
    var dialog = AlertDialog(
      title: Row(
        children: <Widget>[
          Icon(Icons.power_off),
          Text(
            "Vuoi spegnere?",
          )
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: Colors.amber,
      elevation: 10,
      actions: [
        ElevatedButton(
            child: Text("OK"),
            onPressed: () {
              _get("halt");
              Navigator.pop(context); //permette la chiusura del dialog
            }),
        ElevatedButton(
            child: Text("No"),
            onPressed: () {
              _stop();
              Navigator.pop(context); //permette la ciusura del dialog
            }),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  @override
  Widget build(BuildContext context) {
    final isRunning = true;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: myController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: "http://192.168.1.108",
            icon: Icon(Icons.web, color: Colors.white),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                    top: 50.0, right: 15.0, left: 15.0, bottom: 35.0),
                child: Center(
                  //margin: EdgeInsets.all(15.0),
                  child: Mjpeg(
                    width: 480.0,
                    height: 640.0,
                    isLive: isRunning,
                    stream: '$new_url:8001/stream.mjpg',
                    error: (context, error, stack) {
                      return Text(
                        'ACCENDI LA MACCHINA,CORREGGI L\'URL O PREMI STOP',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 35.0,
                        ),
                      );
                    }, // error
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: 15.0, top: 50.0, right: 15.0, bottom: 15.0),
              child: ElevatedButton(
                child: Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                  size: 24.0,
                ),
                onPressed: _avanti,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(15.0),
                  child: ElevatedButton(
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24.0,
                    ),
                    onPressed: _sinistra,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15.0),
                  child: ElevatedButton(
                    child: Icon(
                      Icons.stop,
                      color: Colors.white,
                      size: 32.0,
                    ),
                    onPressed: _stop,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15.0),
                  child: ElevatedButton(
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 24.0,
                    ),
                    onPressed: _destra,
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(
                  left: 15.0, top: 15.0, right: 15.0, bottom: 50.0),
              child: ElevatedButton(
                //style: ElevatedButton.styleFrom(
                //padding: EdgeInsets.symmetric(vertical: 5.0),
                //),
                child: Icon(
                  Icons.arrow_downward,
                  color: Colors.white,
                  size: 24.0,
                ),
                onPressed: _indietro,
              ),
            ),
            Container(
              margin: EdgeInsets.all(5.0),
              child: ElevatedButton.icon(
                icon: Icon(
                  Icons.power_off,
                  color: Colors.white,
                  size: 25.0,
                ),
                label: Text("SPEGNI LA MACCHINA",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                    )),
                onPressed: _spegni,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
