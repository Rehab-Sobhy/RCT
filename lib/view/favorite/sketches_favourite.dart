import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/view/favorite/favourite_details.dart';

import 'package:rct/view-model/cubits/sketches/sketches_cubit.dart';
import 'package:rct/view-model/cubits/sketches/sketches_state.dart';

class SketchesFavourite extends StatefulWidget {
  const SketchesFavourite({super.key});

  @override
  State<SketchesFavourite> createState() => _SketchesFavouriteState();
}

class _SketchesFavouriteState extends State<SketchesFavourite> {
  @override
  void initState() {
    super.initState();
    final cubit = SketchesCubit.get(context);
    cubit.loadSketches(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          BlocConsumer<SketchesCubit, SketchesState>(
            listener: (context, state) {
              // Optionally handle any state changes here
            },
            builder: (context, state) {
              final cubit = SketchesCubit.get(context);

              if (state is SketchesLoading) {
                return Center(child: Container());
              } else if (state is SketchesFailure) {
                return Center(child: Text('Error: ${state.errMessage}'));
              } else if (state is SketchesSuccess) {
                if (cubit.favoriteList.isEmpty) {
                  return Center(child: Text('No favorites added.'));
                }

                // Wrap ListView.builder with Expanded to ensure proper layout
                return Expanded(
                  child: ListView.builder(
                    itemCount: cubit.favoriteList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final sketch = cubit.favoriteList[index];

                      // Corrected usage of sketch fields directly
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FavoritesDetails(
                                          description:
                                              sketch["description"] == null
                                                  ? "${sketch["description"]}"
                                                  : "",
                                          image:
                                              "${linkServerName}/${sketch["image"]}",
                                          name: "${sketch["name"]}",
                                        )));
                          },
                          child: Card(
                            color: Colors.white,
                            elevation: 4,
                            child: Container(
                              height: 110,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            "${linkServerName}/${sketch["image"]}" ??
                                                'https://via.placeholder.com/150',
                                          ),
                                          fit: BoxFit.fill,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      height: 120,
                                      width: MediaQuery.of(context).size.width *
                                          .3,
                                    ),
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      title: Text(
                                        sketch["name"] ?? '',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      subtitle: Text(
                                        "",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      trailing: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.red),
                                        ),
                                        onPressed: () {
                                          cubit.toggleFavorite(sketch);
                                        },
                                        child: Text(
                                          "ازله",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              return SizedBox(); // Handle any other states
            },
          ),
        ],
      ),
    );
  }
}
