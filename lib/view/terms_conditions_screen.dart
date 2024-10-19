import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
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
  bool isLoading = false;
  final Crud crud = Crud();
  List<String?> termsConditions = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTermsAndConditions();
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: BackButtonAppBar(context),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                local.termsConditions,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: constVerticalPadding),
              Expanded(
                child: ListView.builder(
                  itemCount: termsConditions.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        termsConditions[index]!,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future fetchTermsAndConditions() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await crud.getRequest(linkTerms);
      for (var i = 0; i < response["data"].length; i++) {
        termsConditions.add(response["data"][i]["terms"]);
      }
      print(termsConditions);
    } catch (e) {
      print(e);
    }
    // Fetch terms and conditions
    setState(() {
      isLoading = false;
    });
  }
}
