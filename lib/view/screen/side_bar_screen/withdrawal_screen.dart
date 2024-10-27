import 'package:flutter/material.dart';

class WithdrawalScreen extends StatefulWidget {
  static const String routeName = '\WithdrawalScreen';
  const WithdrawalScreen({super.key});

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  Widget _rowHeader(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Container(
        height: 30,
        decoration: BoxDecoration(
          color: Colors.yellow.shade900,
          border: Border.all(color: Colors.grey.shade700),
        ),
        child: Center(
            child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: const Text(
              'Withdrawal',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 22,
              ),
            ),
          ),
          const Divider(color: Colors.grey),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                _rowHeader('NAME', 2),
                _rowHeader('AMOUNT', 1),
                _rowHeader('BANK NAME', 3),
                _rowHeader('BANK ACCOUNT', 2),
                _rowHeader('EMAIL', 3),
                _rowHeader('PHONE NO', 2),
              ],
            ),
          )
        ],
      ),
    );
  }
}
