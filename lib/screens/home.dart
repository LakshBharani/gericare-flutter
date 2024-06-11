import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gericare/constants.dart';
import 'package:gericare/cubits/auth_info.dart';
import 'package:gericare/cubits/patients_info.dart';
import 'package:gericare/db_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

int flexTop = 2;
int flexBottom = 3;
DbService dbservice = DbService();

class _HomeScreenState extends State<HomeScreen> {
  void fetchPatients() async {
    final authInfoCubit = BlocProvider.of<AuthInfoCubit>(context);
    final patientsCubit = BlocProvider.of<PatientsCubit>(context);
    String accessToken = authInfoCubit.state['access_token'];
    final refreshToken = authInfoCubit.state['refresh_token'];
    final newToken = await dbservice.refreshAccessToken(refreshToken);
    accessToken = newToken['access'];
    authInfoCubit.updateAccessToken(accessToken);
    final patients = await dbservice.fetchPatients(accessToken);
    patientsCubit.updatePatients(patients);
  }

  bool showSearch = false;
  TextEditingController searchController = TextEditingController();
  List currentPatientInfoCubit = [];

  @override
  Widget build(BuildContext context) {
    final authInfoCubit = BlocProvider.of<AuthInfoCubit>(context);
    final patients = BlocProvider.of<PatientsCubit>(context);

    fetchPatients();
    return Scaffold(
      backgroundColor: secondaryColor,
      body: Padding(
        padding:
            const EdgeInsets.only(top: Orientation.portrait == true ? 10 : 20),
        child: SafeArea(
          bottom: false,
          child: Column(children: [
            Expanded(
              flex: flexTop,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    topBar(authInfoCubit),
                    const SizedBox(height: 20),
                    title("Reminders"),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: flexBottom,
              child: DraggableScrollableSheet(
                  initialChildSize: 1,
                  minChildSize: 0.99999,
                  builder: (context, ScrollController scrollController) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                title("Your Patients"),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        currentPatientInfoCubit =
                                            patients.state['results'];
                                        showSearch = !showSearch;
                                      });
                                    },
                                    icon: Icon(
                                        showSearch
                                            ? Icons.close
                                            : Icons.search_rounded,
                                        color: primaryColor,
                                        size: 30))
                              ],
                            ),
                            if (showSearch) ...[
                              const SizedBox(height: 10),
                              TextField(
                                controller: searchController,
                                autofocus: true,
                                onChanged: (value) {
                                  patients.updatePatients({
                                    'results': currentPatientInfoCubit
                                        .where((element) => element['name']
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase()))
                                        .toList(),
                                    'count': currentPatientInfoCubit
                                        .where((element) => element['name']
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase()))
                                        .toList()
                                        .length
                                  });
                                },
                                decoration: InputDecoration(
                                  enabled: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  isCollapsed: true,
                                  isDense: true,
                                  hintText: "Search for patients",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 20),
                            Expanded(
                              child: BlocBuilder<PatientsCubit,
                                  Map<String, dynamic>>(
                                builder: (context, state) {
                                  if (state.isEmpty) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return RefreshIndicator(
                                    onRefresh: () async {
                                      fetchPatients();
                                    },
                                    child: state['count'] == 0
                                        ? Center(
                                            child: Text(
                                              searchController.text.isNotEmpty
                                                  ? "No patients found"
                                                  : "Add patients to view here",
                                              style: TextStyle(
                                                color: Colors.grey.shade400,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          )
                                        : ListView.builder(
                                            controller: scrollController,
                                            itemCount: state['results'].length,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.pushNamed(context,
                                                      '/patientDetails',
                                                      arguments: {
                                                        'id': state['results']
                                                            [index]['id'],
                                                      });
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15),
                                                  margin: const EdgeInsets.only(
                                                      bottom: 10),
                                                  decoration: BoxDecoration(
                                                    color: secondaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  height: 75,
                                                  child: Row(children: [
                                                    const CircleAvatar(),
                                                    const SizedBox(width: 10),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.55,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              "${state['results'][index]['name'].toString()[0].toUpperCase()}${state['results'][index]['name'].toString().substring(1)}",
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 18,
                                                                color:
                                                                    primaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              )),
                                                          Text(
                                                            "Last updated: ${formatTimestamp(state['results'][index]['updated_at'])}",
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  primaryColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    const Icon(
                                                      Icons
                                                          .chevron_right_rounded,
                                                      color: primaryColor,
                                                      size: 30,
                                                    )
                                                  ]),
                                                ),
                                              );
                                            },
                                          ),
                                  );
                                },
                              ),
                            ),
                          ]),
                    );
                  }),
            )
          ]),
        ),
      ),
    );
  }

  Widget topBar(AuthInfoCubit authInfoCubit) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(radius: 28),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Good Morning",
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 15.5,
                  ),
                ),
                Text(
                  authInfoCubit.state['data']['username'],
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 20,
          child: IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
            icon: const Icon(Icons.menu),
          ),
        ),
      ],
    );
  }
}

Widget title(String title) {
  return Text(
    title,
    style: const TextStyle(
      color: primaryColor,
      fontSize: 24,
      fontWeight: FontWeight.w500,
    ),
  );
}
