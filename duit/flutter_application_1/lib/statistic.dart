import 'dart:math';

import 'package:intl/intl.dart';

class BalanceTrend {
  final String x;
  final double y;

  BalanceTrend({required this.x, required this.y});
}

List<BalanceTrend> filterTrendData(List<BalanceTrend> trendDatas) {
  // Create a map to store the latest balance for each date
  Map<String, double> latestBalances = {};

  // Iterate through the trend data
  for (var trend in trendDatas) {
    // Update the latest balance for the current date
    latestBalances[trend.x] = trend.y;
  }

  // Get distinct dates and sort them in ascending order
  List<String> recentDates = latestBalances.keys.toList()..sort();

  // Take the last 5 distinct dates
  recentDates = recentDates.sublist(max(0, recentDates.length - 5));

  // Create a list to store filtered trend data with the latest balance for each date
  List<BalanceTrend> filteredTrendData = [];
  for (var date in recentDates) {
    filteredTrendData.add(BalanceTrend(x: date, y: latestBalances[date]!));
  }

  return filteredTrendData;
}

List<BalanceTrend> parseBalanceTrend(List<Map<String, dynamic>> data) {
  return data
      .map((item) {
        String dateString = item['date'].toString();
        try {
          DateTime date = DateFormat('yyyy-MM-dd').parse(dateString);
          final formattedDate = DateFormat('yyyy-MM-dd').format(date);
          double balance = double.parse(item['balance'].toString());
          return BalanceTrend(x: formattedDate, y: balance);
        } catch (e) {
          print('Error parsing date: $dateString');
          return null; // or handle the error accordingly
        }
      })
      .where((trend) => trend != null)
      .cast<BalanceTrend>()
      .toList();
}
