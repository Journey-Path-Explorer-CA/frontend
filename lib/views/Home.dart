import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journey Path Connect'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      drawer: Drawer(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text('Menu', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 20),
            MaterialButton(
              onPressed: () {},
                child: Row(
                  children: [
                    Icon(Icons.home, size: 28),
                    SizedBox(width: 10),
                    Text('Home', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  ],
                )
            ),
            SizedBox(height: 650),

            Divider(thickness: 2),
            SizedBox(height: 20),
            MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Row(
                children: [
                  Icon(Icons.logout, size: 28),
                  SizedBox(width: 10),
                  Text('Cerrar Sesion', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );


  }
}
