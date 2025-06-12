import 'package:JanggelIn/models/control.dart';
import 'package:flutter/material.dart';

class AktuatorStatus extends StatelessWidget {
  final Future<Control> controlAsync;


  const AktuatorStatus({
    super.key,
    required this.controlAsync,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controlAsync, 
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return CircularProgressIndicator();
        }else if(snapshot.hasError){
          return Text(snapshot.error.toString());
        }else if(snapshot.hasData == false){
          return Text('Data Aktuator Tidak Ditemukan');
        }

        final control = snapshot.data!;
        final bool isOn = control.status == 'ON';

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              control.device?.name ?? 'Unknown',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            ElevatedButton.icon(
              onPressed: null,
              icon: Icon(isOn ? Icons.power : Icons.power_off),
              label: Text(isOn ? 'ON' : 'OFF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isOn ? Colors.green : Colors.grey,
                foregroundColor: Colors.white,
                disabledBackgroundColor: isOn ? Colors.green : Colors.grey,
                disabledForegroundColor: Colors.white,
              ),
            ),
          ],
        );
      }
    );
  }
}
