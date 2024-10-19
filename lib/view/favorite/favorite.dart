import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/view/favorite/favourite_details.dart';
import 'package:rct/view-model/cubits/designs/designs_cubit.dart';
import 'package:rct/view-model/cubits/designs/designs_state.dart';

class DesignFavorites extends StatefulWidget {
  const DesignFavorites({super.key});

  @override
  State<DesignFavorites> createState() => _DesignFavoritesState();
}

class _DesignFavoritesState extends State<DesignFavorites> {
  @override
  void initState() {
    super.initState();

    final cubit = DesignsCubit.get(context);
    cubit.loadDesigns(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          BlocConsumer<DesignsCubit, DesignsState>(
            listener: (context, state) {
              // Optionally handle any state changes here
            },
            builder: (context, state) {
              final cubit2 = DesignsCubit.get(context);

              if (state is DesignsLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is DesignsFailure) {
                return Center(child: Text('Error: ${state.errMessage}'));
              } else if (state is DesignsSuccess) {
                // Ensure your favoriteList is populated correctly
                if (cubit2.favoriteList.isEmpty) {
                  return Center(child: Text('No favorites added.'));
                }

                // Wrap ListView.builder with Expanded to ensure proper layout
                return Expanded(
                  child: ListView.builder(
                    itemCount: cubit2.favoriteList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final design = cubit2.favoriteList[index];

                      // Corrected usage of design fields directly
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FavoritesDetails(
                                          description:
                                              "${design["description"]}",
                                          image:
                                              "${linkServerName}/${design["image"]}",
                                          name: "${design["name"]}",
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
                                            "${linkServerName}/${design["image"]}",
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
                                        design["name"] ?? '',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      subtitle: Text(
                                        "${design["price"]} ريال",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      trailing: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.red),
                                        ),
                                        onPressed: () {
                                          cubit2.toggleFavorite(design);
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
