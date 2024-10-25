import 'package:flutter/material.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/view-model/services/crud.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  final Crud crud = Crud();
  List<String?> aboutUsList = [];

  @override
  void initState() {
    super.initState();
    fetchAboutUs();
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButtonAppBar(context),
      body: Center(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.center, // Centralize horizontally
          children: [
            Text(
              local.aboutUs,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: constVerticalPadding),
            Expanded(
              child: ListView.builder(
                itemCount: aboutUsList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        aboutUsList[index]!,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                        textAlign:
                            TextAlign.center, // Center text within the widget
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future fetchAboutUs() async {
    try {
      final response = await crud.getRequest(linkaboutUs);
      for (var i = 0; i < response.length; i++) {
        aboutUsList.add(response[i]["description"]);
      }
      setState(() {}); // Refresh UI after fetching data
    } catch (e) {
      print(e);
    }
  }
}
