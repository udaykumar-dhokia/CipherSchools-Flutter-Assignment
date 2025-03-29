import 'package:cipherx_expense_tracker/core/theme/app_colors.dart';
import 'package:cipherx_expense_tracker/views/home/home_screen.dart';
import 'package:cipherx_expense_tracker/views/transaction/add_transaction_screen.dart';
import 'package:cipherx_expense_tracker/views/transaction/transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class BottomnavigationWidget extends StatefulWidget {
  const BottomnavigationWidget({super.key});

  @override
  State<BottomnavigationWidget> createState() => _BottomnavigationWidgetState();
}

class _BottomnavigationWidgetState extends State<BottomnavigationWidget> {
  @override
  Widget build(BuildContext context) {
    return const Navigation();
  }
}

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.white,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: AppColors.primary,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Iconsax.home_2_bulk, color: AppColors.white),
            icon: Icon(Iconsax.home_2_outline),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Iconsax.transaction_minus_bulk,
              color: AppColors.white,
            ),
            icon: Icon(Iconsax.transaction_minus_outline),
            label: 'Transactions',
          ),
          NavigationDestination(
            selectedIcon: Icon(Iconsax.add_outline, color: AppColors.white),
            icon: Icon(Iconsax.add_outline, size: 50, color: AppColors.primary),
            label: 'Add',
          ),
          NavigationDestination(
            selectedIcon: Icon(Iconsax.activity_bold, color: AppColors.white),
            icon: Icon(Iconsax.activity_outline),
            label: 'Budget',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Iconsax.profile_circle_bold,
              color: AppColors.white,
            ),
            icon: Icon(Iconsax.profile_circle_outline),
            label: 'Profile',
          ),
        ],
      ),
      body:
          <Widget>[
            /// Home page
            HomeScreen(),

            TransactionScreen(),

            AddTransactionScreen(),

            /// Notifications page
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.notifications_sharp),
                      title: Text('Notification 1'),
                      subtitle: Text('This is a notification'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.notifications_sharp),
                      title: Text('Notification 2'),
                      subtitle: Text('This is a notification'),
                    ),
                  ),
                ],
              ),
            ),

            /// Messages page
            ListView.builder(
              reverse: true,
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        'Hello',
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  );
                }
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      'Hi!',
                      style: theme.textTheme.bodyLarge!.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ][currentPageIndex],
    );
  }
}
