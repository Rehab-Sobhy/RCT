import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rct/view/calculations%20and%20projects/percentsmodel.dart';

class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
// Global variables to store the values
  List<PercentageData> globalPercentageData = [];

  Future<void> fetchPercentageData() async {
    try {
      Dio dio = Dio();
      final response =
          await dio.get('https://rctapp.com/api/residentialbuilding');

      // Parse the data and store it in the global variables
      List<dynamic> data = response.data;
      globalPercentageData =
          data.map((json) => PercentageData.fromJson(json)).toList();

      // You can now access the data globally in the screen
      print(globalPercentageData);
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    // Fetch the data when the screen is initialized
    fetchPercentageData().then((_) {
      setState(() {
        // Update UI once data is fetched
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Percentage Data")),
      body: globalPercentageData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: globalPercentageData.length,
              itemBuilder: (context, index) {
                PercentageData data = globalPercentageData[index];
                return ListTile(
                  title: Text('ID: ${data.id}'),
                  subtitle: Text(
                    'First Percentage: ${data.firstPercentage}, '
                    'Second Percentage: ${data.secondPercentage}, '
                    'Last Percentage: ${data.lastPercentage}',
                  ),
                );
              },
            ),
    );
  }
}
