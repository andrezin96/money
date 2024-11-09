import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/models.dart';

class HomeTile extends StatelessWidget {
  const HomeTile({
    super.key,
    required this.description,
    required this.value,
    required this.date,
    required this.type,
    this.onTap,
    this.onLongPress,
  });

  final String description;
  final String value;
  final DateTime date;
  final ValueType type;
  final void Function()? onTap;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            description,
          ),
          Text(
            DateFormat("dd MMM", 'pt_br').format(date).replaceAll('.', ''),
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
      subtitle: Text(value),
      leading: Icon(
        Icons.paid_outlined,
        color: type == ValueType.credit ? Colors.green : Colors.red,
      ),
      subtitleTextStyle: const TextStyle(color: Colors.white70),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
