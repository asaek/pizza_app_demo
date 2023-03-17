import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pizza_app/drawer_pizza.dart';
import 'package:pizza_app/models/pizza.dart';
import 'package:pizza_app/models/shopping.dart';
import 'package:pizza_app/theme/color_theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pizza App',
      home: HomeWidget(),
    );
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final PageController _pageController = PageController();
  double _page = 0;
  Pizza pizza = Pizza.pizzaList.first;
  final shopping = Shopping();

  void _onListener() {
    setState(() {
      _page = _pageController.page ?? 0;
    });
  }

  @override
  void initState() {
    _pageController.addListener(() {
      // print('Pixeles: ${_pageController.position.pixels}');
      _onListener();
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.removeListener(_onListener);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        width: 120,
        child: PizzaDrawer(
          pizzas: shopping.pizzas,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                // print(constraints.maxHeight);
                // print(constraints.maxWidth);

                final height = constraints.maxHeight;
                final width = constraints.maxWidth;
                final size = width * 0.5;
                final backgroundPosition = -height / 2;

                return Stack(
                  children: [
                    Positioned(
                      top: -height,
                      left: backgroundPosition,
                      right: backgroundPosition,
                      bottom: size / 2,
                      child: const DecoratedBox(
                        decoration: BoxDecoration(
                          color: ColorTheme.pinkLight,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Listener(
                      onPointerUp: (_) {
                        _pageController.animateToPage(
                          _page.round(),
                          duration: const Duration(milliseconds: 2000),
                          curve: Curves.elasticOut,
                        );
                      },
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: Pizza.pizzaList.length,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index) {
                          pizza = Pizza.pizzaList[index];
                        },
                        itemBuilder: (context, index) {
                          final pizza = Pizza.pizzaList[index];
                          final percent = _page - index;
                          final opacity = 1.0 - percent.abs();
                          final vereticaSpace = size / 2;
                          final radius = height - size / 2;
                          final x = radius * sin(percent);
                          final y =
                              radius * cos(percent) - height + vereticaSpace;

                          return Opacity(
                            opacity:
                                opacity < 0.4 ? 0.0 : opacity.clamp(0.0, 1.0),
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..translate(x, y)
                                ..rotateZ(percent),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: CircularPizza(
                                  pizza: pizza,
                                  size: size,
                                  boxShadows: const BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 15,
                                    spreadRadius: 5,
                                    offset: Offset(0, 0),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).viewPadding.top,
                      right: 20,
                      child: IconButton(
                        icon: const Icon(
                          Icons.menu,
                          color: ColorTheme.pinkBlack,
                        ),
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                          print('Se toco el meenu');
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: Column(
              children: [
                _PizzaTitle(
                  pizza: pizza,
                  onTapLeft: () {
                    final pagina = _pageController.page!;
                    // print(pagina);
                    if (pagina <= 0.9) return;
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 1500),
                      curve: Curves.elasticOut,
                    );
                  },
                  onTapRight: () {
                    final pagina = _pageController.page!;
                    // print('Pagina Actual $pagina');
                    // print('Lista de pizzas ${Pizza.pizzaList.length - 1}');
                    if (pagina >= Pizza.pizzaList.length - 1.9) return;

                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 1500),
                      curve: Curves.elasticOut,
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: List.generate(
                              5,
                              (index) => Icon(
                                (index + 1) <= pizza.rating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text('${pizza.reviews} Reviews'),
                      Text(
                        pizza.description,
                        textAlign: TextAlign.justify,
                      ),
                      Row(
                        children: [
                          Text(
                            '\$ ${pizza.price.toStringAsPrecision(2)}',
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              children: List.generate(
                                pizza.components.length,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 10, right: 10),
                                  child: Material(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(5),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        pizza.components[index],
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          MaterialButton(
                            color: Colors.black,
                            onPressed: (() {
                              shopping.add(pizza);
                            }),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.shop,
                                  color: Colors.white,
                                ),
                                Text(
                                  '  Add to cart',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CircularPizza extends StatelessWidget {
  const CircularPizza({
    Key? key,
    required this.pizza,
    required this.size,
    this.padding = EdgeInsets.zero,
    required this.boxShadows,
  }) : super(key: key);

  final Pizza pizza;
  final double size;
  final EdgeInsets padding;
  final BoxShadow boxShadows;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            boxShadows,
          ],
        ),
        child: Padding(
          padding: padding,
          child: Image.asset(
            pizza.asset,
            height: size,
          ),
        ),
      ),
    );
  }
}

class _PizzaTitle extends StatelessWidget {
  const _PizzaTitle({
    required this.pizza,
    required this.onTapLeft,
    required this.onTapRight,
  });

  final Pizza pizza;
  final VoidCallback onTapLeft;
  final VoidCallback onTapRight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            InkWell(
              onTap: () => onTapLeft.call(),
              child: const CircleAvatar(
                backgroundColor: ColorTheme.pinkLight,
                child: Icon(
                  Icons.arrow_back,
                  color: ColorTheme.pinkBlack,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  pizza.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () => onTapRight.call(),
              child: const CircleAvatar(
                backgroundColor: ColorTheme.pinkLight,
                child: Icon(
                  Icons.arrow_forward,
                  color: ColorTheme.pinkBlack,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
