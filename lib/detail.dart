import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  const DetailPage({@required this.cityName}) : assert(cityName != null);

  final String cityName;

  @override
  State<StatefulWidget> createState() {
    return DetailPageWidget();
  }
}

class DetailPageWidget extends State<DetailPage> {
  String condTxt = ''; //天气
  String tmp = ''; //温度
  String hum = ''; //湿度
  String wind = '加载中...'; //凤向

  @override
  void initState() {
    super.initState();
    this._getData();
  }

  void _getData() async {
    this.setState(() {
      condTxt = '';
      tmp = '';
      hum = '';
      wind = '加载中...';
    });
    final res = await http.get(
        'https://free-api.heweather.com/s6/weather/now?location=${widget.cityName}&key=a3ecfeb41a194120a7b36e6f4487b24d');
    if (res.statusCode == 200) {
      Map<String, dynamic> j = json.decode(res.body);
      this.setState(() {
        condTxt = j['HeWeather6'][0]['now']['cond_txt'];
        tmp = j['HeWeather6'][0]['now']['tmp'] + "°";
        hum = "湿度  " + j['HeWeather6'][0]['now']['hum'] + "%";
        wind = j['HeWeather6'][0]['now']['wind_dir'];
      });
    } else {
      this.setState(() {
        wind = '获取数据失败';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image.asset(
          "images/ipx.jpg",
          fit: BoxFit.fitHeight,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 40.0),
              child: Text(
                widget.cityName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 100.0),
              child: Column(
                children: <Widget>[
                  Text(
                    this.tmp,
                    style: TextStyle(color: Colors.white, fontSize: 80.0),
                  ),
                  Container(height: 20.0),
                  Text(
                    this.wind,
                    style: TextStyle(color: Colors.white, fontSize: 45.0),
                  ),
                  Container(height: 80.0),
                  Text(
                    this.condTxt,
                    style: TextStyle(color: Colors.white, fontSize: 45.0),
                  ),
                  Text(
                    this.hum,
                    style: TextStyle(color: Colors.white, fontSize: 30.0),
                  ),
                  Container(height: 20.0),
                  Container(
                    child: MaterialButton(
                      child: Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                      onPressed: this._getData,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 40.0),
              child: MaterialButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
