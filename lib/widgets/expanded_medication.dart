import 'package:flutter/material.dart';
import 'package:gericare/constants.dart';

void showCustomBottomSheet(BuildContext context, Map medication) {
  final medicationRecord = medication['master_medication_record'];
  Widget popUpRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(
          icon,
          color: primaryColor,
          size: 24,
        ),
        const SizedBox(width: 10),
        Text(
          "$title : ",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: primaryColor,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: appBarTitle,
          ),
        )
      ],
    );
  }

  Widget beforeMealRow() {
    bool isTrue = medicationRecord['before_meal'] == true;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Before Meal : ",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: primaryColor,
            )),
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: !isTrue ? primaryColor : secondaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(Icons.close,
                    color: !isTrue ? Colors.white : primaryColor, size: 24),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isTrue ? primaryColor : secondaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(Icons.check,
                    color: isTrue ? Colors.white : primaryColor, size: 24),
              ),
            ),
          ],
        ),
      ],
    );
  }

  showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 90,
                decoration: const BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${medicationRecord['name']}",
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w500,
                          color: appBarTitle,
                        ),
                      ),
                      Text(
                        medicationRecord['medication_type'] == "allergies"
                            ? "(Allergies)"
                            : "(IV Fluid & Drugs)",
                        style: const TextStyle(
                          fontSize: 14,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 400,
                child: ListView(
                  padding: const EdgeInsets.all(15),
                  shrinkWrap: true,
                  children: [
                    popUpRow(Icons.person, "Patient", medication['patient']),
                    const SizedBox(height: 10),
                    popUpRow(
                        Icons.medication, "Dosage", medicationRecord['dose']),
                    const SizedBox(height: 10),
                    popUpRow(
                        Icons.access_time_filled,
                        "At Time",
                        medication['time'] +
                            " (in ${getTimeDifference(medication['time'])} minutes)"),
                    const SizedBox(height: 10),
                    popUpRow(
                        Icons.timer,
                        "Frequency",
                        medicationRecord['frequency'][0].toUpperCase() +
                            medicationRecord['frequency'].substring(1)),
                    const SizedBox(height: 10),
                    beforeMealRow(),
                    const SizedBox(height: 10),
                    const Text("Notes : ",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: primaryColor,
                        )),
                    const SizedBox(height: 5),
                    Text(
                      medicationRecord['notes'],
                      style: const TextStyle(
                        fontSize: 16,
                        color: appBarTitle,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      });
}

int getTimeDifference(String time) {
  final now = DateTime.now();
  final timeSplit = time.split(":");
  final timeToTake = DateTime(now.year, now.month, now.day,
      int.parse(timeSplit[0]), int.parse(timeSplit[1]));
  if (timeToTake.isBefore(now)) {
    timeToTake.add(const Duration(days: 1));
  }
  final difference = timeToTake.difference(now).inMinutes;
  if (difference < 0) {
    return 0;
  }
  return difference;
}
