import 'package:flutter/material.dart';
import 'package:pizza_app/main.dart';
import 'package:pizza_app/models/pizza.dart';
import 'package:pizza_app/theme/color_theme.dart';

class PizzaDrawer extends StatelessWidget {
  const PizzaDrawer({
    super.key,
    required this.pizzas,
  });
  final List<Pizza> pizzas;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: ColorTheme.pink),
      child: ListView.builder(
        itemCount: pizzas.length,
        itemBuilder: (context, index) {
          return CircularPizza(
            pizza: pizzas[index],
            size: 80,
            boxShadows: const BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              spreadRadius: 2,
              offset: Offset(0, 0),
            ),
          );
        },
      ),
    );
  }
}
