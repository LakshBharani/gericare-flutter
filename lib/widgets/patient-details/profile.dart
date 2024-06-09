import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gericare/constants.dart';
import 'package:gericare/cubits/current_patient_info.dart';
import 'package:gericare/widgets/patient-details/constants.dart';

class ProfileSubSection extends StatelessWidget {
  const ProfileSubSection({super.key});

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
            title("Patient Profile"),
            lastUpdated(),
            subTitle("BASIC DETAILS"),
            profileItem1("Name", state['name']),
            profileItem1("Sex", state['sex'] == "M" ? "Male" : "Female"),
            profileItem1("Age", state['age'].toString()),
            profileItem1("UHID Number", state['uhid_no'].toString()),
            profileItem1("Informant", state['informant'].toString()),
            subTitle("ALLERGIES"),
            profileItem2(state['allergies']),
            subTitle("LIFESTYLE"),
            profileItem3("Smoking", state['habits']),
            profileItem3("Drinking", state['habits']),
            profileItem3("Tobacco", state['habits']),
            profileItem3("Snuff Use", state['habits']),
            subTitle("HISTORY"),
            profileItem4("Medical", state['medical_history']),
            profileItem4("Surgical", state['surgical_history']),
            subTitle("FALL RISK"),
            profileItem5(state['fall_risk']),
            const SizedBox(height: 200),
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

Widget profileItem1(String title, String value) {
  return Padding(
    padding: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 5),
    child: Wrap(
      children: [
        FractionallySizedBox(
          widthFactor: 0.35,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: primaryColor,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: appBarTitle,
          ),
        ),
      ],
    ),
  );
}

Widget profileItem2(List value) {
  if (value.isEmpty) {
    return const Padding(
      padding: EdgeInsets.only(left: 10, top: 18, right: 10),
      child: Wrap(
        children: [
          Text(
            "No allergies",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: appBarTitle,
            ),
          ),
        ],
      ),
    );
  }
  for (var i = 0; i < value.length; i++) {
    value[i] =
        value[i].toString()[0].toUpperCase() + value[i].toString().substring(1);
  }
  return Padding(
    padding: const EdgeInsets.only(left: 10, top: 18, right: 10),
    child: Wrap(
      children: [
        Text(
          value.join(", "),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: appBarTitle,
          ),
        ),
      ],
    ),
  );
}

Widget profileItem3(String title, List habits) {
  bool isTrue = habits.contains(title.toLowerCase()) || habits.contains(title);
  return Padding(
    padding: const EdgeInsets.only(left: 10, top: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: primaryColor,
          ),
        ),
        const SizedBox(width: 10),
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
    ),
  );
}

Widget profileItem4(String title, List value) {
  if (value.isEmpty) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 18, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: primaryColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            child: Wrap(
              children: [
                Text(
                  "No ${title.toLowerCase()} history",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: appBarTitle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  for (var i = 0; i < value.length; i++) {
    value[i] =
        value[i].toString()[0].toUpperCase() + value[i].toString().substring(1);
  }
  return Padding(
    padding: const EdgeInsets.only(left: 10, top: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: primaryColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          child: Wrap(
            children: [
              Text(
                value.join(", "),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: appBarTitle,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget profileItem5(String risk) {
  return Padding(
    padding: const EdgeInsets.only(left: 10, top: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          flex: 1,
          child: Text(
            "Fall Risk",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: primaryColor,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    "Low",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: appBarTitle,
                    ),
                  ),
                  if (risk == "low_risk")
                    const Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Icon(Icons.check, color: primaryColor, size: 20),
                    ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Text(
                    "High",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: appBarTitle,
                    ),
                  ),
                  if (risk == "high_risk")
                    const Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Icon(Icons.check, color: primaryColor, size: 20),
                    ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Text(
                    "Bell Bound",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: appBarTitle,
                    ),
                  ),
                  if (risk == "bell_bound")
                    const Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Icon(Icons.check, color: primaryColor, size: 20),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
