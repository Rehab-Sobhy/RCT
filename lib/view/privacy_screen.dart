import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
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
  bool isLoading = false;
  final Crud crud = Crud();
  List<String?> termsConditions = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPrivacys();
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButtonAppBar(context),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Center(
          child: Column(
            children: [
              Text(
                local.privacyPolicy,
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

  Future fetchPrivacys() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await crud.getRequest(linkConditions);
      for (var i = 0; i < response["data"].length; i++) {
        termsConditions.add(response["data"][i]["condition"]);
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
