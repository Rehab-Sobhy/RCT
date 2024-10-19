import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
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
  bool isLoading = false;
  final Crud crud = Crud();
  List<String?> aboutUsList = [];
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
      backgroundColor: Colors.white,
      appBar: BackButtonAppBar(context),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Center(
          child: Column(
            children: [
              Text(
                local.aboutUs,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: constVerticalPadding),
              Expanded(
                child: ListView.builder(
                  itemCount: aboutUsList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        aboutUsList[index]!,
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
      final response = await crud.getRequest(linkaboutUs);
      for (var i = 0; i < response.length; i++) {
        aboutUsList.add(response[i]["description"]);
      }
      print(aboutUsList);
    } catch (e) {
      print(e);
    }
    // Fetch terms and conditions
    setState(() {
      isLoading = false;
    });
  }
}
