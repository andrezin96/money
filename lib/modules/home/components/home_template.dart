import 'package:flutter/material.dart';

import '../controller/home_cubit.dart';

class HomeTemplate extends StatelessWidget {
  const HomeTemplate({
    super.key,
    required this.controller,
  });

  final HomeCubit controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mmoney'),
      ),
      body: ListView(
        children: const [
          Text('Saldo'),
        ],
      ),
    );
  }
}
