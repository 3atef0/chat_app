import 'package:chat_app/cubits/register_cubit/register_cubit.dart';
import 'package:chat_app/cubits/register_cubit/register_states.dart';
import 'package:chat_app/features/authentications/login_screen.dart';
import 'package:chat_app/features/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Register Success")));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(),
              settings: RouteSettings(arguments: emailController.text.trim()),
            ),
          );
        } else if (state is RegisterError) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error Occured : ${state.error}")));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
              child: Container(
            padding: EdgeInsets.all(10),
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "REGISTER",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  Text("Please enter details to register"),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter your email ';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.mail_outline_outlined,
                        ),
                        labelText: "Email Address",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter your password';
                      }
                      if (value.length < 6) {
                        return 'The password should more than 6';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock_outline,
                        ),
                        labelText: "Password",
                        suffixIcon: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.remove_red_eye_outlined)),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  state is RegisterLoading
                      ? Center(child: CircularProgressIndicator())
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                        ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            BlocProvider.of<RegisterCubit>(context).register(
                                emailController.text, passwordController.text);
                          }
                        },
                        child: Text(
                          "REGISTER",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          child: Text(
                            "LOGIN",
                            style: TextStyle(color: Colors.blue),
                          ))
                    ],
                  )
                ],
              ),
            ),
          )),
        );
      },
    );
  }
}
