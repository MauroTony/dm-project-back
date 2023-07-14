import 'package:flutter/material.dart';
import 'package:dmproject/domain/services/card.dart';
import 'package:dmproject/domain/services/analise.dart';
import 'package:dmproject/domain/services/login.dart';

class ScreenCard extends StatefulWidget {
  @override
  _ScreenCardState createState() => _ScreenCardState();
}
class _ScreenCardState extends State<ScreenCard> {
  late Map<String, dynamic> cardData;
  late int CardNotFound = 0;
  late int AnaliseNotFound = 0;
  @override
  void initState() {
    cardData = {};
    super.initState();
    getCard();
  }
  Future<void> getCard() async {
    ApiServiceCard.getCardData().then((data) {
      setState(() {
        cardData = data;
        print("Card data: $cardData");
        if (cardData['card'] == 404) {
          CardNotFound = cardData['card'];
        }
        else if (cardData['card'] == 401) {
          Navigator.pushReplacementNamed(context, '/');
        }else{
          ApiServiceAnalise.getAnalise().then((data) {
            setState(() {
              AnaliseNotFound = data['analise'];
              print("Analise data: $cardData");
            });
          });
        }
      });
    }).catchError((error) {
      print('Error: $error');
    });
  }
  Future<void> deleteCard() async {
    ApiServiceCard.deleteCard().then((data) {
      setState(() {
        if (data == 200) {
          Navigator.pushReplacementNamed(context, '/card');
        }
        else if (data == 401) {
          Navigator.pushReplacementNamed(context, '/');
        }
        else if (data == 400) {
          AlertDialog(
            title: Text('Error'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('card is pending processing'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
      });
    }).catchError((error) {
      print('Error: $error');
    });
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
      body: CardNotFound != 404
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
            width: 340.0,
            height: 180,
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(15.0),
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

              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(top: 10),
                  child:
                  Text(
                      '${cardData['number']}',
                      style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(top: 60),
                    alignment: Alignment.bottomLeft,
                    child:
                      Text(
                          '${cardData['name']}',
                          style: TextStyle(
                            fontSize: 17.0,
                          )
                      ),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.only(top: 10),
                  child: Text(AnaliseNotFound != 404 ? 'Credit: ${cardData['credito']}' : "Credit: Request an analysis" ),
                ),

              ],
            ),
        ),
         ElevatedButton(
           style: ButtonStyle(
             backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
             padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),

           ),
          onPressed: deleteCard,
          child: Text('Delete Card'),
        ),
        ],
        ),
      )
          : Center(
        child: Container(
          padding: EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Nenhum cartão encontrado',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ApiServiceCard.createCardData().then((data) {
                    setState(() {
                      if (data == 201) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ScreenCard()),
                        );
                      } else if (data == 401) {
                        Navigator.pushReplacementNamed(context, '/');
                      }
                    });
                  }).catchError((error) {
                    print('Error: $error');
                  });
                },
                child: Text('Solicitar Cartão'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}