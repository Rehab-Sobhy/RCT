import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/view-model/services/crud.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  final Crud crud = Crud();
  List<String?> termsConditions = [];

  @override
  void initState() {
    super.initState();
    fetchTermsAndConditions();
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: BackButtonAppBar(context),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.center, // Centralize horizontally
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              local.termsConditions,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center, // Center the text
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
                        textAlign: TextAlign.center, // Center the terms text
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

  Future fetchTermsAndConditions() async {
    try {
      final response = await crud.getRequest(linkTerms);
      for (var i = 0; i < response["data"].length; i++) {
        termsConditions.add(response["data"][i]["terms"]);
      }
      setState(() {}); // Refresh UI after data is fetched
    } catch (e) {
      print(e);
    }
  }
}
