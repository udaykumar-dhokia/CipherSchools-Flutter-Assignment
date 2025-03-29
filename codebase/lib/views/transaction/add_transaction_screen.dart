import 'package:cipherx_expense_tracker/core/helpers/database_helper.dart';
import 'package:cipherx_expense_tracker/models/transaction_model.dart';
import 'package:cipherx_expense_tracker/core/theme/app_colors.dart';
import 'package:cipherx_expense_tracker/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      setState(() {});
    });

    _amountController.text = "0";
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _addTransaction(String type) async {
    if (_titleController.text.isNotEmpty &&
        _amountController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _categoryController.text.isNotEmpty) {
      final transaction = Transaction(
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        date: DateTime.now().toIso8601String(),
        type: type,
        description: _descriptionController.text,
        category: _categoryController.text,
      );

      await DatabaseHelper().insertTransaction(transaction.toMap());

      _amountController.text = "0.0";
      _titleController.clear();
      _descriptionController.clear();
      _categoryController.clear();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        _tabController.index == 0 ? AppColors.primary : AppColors.primary;

    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: TabBar(
          dividerColor: Colors.transparent,
          indicatorColor: AppColors.white,
          labelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold),
          labelColor: AppColors.white,
          controller: _tabController,
          enableFeedback: true,
          tabs: const [Tab(text: "Income"), Tab(text: "Expense")],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTransactionForm("income"),
          _buildTransactionForm("expense"),
        ],
      ),
    );
  }

  Widget _buildTransactionForm(String type) {
    return SingleChildScrollView(
      child: Container(
        height:
            MediaQuery.of(context).size.height -
            AppBar().preferredSize.height -
            kToolbarHeight,
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    image: AssetImage(
                      type == "income"
                          ? "assets/illustration1.png"
                          : "assets/illustration2.png",
                    ),
                    width: 70,
                    height: 70,
                  ),
                  Text(
                    "How much?",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ],
              ),
            ),
            TextFormField(
              controller: _amountController,
              style: GoogleFonts.inter(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
              keyboardType: TextInputType.number,
              cursorColor: AppColors.white,
              decoration: InputDecoration(
                prefix: Text(
                  "₹ ",
                  style: GoogleFonts.inter(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                border: const OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  TextFieldWidget(
                    controller: _titleController,
                    hintText: "Label",
                  ),
                  const SizedBox(height: 16),
                  TextFieldWidget(
                    controller: _descriptionController,
                    hintText: "Description",
                  ),
                  const SizedBox(height: 16),
                  TextFieldWidget(
                    controller: _categoryController,
                    hintText: "Category",
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _addTransaction(type),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          "Continue",
                          style: GoogleFonts.inter(
                            color: AppColors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
