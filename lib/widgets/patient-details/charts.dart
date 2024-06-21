import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gericare/constants.dart';
import 'package:gericare/cubits/auth_info.dart';
import 'package:gericare/cubits/charts_info.dart';
import 'package:gericare/cubits/current_patient_info.dart';
import 'package:gericare/cubits/selected_care_chart.dart';
import 'package:gericare/cubits/selected_vitals_chart.dart';
import 'package:gericare/db_service.dart';
import 'package:gericare/widgets/patient-details/constants.dart';
import 'package:table_calendar/table_calendar.dart';

class ChartsSubSection extends StatefulWidget {
  const ChartsSubSection({super.key});

  @override
  State<ChartsSubSection> createState() => _ChartsSubSectionState();
}

class _ChartsSubSectionState extends State<ChartsSubSection> {
  DbService dbservice = DbService();
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<DateTime> _highlightedDates = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartsInfoCubit, Map<String, Map<String, dynamic>>>(
      builder: (context, state) {
        // Check if state is empty
        if (state.isEmpty || state['care'] == null || state['vitals'] == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Filter data based on the selected day
        final selectedDate = _selectedDay.toIso8601String().split('T')[0];
        final filteredCareData = state['care']?['results'].where((element) {
          final date = element['date_time'].toString().split('T')[0];
          return date == selectedDate;
        }).toList();
        final filteredVitalsData = state['vitals']?['results'].where((element) {
          final date = element['date_time'].toString().split('T')[0];
          return date == selectedDate;
        }).toList();
        final filteredEmotionData =
            state['emotion']?['results'].where((element) {
          final date = element['date_time'].toString().split('T')[0];
          return date == selectedDate;
        }).toList();

        // Extract highlighted dates from care and vitals data
        _highlightedDates = [
          ...?state['care']?['results']?.map<DateTime>((e) {
            return DateTime.parse(e['date_time']).toLocal();
          }).toList(),
          ...?state['vitals']?['results']?.map<DateTime>((e) {
            return DateTime.parse(e['date_time']).toLocal();
          }).toList(),
          ...?state['emotion']?['results']?.map<DateTime>((e) {
            return DateTime.parse(e['date_time']).toLocal();
          }).toList(),
        ];

        return Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                title("Charts"),
                lastUpdated(),
                table(),
                const SizedBox(height: 20),
                filteredCareData.length +
                            filteredVitalsData.length +
                            filteredEmotionData.length !=
                        0
                    ? Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 100),
                          itemCount: filteredCareData.length +
                              filteredVitalsData.length +
                              filteredEmotionData.length,
                          itemBuilder: (context, index) {
                            if (index < filteredCareData.length) {
                              return chartCard(
                                "Care Chart",
                                filteredCareData[index]['patient']['name'],
                                filteredCareData[index]['id'],
                              );
                            } else if (index <
                                filteredCareData.length +
                                    filteredVitalsData.length) {
                              final vitalsIndex =
                                  index - filteredCareData.length;
                              return chartCard(
                                "Vitals Chart",
                                filteredVitalsData[vitalsIndex]['patient']
                                    ['name'],
                                filteredVitalsData[vitalsIndex]['id'],
                              );
                            } else {
                              final emotionIndex = index -
                                  (filteredCareData.length +
                                      filteredVitalsData.length);
                              return chartCard(
                                "Emotion Chart",
                                filteredEmotionData[emotionIndex]['patient']
                                    ['name'],
                                filteredEmotionData[emotionIndex]['id'],
                              );
                            }
                          },
                        ),
                      )
                    : Expanded(
                        child: Center(
                          child: Text(
                            "No charts for this date",
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
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

  Widget table() {
    return TableCalendar(
      pageJumpingEnabled: true,
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      firstDay: DateTime.now().subtract(const Duration(days: 365 * 8)),
      lastDay: DateTime.now().add(const Duration(days: 365 * 2)),
      focusedDay: _focusedDay,
      calendarFormat: CalendarFormat.month,
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      calendarStyle: CalendarStyle(
        todayDecoration: const BoxDecoration(
          color: primaryColor,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          border: Border.all(color: primaryColor, width: 2),
          shape: BoxShape.circle,
        ),
        outsideDaysVisible: false,
      ),
      eventLoader: (day) {
        if (_highlightedDates.any((d) => isSameDay(d, day))) {
          return ['highlighted'];
        }
        return [];
      },
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          if (_highlightedDates.any((d) => isSameDay(d, day))) {
            return Container(
              margin: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                border: Border.all(color: primaryColor, width: 2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  day.day.toString(),
                  style: const TextStyle(color: primaryColor),
                ),
              ),
            );
          }
          return null;
        },
        selectedBuilder: (context, day, focusedDay) {
          if (_highlightedDates.any((d) => isSameDay(d, day))) {
            return Container(
              margin: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                color: primaryColor,
                border: Border.all(color: primaryColor, width: 2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  day.day.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          } else {
            return Container(
              margin: const EdgeInsets.all(6.0),
              decoration: const BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  day.day.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          }
        },
        todayBuilder: (context, day, focusedDay) {
          return Container(
            margin: const EdgeInsets.all(6.0),
            decoration: const BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                day.day.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget chartCard(String title, String name, int id) {
    Future fetchCareChartData() async {
      final authInfoCubit = BlocProvider.of<AuthInfoCubit>(context);
      final careChartsCubit = BlocProvider.of<SelectedCareChart>(context);
      String accessToken = authInfoCubit.state['access_token'];
      final refreshToken = authInfoCubit.state['refresh_token'];
      final newToken = await dbservice.refreshAccessToken(refreshToken);
      accessToken = newToken['access'];
      authInfoCubit.updateAccessToken(accessToken);
      await dbservice.fetchCareChartData(id, accessToken).then((value) {
        careChartsCubit.updateData(value);
      });
    }

    Future fetchVitalsChartData() async {
      final authInfoCubit = BlocProvider.of<AuthInfoCubit>(context);
      final vitalsChartsCubit = BlocProvider.of<SelectedVitalsChart>(context);
      String accessToken = authInfoCubit.state['access_token'];
      final refreshToken = authInfoCubit.state['refresh_token'];
      final newToken = await dbservice.refreshAccessToken(refreshToken);
      accessToken = newToken['access'];
      authInfoCubit.updateAccessToken(accessToken);
      await dbservice.fetchVitalChartData(id, accessToken).then((value) {
        vitalsChartsCubit.updateData(value);
      });
    }

    return GestureDetector(
      onTap: () {
        if (title == "Care Chart") {
          fetchCareChartData().then((_) {
            Navigator.pushNamed(context, '/careChart-details');
          });
        } else if (title == "Vitals Chart") {
          fetchVitalsChartData().then((_) {
            Navigator.pushNamed(context, '/vitalsChart-details');
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.medical_services_rounded,
              color: primaryColor,
            ),
            const SizedBox(width: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 12,
                      color: primaryColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(
              Icons.chevron_right_rounded,
              color: primaryColor,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
