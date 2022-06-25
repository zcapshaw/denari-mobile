import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class ChartData {
  ChartData(this.name, this.value);
  final String name;
  final int value;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<ChartData> _chartData;

  List<ChartData> getChartData() {
    final List<ChartData> chartData = [
      ChartData('Spendable', 2486),
    ];
    return chartData;
  }

  @override
  void initState() {
    _chartData = getChartData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You\'re in good shape ✅',
              style: GoogleFonts.manrope(
                  textStyle:
                      TextStyle(color: Colors.blueGrey[900], fontSize: 20)),
            ),
            SfCircularChart(
              annotations: <CircularChartAnnotation>[
                CircularChartAnnotation(
                  widget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '\$1,867',
                        style: GoogleFonts.manrope(
                          textStyle: TextStyle(
                              color: Colors.blueGrey[900],
                              fontSize: 50,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        'Cash left to spend',
                        style: GoogleFonts.manrope(
                            textStyle: TextStyle(
                                color: Colors.blueGrey[900], fontSize: 16)),
                      ),
                      Text(
                        'This Month',
                        style: GoogleFonts.manrope(
                          textStyle: TextStyle(
                            color: Colors.blueGrey[900],
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              series: <CircularSeries>[
                RadialBarSeries<ChartData, String>(
                  dataSource: _chartData,
                  xValueMapper: (ChartData data, _) => data.name,
                  yValueMapper: (ChartData data, _) => data.value,
                  maximumValue: 4000,
                  pointColorMapper: (datum, index) => Colors.blueGrey[800],
                  innerRadius: '90%',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}