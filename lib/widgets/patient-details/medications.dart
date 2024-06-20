import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gericare/constants.dart';
import 'package:gericare/cubits/current_patient_info.dart';
import 'package:gericare/cubits/reminders.dart';
import 'package:gericare/widgets/expanded_medication.dart';
import 'package:gericare/widgets/patient-details/constants.dart';

class MedicationsSubSection extends StatelessWidget {
  const MedicationsSubSection({super.key});

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
            title("Master Medication List"),
            lastUpdated(),
            subTitle("Allergy Medication"),
            const SizedBox(height: 20),
            medicationList("allergies"),
            subTitle("IV Fluids and Drugs"),
            const SizedBox(height: 20),
            medicationList("iv_fluids_and_drugs"),
          ],
        );
      },
    );
  }
}

Widget subTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(top: 24),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: appBarTitle,
      ),
    ),
  );
}

Widget medicationList(String subList) {
  return BlocBuilder<RemindersCubit, List<Map<String, dynamic>>>(
      builder: (context, medicationList) {
    if (medicationList.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return BlocBuilder<CurrentPatientInfo, Map<String, dynamic>>(
        builder: (context, patientState) {
      final patientName = patientState['name'];
      final patientMedicationList = medicationList
          .where((element) => element['patient'] == patientName)
          .toList();
      patientMedicationList.removeWhere((element) =>
          element['master_medication_record']['medication_type'] !=
          subList.toLowerCase());
      if (patientMedicationList.isEmpty) {
        return Center(
          child: Text(
            "No Medication Found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade400,
            ),
          ),
        );
      }
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: patientMedicationList.length,
        itemBuilder: (context, index) {
          final medication = patientMedicationList[index];
          final medicationRecord = medication['master_medication_record'];
          return GestureDetector(
            onTap: () => showCustomBottomSheet(context, medication),
            child: Container(
              height: 75,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    subList == "allergies"
                        ? Icons.medication
                        : Icons.medication_liquid,
                    color: primaryColor,
                    size: 30,
                  ),
                  const SizedBox(width: 14),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${medicationRecord['name']} - ${medicationRecord['dose']}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: primaryColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Dose: ${medicationRecord['frequency'][0].toUpperCase()}${medicationRecord['frequency'].substring(1)}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: primaryColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.chevron_right,
                    color: primaryColor,
                    size: 30,
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  });
}
