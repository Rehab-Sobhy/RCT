import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/view/partener_success/cubit.dart';
import 'package:rct/view/partener_success/partener_states.dart';

// ignore: must_be_immutable
class PartenerDetailsScreen extends StatefulWidget {
  PartenerDetailsScreen({super.key, required this.id});
  String id;

  @override
  State<PartenerDetailsScreen> createState() => _PartenerDetailsScreenState();
}

class _PartenerDetailsScreenState extends State<PartenerDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data when the screen initializes
    context.read<ParetenerCubit>().fetchData();
  }

  @override
  Widget build(BuildContext context) {
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
            final product = list?.firstWhere(
              (element) => element.id == widget.id,
            );

            if (list!.isEmpty) {
              return const Center(
                child: Text('No data available'),
              );
            }

            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  if (list[0].image != null)
                    Container(
                        height: 200,
                        width: 200,
                        child: Image.network(
                            "${linkServerName}/${product!.image}")),
                  if (product != null) Text(product.name!),
                  const SizedBox(height: 20),
                  if (product!.description != null)
                    Text(
                      product.description!,
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            );
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
