// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:rct/view/favorite/real_esttaefavourite.dart';
// import 'package:rct/view/favorite/sketches_favourite.dart';
// import 'package:rct/view/favorite/favorite.dart';

// import 'package:rct/view/home_screen.dart';

// class MainFavourites extends StatefulWidget {
//   const MainFavourites({super.key});

//   @override
//   State<MainFavourites> createState() => _MainFavouritesState();
// }

// class _MainFavouritesState extends State<MainFavourites> {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3, // Number of tabs
//       child: Scaffold(
//         appBar: AppBar(
//           elevation: 0,
//           centerTitle: true,
//           title: Image.asset(
//             "assets/images/header.jpg",
//             fit: BoxFit.contain,
//             height: 50.h,
//             width: 170.w,
//           ),
//           backgroundColor: Colors.white,
//           leading: IconButton(
//             onPressed: () {
//               Navigator.of(context).pushAndRemoveUntil(
//                   MaterialPageRoute(builder: (context) => const HomeScreen()),
//                   (route) => false);
//             },
//             icon: const Icon(
//               Icons.arrow_back_ios_new_sharp,
//               color: Colors.black,
//             ),
//           ),
//           bottom: TabBar(
//             tabs: [
//               Tab(
//                 text: "العروض العقارية",
//               ),
//               Tab(text: 'التصاميم'),
//               Tab(text: " المخططات"),
//             ],
//             labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
//             isScrollable: true,
//             unselectedLabelColor: Colors.grey,
//             labelColor: const Color.fromARGB(201, 62, 33, 90),
//             indicatorColor: const Color.fromARGB(201, 62, 33, 90),
//             unselectedLabelStyle:
//                 TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
//             padding: EdgeInsets.all(3),
//           ),
//         ),
//         body: const TabBarView(children: [
//           RealFavorites(),
//           DesignFavorites(),
//           SketchesFavourite(),
//         ]),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/view/favorite/real_esttaefavourite.dart';
import 'package:rct/view/favorite/sketches_favourite.dart';
import 'package:rct/view/favorite/favorite.dart';

import 'package:rct/view/home_screen.dart';

class MainFavourites extends StatefulWidget {
  const MainFavourites({super.key});

  @override
  State<MainFavourites> createState() => _MainFavouritesState();
}

class _MainFavouritesState extends State<MainFavourites> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Image.asset(
            "assets/images/header.jpg",
            fit: BoxFit.contain,
            height: 50.h,
            width: 170.w,
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_sharp,
              color: Colors.black,
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: "العروض العقارية"),
              Tab(text: 'التصاميم'),
              Tab(text: "المخططات"),
            ],
            labelStyle:
                const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
            unselectedLabelColor: Colors.grey,
            labelColor: primaryColor,
            indicatorColor: primaryColor,
            indicatorSize: TabBarIndicatorSize
                .tab, // Stretch the indicator to the full width of the tab

            unselectedLabelStyle:
                const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            indicatorPadding: const EdgeInsets.symmetric(
                horizontal: 20), // Adds padding to the indicator
            isScrollable: false, // Makes tabs equally spaced
            padding: const EdgeInsets.all(3),
          ),
        ),
        body: const TabBarView(children: [
          RealFavorites(),
          DesignFavorites(),
          SketchesFavourite(),
        ]),
      ),
    );
  }
}
