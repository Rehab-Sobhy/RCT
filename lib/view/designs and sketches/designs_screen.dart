import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/common%20copounents/card_container.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/constants/linkapi.dart';

import 'package:rct/view-model/cubits/designs/designs_cubit.dart';
import 'package:rct/view-model/cubits/designs/designs_state.dart';
import 'package:rct/view/designs%20and%20sketches/designs_form_screen.dart';
import 'package:rct/view/designs%20and%20sketches/details_of_designs.dart';

class DesignsScreen extends StatefulWidget {
  const DesignsScreen({super.key});

  @override
  State<DesignsScreen> createState() => _DesignsScreenState();
}

class _DesignsScreenState extends State<DesignsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DesignsCubit>().loadDesigns(context);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DesignsCubit>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButtonAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                child: BlocBuilder<DesignsCubit, DesignsState>(
                  builder: (context, state) {
                    if (state is DesignsLoading) {
                      return const Center(child: Text(""));
                    } else if (state is DesignsFailure) {
                      print("Error in designs screen: $state ");
                      return Image.asset(
                          "$imagePath/modul-lettering-404-with-gears-and-exclamation-mark-text.png");
                    } else if (state is DesignsSuccess) {
                      var data = state.designs;
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          bool isFavorite = cubit.isFavorite(data[index]);

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ShowDetailsOfDesignsScreen(
                                              productId: data[index]["id"]
                                                  .toString())));
                            },
                            child: CardContainer(
                              image: "$linkServerName/${data[index]["image"]}",
                              title: "${data[index]["name"]}",
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DesignsForm(
                                            id: data[index]["id"])));
                              },
                              favoriteIcon: IconButton(
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  cubit.toggleFavorite(data[index]);
                                },
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Text('No data found');
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
