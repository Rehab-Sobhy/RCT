import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/view/RealEstate/modelget.dart';
import 'package:rct/view/RealEstate/real_estate_cubit.dart';
import 'package:rct/view/RealEstate/states.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rct/view/home_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class DetailsScreen extends StatefulWidget {
  String? id;

  DetailsScreen({super.key, required this.id});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int ind = 0;
  String phoneNumber = "+966569988788";

  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<DataCubit, DataState>(
        listener: (BuildContext context, state) {
          if (state is DataError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<DataCubit, DataState>(
          builder: (BuildContext context, state) {
            if (state is DataInitial) {
              return const Center(child: Text('Press button to fetch data'));
            } else if (state is DataLoading) {
              return Center(child: Container());
            } else if (state is DataSuccess ||
                state is SearchSuccess ||
                state is FilterCategorySuccessState ||
                state is FilterSuccessState ||
                state is SearchSuccess ||
                state is FavouriteSuccess) {
              List<Modelget> getdata = DataCubit.get(context).allDataList;
              if (state is SearchSuccess) {
                getdata = DataCubit.get(context).searchList!;
              }
              if (state is FilterCategorySuccessState) {
                getdata = DataCubit.get(context).filterbycategoryList!;
              }
              if (state is FavouriteSuccess) {
                getdata = DataCubit.get(context).favoriteList;
              }

              final product = getdata.firstWhere(
                (element) => element.id == widget.id,
                orElse: () => Modelget(id: ''),
              );
              double price = double.tryParse(product.price.toString()) ?? 0.0;
              String formattedCost = NumberFormat('#,###').format(price);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .55,
                    child: Stack(
                      children: [
                        PageView(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              ind = index;
                            });
                          },
                          children: [
                            ClipRRect(
                              // borderRadius: BorderRadius.circular(40),
                              child: Image.network(
                                product.image2 == null
                                    ? "$linkServerName/${product.image1}"
                                    : "$linkServerName/${product.image2}",
                                fit: BoxFit.fill,
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * .40,
                              ),
                            ),
                            ClipRRect(
                              // borderRadius: BorderRadius.circular(40),
                              child: Image.network(
                                product.image3 == null
                                    ? "$linkServerName/${product.image1}"
                                    : "$linkServerName/${product.image3}",
                                width: double.infinity,
                                fit: BoxFit.fill,
                                height: 400,
                              ),
                            ),
                            ClipRRect(
                              // borderRadius: BorderRadius.circular(40),
                              child: Image.network(
                                product.image4 == null
                                    ? "$linkServerName/${product.image1}"
                                    : "$linkServerName/${product.image4}",
                                fit: BoxFit.fill,
                                width: double.infinity,
                                height: 400,
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back_ios_new_sharp,
                                color: Colors.black),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: 3,
                      effect: const ExpandingDotsEffect(
                        dotWidth: 15,
                        dotHeight: 12,
                        dotColor: Colors.grey,
                        activeDotColor: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "${product.house_type}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "${product.district_name} - ${product.city_name}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      local.discreption,
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "${product.description}",
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      children: [
                        Text(
                          "$formattedCost ${local.sar}",
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () async {
                            String message =
                                '''الصورة: $linkServerName/${product.image4!}
                                   المدينة: ${product.city_name ?? ''},
                                   الحي: ${product.district_name ?? ''},
                                   المساحة: ${product.house_space ?? ''},
                                   السعر: ${product.price ?? ''},
                                   ''';
                            final Uri whatsappUri = Uri(
                              scheme: 'https',
                              host: 'wa.me',
                              path: phoneNumber.replaceFirst('+', ''),
                              queryParameters: {
                                'text': message,
                              },
                            );

                            await launch(whatsappUri.toString());
                          },
                          child: Container(
                            height: 40,
                            decoration:
                                const BoxDecoration(shape: BoxShape.circle),
                            child: Image.asset(
                              "assets/images/watsap.png",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            } else if (state is DataError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const Center(child: Text('Unknown state'));
            }
          },
        ),
      ),
    );
  }
}
