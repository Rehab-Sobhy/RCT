import 'package:flutter/material.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/view-model/services/crud.dart';

class PrivacysScreen extends StatefulWidget {
  static String id = "PrivacysScreen";
  const PrivacysScreen({super.key});

  @override
  State<PrivacysScreen> createState() => _PrivacysScreenState();
}

class _PrivacysScreenState extends State<PrivacysScreen> {
  final Crud crud = Crud();
  List<String?> termsConditions = [];

  @override
  void initState() {
    super.initState();
    fetchPrivacys();
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
              local.privacyPolicy,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: constVerticalPadding),
            Expanded(
              child: ListView.builder(
                itemCount: termsConditions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        termsConditions[index]!,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                        textAlign: TextAlign
                            .center, // Center the text within the widget
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

  Future fetchPrivacys() async {
    try {
      final response = await crud.getRequest(linkConditions);
      for (var i = 0; i < response["data"].length; i++) {
        termsConditions.add(response["data"][i]["condition"]);
      }
      setState(() {}); // Refresh UI after data is fetched
    } catch (e) {
      print(e);
    }
  }
}
