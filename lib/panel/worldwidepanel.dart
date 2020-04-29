import 'package:flutter/material.dart';

class WorldWidePanel extends StatelessWidget {
  final Map worldData;

  const WorldWidePanel({Key key, this.worldData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2,
        ),
        children: <Widget>[
          StatusPanel(
            title: "CONFIRMED",
            panelColor: Colors.blueGrey[100],
            textColor: Colors.blueGrey,
            count: worldData['cases'].toString(),
          ),
          StatusPanel(
            title: "ACTIVE",
            panelColor: Colors.blue[100],
            textColor: Colors.blue,
            count: worldData['active'].toString(),
          ),
          StatusPanel(
            title: "RECOVERED",
            panelColor: Colors.green[100],
            textColor: Colors.green,
            count: worldData['recovered'].toString(),
          ),
          StatusPanel(
            title: "DEATHS",
            panelColor: Colors.red[100],
            textColor: Colors.red,
            count: worldData['deaths'].toString(),
          ),
        ],
      ),
    );
  }
}

class StatusPanel extends StatelessWidget {

  final Color panelColor;
  final Color textColor;
  final String title;
  final String count;

  const StatusPanel({Key key, this.panelColor, this.textColor, this.title, this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.all(10),
      height: 80,
      width: width/2,
      color: panelColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor),),
          Text(count, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
        ],
      ),
    );

  }
}

