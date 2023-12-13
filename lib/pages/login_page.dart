import 'package:consugez_inventario/providers/auth/auth_provider.dart';
import 'package:consugez_inventario/shared/login/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerWidget {
  LoginPage({super.key});

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  // sign user in method
  void signUserIn() {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final authService = Provider.of<AuthService>( context );

    void showSnackbar(BuildContext context, String message) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              // logo
              Container(
                child: Image.network(
                    'https://res.cloudinary.com/dfha4roeg/image/upload/v1699851938/logo_txriz6.png'),
                width: 300,
                height: 300,
              ),

              const SizedBox(height: 50),

              // welcome back, you've been missed!
              Text(
                'Bienvenido Identificate!',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),

              // username textfield
              MyTextField(
                controller: usernameController,
                hintText: 'Usuario',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              // password textfield
              MyTextField(
                controller: passwordController,
                hintText: 'Contraseña',
                obscureText: true,
              ),

              const SizedBox(height: 10),

              // forgot password?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
              ),

              const SizedBox(height: 25),
              ElevatedButton.icon(
                onPressed: ref.watch(authProvider).autenticando
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();

                        final loginOk =
                            await ref.read(authProvider.notifier).login(
                                  usernameController.text.trim(),
                                  passwordController.text.trim(),
                                );

                        if (loginOk) {
                          // TODO: Cambiar a mi main page
                          context.go('/home');
                        } else {
                          // Mostrar alerta
                          showSnackbar(context, "Error al iniciar sesión");
                        }
                      },
                icon: Icon(Icons.key),
                label: Text('Iniciar Sesion'),
              ),

              // sign in button

              const SizedBox(height: 50),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        '',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              const SizedBox(height: 50),

              // not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No eres miembro?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Contactate con el Administrador',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
