import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gericare/constants.dart';
import 'package:gericare/cubits/charts_info.dart';
import 'package:gericare/cubits/current_patient_info.dart';
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
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  List<DateTime> _highlightedDates = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartsInfoCubit, Map<String, Map<String, dynamic>>>(
      builder: (context, state) {
        // Check if state is empty
        if (state.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Extract highlighted dates from care and vitals data
        _highlightedDates = [
          ...state['care']!['results'].map<DateTime>((e) {
            return DateTime.parse(e['date_time']).toLocal();
          }).toList(),
          ...state['vitals']!['results'].map<DateTime>((e) {
            return DateTime.parse(e['date_time']).toLocal();
          }).toList(),
        ];

        // Filter data based on the selected day
        final selectedDate = _selectedDay?.toIso8601String().split('T')[0];
        final filteredCareData = selectedDate != null
            ? state['care']!['results'].where((element) {
                final date = element['date_time'].toString().split('T')[0];
                return date == selectedDate;
              }).toList()
            : state['care']!['results'];
        final filteredVitalsData = selectedDate != null
            ? state['vitals']!['results'].where((element) {
                final date = element['date_time'].toString().split('T')[0];
                return date == selectedDate;
              }).toList()
            : state['vitals']!['results'];

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
                filteredCareData.length + filteredVitalsData.length != 0
                    ? Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 100),
                          itemCount: filteredCareData.length +
                              filteredVitalsData.length,
                          itemBuilder: (context, index) {
                            if (index < filteredCareData.length) {
                              return chartCard(
                                "Care Chart",
                                filteredCareData[index]['patient']['name'],
                              );
                            } else {
                              final vitalsIndex =
                                  index - filteredCareData.length;
                              return chartCard(
                                "Vitals Chart",
                                filteredVitalsData[vitalsIndex]['patient']
                                    ['name'],
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
                color: secondaryColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  day.day.toString(),
                  style: const TextStyle(color: Colors.black),
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

  Widget chartCard(String title, String name) {
    return Container(
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
    );
  }
}
