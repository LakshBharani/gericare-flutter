import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gericare/constants.dart';
import 'package:gericare/cubits/current_patient_info.dart';
import 'package:gericare/cubits/documents_list.dart';
import 'package:gericare/widgets/patient-details/constants.dart';

class DocumentsSubSection extends StatelessWidget {
  const DocumentsSubSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentPatientInfo, Map<String, dynamic>>(
      builder: (context, state) {
        if (state.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return BlocBuilder<DocumentsListCubit, Map<String, dynamic>>(
          builder: (context, documentState) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shrinkWrap: true,
              itemCount:
                  documentState['count'] + 4, // Adjust for headers and spacing
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const SizedBox(height: 20);
                } else if (index == 1) {
                  return title("Documents");
                } else if (index == 2) {
                  return lastUpdated();
                } else if (index == 3) {
                  return const SizedBox(height: 20);
                } else {
                  final docIndex = index - 4;
                  final document = documentState['results'][docIndex];
                  return Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.file_copy,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                document['name'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: primaryColor,
                                ),
                              ),
                              Text(
                                formatTimestamp(
                                    document['patient']['created_at']),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: appBarTitle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            //
                          },
                          icon: const Icon(Icons.download),
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          },
        );
      },
    );
  }
}
