import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gericare/constants.dart';
import 'package:gericare/cubits/selected_care_chart.dart';

class CareChartEditScreen extends StatelessWidget {
  const CareChartEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chartData = BlocProvider.of<SelectedCareChart>(context);
    print(chartData.state);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar("Edit Chart"),
      body: BlocBuilder<SelectedCareChart, Map<String, dynamic>>(
          builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            const Text(
              "Date",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: primaryColor,
              ),
            ),
            GestureDetector(
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: convertDateTime(state['date_time']),
                  firstDate: DateTime(2010),
                  lastDate: DateTime(2050),
                ).then((value) {
                  if (value == null) return;
                  final formattedDate = value.toString().split(' ')[0];
                  chartData.updateData({...state, 'date_time': formattedDate});
                });
              },
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: primaryColor),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatTimestamp(
                          convertDateTime(chartData.state['date_time'])
                              .toString()),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const Icon(Icons.calendar_month, color: primaryColor),
                  ],
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}

DateTime convertDateTime(String dateTime) {
  final date = dateTime.split('T')[0];
  final dateParts = date.split('-');
  return DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]),
      int.parse(dateParts[2]));
}
