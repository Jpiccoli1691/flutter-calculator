import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jonathan Piccoli Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '';
  bool _isOpenBracket = true;

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _clear();
      } else if (value == '=') {
        _calculateResult();
      } else if (value == 'x²') {
        _expression += '^2';
      } else if (value == '()') {
        _expression += _isOpenBracket ? '(' : ')';
        _isOpenBracket = !_isOpenBracket;
      } else if (value == '+/-') {
        _toggleSign();
      } else {
        _expression += value;
      }
    });
  }

  void _toggleSign() {
    if (_expression.isNotEmpty) {
      if (_expression.startsWith('-')) {
        _expression = _expression.substring(1);
      } else {
        _expression = '-$_expression';
      }
    }
  }

  void _calculateResult() {
    try {
      String finalExpression = _expression.replaceAll('^2', '**2');
      final expression = Expression.parse(finalExpression);
      final evaluator = const ExpressionEvaluator();
      final result = evaluator.eval(expression, {
        'pow': pow,
      });
      setState(() {
        _result = result.toString();
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  void _clear() {
    setState(() {
      _expression = '';
      _result = '';
      _isOpenBracket = true; // Reset bracket state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jonathan Piccoli'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        color: Colors.black87,
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _expression,
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    Text(
                      _result,
                      style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        _buildButton('C'),
                        _buildButton('()'),
                        _buildButton('%'),
                        _buildButton('/'),
                      ],
                    ),
                    Row(
                      children: [
                        _buildButton('7'),
                        _buildButton('8'),
                        _buildButton('9'),
                        _buildButton('*'),
                      ],
                    ),
                    Row(
                      children: [
                        _buildButton('4'),
                        _buildButton('5'),
                        _buildButton('6'),
                        _buildButton('-'),
                      ],
                    ),
                    Row(
                      children: [
                        _buildButton('1'),
                        _buildButton('2'),
                        _buildButton('3'),
                        _buildButton('+'),
                      ],
                    ),
                    Row(
                      children: [
                        _buildButton('+/-'),
                        _buildButton('0'),
                        _buildButton('.'),
                        _buildButton('='),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String value) {
    final isOperator =
        value == '/' || value == '*' || value == '-' || value == '+' || value == '%' || value == 'x²';
    final isEquals = value == '=';
    final isClear = value == 'C';
    return Expanded(
      child: ElevatedButton(
        onPressed: () => _onButtonPressed(value),
        style: ElevatedButton.styleFrom(
          backgroundColor: isEquals ? Colors.green : Colors.grey[800], // Button background color
          foregroundColor: Colors.white, // Button text color
          shape: const CircleBorder(), // Circular button shape
          padding: const EdgeInsets.all(24.0),
        ),
        child: Text(
          value,
          style: TextStyle(
            fontSize: 24,
            color: isClear ? Colors.orange : (isOperator ? Colors.green : Colors.white), // Text color
          ),
        ),
      ),
    );
  }
}