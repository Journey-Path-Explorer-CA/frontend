import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
    Widget build(BuildContext context) {
      final TextEditingController _userController = TextEditingController();
      final TextEditingController _passController = TextEditingController();

      return Scaffold(
        appBar: AppBar(
          title: Text('Journey Path Explorer'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Login',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _userController,
                  decoration: InputDecoration(
                    labelText: 'Usuario',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _passController,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor:  Colors.white,
                  ),
                  onPressed: () {
                    // Aquí puedes agregar la lógica de autenticación
                    if (_userController.text == 'admin' && _passController.text == 'admin') {
                      Navigator.pushNamed(context, '/home');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Usuario o contraseña incorrectos')),
                      );
                    }
                  },
                  child: Text('Iniciar sesión'),
                ),
              ],
            ),
          ),
        ),
      );
    }
}

