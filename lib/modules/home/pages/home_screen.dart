import 'package:flutter/material.dart';

import '../../../dependencies/dependencies.dart';
import '../components/components.dart';
import '../controller/home_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeTemplate(
      controller: injector.get<HomeCubit>(),
    );
  }
}
