import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/view-model/cubits/sketches/sketches_state.dart';
import 'package:rct/view/designs%20and%20sketches/sketches_form_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../view-model/cubits/sketches/sketches_cubit.dart';

// ignore: must_be_immutable
class DetailsOfScetches extends StatefulWidget {
  String? productId;

  DetailsOfScetches({super.key, required this.productId});

  @override
  State<DetailsOfScetches> createState() => _DetailsOfScetchesState();
}

class _DetailsOfScetchesState extends State<DetailsOfScetches> {
  int ind = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  dynamic product;

  @override
  Widget build(BuildContext context) {
    var local = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<SketchesCubit, SketchesState>(
        listener: (BuildContext context, state) {
          if (state is SketchesFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errMessage)),
            );
          }
        },
        child: BlocBuilder<SketchesCubit, SketchesState>(
          builder: (BuildContext context, state) {
            if (state is SketchesInitial) {
              return const Center(child: Text('Press button to fetch data'));
            } else if (state is SketchesLoading) {
              return const Center(child: Text(""));
            } else if (state is SketchesSuccess) {
              var data = state.sketches;
              product = data.firstWhere(
                (element) => element["id"].toString() == widget.productId,
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * .55,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        ind = index;
                      },
                      children: [
                        ClipRRect(
                          child: Image.network(
                            product["image1"] != null
                                ? "$linkServerName/${product["image1"]}"
                                : "$linkServerName/${product["image"]}",
                            fit: BoxFit.fill,
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * .40,
                          ),
                        ),
                        ClipRRect(
                          child: Image.network(
                            product["image2"] != null
                                ? "$linkServerName/${product["image2"]}"
                                : "$linkServerName/${product["image"]}",
                            width: double.infinity,
                            fit: BoxFit.fill,
                            height: 400,
                          ),
                        ),
                        ClipRRect(
                          child: Image.network(
                            product["image3"] != null
                                ? "$linkServerName/${product["image3"]}"
                                : "$linkServerName/${product["image"]}",
                            fit: BoxFit.fill,
                            width: double.infinity,
                            height: 400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
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
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "${product['name']}",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      local.discreption,
                      style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "${product["description"]}",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              );
            } else if (state is SketchesFailure) {
              return Center(child: Text('Error: ${state.errMessage}'));
            } else {
              return const Center(child: Text('Unknown state'));
            }
          },
        ),
      ),
      bottomSheet: Container(
        color: const Color.fromARGB(255, 255, 255, 255).withOpacity(.9),
        width: double.infinity,
        alignment: Alignment.bottomLeft,
        height: 66,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SketchForm(id: product["id"]),
              ),
            );
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
                    "${local.completeRequest} + ",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
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
