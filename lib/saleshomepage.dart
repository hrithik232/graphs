import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphsinflutter/linearsales.dart';
import 'sales.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'task.dart';

class SalesHomePage extends StatefulWidget {
  @override
  _SalesHomePageState createState() {
    return _SalesHomePageState();
  }
}

class _SalesHomePageState extends State<SalesHomePage> {
  List<charts.Series<Sales, String>> _seriesBarData;
  List<Sales> mydata;
  List<charts.Series<Task, String>> _seriesPieData;
  List<Task> myData;
  List<charts.Series<LinearSales, int>> _seriesLinearData;
  List<LinearSales> linearData1;
  List<LinearSales> linearData2;

  _generateData3(linearData2) {
    _seriesLinearData = List<charts.Series<LinearSales, int>>();
    _seriesLinearData.add(
      charts.Series(
        domainFn: (LinearSales sales, _) => sales.years,
        measureFn: (LinearSales sales, _) => sales.salesSc,
        colorFn: (LinearSales sales, _) =>
            charts.ColorUtil.fromDartColor(Colors.blue),
        id: 'Air Pollution2',
        data: linearData2,
        labelAccessorFn: (LinearSales row, _) => "${row.years}",
      ),
    );
  }

  _generateData2(linearData1) {
    _seriesLinearData = List<charts.Series<LinearSales, int>>();
    _seriesLinearData.add(
      charts.Series(
        domainFn: (LinearSales sales, _) => sales.years,
        measureFn: (LinearSales sales, _) => sales.salesSc,
        colorFn: (LinearSales sales, _) =>
            charts.ColorUtil.fromDartColor(Colors.blue),
        id: 'Air Pollution',
        data: linearData1,
        labelAccessorFn: (LinearSales row, _) => "${row.years}",
      ),
    );
  }

  _generateData1(myData) {
    _seriesPieData = List<charts.Series<Task, String>>();
    _seriesPieData.add(
      charts.Series(
        domainFn: (Task task, _) => task.taskDetails,
        measureFn: (Task task, _) => task.taskVal,
        colorFn: (Task task, _) =>
            charts.ColorUtil.fromDartColor(Color(int.parse(task.colorVal))),
        id: 'tasks',
        data: myData,
        labelAccessorFn: (Task row, _) => "${row.taskVal}",
      ),
    );
  }

  _generateData(mydata) {
    _seriesBarData = List<charts.Series<Sales, String>>();
    _seriesBarData.add(
      charts.Series(
        domainFn: (Sales sales, _) => sales.saleYear.toString(),
        measureFn: (Sales sales, _) => sales.saleVal,
        colorFn: (Sales sales, _) =>
            charts.ColorUtil.fromDartColor(Color(int.parse(sales.colorVal))),
        id: 'Sales',
        data: mydata,
        labelAccessorFn: (Sales row, _) => "${row.saleYear}",
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: Text('Sales')),
  //     body: _buildBody(context),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            bottom: TabBar(
              indicatorColor: Color(0xff9962D0),
              tabs: [
                Tab(
                  icon: Icon(
                    FontAwesomeIcons.chartBar,
                    color: Colors.green,
                  ),
                ),
                Tab(
                  icon: Icon(
                    FontAwesomeIcons.chartPie,
                    color: Colors.green,
                  ),
                ),
                Tab(
                  icon: Icon(
                    FontAwesomeIcons.chartLine,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            title: Text('Chart View'),
          ),
          body: TabBarView(
            children: [
              _buildBody(context),
              _buildBody1(context),
              _buildBody2(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody2(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('linearsales').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          List<LinearSales> sales = snapshot.data.docs
              .map((documentSnapshot) =>
                  LinearSales.fromMap(documentSnapshot.data()))
              .toList();
          return _buildChart2(context, sales);
        }
      },
    );
  }

  Widget _buildChart2(BuildContext context, List<LinearSales> linearsales) {
    linearData1 = linearsales;
    _generateData2(linearData1);
    // _generateData3(linearData2);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Time spent on daily tasks',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: charts.LineChart(
                  _seriesLinearData,
                  defaultRenderer: new charts.LineRendererConfig(
                    includeArea: true,
                    stacked: true,
                  ),
                  animate: true,
                  animationDuration: Duration(seconds: 2),
                  behaviors: [
                    new charts.ChartTitle(
                      'Years',
                      behaviorPosition: charts.BehaviorPosition.bottom,
                      titleOutsideJustification:
                          charts.OutsideJustification.middleDrawArea,
                    ),
                    new charts.ChartTitle(
                      'Sales',
                      behaviorPosition: charts.BehaviorPosition.bottom,
                      titleOutsideJustification:
                          charts.OutsideJustification.middleDrawArea,
                    ),
                    new charts.ChartTitle(
                      'Department',
                      behaviorPosition: charts.BehaviorPosition.bottom,
                      titleOutsideJustification:
                          charts.OutsideJustification.middleDrawArea,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody1(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('task').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          List<Task> task = snapshot.data.docs
              .map((documentSnapshot) => Task.fromMap(documentSnapshot.data()))
              .toList();
          return _buildChart1(context, task);
        }
      },
    );
  }

  Widget _buildChart1(BuildContext context, List<Task> taskdata) {
    myData = taskdata;
    _generateData1(myData);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Time spent on daily tasks',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: charts.PieChart(
                  _seriesPieData,
                  animate: true,
                  animationDuration: Duration(seconds: 2),
                  behaviors: [
                    new charts.DatumLegend(
                      outsideJustification:
                          charts.OutsideJustification.endDrawArea,
                      horizontalFirst: false,
                      desiredMaxRows: 2,
                      cellPadding: new EdgeInsets.only(
                          right: 4.0, bottom: 4.0, top: 4.0),
                      entryTextStyle: charts.TextStyleSpec(
                          color: charts.MaterialPalette.purple.shadeDefault,
                          fontFamily: 'Georgia',
                          fontSize: 18),
                    )
                  ],
                  defaultRenderer: new charts.ArcRendererConfig(
                    arcWidth: 100,
                    arcRendererDecorators: [
                      new charts.ArcLabelDecorator(
                          labelPosition: charts.ArcLabelPosition.inside)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('sales').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          List<Sales> sales = snapshot.data.docs
              .map((documentSnapshot) => Sales.fromMap(documentSnapshot.data()))
              .toList();
          return _buildChart(context, sales);
        }
      },
    );
  }

  Widget _buildChart(BuildContext context, List<Sales> saledata) {
    mydata = saledata;
    _generateData(mydata);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Sales by Year',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: charts.BarChart(
                  _seriesBarData,
                  animate: true,
                  barGroupingType: charts.BarGroupingType.grouped,
                  animationDuration: Duration(seconds: 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
