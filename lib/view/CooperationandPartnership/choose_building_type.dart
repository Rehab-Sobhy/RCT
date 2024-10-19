import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/common%20copounents/custom_dropdownlist.dart';

import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/constants/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:rct/view-model/cubits/types/types_cubit.dart';
import 'package:rct/view/CooperationandPartnership/OldBuilding.dart';

import 'package:rct/view/CooperationandPartnership/Plans.dart';
import 'package:rct/view/CooperationandPartnership/RawLand.dart';

class ChooseBuildingType extends StatefulWidget {
  const ChooseBuildingType({Key? key}) : super(key: key);

  @override
  State<ChooseBuildingType> createState() => _ChooseBuildingTypeState();
}

class _ChooseBuildingTypeState extends State<ChooseBuildingType> {
  String? _selectedType;
  List<String> itemNames = [
    "أرض خام",
    "مبنى قديم",
    "مخططات",
  ];
  Map<String, Map<String, dynamic>> nameToDetails = {};

  @override
  void initState() {
    super.initState();
    context.read<TypesCubit>().get();
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocalizations.of(context)!;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: BackButtonAppBar(context),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: constVerticalPadding + 10),
              Text(
                local.estateType,
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: constVerticalPadding + 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: grey,
                ),
                child: CustomDropDownList(
                  list: itemNames,
                  selectedValue: _selectedType,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedType = newValue!;
                    });
                  },
                  hint: local.chooseType,
                ),
              ),
              SizedBox(height: 50),
              Center(
                child: MainButton(
                  text: local.next,
                  backGroundColor: primaryColor,
                  onTap: () {
                    if (_selectedType == "أرض خام") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Raw_Screen()));
                    } else if (_selectedType == "مبنى قديم") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Oldbuilding_Screen()));
                    } else if (_selectedType == "مخططات") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PlansScreen()));
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
