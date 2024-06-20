import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gericare/constants.dart';
import 'package:gericare/cubits/auth_info.dart';
import 'package:gericare/cubits/charts_info.dart';
import 'package:gericare/cubits/current_patient_info.dart';
import 'package:gericare/cubits/documents_list.dart';
import 'package:gericare/cubits/patients_info.dart';
import 'package:gericare/cubits/reminders.dart';
import 'package:gericare/cubits/selected_care_chart.dart';
import 'package:gericare/cubits/selected_vitals_chart.dart';
import 'package:gericare/screens/carechart.details.dart';
import 'package:gericare/screens/home.dart';
import 'package:gericare/screens/login.dart';
import 'package:gericare/screens/onboarding.dart';
import 'package:gericare/screens/patient.details.dart';
import 'package:gericare/screens/vitalschart.details.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthInfoCubit()),
        BlocProvider(create: (context) => PatientsCubit()),
        BlocProvider(create: (context) => CurrentPatientInfo()),
        BlocProvider(create: (context) => ChartsInfoCubit()),
        BlocProvider(create: (context) => SelectedCareChart()),
        BlocProvider(create: (context) => SelectedVitalsChart()),
        BlocProvider(create: (context) => RemindersCubit()),
        BlocProvider(create: (context) => DocumentsListCubit()),
      ],
      child: MaterialApp(
        title: 'GeriCare',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const OnboardingScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/patientDetails': (context) => const PatientDetailsScreen(),
          '/careChart-details': (context) => const CareChartDetailsScreen(),
          '/vitalsChart-details': (context) => const VitalsChartDetailsScreen(),
        },
      ),
    );
  }
}
