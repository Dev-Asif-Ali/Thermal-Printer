import 'package:bluetooth_print_plus/bluetooth_print_plus.dart' as ps;
import 'bill_model_class.dart';


//TODO: to implement the api that is to provide the transaction details of the customer.
class PrintReceiptController {
  Future<void> printReceipt(Bill bill) async {
    try {
      final escCommand = ps.EscCommand();
      final cpclCommand = ps.CpclCommand();
      await cpclCommand.cleanCommand();
      await escCommand.cleanCommand();

      // Print Receipt Header
      await escCommand.text(
        content: '-------------------------\n',
        alignment: ps.Alignment.center,
      );
      await escCommand.text(
        content: 'TRANSACTION RECEIPT\n',
        alignment: ps.Alignment.center,
        style: ps.EscTextStyle.bold,
      );
      await escCommand.text(
        alignment: ps.Alignment.center,
        content: '-------------------------\n',
      );
      // Company Details
      await escCommand.text(
        content: '${bill.companyName}\n',
        alignment: ps.Alignment.center,
        style: ps.EscTextStyle.bold,
      );
      await escCommand.text(
        content: 'Address: ${bill.address}\n',
      );
      await escCommand.text(
        content: 'Manager: ${bill.manager}\n',
      );

      // Transaction Details
      await escCommand.text(
        content: 'Account: ${bill.accountNumber}\n',
      );
      await escCommand.text(
        content: 'Transaction Type: ${bill.transactionType}\n',
      );
      await escCommand.text(
        content: 'Amount: \$${bill.amount.toStringAsFixed(2)}\n',
      );
      await escCommand.text(
        content: 'Date: ${bill.transactionDate.toLocal().toString().split(' ')[0]}\n',
      );
      await escCommand.text(
        content: '-----------------------------------\n',
      );
      // Tax and Total
      await escCommand.text(
        content: '\nTax (8%):'.padRight(30) + '\$${bill.tax.toStringAsFixed(2)}'.padLeft(8) + '\n',
      );
      await escCommand.text(
        content: 'TOTAL:'.padRight(30) + '\$${bill.grandTotal.toStringAsFixed(2)}'.padLeft(8) + '\n\n',
        style: ps.EscTextStyle.bold,
      );

      await escCommand.text(
        content: '--------************--------\n',
        alignment: ps.Alignment.center,
      );

      // Thank You Message
      await escCommand.text(
        content: 'THANK YOU\n',
        alignment: ps.Alignment.center,
        style: ps.EscTextStyle.bold,
      );

      // Feed paper
      await escCommand.print(feedLines: 2);
      final cmd = await escCommand.getCommand();
      final cmd2 = await cpclCommand.getCommand();
      if (cmd == null && cmd2 == null) return;
      ps.BluetoothPrintPlus.write(cmd);
      ps.BluetoothPrintPlus.write(cmd2);
    } catch (e) {
      print("Error occurred: $e");
    }
  }
}
