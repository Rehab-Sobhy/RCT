import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/view/RealEstate/details_screen.dart';
import 'package:rct/view/RealEstate/filter.dart';
import 'package:rct/view/RealEstate/modelget.dart';
import 'package:rct/view/RealEstate/real_estate_cubit.dart';
import 'package:rct/view/RealEstate/states.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FinalOffers extends StatefulWidget {
  const FinalOffers({super.key, required this.url});
  final String url;

  @override
  State<FinalOffers> createState() => _FinalOffersState();
}

class _FinalOffersState extends State<FinalOffers> {
  List<Modelget> data = [];
  bool allButtonActive = true;
  bool sakanyActive = true;
  bool tojaryActive = true;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    await context.read<DataCubit>().fetchData(widget.url);
  }

  void _handleCategoryFilter(String category) async {
    await context.read<DataCubit>().filterByCategory(category);
    setState(() {
      data = context.read<DataCubit>().filterbycategoryList ?? [];
    });
  }

  void _handleSearch(String query) {
    context.read<DataCubit>().SearchHouse(input: query);
    setState(() {
      data = context.read<DataCubit>().searchList ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocalizations.of(context)!;
    final cubit = context.read<DataCubit>();

    return Scaffold(
      appBar: BackButtonAppBar(context),
      backgroundColor: Colors.white,
      body: BlocConsumer<DataCubit, DataState>(
        listener: (context, state) {
          if (state is DataError) {
            print(state.message);
          }
        },
        builder: (context, state) {
          if (state is DataLoading) {
            return Container();
          } else if (state is DataError) {
            return const Center(child: Text('No Data Added'));
          } else if (state is DataSuccess) {
            data = cubit.allDataList;
          }

          return Padding(
            padding:
                const EdgeInsets.only(top: 40, right: 20, left: 20, bottom: 10),
            child: Column(
              children: [
                // Search & Filter Row
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        onChanged: _handleSearch,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          labelText: local.search,
                          floatingLabelAlignment: FloatingLabelAlignment.start,
                          fillColor: Colors.grey[200],
                          filled: true,
                          labelStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.search),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.line_style_sharp, size: 27),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FilterScreen()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Text(
                      local.type,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                _buildCategoryRow(local),
                const SizedBox(height: 20),
                // Property Listings
                Expanded(
                  child: data.isEmpty
                      ? const Center(
                          child: Text('لم يتم إضافة عروض عقارية حتى الآن'))
                      : _buildPropertyGrid(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryRow(AppLocalizations local) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildFilterButton(local.all, allButtonActive, () {
          setState(() {
            allButtonActive = !allButtonActive;
            sakanyActive = true;
            tojaryActive = true;
            data = context.read<DataCubit>().allDataList;
          });
        }),
        _buildFilterButton(local.residential, sakanyActive, () {
          _handleCategoryFilter("سكني");
          setState(() {
            sakanyActive = !sakanyActive;
            allButtonActive = true;
            tojaryActive = true;
          });
        }),
        _buildFilterButton(local.commercial, tojaryActive, () {
          _handleCategoryFilter("تجاري");
          setState(() {
            tojaryActive = !tojaryActive;
            allButtonActive = true;
            sakanyActive = true;
          });
        }),
      ],
    );
  }

  Widget _buildFilterButton(
      String label, bool isActive, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isActive ? const Color.fromRGBO(238, 238, 238, 1) : primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      ),
      child: Text(
        label,
        style: TextStyle(color: isActive ? Colors.black : Colors.white),
      ),
    );
  }

  Widget _buildPropertyGrid() {
    return GridView.builder(
      itemCount: data.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 10,
        childAspectRatio: 0.55,
      ),
      itemBuilder: (context, index) {
        final house = data[index];
        return _buildPropertyCard(house);
      },
    );
  }

  Widget _buildPropertyCard(Modelget house) {
    final cubit = context.read<DataCubit>();
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailsScreen(id: house.id)),
        );
      },
      child: Card(
        elevation: 1,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: house.image1 != null
                        ? Image.network(
                            "${linkServerName}/${house.image1!}",
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image),
                  ),
                  Positioned(
                    top: 6,
                    left: 5,
                    child: IconButton(
                      icon: Icon(
                        cubit.favoriteList
                                .any((favHouse) => favHouse.id == house.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: cubit.favoriteList
                                .any((favHouse) => favHouse.id == house.id)
                            ? Colors.red
                            : Colors.black,
                      ),
                      onPressed: () => setState(() {
                        cubit.toggleFavorite(house);
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                house.house_type ?? 'No house type',
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
              ),
              Text(
                "${house.price} ${AppLocalizations.of(context)!.sar}",
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                    fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 4),
              Text(
                "${house.city_name} - ${house.district_name}",
                style:
                    const TextStyle(fontSize: 9, fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                house.description ?? '',
                style: const TextStyle(fontSize: 8),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
