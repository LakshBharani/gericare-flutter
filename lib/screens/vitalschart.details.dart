import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gericare/constants.dart';
import 'package:gericare/cubits/selected_vitals_chart.dart';
import 'package:gericare/widgets/patient-details/constants.dart';

class VitalsChartDetailsScreen extends StatelessWidget {
  const VitalsChartDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vitalsChartsCubit = BlocProvider.of<SelectedVitalsChart>(context);
    final vitals = vitalsChartsCubit.state;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(8),
          child: Divider(
            color: borderGrey,
            height: 0,
          ),
        ),
        title: const Text(
          'View Chart',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title("Vitals Chart"),
            lastUpdated(),
            const SizedBox(height: 10),
            Expanded(
              child: GridView(
                padding: const EdgeInsets.only(top: 10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      (MediaQuery.of(context).size.width / 120).toInt(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 14,
                  childAspectRatio: 2 / 2.2,
                ),
                children: [
                  vitalTile(vitals['blood_pressure_diastolic'], "mmHg",
                      "BP Diastolic", "assets/icons/bp-icon.png"),
                  vitalTile(vitals['blood_pressure_systolic'], "mmHg",
                      "BP Systolic", "assets/icons/bp-icon.png"),
                  vitalTile(vitals['heart_rate'], "bpm", "Heart Rate",
                      "assets/icons/hr-icon.png"),
                  vitalTile(vitals['temperature'], "Farhenite", "Temperature",
                      "assets/icons/temp-icon.png"),
                  vitalTile(vitals['spo2'], "%", "SPO2",
                      "assets/icons/spo2-icon.png"),
                  vitalTile(vitals['respiratory_rate'], "%", "Respiratory Rate",
                      "assets/icons/spo2-icon.png"),
                  vitalTile(vitals['total_intake'], "FAU", "Total Intake",
                      "assets/icons/spo2-icon.png"),
                  vitalTile(vitals['total_output'], "FAU", "Total Output",
                      "assets/icons/spo2-icon.png"),
                  vitalTile(vitals['sleep'], "Hours", "Sleep",
                      "assets/icons/slp-icon.png"),
                  vitalTile(vitals['weight'], "Kgs", "Weight",
                      "assets/icons/wmchine-icon.png"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget vitalTile(dynamic value, String unit, String title, String iconPath) {
  return GridTile(
    child: Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  iconPath,
                  height: 23,
                ),
              ],
            ),
          ),
          const Spacer(),
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 33,
              fontWeight: FontWeight.w500,
              color: primaryColor,
            ),
          ),
          Text(
            unit,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: primaryColor,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: primaryColor,
            ),
          ),
        ],
      ),
    ),
  );
}
