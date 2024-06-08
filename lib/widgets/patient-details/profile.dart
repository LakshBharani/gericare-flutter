import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gericare/constants.dart';
import 'package:gericare/cubits/current_patient_info.dart';
import 'package:gericare/widgets/patient-details/constants.dart';

class ProfileSubSection extends StatelessWidget {
  const ProfileSubSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        const SizedBox(height: 20),
        title("Patient Profile"),
        lastUpdated(),
        const SizedBox(height: 20),
        topDivider(),
      ],
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
}

Widget topDivider() {
  return const Row(
    children: [
      Text(
        "BASIC DETAILS",
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: appBarTitle,
        ),
      ),
      Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Divider(
            color: appBarTitle,
            thickness: 0.5,
          ),
        ),
      ),
    ],
  );
}
