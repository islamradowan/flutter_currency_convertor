import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CurrencyConverterProvider extends ChangeNotifier {
  List<String> currencies = [];
  String fromCurrency = 'USD';
  String toCurrency = 'EUR';
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  Timer? _debounce;
  bool isLoading = false;

  Map<String, double>? cachedRates;

  CurrencyConverterProvider() {
    fromController.text = '0';
    toController.text = '0.0';
    _initializeCurrencies();
  }

  Future<void> _initializeCurrencies() async {
    try {
      final url =
          'https://v6.exchangerate-api.com/v6/2112db05b9acd8126ccf0263/codes';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        currencies = (data['supported_codes'] as List)
            .map((code) => code[0] as String)
            .toList();
      } else {
        throw Exception('Failed to fetch currencies');
      }
    } catch (e) {
      print('Error fetching supported currencies: $e');
      currencies = [
        'USD',
        'EUR',
        'GBP',
        'JPY',
        'INR',
        'BDT',
        'AUD',
        'CAD',
        'CHF',
        'CNY',
        'NZD',
      ]; // Fallback to predefined list
    } finally {
      notifyListeners();
    }
  }

  void updateFromCurrency(String? value) {
    fromCurrency = value!;
    cachedRates = null;
    convertCurrency();
  }

  void updateToCurrency(String? value) {
    toCurrency = value!;
    convertCurrency();
  }

  void onInputChange(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), convertCurrency);
  }

  Future<void> convertCurrency() async {
    if (cachedRates != null) {
      updateConversion();
      return;
    }

    isLoading = true;
    notifyListeners();

    final url =
        'https://v6.exchangerate-api.com/v6/2112db05b9acd8126ccf0263/latest/$fromCurrency';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        cachedRates = (data['conversion_rates'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(key, (value as num).toDouble()),
        );
        updateConversion();
      }
    } catch (e) {
      print('Error fetching rates: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateConversion() {
    final inputAmount = double.tryParse(fromController.text) ?? 0.0;
    final rate = cachedRates?[toCurrency] ?? 0.0;
    toController.text = (inputAmount * rate).toStringAsFixed(2);
    notifyListeners();
  }
}
