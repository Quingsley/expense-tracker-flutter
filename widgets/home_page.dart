import 'dart:io';
import './new_transaction.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import '../models/transactions.dart';
import './chart.dart';
import './transaction_list.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  final List<Transactions> _userTransactions = [
    // Transactions('${DateTime.now().millisecondsSinceEpoch + 200}', 'Shoes',
    //     2500.34, DateTime.now()),
    // Transactions('${DateTime.now().millisecondsSinceEpoch + 300}', 'Bag', 1500,
    //     DateTime.now()),
  ];

  bool _showChart = false;

  void _sortTransasctions() {
    _userTransactions.sort((tx1, tx2) => tx2.date.compareTo(tx1.date));
  }

  get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        const Duration(days: 7),
      ));
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    var id = Random().nextInt(100) + 900; //random id
    final txValue = Transactions(
        '${DateTime.now().millisecondsSinceEpoch + id}',
        txTitle,
        txAmount,
        chosenDate);

    setState(() {
      _userTransactions.add(txValue);
      _sortTransasctions();
    });
  }

  void _startNewTransaction(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: ((_) {
        return GestureDetector(
          onTap: (() {}),
          behavior: HitTestBehavior.opaque,
          child: NewTransactions(transactionHandler: _addNewTransaction),
        );
      }),
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  _buildIsLandscape() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      const Text('Show Chart'),
      Switch.adaptive(
          value: _showChart,
          onChanged: (val) {
            setState(() {
              _showChart = val;
            });
          }),
    ]);
  }

  _buildIsPortrait(MediaQueryData mediquery, AppBar appBar) {
    return SizedBox(
      height: (mediquery.size.height -
              appBar.preferredSize.height -
              mediquery.padding.top) *
          0.3,
      child: Chart(
        recentTransactions: _recentTransactions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customMediaQuery = MediaQuery.of(context);
    final isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = AppBar(
      title: const Text(
        'Expense Tracker',
      ),
      actions: [
        IconButton(
          onPressed: (() => _startNewTransaction(context)),
          icon: const Icon(
            Icons.add,
            size: 30,
            semanticLabel: 'Add new Transaction',
          ),
        ),
      ],
    );
    final transactionList = SizedBox(
      height: (customMediaQuery.size.height -
              appBar.preferredSize.height -
              customMediaQuery.padding.top) *
          0.7,
      child: TransactionsList(
        transactions: _userTransactions,
        deleteTransactionHandler: _deleteTransaction,
      ),
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (isLandScape) _buildIsLandscape(),
              if (!isLandScape) _buildIsPortrait(customMediaQuery, appBar),
              if (!isLandScape) transactionList,
              if (isLandScape)
                _showChart
                    ? SizedBox(
                        height: (customMediaQuery.size.height -
                                appBar.preferredSize.height -
                                customMediaQuery.padding.top) *
                            0.7,
                        child: Chart(
                          recentTransactions: _recentTransactions,
                        ),
                      )
                    : transactionList,
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS
          ? const SizedBox()
          : FloatingActionButton(
              onPressed: () => _startNewTransaction(context),
              child: Icon(
                Icons.add,
                size: 30 * (MediaQuery.of(context).textScaleFactor),
                semanticLabel: 'Add new Transaction',
              ),
            ),
    );
  }
}
