import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../models/transactions.dart';

class TransacationItem extends StatelessWidget {
  const TransacationItem({
    Key? key,
    required this.transaction,
    required this.deleteTransactionHandler,
  }) : super(key: key);

  final Transactions transaction;
  final Function deleteTransactionHandler;

  String getCurrency() {
    var format =
        NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'KES');
    return format.currencySymbol;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColorLight,
      elevation: 5,
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.white,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FittedBox(
              child: Text(
                  '${getCurrency()} ${transaction.amount.toStringAsFixed(2)}'),
            ),
          ),
        ),
        title: Text(
          transaction.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(transaction.date),
        ),
        trailing: MediaQuery.of(context).size.width > 460
            ? TextButton.icon(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                onPressed: (() => deleteTransactionHandler(transaction.id)),
                label: Text(
                  'Delete',
                  style: TextStyle(
                    color: Theme.of(context).errorColor,
                  ),
                ),
              )
            : IconButton(
                onPressed: (() => deleteTransactionHandler(transaction.id)),
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                tooltip: 'Delete transaction',
              ),
      ),
    );
  }
}
