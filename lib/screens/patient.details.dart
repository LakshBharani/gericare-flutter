import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gericare/constants.dart';
import 'package:gericare/cubits/auth_info.dart';
import 'package:gericare/cubits/charts_info.dart';
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
  }

  void fetchCareChartData() {
    final chartsCubit = BlocProvider.of<ChartsInfoCubit>(context);
    final authCubit = BlocProvider.of<AuthInfoCubit>(context);
    final accessToken = authCubit.state['access_token'];
    dbservice.fetchCareChartRecords(accessToken).then((value) {
      chartsCubit.updateCharts("care", value);
    });
  }

  void fetchVitalsChartData() {
    final chartsCubit = BlocProvider.of<ChartsInfoCubit>(context);
    final authCubit = BlocProvider.of<AuthInfoCubit>(context);
    final accessToken = authCubit.state['access_token'];
    dbservice.fetchVitalChartRecords(accessToken).then((value) {
      chartsCubit.updateCharts("vitals", value);
    });
  }

  @override
  Widget build(BuildContext context) {
    // get the int id from navigator arguments
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final id = arguments['id'] as int;
    fetchPatientDetails(id);
    fetchCareChartData();
    fetchVitalsChartData();
    final chartsCubit = BlocProvider.of<ChartsInfoCubit>(context);

    print(chartsCubit.state);

    return DefaultTabController(
      length: 5,
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              bottom: const TabBar(
                tabs: [
                  Tab(
                    text: 'Profile',
                  ),
                  Tab(
                    text: 'Medications',
                  ),
                  Tab(
                    text: 'Charts',
                  ),
                  Tab(
                    text: 'Documents',
                  ),
                ],
              ),
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
            body: TabBarView(children: subScreens)),
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
