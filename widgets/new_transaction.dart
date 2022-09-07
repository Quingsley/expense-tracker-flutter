import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransactions extends StatefulWidget {
  final Function transactionHandler;
  const NewTransactions({Key? key, required this.transactionHandler})
      : super(key: key);

  @override
  State<NewTransactions> createState() => _NewTransactionsState();
}

class _NewTransactionsState extends State<NewTransactions> {
  final _titleController = TextEditingController();

  final _amountController = TextEditingController();
  dynamic _selectedDate;

  void _submitData() {
    String enteredTitle = _titleController.text;
    if (enteredTitle.isEmpty) {
      return;
    }

    final enterdAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enterdAmount <= 0 || _selectedDate == null) {
      return;
    }

    final userTitle =
        "${enteredTitle[0].toUpperCase()}${enteredTitle.substring(1).toLowerCase()}";

    widget.transactionHandler(userTitle, enterdAmount, _selectedDate);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  // onChanged: ((value) => inputValue = value),
                  controller: _titleController,
                  onSubmitted: ((_) => _submitData()),
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                  ),
                  keyboardType: TextInputType.number,
                  onSubmitted: ((_) => _submitData()),
                  // onChanged: ((value) => amountValue = value),
                  controller: _amountController,
                ),
                SizedBox(
                  height: 70,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                            // ignore: unnecessary_null_comparison
                            _selectedDate == null
                                ? 'No Date Chosen'
                                : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}'),
                      ),
                      TextButton(
                        onPressed: _presentDatePicker,
                        child: const Text(
                          'Choose A date',
                          style: TextStyle(
                            color: Colors.purpleAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _submitData,
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                  ),
                  child: const Text(
                    'Add Transcation',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
