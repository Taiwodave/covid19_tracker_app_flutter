import 'dart:convert';

import 'package:covid19_app/datasource.dart';
import 'package:covid19_app/pages/countryPage.dart';
import 'package:covid19_app/panel/infopanel.dart';
import 'package:covid19_app/panel/mostaffectedcountries.dart';
import 'package:covid19_app/panel/worldwidepanel.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map worldData;
  fetchWorldWideData() async {
    http.Response response = await http.get("https://corona.lmao.ninja/v2/all");
    setState(() {
      worldData = json.decode(response.body);
    });
  }

  List countryData;
  fetchCountryData() async {
    http.Response response =
        await http.get("https://corona.lmao.ninja/v2/countries?sort=cases");
    setState(() {
      countryData = json.decode(response.body);
    });
  }

  @override
  void initState() {
    fetchWorldWideData();
    fetchCountryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("COVID-19 TRACKER"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Theme.of(context).brightness == Brightness.light
                ? Icons.lightbulb_outline
                : Icons.highlight),
            onPressed: (){
              DynamicTheme.of(context).setBrightness(Theme.of(context).brightness == Brightness.light ? Brightness.dark : Brightness.light);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                height: 110,
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                color: Colors.orange[100],
                child: Text(
                  DataSource.quote,
                  style: TextStyle(
                      color: Colors.orange[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                )),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Worldwide",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CountryPage()));
                    },
                    child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: primaryBlack,
                            borderRadius: BorderRadius.circular(15)),
                        child: Text(
                          "Regional",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                ],
              ),
            ),
            worldData == null
                ? Center(child: CircularProgressIndicator())
                : WorldWidePanel(
                    worldData: worldData,
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "Most Affected Countries",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            countryData == null
                ? Container()
                : MostAffectedPanel(
                    countryData: countryData,
                  ),
            SizedBox(
              height: 20,
            ),
            InfoPanel(),
            SizedBox(
              height: 20,
            ),
            Center(
                child: Text(
              "WE ARE TOGETHER IN THE FIGHT",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
