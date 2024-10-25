import 'package:flutter/material.dart';

import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/view/RealEstate/final_offers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rct/view/RealEstate/real_estate_cubit.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

final List<String> _cities = [
  'الرياض',
  'جده',
  'المدينه المنوره',
  'تبوك',
  'الدمام',
  'الاحساء',
  'القطيف',
  'خميس مشيط',
  'المظيلف',
  'الهفوف',
  'المبرز',
  'الطائف',
  'نجران',
  'حفر الباطن',
  'الجبيل',
  'ضباء',
  'الخرج',
  'الثقبة',
  'ينبع البحر',
  'الخبر',
  'عرعر',
  'الحوية',
  'عنيزه',
  'سكاكا',
  'جيزان',
  'القريات',
  'الظهران',
  'الباحة',
  'الزلفي',
  'الرس',
  'وادى الدواسر',
  'بيشه',
  'سيهات',
  'شروره',
  'بحره',
  'تاروت',
  'الدوادمى',
  'صبياء',
  'بيش',
  'احد رفيدة',
  'الفريش',
  'بارق',
  'الحوطه',
  'الافلاج'
];

class _FilterScreenState extends State<FilterScreen> {
  String? selectedCity;
  String? selectedDistrict;
  TextEditingController distrectnameController = TextEditingController();
  double initialPrice = 50;

  @override
  Widget build(BuildContext context) {
    var local = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          local.filter,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_sharp,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              Text(
                local.city,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                dropdownColor: Colors.white,
                value: selectedCity,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    border: const OutlineInputBorder(),
                    hintText: local.chooseCity,
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12)),
                items: _cities.map((String city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(
                      city,
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCity = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),
              Text(
                local.district,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: distrectnameController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  hintText: local.enterDistrict,
                  hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Slider
              Text(local.price),
              Slider(
                value: initialPrice,
                min: 50,
                divisions: 1000,
                max: 1000000,
                label: initialPrice.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    initialPrice = value;
                  });
                },
              ),
              const SizedBox(height: 32),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MainButton(
                    width: 150,
                    text: local.refilter,
                    backGroundColor: primaryColor,
                    onTap: () {
                      // Debugging the filter call
                      print("Selected City: $selectedCity");
                      print("District Name: ${distrectnameController.text}");

                      // Trigger filtering
                      DataCubit.get(context).FilteredData(
                        city: selectedCity ?? '',
                        district: distrectnameController.text,
                      );

                      // Navigate back (ensure this is correct behavior)
                      Navigator.pop(context);
                    },
                  ),
                  MainButton(
                      width: 150,
                      text: local.cancel,
                      backGroundColor: grey,
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const FinalOffers(url: linkHouses)));
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
