import 'package:flutter/material.dart';

const _background = Color(0xFF17181A);
const _key = Color(0xFF303136);
const _utility = Color(0xFF616161);
const _blue = Color(0xFF109DFF);
const _blueDark = Color(0xFF005DB2);
const _textBlue = Color(0xFF29A8FF);

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _expression = '';
  String _preview = '0';
  String _answer = '';
  bool _justEvaluated = false;

  void _press(String value) {
    setState(() {
      if (value == 'AC') {
        _expression = '';
        _preview = '0';
        _answer = '';
        _justEvaluated = false;
        return;
      }
      if (value == '⌫') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
        _justEvaluated = false;
        _updatePreview();
        return;
      }
      if (value == '=') {
        if (_expression.isEmpty) return;
        try {
          final result = _ExpressionParser(_expression).parse();
          _answer = _format(result);
          _preview = _answer;
          _justEvaluated = true;
        } on FormatException {
          _answer = 'Invalid expression';
        } on Exception {
          _answer = 'Cannot divide by zero';
        }
        return;
      }
      if (_justEvaluated && RegExp(r'^[0-9.]$').hasMatch(value)) {
        _expression = '';
      }
      _justEvaluated = false;
      if (value == '±') {
        if (_expression.startsWith('-')) {
          _expression = _expression.substring(1);
        } else if (_expression.isNotEmpty) {
          _expression = '-($_expression)';
        }
      } else if (value == '%') {
        _expression += '/100';
      } else {
        _expression += value;
      }
      _answer = '';
      _updatePreview();
    });
  }

  void _updatePreview() {
    if (_expression.isEmpty) {
      _preview = '0';
      return;
    }
    try {
      _preview = _format(_ExpressionParser(_expression).parse());
    } catch (_) {
      _preview = '';
    }
  }

  String _format(double value) {
    if (!value.isFinite) throw const FormatException('Not finite');
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsPrecision(10).replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxHeight < 700;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: _key,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.calculate_outlined, color: _blue),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Calculator', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                                SizedBox(height: 2),
                                Text('Simple • Smart • Precise', style: TextStyle(fontSize: 11, color: Colors.white54)),
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: 'Clear calculator',
                            onPressed: () => _press('AC'),
                            icon: const Icon(Icons.restart_alt_rounded, color: Colors.white70),
                          ),
                        ],
                      ),
                      SizedBox(height: compact ? 12 : 28),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(8, 18, 8, 10),
                          alignment: Alignment.bottomRight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                reverse: true,
                                child: Text(
                                  _expression.isEmpty ? ' ' : _prettyExpression(_expression),
                                  maxLines: 1,
                                  style: const TextStyle(fontSize: 22, color: Color(0xFF818181), fontWeight: FontWeight.w400),
                                ),
                              ),
                              const SizedBox(height: 12),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                reverse: true,
                                child: Text(
                                  _answer.isNotEmpty ? _answer : (_preview.isEmpty ? '0' : _preview),
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: compact ? 44 : 52,
                                    color: _answer.isNotEmpty ? _blue : Colors.white,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: compact ? 12 : 24),
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            _keyRow(['AC', '±', '%', '÷']),
                            _keyRow(['7', '8', '9', '×']),
                            _keyRow(['4', '5', '6', '-']),
                            _keyRow(['1', '2', '3', '+']),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(flex: 2, child: _keyButton('0', wide: true)),
                                  Expanded(child: _keyButton('.')),
                                  Expanded(child: _keyButton('=')),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 34,
                        height: 4,
                        decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _prettyExpression(String expression) =>
      expression.replaceAll('*', ' × ').replaceAll('/', ' ÷ ').replaceAll('+', ' + ').replaceAll('-', ' − ');

  Widget _keyRow(List<String> values) => Expanded(
        child: Row(children: values.map((value) => Expanded(child: _keyButton(value))).toList()),
      );

  Widget _keyButton(String label, {bool wide = false}) {
    final isOperator = const ['÷', '×', '-', '+', '='].contains(label);
    final isUtility = const ['AC', '±', '%'].contains(label);
    final color = label == '='
        ? _blue
        : isOperator
            ? (label == '+' ? _blueDark : const Color(0xFF005DB2))
            : isUtility
                ? _utility
                : _key;
    final foreground = isUtility ? const Color(0xFFBDBDBD) : (label == '=' ? const Color(0xFFEAF6FF) : _textBlue);
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(label == '=' || isOperator ? 16 : 18),
        child: InkWell(
          borderRadius: BorderRadius.circular(label == '=' || isOperator ? 16 : 18),
          onTap: () => _press(label == '×' ? '*' : label == '÷' ? '/' : label),
          child: SizedBox(
            height: double.infinity,
            child: Center(
              child: label == '⌫'
                  ? Icon(Icons.backspace_outlined, color: foreground, size: 25)
                  : Text(
                      label,
                      style: TextStyle(
                        color: foreground,
                        fontSize: label == 'AC' ? 22 : 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ExpressionParser {
  _ExpressionParser(this.input);
  final String input;
  int _index = 0;

  double parse() {
    final value = _expression();
    if (_index != input.length) throw const FormatException('Unexpected input');
    return value;
  }

  double _expression() {
    var value = _term();
    while (_index < input.length && (input[_index] == '+' || input[_index] == '-')) {
      final operator = input[_index++];
      final next = _term();
      value = operator == '+' ? value + next : value - next;
    }
    return value;
  }

  double _term() {
    var value = _factor();
    while (_index < input.length && (input[_index] == '*' || input[_index] == '/')) {
      final operator = input[_index++];
      final next = _factor();
      if (operator == '/' && next == 0) throw Exception('Division by zero');
      value = operator == '*' ? value * next : value / next;
    }
    return value;
  }

  double _factor() {
    if (_index >= input.length) throw const FormatException('Missing number');
    if (input[_index] == '-') {
      _index++;
      return -_factor();
    }
    if (input[_index] == '(') {
      _index++;
      final value = _expression();
      if (_index >= input.length || input[_index] != ')') {
        throw const FormatException('Missing closing parenthesis');
      }
      _index++;
      return value;
    }
    final start = _index;
    var dots = 0;
    while (_index < input.length &&
        (RegExp(r'[0-9.]').hasMatch(input[_index]))) {
      if (input[_index] == '.') dots++;
      if (dots > 1) throw const FormatException('Invalid decimal');
      _index++;
    }
    if (start == _index) throw const FormatException('Expected number');
    return double.parse(input.substring(start, _index));
  }
}
