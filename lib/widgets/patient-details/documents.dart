import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gericare/constants.dart';
import 'package:gericare/cubits/current_patient_info.dart';
import 'package:gericare/widgets/patient-details/constants.dart';

class DocumentsSubSection extends StatelessWidget {
  const DocumentsSubSection({super.key});

  @override
  Widget build(BuildContext context) {
    // return loader if patient data is not available
    return BlocBuilder<CurrentPatientInfo, Map<String, dynamic>>(
      builder: (context, state) {
        if (state.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shrinkWrap: true,
          children: [
            const SizedBox(height: 20),
            title("Documents"),
            lastUpdated(),
            const SizedBox(height: 100),
          ],
        );
      },
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
