import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gericare/constants.dart';
import 'package:gericare/cubits/auth_info.dart';
import 'package:gericare/cubits/current_patient_info.dart';
import 'package:gericare/screens/home.dart';
import 'package:gericare/widgets/patient-details/constants.dart';

class AddchartScreen extends StatefulWidget {
  const AddchartScreen({super.key});

  @override
  State<AddchartScreen> createState() => _AddchartScreenState();
}

class _AddchartScreenState extends State<AddchartScreen> {
  int dropDownValueIndex = 0;
  Map dropDownValueMap = {
    0: 'Care Chart',
    1: 'Vitals Chart',
    2: 'Emotion Chart',
  };
  List<String> vitals = [
    "BP Systolic",
    "BP Diastolic",
    "Heart Rate",
    "Temperature",
    "SPo2",
    "RR",
    "Total Intake",
    "Total Output",
    "Sleep",
    "Weight",
    "Motion",
  ];

  Map<String, dynamic> vitalsValuesJSON = {
    "patient": null,
    "blood_pressure_systolic": null,
    "blood_pressure_diastolic": null,
    "heart_rate": null,
    "temperature": null,
    "spo2": null,
    "respiratory_rate": null,
    "total_intake": null,
    "total_output": null,
    "sleep": null,
    "weight": null,
    "motion": null,
  };

  List<String> careChart = [
    "Patient",
    "Bath",
    "Oral Care",
    "Skin Care",
    "Nail Care",
    "Bed Making",
    "Ambulation",
    "Bladder Care",
    "Feeds",
    "Medicines",
  ];

  Map<String, dynamic> careChartValuesJSON = {
    "patient": null,
    "bath": false,
    "oral_care": false,
    "skin_care": false,
    "nail_care": false,
    "bed_making": false,
    "ambulation": false,
    "bladder_care": false,
    "feeds": null,
    "medicines": null,
  };

  List<String> emotionChart = [
    "Patient",
    "Medicines Taken",
    "Adequate Sleep",
    "Happiness",
    "Anxiety",
    "Irritability",
    "Energy",
  ];

  Map<String, dynamic> emotionChartValuesJSON = {
    "patient": null,
    "medicines_taken": false,
    "adequate_sleep": false,
    "happiness": null,
    "anxiety": null,
    "irritability": null,
    "energy": null,
  };

  final _formKey = GlobalKey<FormState>();

  Future postCareChartData() async {
    final authInfoCubit = BlocProvider.of<AuthInfoCubit>(context);
    String accessToken = authInfoCubit.state['access_token'];
    final refreshToken = authInfoCubit.state['refresh_token'];
    final newToken = await dbservice.refreshAccessToken(refreshToken);
    accessToken = newToken['access'];
    authInfoCubit.updateAccessToken(accessToken);
    dbservice.postCareChart(accessToken, careChartValuesJSON);
  }

  Future postVitalChartData() async {
    final authInfoCubit = BlocProvider.of<AuthInfoCubit>(context);
    String accessToken = authInfoCubit.state['access_token'];
    final refreshToken = authInfoCubit.state['refresh_token'];
    final newToken = await dbservice.refreshAccessToken(refreshToken);
    accessToken = newToken['access'];
    authInfoCubit.updateAccessToken(accessToken);
    dbservice.postVitalChart(accessToken, vitalsValuesJSON);
  }

  Future postEmotionChartData() async {
    final authInfoCubit = BlocProvider.of<AuthInfoCubit>(context);
    String accessToken = authInfoCubit.state['access_token'];
    final refreshToken = authInfoCubit.state['refresh_token'];
    final newToken = await dbservice.refreshAccessToken(refreshToken);
    accessToken = newToken['access'];
    authInfoCubit.updateAccessToken(accessToken);
    dbservice.postEmotionalChart(accessToken, emotionChartValuesJSON);
  }

  @override
  Widget build(BuildContext context) {
    final currentPatient = BlocProvider.of<CurrentPatientInfo>(context).state;
    vitalsValuesJSON["patient"] = currentPatient["id"];
    careChartValuesJSON["patient"] = currentPatient["id"];
    emotionChartValuesJSON["patient"] = currentPatient["id"];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar("Add Chart"),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SafeArea(
            child: Stack(
              children: [
                Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    children: [
                      label("Date"),
                      dateContainer(),
                      const SizedBox(height: 20),
                      label("Chart Type"),
                      const SizedBox(height: 10),
                      buildDropdownButton(),
                      const SizedBox(height: 10),
                      subTitle("DETAILS"),
                      const SizedBox(height: 15),
                      if (dropDownValueIndex == 0) buildCareChartColumn(),
                      if (dropDownValueIndex == 1)
                        buildVitalsGrid(constraints.maxWidth),
                      if (dropDownValueIndex == 2) buildEmotionChartColumn(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
                saveButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildDropdownButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor),
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        value: dropDownValueMap[dropDownValueIndex],
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
            dropDownValueIndex = dropDownValueMap.keys.firstWhere(
                (k) => dropDownValueMap[k] == newValue,
                orElse: () => 0);
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
    );
  }

  Widget buildCareChartColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 1; i < careChart.length - 2; i++)
          careChartRow(careChart[i], careChartValuesJSON.values.toList()[i], i),
        for (var i = careChart.length - 2; i < careChart.length; i++)
          careChartInputField(careChart[i], i),
      ],
    );
  }

  Widget careChartRow(String title, bool isTrue, int index) {
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
              GestureDetector(
                onTap: () {
                  setState(() {
                    careChartValuesJSON[
                        careChartValuesJSON.keys.toList()[index]] = false;
                  });
                },
                child: Container(
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
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    careChartValuesJSON[
                        careChartValuesJSON.keys.toList()[index]] = true;
                  });
                },
                child: Container(
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget careChartInputField(String title, int index) {
    final keys = careChartValuesJSON.keys.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: primaryColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        TextFormField(
          keyboardType: TextInputType.text,
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
          onChanged: (value) {
            careChartValuesJSON[keys[index]] = value;
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Enter value';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget buildVitalsGrid(double maxWidth) {
    int crossAxisCount = (maxWidth / 180).floor();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.9,
          ),
          itemCount: vitals.length - 1,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return vitalsInputField(vitals[index], index);
          },
        ),
        Text(
          vitals.last,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: primaryColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        TextFormField(
          keyboardType: TextInputType.text,
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
          onChanged: (value) {
            vitalsValuesJSON[vitalsValuesJSON.keys.toList().last] = value;
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Enter details';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget vitalsInputField(String title, int index) {
    final keys = vitalsValuesJSON.keys.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: primaryColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
          onChanged: (value) {
            vitalsValuesJSON[keys[index + 1]] = value;
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Enter value';
            } else if (double.tryParse(value) == null) {
              return 'Enter a valid number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget buildEmotionChartColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 1; i < 3; i++)
          emotionChartRow1(
              emotionChart[i], emotionChartValuesJSON.values.toList()[i], i),
        subTitle("EMOTIONS"),
        for (var i = 3; i < emotionChart.length; i++)
          emotionChartRow2(emotionChart[i], i),
      ],
    );
  }

  Widget emotionChartRow1(String title, bool isTrue, int index) {
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
              GestureDetector(
                onTap: () {
                  setState(() {
                    emotionChartValuesJSON[
                        emotionChartValuesJSON.keys.toList()[index]] = false;
                  });
                },
                child: Container(
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
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    emotionChartValuesJSON[
                        emotionChartValuesJSON.keys.toList()[index]] = true;
                  });
                },
                child: Container(
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget emotionChartRow2(String title, int index) {
    final keys = emotionChartValuesJSON.keys.toList();
    return Container(
      padding: const EdgeInsets.only(left: 10, top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          SizedBox(
            width: 150,
            child: DropdownButtonFormField<String>(
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
              value: emotionChartValuesJSON[keys[index]],
              onChanged: (String? newValue) {
                setState(() {
                  emotionChartValuesJSON[keys[index]] = newValue;
                });
              },
              items: <String>['low', 'medium', 'high']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value[0].toUpperCase() + value.substring(1)),
                );
              }).toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Select value';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
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

  Widget saveButton() {
    return Positioned(
      bottom: 0,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        width: double.infinity,
        color: Colors.white,
        child: ElevatedButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            if (_formKey.currentState!.validate()) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Adding chart...')));

              if (dropDownValueIndex == 0) {
                postCareChartData().then((_) {
                  Navigator.pop(context);
                });
              } else if (dropDownValueIndex == 1) {
                postVitalChartData().then((_) {
                  Navigator.pop(context);
                });
              } else if (dropDownValueIndex == 2) {
                print(emotionChartValuesJSON);
                postEmotionChartData().then((_) {
                  Navigator.pop(context);
                });
              }
            }
          },
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
    );
  }
}
