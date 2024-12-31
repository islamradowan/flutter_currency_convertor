import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/currency_converter_provider.dart';
import 'screens/currency_converter_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CurrencyConverterProvider(),
      child: const CurrencyConverterApp(),
    ),
  );
}

class CurrencyConverterApp extends StatelessWidget {
  const CurrencyConverterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CurrencyConverterScreen(),
    );
  }
}
