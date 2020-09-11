
import 'dart:io';

import 'package:band_names0820/models/band.dart';
import 'package:band_names0820/services/socket_service.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {



  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    // Band(id: '1', name: 'Metallica', votes: 5 ),
    // Band(id: '2', name: 'Megadeath', votes: 3 ),
    // Band(id: '3', name: 'Iron Maiden', votes: 1 ),
    // Band(id: '4', name: 'Korn', votes: 8 ),
  ];

  @override
  void initState() { 

    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('active-bands', _handleActiveBands);
    super.initState();
  }

  _handleActiveBands(dynamic payload){
    this.bands = (payload as List)
        .map((band) => Band.fromMap(band))
        .toList();

      setState(() { });

  }

  @override
  void dispose() {
    // TODO: implement 
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService> (context);


    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Text('Bandas', style: TextStyle(color: Colors.black87, )),
        backgroundColor: Colors.white,
        actions: <Widget> [
          Row(
            children: [
              Text('Server',  style: TextStyle(color: Colors.black),),
              Container(
                margin: EdgeInsets.only(right: 10),  // 
                child: (socketService.serverStatus == ServerStatus.Online)
                ? Icon(Icons.signal_cellular_4_bar, color: Colors.blue)
                : Icon(Icons.signal_cellular_off, color: Colors.red)
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: <Widget>[

          SizedBox(height: 10),

          _showGraf(),
          

          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: ( context, i) => bandTile(bands[i])
            ),
          )
        ]
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 2,
        onPressed: addNewBand,
      ),
   );
  }

  Widget bandTile(Band band) {

    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: ( _ ) => socketService.socket.emit('delete-band', {'id': band.id }),
      background: Container(
        padding: EdgeInsets.only(left: 10.0),
        color: Colors.redAccent,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Text('Delete Band', style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold)),
              SizedBox(width: 10),
              Icon(Icons.delete, color: Colors.white,)
            ],
          ),
        )
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0,3)),
          backgroundColor: Colors.blue[200],
        ),
        title: Text(band.name),
        trailing: Text('${band.votes}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
        onTap: ()=> socketService.socket.emit('vote-band', {'id': band.id }), 
      ),
    );
  }

  addNewBand(){
    /// Para manipular el texto ingresado
    final textController = new TextEditingController();

    if(Platform.isAndroid){
      ///Dialog para Android (si se abre desde un Android)
      return showDialog(
        context: context,
        builder: (_ ) => AlertDialog(
            title: Text('New band name:'),
            content: TextField(
              ///Para manipular el texto del input
              controller: textController,
            ),
            actions:<Widget> [
              MaterialButton(
                child: Text('Add'),
                elevation: 5,
                textColor: Colors.blue,
                onPressed: () => addbandToList(textController.text)
              )
            ],
          ),   
      );
    }

    showCupertinoDialog(
      context: context, 
      builder: (_) =>  CupertinoAlertDialog(
          title: Text('New band name:'),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text('Dismiss'),
              onPressed: () => Navigator.pop(context) ,
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Add'),
              onPressed: () => addbandToList(textController.text) 
            ),
            
          ],
        ),
    );

    
  }

  void addbandToList(String name){
    if(name.length > 1){
      //Podemos agregar 
      ///Emitir el evento : add-band
      ///{name: name}
      final socketService = Provider.of<SocketService>(context, listen: false);

      socketService.socket.emit('add-band', {'name': name});
      
      
    }
    setState(() {  });


    Navigator.pop(context);
  }


  //Mostrar grafico
  Widget _showGraf(){
    
    Map<String, double> dataMap = new Map();
    // dataMap.putIfAbsent('Flutter', () => 5);
    // dataMap.putIfAbsent('React', () => 2);
    // dataMap.putIfAbsent('Xamarin', () => 3);
    // dataMap.putIfAbsent('Angular', () => 1);

    bands.forEach((band) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
     });

    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: PieChart(
        dataMap: dataMap,
        chartType: ChartType.ring,
        animationDuration: Duration(milliseconds: 800),
        chartValuesOptions: ChartValuesOptions(chartValueBackgroundColor: Colors.transparent),
      ),
      width: double.infinity,
      height: 200,

    );
      
  }



}