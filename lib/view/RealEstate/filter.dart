import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/view/RealEstate/real_estate_cubit.dart';
import 'package:rct/view/RealEstate/states.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String? selectedCity;
  TextEditingController distrectnameController = TextEditingController();
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
  final List<int> priceOptions = [
    500000,
    1000000,
    2000000,
    3000000,
    4000000,
    5000000,
    6000000,
    7000000,
    8000000,
    9000000
  ];
  int selectedPriceIndex = 0;

  @override
  Widget build(BuildContext context) {
    var local = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
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
              Text(local.city,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedCity,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  border: const OutlineInputBorder(),
                  hintText: local.chooseCity,
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                items: _cities.map((String city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.black)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCity = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),
              Text(local.district,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: distrectnameController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  hintText: local.enterDistrict,
                  hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Text(local.price),
              Slider(
                value: selectedPriceIndex.toDouble(),
                min: 0,
                max: (priceOptions.length - 1).toDouble(),
                divisions: priceOptions.length - 1,
                label: priceOptions[selectedPriceIndex].toString(),
                onChanged: (double value) {
                  setState(() {
                    selectedPriceIndex = value.round();
                  });
                },
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MainButton(
                    width: 150,
                    text: local.refilter,
                    backGroundColor: primaryColor,
                    onTap: () {
                      if (selectedCity != null &&
                          distrectnameController.text.isNotEmpty) {
                        int selectedPrice = priceOptions[selectedPriceIndex];

                        context.read<DataCubit>().filterData(
                              city: selectedCity!,
                              district: distrectnameController.text,
                              // maxPrice: selectedPrice,
                            );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("fill all fields")),
                        );
                      }
                    },
                  ),
                  MainButton(
                    width: 150,
                    text: local.cancel,
                    backGroundColor: grey,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              BlocListener<DataCubit, DataState>(
                listener: (context, state) {
                  if (state is FilterSuccessState) {
                    Navigator.pop(context);
                  } else if (state is DataError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
