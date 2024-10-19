import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/view/partener_success/cubit.dart';
import 'package:rct/view/partener_success/partener_details.dart';
import 'package:rct/view/partener_success/partener_states.dart';

class PartnersScreen extends StatefulWidget {
  const PartnersScreen({super.key});

  @override
  State<PartnersScreen> createState() => _PartnersScreenState();
}

class _PartnersScreenState extends State<PartnersScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data when the screen initializes
    context.read<ParetenerCubit>().fetchData();
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButtonAppBar(context),
      body: BlocConsumer<ParetenerCubit, PartenerStates>(
        listener: (context, state) {
          // You can handle snackbar messages or navigation based on the state here
          if (state is PartenerFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message!)),
            );
          }
        },
        builder: (context, state) {
          if (state is PartenerLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PartenerSuccess) {
            final list = state.data;

            if (list!.isEmpty) {
              return const Center(
                child: Text('No data available'),
              );
            }

            return Center(
              child: Column(
                children: [
                  Text(local.successPartners,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 600.h,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10, // Adjust this value
                        mainAxisSpacing: 10, // Adjust this v alue
                        childAspectRatio: 2,
                      ),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(15),
                      itemCount: list.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (conext) => PartenerDetailsScreen(
                                      id: list[index].id!)));
                        },
                        child: Card(
                          elevation: 5,
                          shadowColor: Colors.black,
                          child: Container(
                            height: 250,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 199, 195, 195),
                                image: DecorationImage(
                                    image: NetworkImage(
                                      "${linkServerName}/${list[index].image!}",
                                    ),
                                    fit: BoxFit.fill),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
//       ),
          } else if (state is PartenerFailed) {
            return Center(
              child: Text('Failed to load data: ${state.message}'),
            );
          } else {
            return const Center(
              child: Text('No data available'),
            );
          }
        },
      ),
    );
  }
}
