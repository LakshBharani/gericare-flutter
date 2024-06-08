import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gericare/constants.dart';
import 'package:gericare/cubits/auth_info.dart';
import 'package:gericare/cubits/current_patient_info.dart';
import 'package:gericare/screens/home.dart';
import 'package:gericare/widgets/patient-details/charts.dart';
import 'package:gericare/widgets/patient-details/documents.dart';
import 'package:gericare/widgets/patient-details/medications.dart';
import 'package:gericare/widgets/patient-details/profile.dart';

class PatientDetailsScreen extends StatefulWidget {
  const PatientDetailsScreen({super.key});

  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  String currentPage = 'PROFILE';

  List<Widget> subScreens = [
    const ProfileSubSection(),
    const MedicationsSubSection(),
    const ChartsSubSection(),
    const DocumentsSubSection(),
  ];

  Map<String, int?> subScreenIndex = {
    'PROFILE': 0,
    'MEDICATION': 1,
    'CHARTS': 2,
    'DOCUMENTS': 3,
  };

  void fetchPatientDetails(int id) async {
    final currentPatientInfoCubit =
        BlocProvider.of<CurrentPatientInfo>(context);
    final authInfoCubit = BlocProvider.of<AuthInfoCubit>(context);
    String accessToken = authInfoCubit.state['access_token'];
    final refreshToken = authInfoCubit.state['refresh_token'];
    final newToken = await dbservice.refreshAccessToken(refreshToken);
    accessToken = newToken['access'];
    authInfoCubit.updateAccessToken(accessToken);
    final patientData = await dbservice.fetchPatientData(id, accessToken);
    currentPatientInfoCubit.updateData(patientData);
    print(currentPatientInfoCubit.state.toString());
  }

  @override
  Widget build(BuildContext context) {
    // get the int id from navigator arguments
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final id = arguments['id'] as int;
    fetchPatientDetails(id);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        foregroundColor: appBarTitle,
        title: const Text(
          'Patient Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      // show circular indicator while fetching data
      body: BlocBuilder<CurrentPatientInfo, Map<String, dynamic>>(
        builder: (context, state) {
          if (state.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: borderGrey,
                      width: 1,
                    ),
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ButtonBar(
                    alignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 3),
                      buttonBarBtn("PROFILE", () {}),
                      buttonBarBtn("MEDICATION", () {}),
                      buttonBarBtn("CHARTS", () {}),
                      buttonBarBtn("DOCUMENTS", () {}),
                      const SizedBox(width: 3),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: subScreens[subScreenIndex[currentPage]!],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buttonBarBtn(String text, Function onPressed) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        foregroundColor:
            currentPage == text ? primaryColor : primaryColor.withOpacity(0.5),
        backgroundColor: currentPage == text ? secondaryColor : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      onPressed: () {
        onPressed();
        setState(() {
          currentPage = text;
        });
      },
      child: Text(
        text,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
