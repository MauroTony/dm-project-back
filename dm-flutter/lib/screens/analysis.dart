import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dmproject/domain/services/analise.dart';
import 'package:dmproject/domain/services/login.dart';

class AnaliseScreen extends StatefulWidget {
  @override
  _AnaliseScreenState createState() => _AnaliseScreenState();
}
class _AnaliseScreenState extends State<AnaliseScreen> {
  List<dynamic> tableData = [];
  String? status_analise = '';
  @override
  void initState() {
    super.initState();
    fetchData();
  }
  Future<void> fetchData() async {
    try {
      ApiServiceAnalise.getAnaliseLogs().then((data) {
        setState(() {

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
    try {
      ApiServiceAnalise.getAnalise().then((data) {
        setState(() {
          print(data);
          if ( data["analise"] == 404) {
            status_analise = "Sem Analise Pendente";
          }
          else if ( data["analise"] == 401) {
            Navigator.pushReplacementNamed(context, '/');
          }
          else {
            status_analise = "Status: ${data["status"]} - Score: ${data["score"]}";
          }
        });
      });
    } catch (e) {
      print('Error: $e');
    }
  }
  Future<void> solicitaAnalise() async {
    try {
      ApiServiceAnalise.createAnalise().then((data) {
        setState(() {
          if ( data == 401) {
            Navigator.pushReplacementNamed(context, '/');
          }
          else if ( data == 201) {
            Navigator.pushReplacementNamed(context, '/analysis');
          }
          else if ( data == 400) {
            Navigator.pushReplacementNamed(context, '/analysis');
          }
          if ( data == 404) {
            Navigator.pushReplacementNamed(context, '/card');
          }
          else {
            Navigator.pushReplacementNamed(context, '/');
          }
        });
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> deletaAnalise() async {
    try {
      ApiServiceAnalise.deleteAnalise().then((data) {
        setState(() {
          if ( data == 401) {
            print("401");
            Navigator.pushReplacementNamed(context, '/');
          }
          else if ( data == 200) {
            print("200");
            Navigator.pushReplacementNamed(context, '/analysis');
          }
          else if ( data == 400) {
            print("400");
            Navigator.pushReplacementNamed(context, '/analysis');
          }
          if ( data == 404) {
            print("404");
            Navigator.pushReplacementNamed(context, '/card');
          }
          else {
            print("Delete Analise");
            Navigator.pushReplacementNamed(context, '/');
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
        title: Text('User Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Navigator.pushNamed(context, '/user');
            },
          ),
          IconButton(
            icon: Icon(Icons.credit_card),
            onPressed: () {
              Navigator.pushNamed(context, '/card');
            },
          ),
          IconButton(
            icon: Icon(Icons.analytics),
            onPressed: () {
              Navigator.pushNamed(context, '/analysis');
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              ApiServiceAuth.logout().then((data) {
                Navigator.pushReplacementNamed(context, '/');
              });
            },
          ),
        ],
      ),
      body: Center(
          child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Center(
                child: Container(
                  width: 300.0,
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Solicitação de Analise:'),
                      SizedBox(height: 20.0),
                      Text(status_analise!),
                      SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                  [
                    ElevatedButton(
                      onPressed: () {
                        solicitaAnalise();
                      },
                      child: Text('Solicitar Analise'),
                    ),
                    SizedBox(width: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        deletaAnalise();
                      },
                      child: Text('Cancelar Analise'),
                    ),
                  ]
              ),
              Center(
                  child: Container(
                      width: 200,
                      height: 50,
                      child: Center(
                        child: Text(
                          'Analysis Logs',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  tableData.isEmpty
                  ? Center(
                      child: Container(
                      width: 100,
                      height: 50,
                      child: Center(
                        child: Text(
                          'No data',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  )
                  : Center(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        child: DataTable(
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
                    ),
                  ]
              ),
          ),
      ),
      );
   }
}
