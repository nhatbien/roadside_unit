import 'package:flutter/material.dart';

class OrderIconStatusOrder extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final Color? color;
  const OrderIconStatusOrder({Key? key, this.text, this.icon, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: color!.withOpacity(0.2)),
          child: Icon(
            icon,
            color: color,
            size: 30.0,
          ),
        ),
        const SizedBox(width: 10.0),
        Text(text!,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .merge(TextStyle(color: color)))
      ],
    );
  }
}
