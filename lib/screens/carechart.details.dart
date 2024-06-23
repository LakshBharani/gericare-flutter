import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gericare/constants.dart';
import 'package:gericare/cubits/selected_care_chart.dart';
import 'package:gericare/widgets/patient-details/constants.dart';

class CareChartDetailsScreen extends StatelessWidget {
  const CareChartDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chartData = BlocProvider.of<SelectedCareChart>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(8),
          child: Divider(
            color: borderGrey,
            height: 0,
          ),
        ),
        title: const Text(
          'View Chart',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.pushNamed(context, '/careChart-edit');
              },
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          title("Care Chart"),
          lastUpdated(),
          const SizedBox(height: 20),
          rowItem1("Bath", chartData.state['bath']),
          rowItem1("Oral Care", chartData.state['oral_care']),
          rowItem1("Skin Care", chartData.state['skin_care']),
          rowItem1("Nail Care", chartData.state['nail_care']),
          rowItem1("Bed Making", chartData.state['bed_making']),
          rowItem1("Ambulation", chartData.state['ambulation']),
          rowItem1("Bladder Care", chartData.state['bladder_care']),
          subTitle("DIETARY REQUIREMENTS"),
          rowItem2(chartData.state['feeds']),
          subTitle("MEDICINAL REQUIREMENTS"),
          rowItem2(chartData.state['medicines']),
        ],
      ),
    );
  }
}

Widget rowItem1(String title, dynamic isTrue) {
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

Widget rowItem2(String items) {
  return Padding(
    padding: const EdgeInsets.only(left: 10, top: 18, right: 10),
    child: Wrap(
      children: [
        Text(
          items,
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
