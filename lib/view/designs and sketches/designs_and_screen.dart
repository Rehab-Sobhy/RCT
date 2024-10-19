import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/model/order_model.dart';
import 'package:rct/view-model/cubits/designs/designs_cubit.dart';
import 'package:rct/view-model/cubits/designs/designs_state.dart';
import 'package:rct/view-model/cubits/order%20number/order_number_cubit.dart';
import 'package:rct/view-model/cubits/sketches/sketches_cubit.dart';
import 'package:rct/view-model/cubits/sketches/sketches_state.dart';
import 'package:rct/view-model/functions/snackbar.dart';
import 'package:rct/view/designs%20and%20sketches/custom_designs_and_diagrams_screen.dart';
import 'package:rct/view/designs%20and%20sketches/designs_screen.dart';
import 'package:rct/view/designs%20and%20sketches/sketches_screen.dart';

class DesignAndScreen extends StatefulWidget {
  const DesignAndScreen({super.key});

  @override
  State<DesignAndScreen> createState() => _DesignAndScreenState();
}

class _DesignAndScreenState extends State<DesignAndScreen> {
  @override
  void initState() {
    super.initState();
    final designsCubit = DesignsCubit.get(context);
    final sketchesCubit = SketchesCubit.get(context);

    sketchesCubit.loadSketches(context);
    designsCubit.loadDesigns(context);
  }

  Widget build(BuildContext context) {
    var local = AppLocalizations.of(context)!;
    List<String> items = [];
    var data = [];

    context.read<OrderNumberCubit>().fetchOrders();
    OrderModel orderModel = Provider.of<OrderModel>(context, listen: false);

    return BlocConsumer<OrderNumberCubit, OrderNumberState>(
      listener: (context, state) {
        if (state is OrderNumberFailure) {
          showSnackBar(context, state.errMessage, redColor);
        } else if (state is OrderNumberSuccess) {
          if (state.orderNumber.isEmpty) {
            showSnackBar(context, local.noRequests, redColor);
          } else {
            data = state.orderNumber;
            items = data.map((map) => map["number"] as String).toList();
            orderModel.orderNumbers = items;
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: BackButtonAppBar(context),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(constHorizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset("$imagePath/banner-photo.png"),
                  ),
                  SizedBox(height: constVerticalPadding),
                  Text(
                    local.categories,
                    style: TextStyle(
                      fontSize: 12,
                      color: blackColor.withOpacity(0.5),
                    ),
                  ),
                  SizedBox(height: constVerticalPadding),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SketchesScreen(),
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF747171).withOpacity(0.3),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: ListTile(
                              title: Text(
                                local.plans,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: blackColor.withOpacity(0.5),
                                ),
                              ),
                              leading: Image.asset(
                                "$iconsPath/fluent_building-home-24-regular.png",
                                width: 30.w,
                                height: 30.h,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: constHorizontalPadding),
                      Expanded(
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DesignsScreen(),
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF0661E9).withOpacity(0.3),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: ListTile(
                              title: Text(
                                local.designs,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: const Color(0xFF0661E9),
                                ),
                              ),
                              leading: Image.asset(
                                "$iconsPath/material-symbols_add-home-work.png",
                                width: 30.w,
                                height: 30.h,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: constVerticalPadding),
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomDesignAndDiagramsScreen(),
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D8386).withOpacity(0.3),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Center(
                        child: ListTile(
                          titleAlignment: ListTileTitleAlignment.center,
                          title: Text(
                            local.customPlansAndDesigns,
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color(0xFF2D8386),
                            ),
                          ),
                          leading: Image.asset(
                            "$iconsPath/Vector.png",
                            width: 30.w,
                            height: 30.h,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: constVerticalPadding),
                  Text(
                    local.favourite,
                    style: TextStyle(
                      fontSize: 13,
                      color: blackColor.withOpacity(0.5),
                    ),
                  ),
                  SizedBox(height: constVerticalPadding),
                  // Display Favorite Designs and Sketches
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: BlocBuilder<DesignsCubit, DesignsState>(
                      builder: (context, designState) {
                        if (designState is DesignsSuccess) {
                          final favoriteDesigns =
                              context.read<DesignsCubit>().favoriteList;

                          return BlocBuilder<SketchesCubit, SketchesState>(
                            builder: (context, sketchState) {
                              if (sketchState is SketchesSuccess) {
                                final favoriteSketches =
                                    context.read<SketchesCubit>().favoriteList;

                                // Combine the lists of designs and sketches
                                final combinedFavorites = [
                                  ...favoriteDesigns.map((item) => {
                                        'image': item['image'],
                                        'name': item['name'],
                                        'type':
                                            'design' // Add a type field to distinguish
                                      }),
                                  ...favoriteSketches.map((item) => {
                                        'image': item['image'],
                                        'name': item['name'],
                                        'type':
                                            'sketch' // Add a type field to distinguish
                                      }),
                                ];

                                return SizedBox(
                                  // height: 500, // Adjust height as needed
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        NeverScrollableScrollPhysics(), // Disable scrolling for smoother integration
                                    itemCount: combinedFavorites.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          2, // Number of items per row
                                      crossAxisSpacing:
                                          8.0, // Horizontal space between items
                                      mainAxisSpacing:
                                          8.0, // Vertical space between items
                                      childAspectRatio:
                                          0.8, // Adjust to control image height and width ratio
                                    ),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final item = combinedFavorites[index];
                                      return Container(
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Card(
                                            color: Colors.white,
                                            elevation: 5,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Expanded(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                    15)),
                                                    child: Image.network(
                                                      "$linkServerName/${item['image']}",
                                                      fit: BoxFit
                                                          .cover, // Ensure the image fits nicely inside the container
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "${item['name']}",
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      backgroundColor:
                                                          Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign
                                                        .center, // Center the text
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                              return SizedBox(
                                  height: 20); // Hide if no sketches
                            },
                          );
                        }
                        return SizedBox(height: 20); // Hide if no designs
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
