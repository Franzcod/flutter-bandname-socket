import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:band_names0820/services/socket_service.dart';



class StatusPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService> (context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            Text(' ${socketService.serverStatus}', style: TextStyle(fontSize: 20),),
          ],
        ),
     ),
     floatingActionButton: FloatingActionButton(
       child: Icon(Icons.message),
       onPressed: (){
         // TAREA
         //Emitir :
         //{nombre: 'Flutter', mensaje: 'Hola desde Flutter'}
        socketService.emit('emitir-mensaje', {
          'nombre': 'Flutter', 
          'mensaje': 'Hola desde Flutter'
        });
        
       }
       ),
   );
  }
}