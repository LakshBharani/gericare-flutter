import 'package:flutter/material.dart';
import 'package:gericare/constants.dart';
import 'package:gericare/widgets/patient-details/constants.dart';

class AddchartScreen extends StatefulWidget {
  const AddchartScreen({super.key});

  @override
  State<AddchartScreen> createState() => _AddchartScreenState();
}

String dropDownValue = 'Care Chart';

class _AddchartScreenState extends State<AddchartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar("Add Chart"),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: [
              label("Date"),
              dateContainer(),
              const SizedBox(height: 20),
              label("Chart Type"),
              const SizedBox(height: 10),
              // create a drop down button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: primaryColor),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: dropDownValue,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  underline: Container(
                    height: 0,
                    color: primaryColor,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropDownValue = newValue!;
                    });
                  },
                  items: <String>['Care Chart', 'Vitals Chart', 'Emotion Chart']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),
              subTitle("DETAILS"),
              const SizedBox(height: 15),
              if (dropDownValue == 'Care Chart')
                ...[]
              else if (dropDownValue == 'Vitals Chart') ...[
                Wrap(
                  runAlignment: WrapAlignment.spaceBetween,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    vitalsInputField("Blood Pressure"),
                    vitalsInputField("Heart Rate"),
                    vitalsInputField("Temperature"),
                    vitalsInputField("SPo2"),
                    vitalsInputField("RR"),
                    vitalsInputField("Motion"),
                    vitalsInputField("Total Input"),
                    vitalsInputField("Total Output"),
                    vitalsInputField("Sleep"),
                    vitalsInputField("Weight"),
                    SizedBox(
                      height: 100,
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                  ],
                ),
              ] else
                ...[],
            ],
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: secondaryColor,
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "SAVE DETAILS",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget vitalsInputField(String value) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      margin: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              fillColor: secondaryColor,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Colors.white),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget label(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: primaryColor,
    ),
  );
}

Widget dateContainer() {
  return Container(
    margin: const EdgeInsets.only(top: 10),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    decoration: BoxDecoration(
      border: Border.all(color: primaryColor),
      borderRadius: BorderRadius.circular(5),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          formatTimestamp(DateTime.now().toString()),
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const Icon(Icons.calendar_month, color: primaryColor),
      ],
    ),
  );
}
