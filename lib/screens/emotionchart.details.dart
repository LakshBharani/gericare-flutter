import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gericare/constants.dart';
import 'package:gericare/cubits/selected_emotion_chart.dart';
import 'package:gericare/widgets/patient-details/constants.dart';

class EmotionChartDetailsScreen extends StatelessWidget {
  const EmotionChartDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chartData = BlocProvider.of<SelectedEmotionChart>(context);

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
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          title("Emotion Chart"),
          lastUpdated(),
          const SizedBox(height: 20),
          subTitle("BASIC"),
          rowItem1("Adequate Sleep", chartData.state['adequate_sleep']),
          rowItem1("Medecines Taken", chartData.state['medicines_taken']),
          subTitle("EMOTIONS"),
          rowItem2("Happiness", chartData.state['happiness']),
          rowItem2("Anxiety", chartData.state['anxiety']),
          rowItem2("Irritability", chartData.state['irritability']),
          rowItem2("Energy", chartData.state['energy']),
          subTitle("NOTES"),
          rowItem3(context),
        ],
      ),
    );
  }
}

Widget subTitle(String title) {
  return Column(
    children: [
      const SizedBox(height: 20),
      Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: appBarTitle,
            ),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                color: appBarTitle,
                thickness: 0.5,
              ),
            ),
          ),
        ],
      ),
    ],
  );
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

Widget rowItem2(String title, String status) {
  return Padding(
    padding: const EdgeInsets.only(left: 10, top: 18, right: 10),
    // horizontal row of text low, med , high
    child: Row(
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
        // horizontal row of 3 circles
        Row(
          children: [
            Container(
              width: 60,
              height: 40,
              decoration: BoxDecoration(
                color: status == "low" ? primaryColor : secondaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  "Low",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: status == "low" ? Colors.white : primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 60,
              height: 40,
              decoration: BoxDecoration(
                color: status == "med" ? primaryColor : secondaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  "Med",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: status == "med" ? Colors.white : primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 60,
              height: 40,
              decoration: BoxDecoration(
                color: status == "high" ? primaryColor : secondaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  "High",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: status == "high" ? Colors.white : primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget rowItem3(BuildContext context) {
  final chartData = BlocProvider.of<SelectedEmotionChart>(context);
  return Padding(
    padding: const EdgeInsets.only(left: 10, top: 18, right: 10),
    child: Text(
      chartData.state['notes'],
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
    ),
  );
}
