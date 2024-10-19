import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/view/RealEstate/details_screen.dart';
import 'package:rct/view/RealEstate/filter.dart';
import 'package:rct/view/RealEstate/form.dart';
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
  Modelget? modelget;
  bool allbutton = true;

  bool sakany = true;
  bool tojary = true;
  List<Modelget> data = [];
  String selectedCategory = "الكل";

  @override
  void initState() {
    super.initState();
    _fetchInitialData();

    final cubit = DataCubit.get(context);
  }

  Future<void> _fetchInitialData() async {
    await DataCubit.get(context).fetchData(widget.url);
    // Apply initial filter or fetch if needed
  }

  Future<void> _filterbycategoryData(String category) async {
    await DataCubit.get(context).filterByCategory(category);
    // Update with filtered data
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocalizations.of(context)!;
    final cubit = DataCubit.get(context);
    return Scaffold(
      appBar: BackButtonAppBar(context),
      backgroundColor: Colors.white,
      body: BlocConsumer<DataCubit, DataState>(
        listener: (context, state) {
          if (state is DataError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            print(state.message);
          }

          if (state is DataSuccess) {
            data = DataCubit.get(context).allDataList;
          } else if (cubit.searchList != null) {
            data = DataCubit.get(context).searchList!;
          } else if (cubit.filterbycategoryList != null) {
            data = DataCubit.get(context).filterbycategoryList!;
          } else if (cubit.filterList != null) {
            data = DataCubit.get(context).filterList!;

            print("filter success state");
          }
        },
        builder: (BuildContext context, Object? state) {
          if (state is DataInitial) {
            return const Center(child: Text('Press button to fetch data'));
          } else if (state is DataError) {
            return Center(child: Center(child: Text('No Data Added')));
          } else if (state is DataLoading) {
            return const Center(child: const CircularProgressIndicator());
          } else {
            //getdata = DataCubit.get(context).allDataList;
            print("filtred lis${cubit.filterList}");
            print("alldatalist lis${cubit.allDataList}");
            print("filterby category lis${cubit.filterbycategoryList}");

            if (state is DataSuccess) {
              data = DataCubit.get(context).allDataList;
            } else if (cubit.searchList != null) {
              data = DataCubit.get(context).searchList!;
            } else if (cubit.filterbycategoryList != null) {
              data = DataCubit.get(context).filterbycategoryList!;
            } else if (cubit.filterList != null) {
              data = DataCubit.get(context).filterList!;

              print("filter success state");
            }
            print(data);
            return Padding(
              padding: const EdgeInsets.only(
                  top: 40, right: 20, left: 20, bottom: 70),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          onChanged: (value) {
                            DataCubit.get(context).SearchHouse(input: value);
                          },
                          enabled: true,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            labelText: local.search,
                            floatingLabelAlignment:
                                FloatingLabelAlignment.start,
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
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide.none,
                            ),
                            hintStyle: TextStyle(
                                color: Colors.black.withOpacity(0.25)),
                            suffixIcon: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.search),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.line_style_sharp,
                          size: 27,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const FilterScreen()));
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          local.type,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await context.read<DataCubit>().allDataList;
                          setState(() {
                            sakany = true;
                            tojary = true;
                            allbutton = !allbutton;
                            data = DataCubit.get(context).allDataList;
                          });
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const FinalOffers(
                                        url: linkHouses,
                                      )));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: allbutton == true
                              ? const Color.fromRGBO(238, 238, 238, 1)
                              : primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 8),
                        ),
                        child: Text(
                          local.all,
                          style: TextStyle(
                            color:
                                allbutton == true ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          print("tapped");
                          await context
                              .read<DataCubit>()
                              .filterByCategory("سكني");
                          setState(() {
                            sakany = !sakany;
                            allbutton = true;
                            tojary = true;
                            data = DataCubit.get(context).filterbycategoryList!;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: sakany == true
                              ? const Color.fromRGBO(238, 238, 238, 1)
                              : primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 8),
                        ),
                        child: Text(
                          local.residential,
                          style: TextStyle(
                            color: sakany == true ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          print("tapped");
                          await context
                              .read<DataCubit>()
                              .filterByCategory("تجاري");
                          setState(() {
                            tojary = !tojary;
                            allbutton = true;
                            sakany = true;
                            data = DataCubit.get(context).filterbycategoryList!;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tojary == true
                              ? const Color.fromRGBO(238, 238, 238, 1)
                              : primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 8),
                        ),
                        child: Text(
                          local.commercial,
                          style: TextStyle(
                            color: tojary == true ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Property Listings
                  Expanded(
                    child: data.isEmpty
                        ? Center(
                            child: Text(
                              'لم يتم إضافة عروض عقارية حتى الآن',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            //physics: NeverScrollableScrollPhysics(),
                            itemCount: data.length,

                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 10,
                              childAspectRatio: 0.55,
                            ),
                            itemBuilder: (context, index) {
                              final house = data[index];
                              return InkWell(
                                onTap: () {
                                  print(data.length);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DesignPage(
                                          productId: house.id,
                                        ),
                                      ));
                                },
                                child: LayoutBuilder(
                                    builder: (context, constraints) {
                                  return Card(
                                    elevation: 1,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 8, left: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 5),
                                          Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
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
                                                    cubit.favoriteList.any(
                                                            (favoriteHouse) =>
                                                                favoriteHouse
                                                                    .id ==
                                                                house.id)
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                    color: cubit.favoriteList.any(
                                                            (favoriteHouse) =>
                                                                favoriteHouse
                                                                    .id ==
                                                                house.id)
                                                        ? Colors.red
                                                        : Colors.black,
                                                  ),
                                                  onPressed: () {
                                                    cubit.toggleFavorite(house);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            house.house_type ?? 'No house type',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          Text(
                                            "${house.price.toString()} ${local.sar}",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.red,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            overflow: TextOverflow
                                                .ellipsis, // Handles overflow
                                            maxLines: 1,
                                            "${house.city_name} - ${house.district_name}",
                                            style: const TextStyle(
                                              fontSize: 9,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "${house.description}",
                                            style: const TextStyle(fontSize: 8),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomSheet: Container(
        color: const Color.fromARGB(255, 255, 255, 255).withOpacity(.9),
        width: double.infinity,
        alignment: Alignment.bottomLeft,
        height: 66,
        child: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddEstate()));
          },
          child: Container(
            height: 66,
            width: 199,
            decoration: const BoxDecoration(
              color: Color.fromARGB(223, 14, 15, 29),
              borderRadius: BorderRadius.only(topRight: Radius.circular(50)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${local.addEstate} + ",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildCategoryFilter(String text, {required Color color}) {
  return ElevatedButton(
    onPressed: () {},
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black,
      ),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
    ),
  );
}
