import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker_provider/models/my_transaction.dart';
import 'package:expense_tracker_provider/providers/transaction_provider.dart';

class AddEditScreen extends StatefulWidget {
  static const routeName = '/add-edit';
  final MyTransaction? transaction; // ✅ รับค่า transaction ถ้ามี

  const AddEditScreen({super.key, this.transaction});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  TransactionType _selectedType = TransactionType.income;

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      _titleController.text = widget.transaction!.title;
      _amountController.text = widget.transaction!.amount.toString();
      _selectedType = widget.transaction!.type;
    }
  }

  Future<void> _saveTransaction() async {
    final title = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text) ?? 0;

    if (title.isEmpty || amount <= 0) return;

    final provider = context.read<TransactionProvider>();

    if (widget.transaction == null) {
      // ✅ เพิ่มใหม่
      await provider.addMyTransaction(title, amount, DateTime.now(), _selectedType);
    } else {
      // ✅ แก้ไข
      final updated = MyTransaction(
        id: widget.transaction!.id,
        title: title,
        amount: amount,
        date: DateTime.now(),
        type: _selectedType,
      );
      await provider.updateTransaction(widget.transaction!.id!, updated);
    }

    if (mounted) Navigator.pop(context); // ✅ กลับหน้าหลัก
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transaction != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'แก้ไขข้อมูล' : 'เพิ่มข้อมูลใหม่'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'ชื่อรายการ'),
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'จำนวนเงิน'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<TransactionType>(
                    title: const Text('รายรับ'),
                    value: TransactionType.income,
                    groupValue: _selectedType,
                    onChanged: (val) => setState(() => _selectedType = val!),
                  ),
                ),
                Expanded(
                  child: RadioListTile<TransactionType>(
                    title: const Text('รายจ่าย'),
                    value: TransactionType.expense,
                    groupValue: _selectedType,
                    onChanged: (val) => setState(() => _selectedType = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveTransaction,
              child: Text(isEditing ? 'ปรับปรุงข้อมูล' : 'บันทึกข้อมูล'),
            ),
          ],
        ),
      ),
    );
  }
}
