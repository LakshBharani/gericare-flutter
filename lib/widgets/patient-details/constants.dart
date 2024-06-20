import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gericare/constants.dart';
import 'package:gericare/cubits/current_patient_info.dart';

// common title widget
Widget title(String title) {
  return Text(
    title,
    style: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: appBarTitle,
    ),
  );
}

Widget lastUpdated() {
  return Row(
    children: [
      const Icon(
        Icons.check_circle,
        size: 16,
        color: greenTick,
      ),
      const SizedBox(width: 5),
      BlocBuilder<CurrentPatientInfo, Map<String, dynamic>>(
        builder: (context, state) {
          return Text(
            "Last updated: ${formatTimestamp(state['updated_at'])}",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: appBarTitle,
            ),
          );
        },
      ),
    ],
  );
}

Widget subTitle(String title) {
  return Column(
    children: [
      const SizedBox(height: 20),
      Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: appBarTitle,
            ),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                color: appBarTitle,
                thickness: 0.5,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
