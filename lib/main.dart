import 'dart:convert';
import 'package:flutter/material.dart';
import 'detail.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'GDG Weather Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeListPage());
  }
}

class HomeListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeListState();
  }
}

class HomeListState extends State<HomeListPage> {
  List<dynamic> orginalData = [];
  List<dynamic> data = ['广州'];

  @override
  void initState() {
    super.initState();
    _getCitys();
  }

  _getCitys() async {
    final res = await http.get(
        'https://search.heweather.com/top?key=a3ecfeb41a194120a7b36e6f4487b24d&group=cn&number=50');
    if (res.statusCode == 200) {
      Map<String, dynamic> j = json.decode(res.body);
      this.setState(() {
        orginalData =
            j['HeWeather6'][0]['basic'].map((ele) => ele['location']).toList();
        data = orginalData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var widgets = data.map((f) => new HomeListItem(f)).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('GDG Weather Demo'),
      ),
      body: Container(
        color: Colors.black12,
        child: Stack(
          children: <Widget>[
            ListView(children: widgets),
            Container(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              color: Theme.of(context).accentColor,
              child: Form(
                child: TextFormField(
                  decoration: InputDecoration(labelText: '输入城市名称'),
                  onSaved: (String value) {
                    this.setState(() {
                      data = orginalData
                          .map((each) => each.indexOf(value) > 0)
                          .toList();
                    });
                    print(value);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class HomeListItem extends StatelessWidget {
  final String title;

  HomeListItem(this.title);

  onPressed(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        child: MaterialButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DetailPage(
                    cityName: title,
                  ))),
          child: Container(
            child: Text(this.title),
            padding: EdgeInsets.all(16.0),
          ),
        ),
      ),
    );
  }
}
