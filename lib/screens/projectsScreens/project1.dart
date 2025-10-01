import 'package:flutter/material.dart';

class Project1 extends StatelessWidget {
  const Project1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medcall UI/UX Case Study'),
        backgroundColor: Colors.blueGrey,
      ),
      body: const Center(
        child: Text(
          'Welcome to Project 1 Details Page!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}