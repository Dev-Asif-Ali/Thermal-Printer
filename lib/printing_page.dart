import 'package:bharat_finance/print_receipt_controller.dart';
import 'package:bluetooth_print_plus/bluetooth_print_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as sc;
import 'dart:async';
import 'bill_model_class.dart';



class PrintingPage extends StatefulWidget {
  @override
  _PrintingPageState createState() => _PrintingPageState();
}

class _PrintingPageState extends State<PrintingPage> {
  late StreamSubscription<ConnectState> _connectStateSubscription;
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _managerController = TextEditingController();

  Bill bill = Bill(
    companyName: '',
    address: '',
    manager: '',
    accountNumber: '',
    amount: 0.0,
    transactionDate: DateTime.now(),
    transactionType: 'Debit',
  );

  bool _isBluetoothConnected = false;

  // Update Bluetooth connection state
  void _updateBluetoothConnectionState() {
    _connectStateSubscription = BluetoothPrintPlus.connectState.listen((event) {
      print('********** connectState change: $event **********');
      setState(() {
        if (event == ConnectState.connected) {
          _isBluetoothConnected = true;
        } else if (event == ConnectState.disconnected) {
          _isBluetoothConnected = false;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _updateBluetoothConnectionState();
  }

  @override
  void dispose() {
    _connectStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Receipt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Bluetooth Connection Status
              Row(
                children: [
                  Icon(
                    _isBluetoothConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
                    color: _isBluetoothConnected ? Colors.green : Colors.red,
                  ),
                  SizedBox(width: 10),
                  Text(
                    _isBluetoothConnected ? 'Bluetooth Connected' : 'Bluetooth Disconnected',
                    style: TextStyle(
                      color: _isBluetoothConnected ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Company Details Section
              TextField(
                controller: _companyController,
                decoration: InputDecoration(
                  labelText: 'Company Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    bill.companyName = value;
                  });
                },
              ),
              SizedBox(height: 10),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    bill.address = value;
                  });
                },
              ),
              SizedBox(height: 10),
              TextField(
                controller: _managerController,
                decoration: InputDecoration(
                  labelText: 'Manager',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    bill.manager = value;
                  });
                },
              ),
              SizedBox(height: 20),
              // Transaction Details Section
              TextField(
                controller: _accountController,
                decoration: InputDecoration(
                  labelText: 'Account Number',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    bill.accountNumber = value;
                  });
                },
              ),
              SizedBox(height: 10),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Transaction Amount',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    bill.amount = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              SizedBox(height: 10),
              // Transaction Type (Credit/Debit)
              DropdownButton<String>(
                value: bill.transactionType,
                onChanged: (newValue) {
                  setState(() {
                    bill.transactionType = newValue!;
                  });
                },
                items: <String>['Debit', 'Credit']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (!_isBluetoothConnected) {
                    // Show a Snackbar if Bluetooth is not connected
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please connect to Bluetooth first'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  }

                  setState(() {
                    bill.companyName = _companyController.text;
                    bill.address = _addressController.text;
                    bill.manager = _managerController.text;
                    bill.accountNumber = _accountController.text;
                    bill.amount = double.tryParse(_amountController.text) ?? 0.0;
                  });
                  PrintReceiptController().printReceipt(bill);
                },
                child: Text('Print Receipt'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}