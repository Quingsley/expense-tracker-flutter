import '../models/transactions.dart';
import 'package:flutter/material.dart';
import './transaction_item.dart';

class TransactionsList extends StatelessWidget {
  final List<Transactions> transactions;
  final Function deleteTransactionHandler;
  const TransactionsList(
      {Key? key,
      required this.transactions,
      required this.deleteTransactionHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: transactions.isEmpty
          ? LayoutBuilder(builder: ((context, constraints) {
              return Column(
                children: <Widget>[
                  Text(
                    'No transactions added yet!',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset('assets/images/waiting.png'),
                  ),
                ],
              );
            }))
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                return TransacationItem(
                    transaction: transactions[index],
                    deleteTransactionHandler: deleteTransactionHandler);
              },
            ),
    );
  }
}
