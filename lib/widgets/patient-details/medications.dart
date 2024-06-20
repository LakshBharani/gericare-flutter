import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gericare/constants.dart';
import 'package:gericare/cubits/current_patient_info.dart';
import 'package:gericare/cubits/reminders.dart';
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
            allergyMedicationList(),
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

Widget allergyMedicationList() {
  return BlocBuilder<RemindersCubit, List<Map<String, dynamic>>>(
      builder: (context, medicationList) {
    if (medicationList.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // [{patient: Laksh Bharani, master_medication_record: {id: 2, medication_type: iv_fluids_and_drugs, name: Some fluid, dose: 150 mL, frequency: once daily, before_meal: false, notes: Notes test}, time: 10:00}, {patient: Laksh Bharani, master_medication_record: {id: 1, medication_type: allergies, name: Tobramycin, dose: 1 Tablet, frequency: once daily, before_meal: true, notes: -}, time: 15:00}, {patient: Hemali Bharani, master_medication_record: {id: 3, medication_type: allergies, name: Tuberclosis, dose: 2 Tablet, frequency: twice daily, before_meal: false, notes: -}, time: 20:30}]
    return BlocBuilder<CurrentPatientInfo, Map<String, dynamic>>(
        builder: (context, patientState) {
      final patientName = patientState['name'];
      final patientMedicationList = medicationList
          .where((element) => element['patient'] == patientName)
          .toList();
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: patientMedicationList.length,
        itemBuilder: (context, index) {
          final medication = patientMedicationList[index];
          final medicationRecord = medication['master_medication_record'];
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicationRecord['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: appBarTitle,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Dose: ${medicationRecord['dose']}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: appBarTitle,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Frequency: ${medicationRecord['frequency']}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: appBarTitle,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Time: ${medication['time']}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: appBarTitle,
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  });
}
