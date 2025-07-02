import 'package:woloo_smart_hygiene/client_flow/screens/login/bloc/signup_bloc.dart';
import 'package:woloo_smart_hygiene/firebase_options.dart';
import 'package:woloo_smart_hygiene/injection_container.dart' as di;
import 'package:woloo_smart_hygiene/janitorial_services/model/iotdata_model.dart';
import 'package:woloo_smart_hygiene/messaging.dart';
import 'package:woloo_smart_hygiene/screens/login/bloc/login_bloc.dart';
import 'package:woloo_smart_hygiene/screens/my_account/view/bloc/profile_bloc.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/login/bloc/signup_bloc.dart';
import 'package:woloo_smart_hygiene/firebase_options.dart';
import 'package:woloo_smart_hygiene/injection_container.dart' as di;
import 'package:woloo_smart_hygiene/messaging.dart';
import 'package:woloo_smart_hygiene/screens/login/bloc/login_bloc.dart';
import 'package:woloo_smart_hygiene/screens/my_account/view/bloc/profile_bloc.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';

// Data model for chart points
class ChartDataPoint {
  final DateTime timestamp;
  final double airQuality; // Normalized value for plotting (0.0 to 1.0)
  final double usage; // Normalized value for plotting (0.0 to 1.0)
  final int value; // The actual air quality reading (e.g., 376)

  ChartDataPoint({
    required this.timestamp,
    required this.airQuality,
    required this.usage,
    required this.value,
  });
}

// // Simulated API call to fetch chart data
// Future<List<ChartDataPoint>> fetchChartData(List<AvgppmTimeRange> data) async {
//   // Simulate network delay to mimic a real API call
//   await Future.delayed(const Duration(seconds: 1));

//   // Pre-generated dynamic data
//   // airQuality and usage are normalized values (0.0 to 1.0) for easier plotting,
//   // while 'value' is the actual reading for the highlighted point.
//   return data
//       .map((e) => ChartDataPoint(
//             timestamp: DateTime.parse(e.timeRange ?? ''),
//             airQuality: double.parse(e.avgPpmAvg ?? ''),
//             usage: double.parse(e.avgPcdMax ?? ''),
//             value: int.parse(e.avgPpmAvg ?? ''),
//           ))
//       .toList();
// }

class CustomChartPainter extends CustomPainter {
  final List<ChartDataPoint> data;
  final int? highlightedIndex;
  final double airQualityMax;
  final double usageMax;

  CustomChartPainter({
    required this.data,
    this.highlightedIndex,
    required this.airQualityMax,
    required this.usageMax,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) {
      return;
    }

    final double width = size.width;
    final double height = size.height;

    // Scale factors to map normalized data values to canvas coordinates
    // Y-coordinates are inverted: higher data value means lower Y on canvas.
    final double airQualityScale = height / airQualityMax;
    final double usageScale = height / usageMax;

    // Define colors from the provided image
    final Color usageColor = AppColors.backgroundColor;
    // const Color(0xFF66C8D8).withOpacity(0.5); // Light blue
    const Color airQualityColor = Color(0xFF4A4B51); // Dark grey
    final Color highlightLineColor = Colors.white.withOpacity(0.7);
    const Color highlightDotColor = Colors.white;
    final Color highlightGlowColorStart = Colors.yellow.withOpacity(0.7);
    final Color highlightGlowColorEnd = Colors.yellow.withOpacity(0.0);

    // --- Pre-calculate scaled points for both curves ---
    List<Offset> usageScaledPoints = [];
    List<Offset> airQualityScaledPoints = [];

    for (int i = 0; i < data.length; i++) {
      final double x = (i / (data.length - 1)) * width;
      usageScaledPoints.add(Offset(x, height - (data[i].usage * usageScale)));
      airQualityScaledPoints
          .add(Offset(x, height - (data[i].airQuality * airQualityScale)));
    }

    // --- Draw Usage Curve (Light Blue Area) ---
    final Path usagePath = Path();
    usagePath.moveTo(0, height); // Start from bottom-left
    if (usageScaledPoints.isNotEmpty) {
      // Move to the first data point for the top edge
      usagePath.lineTo(usageScaledPoints.first.dx, usageScaledPoints.first.dy);

      // Apply quadratic Bezier for smoothing for subsequent points
      for (int i = 0; i < usageScaledPoints.length - 1; i++) {
        final Offset p0 = usageScaledPoints[i]; // Current point
        final Offset p1 = usageScaledPoints[i + 1]; // Next point

        // Calculate midpoint between current and next point as the end point of the quadratic Bezier segment.
        // The current data point (p0) serves as the control point for the segment.
        final Offset midpoint = Offset(
          (p0.dx + p1.dx) / 2,
          (p0.dy + p1.dy) / 2,
        );
        usagePath.quadraticBezierTo(p0.dx, p0.dy, midpoint.dx, midpoint.dy);
      }
      // Ensure the path reaches the last actual data point's x coordinate after the loop
      // (the loop ends at the midpoint of the last two points).
      usagePath.lineTo(usageScaledPoints.last.dx, usageScaledPoints.last.dy);
    }
    usagePath.lineTo(width, height); // Draw down to bottom-right
    usagePath.close(); // Close back to (0, height)
    canvas.drawPath(usagePath, Paint()..color = usageColor);

    // --- Draw Air Quality Curve (Dark Grey Area BETWEEN air quality and usage) ---
    final Path airQualityPath = Path();
    if (airQualityScaledPoints.isEmpty || usageScaledPoints.isEmpty) {
      return; // Not enough data to draw the filled area
    }

    // 1. Move to the first point of the air quality curve's top edge
    airQualityPath.moveTo(
        airQualityScaledPoints.first.dx, airQualityScaledPoints.first.dy);

    // 2. Trace the smooth top edge of the air quality curve
    for (int i = 0; i < airQualityScaledPoints.length - 1; i++) {
      final Offset p0 = airQualityScaledPoints[i];
      final Offset p1 = airQualityScaledPoints[i + 1];
      final Offset midpoint = Offset((p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
      airQualityPath.quadraticBezierTo(p0.dx, p0.dy, midpoint.dx, midpoint.dy);
    }
    airQualityPath.lineTo(airQualityScaledPoints.last.dx,
        airQualityScaledPoints.last.dy); // Ensure it ends at the last point

    // 3. Go down from the last air quality point to the last usage point
    airQualityPath.lineTo(usageScaledPoints.last.dx, usageScaledPoints.last.dy);

    // 4. Trace back along the top edge of the usage curve (which forms the bottom boundary of the grey area)
    // We trace this in reverse, applying the same smoothing logic.
    for (int i = usageScaledPoints.length - 1; i > 0; i--) {
      final Offset p1 = usageScaledPoints[
          i]; // Current point in forward order (control point)
      final Offset p0 =
          usageScaledPoints[i - 1]; // Previous point in forward order

      final Offset midpoint = Offset(
          (p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2); // Midpoint of (p0, p1)

      // When traversing backwards, the 'p1' (current point in the forward list) becomes the control point,
      // and 'midpoint' (of p0 and p1) becomes the end point of the quadratic Bezier segment.
      airQualityPath.quadraticBezierTo(p1.dx, p1.dy, midpoint.dx, midpoint.dy);
    }
    // Connect to the very first usage point after tracing backwards through midpoints.
    airQualityPath.lineTo(
        usageScaledPoints.first.dx, usageScaledPoints.first.dy);

    airQualityPath.close();
    canvas.drawPath(airQualityPath, Paint()..color = airQualityColor);

    // --- Draw Highlighted Indicator ---
    if (highlightedIndex != null &&
        highlightedIndex! >= 0 &&
        highlightedIndex! < data.length) {
      final ChartDataPoint highlightedData = data[highlightedIndex!];
      // Use the airQualityScaledPoints for accurate highlight position on the curve
      final Offset highlightPoint = airQualityScaledPoints[highlightedIndex!];
      final double highlightX = highlightPoint.dx;
      final double highlightY = highlightPoint.dy;

      // Vertical line (from top to bottom)
      final Paint linePaint = Paint()
        ..color = highlightLineColor
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;
      canvas.drawLine(
          Offset(highlightX, 0), Offset(highlightX, height), linePaint);

      // Gradient circle/glow effect
      final Paint glowPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            highlightGlowColorStart,
            highlightGlowColorEnd,
          ],
          stops: const [0.0, 1.0],
          radius: 0.8,
        ).createShader(Rect.fromCircle(
            center: Offset(highlightX, highlightY), radius: 25));
      canvas.drawCircle(Offset(highlightX, highlightY), 25, glowPaint);

      // Solid dot at the intersection
      final Paint dotPaint = Paint()..color = highlightDotColor;
      canvas.drawCircle(Offset(highlightX, highlightY), 4, dotPaint);

      // Data value text (e.g., 376)
      final TextPainter valueTextPainter = TextPainter(
        text: TextSpan(
          text: '${highlightedData.value}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        // textDirection: TextDirection.ltr,
      );
      valueTextPainter.layout();
      valueTextPainter.paint(
          canvas,
          Offset(highlightX - valueTextPainter.width / 2,
              highlightY - valueTextPainter.height - 10));

      // Timestamp text (e.g., 3:59AM)
      final TextPainter timeTextPainter = TextPainter(
        text: TextSpan(
          text: DateFormat('h:mm a').format(highlightedData.timestamp),
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
        // textDirection: TextDirection.ltr,
      );
      timeTextPainter.layout();
      timeTextPainter.paint(
          canvas,
          Offset(highlightX - timeTextPainter.width / 2,
              height - timeTextPainter.height - 5));
    }
  }

  @override
  bool shouldRepaint(covariant CustomChartPainter oldDelegate) {
    // Only repaint if the data or highlighted index has changed
    return oldDelegate.data != data ||
        oldDelegate.highlightedIndex != highlightedIndex;
  }
}

class CustomChartWidget extends StatefulWidget {
  final List<AvgppmTimeRange> data;
  const CustomChartWidget({super.key, required this.data});

  @override
  State<CustomChartWidget> createState() => _CustomChartWidgetState();
}

class _CustomChartWidgetState extends State<CustomChartWidget> {
  late Future<List<ChartDataPoint>> _chartDataFuture;
  int? _highlightedIndex; // Index for the currently highlighted data point
  String _selectedRange = 'ALL'; // State for the filter buttons

  // Function to convert and normalize AvgppmTimeRange data
  Future<List<ChartDataPoint>> _convertAndNormalizeChartData(
      List<AvgppmTimeRange> data) async {
    if (data.isEmpty) return [];

    // Parse values and find min/max for normalization
    List<double> airQualityValues = [];
    List<double> usageValues = [];
    for (var e in data) {
      double? airQuality = double.tryParse(e.avgPpmAvg ?? '');
      double? usage = double.tryParse(e.avgPcdMax ?? '');
      if (airQuality != null) airQualityValues.add(airQuality);
      if (usage != null) usageValues.add(usage);
    }
    double airQualityMin = airQualityValues.reduce((a, b) => a < b ? a : b);
    double airQualityMax = airQualityValues.reduce((a, b) => a > b ? a : b);
    double usageMin = usageValues.reduce((a, b) => a < b ? a : b);
    double usageMax = usageValues.reduce((a, b) => a > b ? a : b);

    // Avoid division by zero
    double airQualityRange = (airQualityMax - airQualityMin) == 0
        ? 1
        : (airQualityMax - airQualityMin);
    double usageRange = (usageMax - usageMin) == 0 ? 1 : (usageMax - usageMin);

    return data.map((e) {
      final timestamp = DateTime.tryParse(e.timeRange ?? '') ?? DateTime.now();
      final airQualityRaw = double.tryParse(e.avgPpmAvg ?? '') ?? 0;
      final usageRaw = double.tryParse(e.avgPcdMax ?? '') ?? 0;
      final value = int.tryParse(e.avgPpmAvg ?? '') ?? 0;

      // Normalize
      final airQuality = (airQualityRaw - airQualityMin) / airQualityRange;
      final usage = (usageRaw - usageMin) / usageRange;

      return ChartDataPoint(
        timestamp: timestamp,
        airQuality: airQuality,
        usage: usage,
        value: value,
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _chartDataFuture = _convertAndNormalizeChartData(widget.data);

    _chartDataFuture.then((data) {
      // Find the index of the specific highlighted point from the image (3:59 AM, June 16)
      final index = data.indexWhere((point) =>
          point.timestamp.hour == 3 &&
          point.timestamp.minute == 59 &&
          point.timestamp.day == 16 &&
          point.timestamp.month == 6);
      if (index != -1) {
        setState(() {
          _highlightedIndex = index; // Set initial highlighted point
        });
      }
    });
  }

  // Helper method to build the range selection buttons (ALL, 1M, 6M)
  Widget _buildRangeButton(String text) {
    final bool isSelected = _selectedRange == text;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRange = text;
          // In a real application, you would typically trigger a new API call
          // here with the selected range as a parameter.
          // _chartDataFuture = fetchChartData(range: text);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.grey[700]
              : Colors.transparent, // Selected state color
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.backgroundColor,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[400],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.all(8.0), // Outer margin for the entire widget

      // padding: const EdgeInsets.all(10.0), // Inner padding
      child: Column(
        mainAxisSize: MainAxisSize.min, // Make column only take needed space
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align content to the start
        children: [
          // Top row: Title and Range Selection Buttons
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: SizedBox(
              height: 25,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 20,
                children: [
                  Text(
                    'Air Quality vs Usage',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Spacer(),
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildRangeButton('Today'),
                        const SizedBox(width: 8),
                        _buildRangeButton('7 days'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Chart Area: Uses AspectRatio and LayoutBuilder for responsiveness
          AspectRatio(
            aspectRatio: 16 / 9, // Maintain aspect ratio of the chart area
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return FutureBuilder<List<ChartDataPoint>>(
                    future: _chartDataFuture, // Our simulated API call
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Show a loading indicator while data is being fetched
                        return const Center(
                            child:
                                CircularProgressIndicator(color: Colors.white));
                      } else if (snapshot.hasError) {
                        // Display an error message if data fetching fails
                        return Center(
                            child: Text('Error: ${snapshot.error}',
                                style: const TextStyle(color: Colors.red)));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        // Message if no data is available
                        return const Center(
                            child: Text('No data available',
                                style: TextStyle(color: Colors.grey)));
                      } else {
                        final List<ChartDataPoint> data = snapshot.data!;

                        // Determine max values for scaling.
                        // Here, we assume normalized data (0-1) and scale based on 1.0.
                        const double airQualityMax = 1.0;
                        const double usageMax = 1.0;

                        return CustomPaint(
                          painter: CustomChartPainter(
                            data: data,
                            highlightedIndex: _highlightedIndex,
                            airQualityMax: airQualityMax,
                            usageMax: usageMax,
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
