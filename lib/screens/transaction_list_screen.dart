import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import '../models/my_transaction.dart';
import 'add_edit_screen.dart';

class TransactionListScreen extends StatelessWidget {
  static const routeName = '/';

  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('รายรับ - รายจ่าย')),
      body: Consumer<TransactionProvider>(
        builder: (context, txProvider, child) {
          final transactions = txProvider.transactions;
          if (transactions.isEmpty) {
            return const Center(child: Text('ไม่มีรายการ'));
          }
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (ctx, i) {
              final tx = transactions[i];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(tx.type == TransactionType.income ? 'รับ' : 'จ่าย'),
                ),
                title: Text(tx.title),
                subtitle: Text(DateFormat.yMMMd().format(tx.date)),
                trailing: Text(
                  '${tx.amount.toStringAsFixed(2)} ฿',
                  style: TextStyle(
                    color: tx.type == TransactionType.income ? Colors.green : Colors.red,
                  ),
                ),
                onTap: () {
                  // ✅ แตะเพื่อแก้ไข
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditScreen(transaction: tx),
                    ),
                  );
                },
                onLongPress: () {
                  // ✅ ลบข้อมูลเมื่อกดค้าง
                  context.read<TransactionProvider>().deleteTransaction(tx.id!);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditScreen()),
          );
        },
      ),
    );
  }
}
