import 'package:cipherx_expense_tracker/core/helpers/database_helper.dart';
import 'package:cipherx_expense_tracker/core/theme/app_colors.dart';
import 'package:cipherx_expense_tracker/models/transaction_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  List<Transaction> _transactions = [];
  Map<String, List<Transaction>> _transactionsByMonth = {};
  Map<String, double> _categoryTotals = {};
  int _currentMonthTransactionCount = 0;
  bool showAnalysis = true;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _deleteTransaction(int id) async {
    await DatabaseHelper().deleteTransaction(id);
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    final transactionMaps = await DatabaseHelper().getTransactions();
    final transactions =
        transactionMaps.map((map) => Transaction.fromMap(map)).toList();

    setState(() {
      _transactions = transactions;
      _groupTransactionsByMonth();
      _calculateCurrentMonthTransactionCount();
      _calculateCategoryTotals();
    });
  }

  void _groupTransactionsByMonth() {
    _transactionsByMonth.clear();
    for (var transaction in _transactions) {
      final transactionDate = DateTime.parse(transaction.date);
      final monthKey = DateFormat('MMMM yyyy').format(transactionDate);

      if (!_transactionsByMonth.containsKey(monthKey)) {
        _transactionsByMonth[monthKey] = [];
      }
      _transactionsByMonth[monthKey]!.add(transaction);
    }
  }

  void _calculateCurrentMonthTransactionCount() {
    final now = DateTime.now();
    final currentMonthKey = DateFormat('MMMM yyyy').format(now);

    _currentMonthTransactionCount =
        _transactionsByMonth[currentMonthKey]?.length ?? 0;
  }

  void _calculateCategoryTotals() {
    _categoryTotals.clear();
    final now = DateTime.now();
    final currentMonthKey = DateFormat('MMMM yyyy').format(now);

    final currentMonthTransactions =
        _transactionsByMonth[currentMonthKey] ?? [];

    for (var transaction in currentMonthTransactions) {
      if (!_categoryTotals.containsKey(transaction.category)) {
        _categoryTotals[transaction.category] = 0.0;
      }
      _categoryTotals[transaction.category] =
          _categoryTotals[transaction.category]! + transaction.amount;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: const Color(0xffFFF6E5),
        title: Text(
          "Transactions",
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        actions: [
          InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              setState(() {
                showAnalysis = !showAnalysis;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Row(
                spacing: 5,
                children: [
                  Text("${showAnalysis ? "Hide" : "Show"} Analysis"),
                  Icon(Iconsax.chart_21_bold),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xffFFF6E5),
                  const Color(0xffF8EDD8).withOpacity(0.1),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Transactions this month",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      Text(
                        "$_currentMonthTransactionCount",
                        style: GoogleFonts.inter(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (showAnalysis)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Category Breakdown",
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 200,
                                child: PieChart(
                                  PieChartData(
                                    sections: _buildPieChartSections(),
                                    centerSpaceRadius: 20,
                                    titleSunbeamLayout: true,
                                    sectionsSpace: 1,
                                  ),
                                ),
                              ),
                            ),
                            // Legend
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _buildLegend(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Transactions List Grouped by Month
              Expanded(
                child: ListView.builder(
                  itemCount: _transactionsByMonth.keys.length,
                  itemBuilder: (context, index) {
                    final monthKey = _transactionsByMonth.keys.toList()[index];
                    final transactions = _transactionsByMonth[monthKey]!;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Month Header
                            Text(
                              monthKey,
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Transactions for the Month
                            ...transactions.map((transaction) {
                              return Slidable(
                                startActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed:
                                          (context) => _deleteTransaction(
                                            transaction.id!,
                                          ),
                                      backgroundColor: const Color(0xFFFE4A49),
                                      foregroundColor: Colors.white,
                                      icon: Iconsax.archive_2_bold,
                                      label: 'Delete',
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  title: Text(
                                    transaction.title,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    transaction.description,
                                    style: GoogleFonts.inter(),
                                  ),
                                  trailing: Text(
                                    "${transaction.type == "income" ? "+" : "-"} ₹${transaction.amount.toStringAsFixed(2)}",
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color:
                                          transaction.type == "income"
                                              ? AppColors.success
                                              : AppColors.error,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    final List<PieChartSectionData> sections = [];
    final totalAmount = _categoryTotals.values.fold(
      0.0,
      (sum, value) => sum + value,
    );

    _categoryTotals.forEach((category, amount) {
      final percentage = (amount / totalAmount) * 100;
      sections.add(
        PieChartSectionData(
          color: _getCategoryColor(category),
          value: percentage,
          title: "${percentage.toStringAsFixed(1)}%",
          radius: 50,
          titleStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    });

    return sections;
  }

  List<Widget> _buildLegend() {
    return _categoryTotals.entries.map((entry) {
      final category = entry.key;
      final amount = entry.value;
      final color = _getCategoryColor(category);

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                category,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Color _getCategoryColor(String category) {
    // Assign unique colors to categories
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
    ];
    return colors[category.hashCode % colors.length];
  }
}
