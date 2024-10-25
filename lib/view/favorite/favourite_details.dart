import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class FavoritesDetails extends StatefulWidget {
  String? description;
  dynamic image;
  String? name;

  FavoritesDetails({
    super.key,
    required this.description,
    required this.image,
    required this.name,
  });

  @override
  State<FavoritesDetails> createState() => _FavoritesDetailsState();
}

class _FavoritesDetailsState extends State<FavoritesDetails> {
  dynamic product;
  int ind = 0;
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
      body: Column(
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
                  borderRadius: BorderRadius.circular(40),
                  child: Image.network(
                    widget.image ?? 'https://via.placeholder.com/150',
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * .40,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              widget.name ?? "name",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "الوصف",
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
              widget.description ?? "Details",
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                decoration: TextDecoration.underline,
                decorationColor: Colors.black,
                decorationThickness: .5,
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
