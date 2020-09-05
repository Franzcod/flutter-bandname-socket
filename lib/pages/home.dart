
import 'dart:io';

import 'package:band_names0820/models/band.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {



  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 5 ),
    Band(id: '2', name: 'Megadeath', votes: 3 ),
    Band(id: '3', name: 'Iron Maiden', votes: 1 ),
    Band(id: '4', name: 'Korn', votes: 8 ),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Text('Bandas', style: TextStyle(color: Colors.black87, )),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: ( context, i) => bandTile(bands[i])
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 2,
        onPressed: addNewBand,
      ),
   );
  }

  Widget bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction){
        print('direction: $direction' );
        //TODO: llamar el borrado en el server
      },
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
        trailing: Text('${band.votes}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        onTap: (){
          print(band.name + ' ' + '${band.votes}');
        }, 
      ),
    );
  }

  addNewBand(){
    /// Para manipular el texto ingresado
    final textController = new TextEditingController();

    if(!Platform.isAndroid){
      ///Dialog para Android (si se abre desde un Android)
      return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
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
          ) ;
        }  
      );
    }

    showCupertinoDialog(
      context: context, 
      builder: (_){
        return CupertinoAlertDialog(
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
        );
      }
    );

    
  }

  void addbandToList(String name){
    print(name);
    if(name.length > 1){
      //Podemos agregar el texto
      /// Crear una nueva banda con la clase Band (se agrega a la lista)
      this.bands.add(new Band(id: DateTime.now().toString(), name: name, votes: 0));
    }
    setState(() {  });


    Navigator.pop(context);
  }





}