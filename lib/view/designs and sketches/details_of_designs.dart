import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rct/constants/linkapi.dart';
import 'package:rct/view-model/cubits/designs/designs_cubit.dart';
import 'package:rct/view-model/cubits/designs/designs_state.dart';
import 'package:rct/view/designs%20and%20sketches/designs_form_screen.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class ShowDetailsOfDesignsScreen extends StatefulWidget {
  String? productId;

  ShowDetailsOfDesignsScreen({super.key, required this.productId});

  @override
  State<ShowDetailsOfDesignsScreen> createState() =>
      _ShowDetailsOfDesignsScreenState();
}

class _ShowDetailsOfDesignsScreenState
    extends State<ShowDetailsOfDesignsScreen> {
  dynamic product;
  int ind = 0;
  final PageController _pageController = PageController();

  // ignore: annotate_overrides
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<DesignsCubit, DesignsState>(
          listener: (BuildContext context, state) {
        if (state is DesignsFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errMessage)),
          );
          // print(state.message);
        }
      }, child: BlocBuilder<DesignsCubit, DesignsState>(
              builder: (BuildContext context, state) {
        if (state is DesignsInitial) {
          return const Center(child: Text('Press button to fetch data'));
        } else if (state is DesignsLoading) {
          return const Center(child: Text(""));
        } else if (state is DesignsSuccess) {
          var data = state.designs;

          product = data.firstWhere(
            (element) => element["id"].toString() == widget.productId,

            // orElse: () => Modelget(id: ''),
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .55,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      ind = index;
                    });
                  },
                  children: [
                    ClipRRect(
                      child: Image.network(
                        product["image1"] != null
                            ? "$linkServerName/${product["image1"]}"
                            : "$linkServerName/${product["image"]}",
                        fit: BoxFit.fill,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.40,
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
                            : "$linkServerName/${product["image"]}", // Placeholder or default image

                        fit: BoxFit.fill,
                        width: double.infinity,
                        height: 400,
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
                  "${product['name']}",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w900),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  local.discreption,
                  style: TextStyle(
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
        } else if (state is DesignsFailure) {
          return Center(
              child: Center(child: Text('Error: ${state.errMessage}')));
        } else {
          return const Center(child: Text('Unknown state'));
        }
      })),
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
                    builder: (context) => DesignsForm(id: product["id"])));
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
