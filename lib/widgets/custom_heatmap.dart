import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomHeatMap extends StatelessWidget {
  final Map<String, dynamic> dataSet;
  const CustomHeatMap({
    super.key,
    required this.dataSet,
  });

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.now();
    Map<DateTime, int> dataSets = {};

    dataSet.forEach((key, value) {
      int timestamp = int.parse(key);
      DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      dataSets[DateTime(date.year, date.month, date.day)] = value;
    });

    double size = MediaQuery.of(context).size.width;
    return HeatMap(
      startDate: DateTime(date.year - 1, date.month),
      endDate: date,
      defaultColor: Colors.grey.shade700,
      datasets: dataSets,
      size: 20,
      colorMode: ColorMode.color,
      scrollable: true,
      colorsets: {
        0: Colors.blue.shade200,
        2: Colors.blue.shade300,
        4: Colors.blue.shade400,
        6: Colors.blue.shade400,
        10: Colors.blue.shade500,
        20: Colors.blue,
      },
      showColorTip: false,
      onClick: (value) {
        Fluttertoast.showToast(
          msg:
              '${dataSets[value] ?? 0} submissions on ${value.day}/${value.month}/${value.year}',
          webBgColor: "linear-gradient(#24222a,#24222a)",
          timeInSecForIosWeb: 3,
          backgroundColor: const Color.fromARGB(255, 46, 44, 54),
          webPosition: size > 768 ? "right" : "center",
          gravity: size > 768 ? ToastGravity.BOTTOM_RIGHT : ToastGravity.CENTER,
        );
      },
    );
  }
}
