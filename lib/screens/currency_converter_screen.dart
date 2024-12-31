import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/currency_converter_provider.dart';
import '../widgets/currency_dropdown.dart';
import '../widgets/input_field.dart';
import '../widgets/convert_button.dart';

class CurrencyConverterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Consumer<CurrencyConverterProvider>(
          builder: (context, provider, _) {
            return provider.currencies.isEmpty
                ? const CircularProgressIndicator()
                : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: 320,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.currency_exchange,
                      color: Colors.white,
                      size: 50,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Converter',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CurrencyDropdown(
                          value: provider.fromCurrency,
                          onChanged: provider.updateFromCurrency,
                          currencies: provider.currencies,
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.swap_horiz,
                            color: Colors.white, size: 30),
                        const SizedBox(width: 10),
                        CurrencyDropdown(
                          value: provider.toCurrency,
                          onChanged: provider.updateToCurrency,
                          currencies: provider.currencies,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    InputField(
                      label: 'From',
                      controller: provider.fromController,
                      onChanged: provider.onInputChange,
                    ),
                    const SizedBox(height: 20),
                    InputField(
                      label: 'To',
                      controller: provider.toController,
                      isEditable: false,
                    ),
                    const SizedBox(height: 20),
                    ConvertButton(
                      isLoading: provider.isLoading,
                      onPressed: provider.convertCurrency,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
