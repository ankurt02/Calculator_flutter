// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'button_values.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = ""; //. 0-9
  String operand = ""; //+ - * /
  String number2 = ""; //. 0-9

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      bottom: false,
      child: Column(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          // output
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(16),
                child: Text(
                  "$number1$operand$number2".isEmpty
                      ? "0"
                      : "$number1$operand$number2",
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
          ),

          // buttons
          Wrap(
            children: Btn.buttonValues
                .map(
                  (value) => SizedBox(
                      width: value == Btn.calculate
                          ? (screenSize.width / 2)
                          : (screenSize.width / 4),
                      height: screenSize.width / 5,
                      child: buildButton(value)),
                )
                .toList(),
          )
        ],
      ),
    ));
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip
            .hardEdge, // this limits the splash animation within the button rather than the original box
        shape: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white24),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
              child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          )),
        ),
      ),
    );
  }

  Color getBtnColor(value) {
    return [
      Btn.del,
      Btn.clr,
    ].contains(value)
        ? Colors.grey
        : [
            Btn.per,
            Btn.multiply,
            Btn.add,
            Btn.subtract,
            Btn.divide,
            // Btn.calculate,
          ].contains(value)
            ? Color.fromARGB(255, 244, 155, 46)
            : Colors.black45;
  }

  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }

    if (value == Btn.clr) {
      clearAll();
      return;
    }

    if (value == Btn.per) {
      convertToPercantage();
      return;
    }

    if (value == Btn.calculate) {
      calculate();
      return;
    }

    appendValue(value);
  }

  // calculate the result
  void calculate() {
    if (number1.isEmpty) return;
    if (operand.isEmpty) return;
    if (number2.isEmpty) return;

    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);

    var result = 0.0;
    switch (operand) {
      case Btn.add:
        result = num1 + num2;
        break;

      case Btn.subtract:
        result = num1 - num2;
        break;

      case Btn.multiply:
        result = num1 * num2;
        break;

      case Btn.divide:
        result = num1 / num2;
        break;
      default:
    }

    setState(() {
      // number1 = "$result";

      // if (number1.endsWith(".0")) {
      //   number1 = number1.substring(0, number1.length - 2);
      // }
      if (result % 1 == 0) {
      // If result is an integer, remove ".0"
      number1 = result.toInt().toString();
    } else {
      // Limit decimals to 5 if there are more than 5 digits after the decimal
      number1 = result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 3);
    }

      operand = "";
      number2 = "";
    });
  }

  // convert to percentage
  void convertToPercantage() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      // calculate before conversion
      calculate();
    }

    if (operand.isNotEmpty) {
      // cannot be converted
      return;
    }

    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operand = "";
      number2 = "";
    });
  }

  // clears all
  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

  // deletes from the end
  void delete() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }

    setState(() {});
  }

  // appends value to the end
  void appendValue(String value) {
    // i fis operand is ot "."
    if (value != Btn.dot && int.tryParse(value) == null) {
      // operand pressed
      if (operand.isNotEmpty && number2.isNotEmpty) {
        // todo calculate the equation before assiginging
        calculate();
      }
      operand = value;
    }
    // assign value to number1 variable
    else if (number1.isEmpty || operand.isEmpty) {
      // "<number 1> this cannot be empty" "" ""
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
        value = "0.";
      }
      number1 += value;
    }
    // assign value to number2 variable
    else if (number2.isEmpty || operand.isNotEmpty) {
      // "<number 1> this cannot be empty" "" ""
      if (value == Btn.dot && number2.contains(Btn.dot)) return;
      if (value == Btn.dot && (number2.isEmpty || number2 == Btn.n0)) {
        value = "0.";
      }
      number2 += value;
    }

    setState(() {});
  }
}
