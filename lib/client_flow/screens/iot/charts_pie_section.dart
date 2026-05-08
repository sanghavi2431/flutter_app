import 'package:flutter/material.dart';
import '../../widgets/pie_chart.dart';
import '../dashbaord/bloc/dashboard_state.dart';



class ChartsPieSection extends StatelessWidget {

  final DashboardState state;

  const ChartsPieSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {

    if (state is! DashbaordTask) {
      return const SizedBox(height: 200);
    }

    final dashboardModel = (state as DashbaordTask).dashbaordModel;

    return Center(
      child: ChartPie(
        complatedTask:
        dashboardModel?.results!.taskStatusDistribution!.completedCount ?? "0",
        pendingTask:
        dashboardModel?.results!.taskStatusDistribution!.pendingCount ?? "0",
        totalTask:
        dashboardModel?.results!.janitorEfficiency!.totaltask.toString(),
        accetedTask:
        dashboardModel?.results!.taskStatusDistribution!.acceptedCount ?? "0",
        ongoingTask:
        dashboardModel?.results!.taskStatusDistribution!.ongoingCount ?? "0",
        rejectedTask:
        dashboardModel?.results!.taskStatusDistribution!.rejectedCount ?? "0",
        rfcTask:
        dashboardModel?.results!.taskStatusDistribution!.closureCount ?? "0",
        complatedPercentage:
        dashboardModel?.results!.taskStatusDistribution!.completedPercentage,
        acceptedPercentage:
        dashboardModel?.results!.taskStatusDistribution!.acceptedPercentage,
        ongoingPercentage:
        dashboardModel?.results!.taskStatusDistribution!.ongoingPercentage,
        pendingPercentage:
        dashboardModel?.results!.taskStatusDistribution!.pendingPercentage,
        rejectedPercentage:
        dashboardModel?.results!.taskStatusDistribution!.rejectedPercentage,
        rfcPercentage:
        dashboardModel?.results!.taskStatusDistribution!.closurePercentage,
      ),
    );
  }
}