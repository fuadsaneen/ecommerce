import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      title: 'Nuchange Informatics - Ecommerce',
      // Application theme data, you can set the colors for the application as
      // you want
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // A widget which will be started on application startup
      home: MyHomePage(title: 'Nuchange Informatics - Ecommerce'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({required this.title});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // The title text which will be shown on the action bar
          title: Center(
            child: Text(
              widget.title,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        body: FutureBuilder(
            future: readJson(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(items);
                return Center(child: Text("${snapshot.error}"));
              } else {
                print(items);
                return Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      height: 50,
                      child: Center(
                          child: Text(
                        'All Products',
                        style: TextStyle(color: Colors.grey),
                      )),
                    ),
                  ),
                  Expanded(
                      child: GridView.builder(
                          padding: const EdgeInsets.all(10.0),
                          scrollDirection: Axis.vertical,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                          ),
                          itemCount: items.length,
                          itemBuilder: (context, i) => CatGrid(i, items)))
                ]);
              }
            }));
  }

  List items = [];
  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/product_list.json');

    final data = await json.decode(response);
    setState(() {
      items = data["items"];
    });
  }
}

class CatGrid extends StatefulWidget {
  final int i;
  final List items;
  const CatGrid(this.i, this.items);
  @override
  _CatGridState createState() => _CatGridState();
}

class _CatGridState extends State<CatGrid> {
  // bool favourite = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: Container(
          height: 400,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey, offset: Offset(-5, 5), blurRadius: 10),
              ]),
          child: Column(
            children: <Widget>[
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: <Widget>[
                      Positioned.fill(
                          child: Align(
                        alignment: Alignment.center,
                      )),
                      Image.asset(
                        'images/${widget.items[widget.i]["name"]}.jpg',
                        // height: 126,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: RichText(
                            text: TextSpan(
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                text: '${widget.items[widget.i]["name"]}\n',
                                children: <TextSpan>[
                              TextSpan(
                                style: TextStyle(color: Colors.black),
                                text: '${widget.items[widget.i]["category"]}\n',
                              ),
                              TextSpan(
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                                text:
                                    'Sold by : ${widget.items[widget.i]["vendor"]}\n',
                              ),
                            ])),
                      ),
                      Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text('₹${widget.items[widget.i]["price"]}\n',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ]),
                    ]),
              ),
            ],
          ),
        ));
  }
}
