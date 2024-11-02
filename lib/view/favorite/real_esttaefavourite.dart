import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/view/favorite/favourite_details.dart';

import 'package:rct/view/RealEstate/real_estate_cubit.dart';
import 'package:rct/view/RealEstate/states.dart';

class RealFavorites extends StatefulWidget {
  const RealFavorites({super.key});

  @override
  State<RealFavorites> createState() => _RealFavoritesState();
}

class _RealFavoritesState extends State<RealFavorites> {
  @override
  void initState() {
    super.initState();
    final cubit = DataCubit.get(context);

    // Load favorites when screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          BlocConsumer<DataCubit, DataState>(
            listener: (context, state) {
              // Optionally handle any state changes here
            },
            builder: (context, state) {
              final cubit = DataCubit.get(context);

              if (state is DataLoading) {
                return Center(child: Container());
              } else if (state is DataError) {
                return Center(child: Text(' ${state.message}'));
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: cubit.favoriteList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final house = cubit.favoriteList[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FavoritesDetails(
                                        description: "${house.description}",
                                        image:
                                            "${linkServerName}/${house.image1}",
                                        name: "${house.city_name!}",
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
                                          house.image1 != null
                                              ? "${linkServerName}/${house.image1}"
                                              : 'https://via.placeholder.com/150',
                                        ),
                                        fit: BoxFit.fill,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    height: 120,
                                    width:
                                        MediaQuery.of(context).size.width * .3,
                                  ),
                                ),
                                Expanded(
                                  child: ListTile(
                                    title: Text(
                                      house.city_name ?? '',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    subtitle: Text(
                                      house.price == null
                                          ? '${house.price} ريال'
                                          : "",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    trailing: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.red),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          cubit.toggleFavorite(house);
                                        });
                                      },
                                      child: Text(
                                        "ازله",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
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
            },
          ),
        ],
      ),
    );
  }
}
