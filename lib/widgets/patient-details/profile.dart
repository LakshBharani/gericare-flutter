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
            subTitle("RESPIRATORY"),
            profileItem6(
                "Airway Blocked", state['respiratory']['airway_blocked']),
            profileItem6("ET Tube", state['respiratory']['et_tube']),
            profileItem6("Tracheostomy", state['respiratory']['tracheostomy']),
            profileItem7(
                "Breath Sounds", state['respiratory']['breath_sounds']),
            profileItem8(
                "Requires Oxygen", state['respiratory']['requires_o2']),
            profileItem8("Requires Suctioning",
                state['respiratory']['requires_suctioning']),
            profileItem7("Others", state['respiratory']['others']),
            const SizedBox(height: 100),
          ],
        );
      },
    );
  }
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
              fontWeight: FontWeight.w600,
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
            fontWeight: FontWeight.w600,
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
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            child: Wrap(
              children: [
                Text(
                  "No ${title.toLowerCase()} history",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade400,
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
            fontWeight: FontWeight.w600,
            color: primaryColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
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
              fontWeight: FontWeight.w600,
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

Widget profileItem6(String title, bool value) {
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
            fontWeight: FontWeight.w600,
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
                color: !value ? primaryColor : secondaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(Icons.close,
                    color: !value ? Colors.white : primaryColor, size: 24),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: value ? primaryColor : secondaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(Icons.check,
                    color: value ? Colors.white : primaryColor, size: 24),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget profileItem7(String title, String subtitle) {
  if (subtitle == "") {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 18, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            child: Wrap(
              children: [
                Text(
                  "No ${title.toLowerCase()}",
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

  return Padding(
    padding: const EdgeInsets.only(left: 10, top: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: primaryColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          child: Wrap(
            children: [
              Text(
                subtitle,
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

Widget profileItem8(String title, bool value) {
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
            fontWeight: FontWeight.w600,
            color: primaryColor,
          ),
        ),
        const SizedBox(width: 10),
        Switch(value: value, onChanged: (value) {}),
      ],
    ),
  );
}
