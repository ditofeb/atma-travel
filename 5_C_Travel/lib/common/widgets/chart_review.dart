import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tubes_5_c_travel/common/constants/colors.dart';
import 'package:tubes_5_c_travel/common/constants/fonts.dart';

final DateTime today = DateTime.now();

class ChartReview extends StatefulWidget {
  List<double> listRating;
  ChartReview({super.key, required this.listRating});

  @override
  State<ChartReview> createState() => _ChartReviewState();
}

class _ChartReviewState extends State<ChartReview> {
  late Map<int, double> data;

  @override
  void initState() {
    super.initState();
    if (widget.listRating.isEmpty) {
      data = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    } else {
      data = {
        for (int i = 0; i < widget.listRating.length && i < 5; i++)
          i + 1: widget.listRating[i]
      };
      if (widget.listRating.length < 5) {
        for (int i = widget.listRating.length; i < 5; i++) {
          data[i] = 0;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final spots1 = <FlSpot>[
      for (final entry in data.entries)
        FlSpot(entry.key.toDouble(), entry.value)
    ];

    final lineChartData = LineChartData(
      lineBarsData: [
        LineChartBarData(
          spots: spots1,
          color: themeColor,
          barWidth: 4,
          isCurved: false,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(show: true),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (_) => themeColor,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((touchedSpot) {
              return LineTooltipItem(
                '${touchedSpot.y}',
                TextStyles.poppinsBold(
                  fontSize: 12,
                  color: Colors.white,
                ),
              );
            }).toList();
          },
        ),
        touchCallback: (_, __) {},
        handleBuiltInTouches: true,
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Colors.grey, width: 2),
          left: BorderSide(color: Colors.grey, width: 2),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      ),
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (double val, _) {
              if (val == 1 || val == 2 || val == 3 || val == 4 || val == 5) {
                final monthIndex =
                    today.subtract(Duration(days: 30 * (5 - val.toInt())));
                return Text(
                  DateFormat.MMM().format(monthIndex),
                  style: TextStyles.poppinsNormal(fontSize: 12),
                );
              }
              return Text('');
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (double val, _) {
              if (val == 0 ||
                  val == 1 ||
                  val == 2 ||
                  val == 3 ||
                  val == 4 ||
                  val == 5) {
                return Text(
                  '${val.toInt()}',
                  style: TextStyles.poppinsNormal(fontSize: 12),
                );
              } else {
                return Text('');
              }
            },
          ),
        ),
      ),
    );

    return Container(
      color: Colors.white,
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.28,
      child: Row(
        children: [
          RotatedBox(
            quarterTurns: 3,
            child: Text(
              'Rating',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 315,
                height: 200,
                child: LineChart(lineChartData),
              ),
              Text(
                'Bulan',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
