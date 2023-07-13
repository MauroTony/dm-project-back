import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dmproject/domain/services/analise.dart';

class AnaliseScreen extends StatefulWidget {
  @override
  _AnaliseScreenState createState() => _AnaliseScreenState();
}
class _AnaliseScreenState extends State<AnaliseScreen> {
  List<dynamic> tableData = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }
  Future<void> fetchData() async {
    try {
      ApiServiceAnalise.getAnaliseLogs().then((data) {
        setState(() {
          print("Analise data: $data");

          if ( data.length == 1 && data[0] == 401) {
            Navigator.pushReplacementNamed(context, '/');
            }
          else {
            tableData = data;
          }
        });
      });
    } catch (e) {
      print('Error: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Analysis'),
      ),
      body: Center(
        child: tableData.isEmpty
            ? CircularProgressIndicator()
            : DataTable(
          columns: [
            DataColumn(label: Text('Card Number')),
            DataColumn(label: Text('Score')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Date')),
          ],
          rows: tableData.map((data) {
            return DataRow(cells: [
              DataCell(Text(data['card_number'])),
              DataCell(Text(data['score'])),
              DataCell(Text(data['status'])),
              DataCell(Text(data['date_request'])),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}