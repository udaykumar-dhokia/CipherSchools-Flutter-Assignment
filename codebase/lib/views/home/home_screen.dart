import 'package:cipherx_expense_tracker/core/helpers/database_helper.dart';
import 'package:cipherx_expense_tracker/models/transaction_model.dart';
import 'package:cipherx_expense_tracker/core/theme/app_colors.dart';
import 'package:cipherx_expense_tracker/views/transaction/add_transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Transaction> _transactions = [];
  List<Transaction> _filteredTransactions = [];
  double _totalIncome = 0.0;
  double _totalExpense = 0.0;
  String selectedFilter = "Today";

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    final transactionMaps = await DatabaseHelper().getTransactions();
    setState(() {
      _transactions =
          transactionMaps.map((map) => Transaction.fromMap(map)).toList();
      _applyFilter();
    });
  }

  Future<void> _deleteTransaction(int id) async {
    await DatabaseHelper().deleteTransaction(id);
    _fetchTransactions(); 
  }

  void _applyFilter() {
    DateTime now = DateTime.now();
    List<Transaction> filtered;

    if (selectedFilter == "Today") {
      filtered =
          _transactions.where((transaction) {
            DateTime transactionDate = DateTime.parse(transaction.date);
            return isSameDay(transactionDate, now);
          }).toList();
    } else if (selectedFilter == "Week") {
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      filtered =
          _transactions.where((transaction) {
            DateTime transactionDate = DateTime.parse(transaction.date);
            return transactionDate.isAfter(startOfWeek) &&
                transactionDate.isBefore(now.add(const Duration(days: 1)));
          }).toList();
    } else if (selectedFilter == "Month") {
      filtered =
          _transactions.where((transaction) {
            DateTime transactionDate = DateTime.parse(transaction.date);
            return transactionDate.year == now.year &&
                transactionDate.month == now.month;
          }).toList();
    } else if (selectedFilter == "Year") {
      filtered =
          _transactions.where((transaction) {
            DateTime transactionDate = DateTime.parse(transaction.date);
            return transactionDate.year == now.year;
          }).toList();
    } else {
      filtered = _transactions;
    }

    setState(() {
      _filteredTransactions = filtered;
      _calculateTotals();
    });
  }

  void _calculateTotals() {
    _totalIncome = _filteredTransactions
        .where((transaction) => transaction.type == "income")
        .fold(0.0, (sum, transaction) => sum + transaction.amount);

    _totalExpense = _filteredTransactions
        .where((transaction) => transaction.type == "expense")
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    final double totalBalance = _totalIncome - _totalExpense;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xffFFF6E5),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Iconsax.profile_circle_outline),
            ),
            IconButton(
              icon: const Icon(
                Iconsax.notification_bold,
                color: AppColors.primary,
              ),
              onPressed: () {},
            ),
          ],
        ),
        actions: [],
      ),
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
                child: Column(
                  children: [
                    _buildTotalBalanceCard(totalBalance),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTotalCard(
                          "Income",
                          _totalIncome,
                          AppColors.success,
                        ),
                        _buildTotalCard(
                          "Expense",
                          _totalExpense,
                          AppColors.error,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Filter Buttons
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildFilterButton("Today"),
                    _buildFilterButton("Week"),
                    _buildFilterButton("Month"),
                    _buildFilterButton("Year"),
                  ],
                ),
              ),

              // Recent Transactions Header
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Recent Transactions",
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                        Text(
                          "*Swipe from left for options.",
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        "See All",
                        style: GoogleFonts.inter(
                          color: AppColors.primary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Transactions List
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredTransactions.length,
                  itemBuilder: (context, index) {
                    final transaction = _filteredTransactions[index];
                    return Slidable(
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed:
                                (context) =>
                                    _deleteTransaction(transaction.id!),
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
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
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
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String filter) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedFilter = filter;
          _applyFilter();
        });
      },
      splashColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selectedFilter == filter ? const Color(0xffFCEED4) : null,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          filter,
          style: GoogleFonts.inter(
            color:
                selectedFilter == filter
                    ? const Color(0xffFCAC12)
                    : const Color(0xff91919F),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTotalBalanceCard(double totalBalance) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      child: Column(
        spacing: 4,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Account Balance",
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade500,
            ),
          ),
          Text(
            "₹${totalBalance.toStringAsFixed(2)}",
            style: GoogleFonts.inter(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCard(String title, double amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: MediaQuery.of(context).size.width / 2 - 32,
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            title == "Income"
                ? Iconsax.arrow_up_1_bold
                : Iconsax.arrow_down_bold,
            color: AppColors.white,
            size: 30,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "₹${amount.toStringAsFixed(2)}",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
