import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/signup.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'login.dart';
import 'package:http/http.dart' as http;

import 'aftersplash.dart';
import 'statistic.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: 'assets/logoduit.png',
        nextScreen: Aftersplash(),
        duration: 1000,
        backgroundColor: Color(0xFF597E52),
        splashTransition: SplashTransition.scaleTransition,
        pageTransitionType: PageTransitionType.bottomToTop,
      ),
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomePage(
              userData: ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>,
            ),
        '/signup': (context) => SignupScreen(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const HomePage({Key? key, required this.userData}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _goals = [];
  late Map<String, dynamic> _userData;

  @override
  void initState() {
    super.initState();
    fetchUserData(widget.userData['accountId'].toString());
    _fetchGoalData(widget.userData['accountId'].toString());
    _pages[0] = BalancePage(userData: widget.userData);
    _pages[1] = BalanceTrendPage(userData: widget.userData);
    _pages[3] = PlaylistPage(userData: widget.userData);
    _pages[4] = ProfilePage(userData: widget.userData);
  }

  Future<void> fetchUserData(String accountId) async {
    final String apiUrl = 'http://192.168.0.103:3000/getAccountData';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'accountId': accountId},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _userData = Map<String, dynamic>.from(data);
        });
      } else {
        // Error fetching data
        print('Failed to fetch user data. Status code: ${response.statusCode}');
        throw Exception('Failed to fetch user data');
      }
    } catch (error) {
      // Exception occurred during fetching data
      print('Error during fetching user data: $error');
      throw Exception('Error during fetching user data');
    }
  }

  Future<void> _fetchGoalData(String accountId) async {
    final String apiUrl = 'http://192.168.0.103:3000/getAllGoal';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'accountId': accountId},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _goals = List<Map<String, dynamic>>.from(data);
        });
      } else {
        print('Failed to fetch goal data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching goal data: $error');
    }
  }

  final List<Widget> _pages = [
    BalancePage(
      userData: {},
    ),
    BalanceTrendPage(
      userData: {},
    ),
    Placeholder(),
    PlaylistPage(userData: {}),
    ProfilePage(userData: {})
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      debugPrint("Selected index: $index");
    });
  }

  void _showBottomSheet(BuildContext context, Map<String, dynamic> userData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.95,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: BottomSheetContent(
              userData: widget.userData,
              refreshData: () =>
                  _fetchGoalData(widget.userData['accountId'].toString()),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFEC),
      body: _pages[_selectedIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top: 67),
        height: 40,
        width: 40,
        child: FloatingActionButton(
          backgroundColor: Colors.lightBlue,
          elevation: 0,
          onPressed: () => _showBottomSheet(context, widget.userData),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 0.2,
              color: Color(0xff658fab),
            ),
          ),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: Color(0xffc6a969),
            labelTextStyle: MaterialStateProperty.all(
              TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            iconTheme: MaterialStateProperty.all(
              IconThemeData(color: Colors.black),
            ),
          ),
          child: NavigationBar(
            backgroundColor: Color(0xFFFFFFEC),
            height: 60,
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.home_outlined, size: 29),
                selectedIcon:
                    Icon(Icons.home, size: 30, color: Color(0xFFFFFFEC)),
                label: '',
              ),
              NavigationDestination(
                icon: Icon(Icons.bar_chart_outlined, size: 29),
                selectedIcon:
                    Icon(Icons.bar_chart, size: 30, color: Color(0xFFFFFFEC)),
                label: '',
              ),
              SizedBox(width: 50),
              NavigationDestination(
                icon: Icon(Icons.playlist_add_circle_outlined, size: 29),
                selectedIcon: Icon(Icons.playlist_add_circle,
                    size: 30, color: Color(0xFFFFFFEC)),
                label: '',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline, size: 29),
                selectedIcon:
                    Icon(Icons.person, size: 30, color: Color(0xFFFFFFEC)),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomSheetContent extends StatefulWidget {
  final Map<String, dynamic> userData;
  final Future<void> Function() refreshData;

  const BottomSheetContent({
    Key? key,
    required this.userData,
    required this.refreshData,
  }) : super(key: key);

  @override
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

Widget _buildTextFieldWithShadow({required Widget child}) {
  return Container(
    height: 50,
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    ),
    child: child,
  );
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  String selectedCategory = "Goals";
  TextEditingController _dateController = TextEditingController();
  TextEditingController _goalTitleController = TextEditingController();
  TextEditingController _endGoalController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  late final Map<String, dynamic> _userData;

  @override
  void initState() {
    super.initState();
    _userData = widget.userData;
  }

  @override
  void dispose() {
    _dateController.dispose();
    _goalTitleController.dispose();
    _endGoalController.dispose();
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _setCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void _updateGoalTitle(String value) {
    setState(() {
      _goalTitleController.text = value;
    });
  }

  void _updateEndGoal(String value) {
    setState(() {
      _endGoalController.text = value;
    });
  }

  void _addIncome(BuildContext context) async {
    if (_titleController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _amountController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please fill in all fields."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      var url = Uri.parse('http://192.168.0.103:3000/income');

      var body = json.encode({
        'accountId': _userData['accountId'].toString(),
        'title': _titleController.text,
        'date': _dateController.text,
        'categoryName': 'Primary',
        'amount': _amountController.text,
      });

      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 201) {
        print('Income added successfully');
        Navigator.pop(context);
      } else {
        print('Failed to add income');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _addGoal(BuildContext context) async {
    if (_goalTitleController.text.isEmpty || _endGoalController.text.isEmpty) {
      // Show error dialog if fields are empty
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please fill in all fields."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      var url = Uri.parse('http://192.168.0.103:3000/createGoal');

      var body = json.encode({
        'accountId': _userData['accountId'].toString(),
        'goalTitle': _goalTitleController.text,
        'endGoal':
            _endGoalController.text.toString(), // Convert _endGoal to string
        'currentGoal': '0',
      });

      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 201) {
        // Goal added successfully
        print('Goal created successfully');
        // Refresh the playlist page
        widget.refreshData();
        // Close the bottom sheet
        Navigator.pop(context);
      } else {
        // Handle failure scenario if needed
        print('Failed to create goal');
      }
    } catch (error) {
      // Handle any exceptions or errors that occur during the HTTP request
      print('Error: $error');
    }
  }

  void _addExpense(BuildContext context) async {
    if (_titleController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _amountController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please fill in all fields."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      var url = Uri.parse('http://192.168.0.103:3000/expense');

      var body = json.encode({
        'accountId': _userData['accountId'].toString(),
        'title': _titleController.text,
        'categoryName': 'Primary',
        'date': _dateController.text,
        'amount': _amountController.text,
      });

      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 201) {
        print('Expense added successfully');
        Navigator.pop(context);
      } else {
        print('Failed to add expense');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      // Format the picked date in the desired format
      final formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      _dateController.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 5),
      decoration: BoxDecoration(
        color: Color(0xFFD9C7A0),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  // Close the bottom sheet
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Color(0xff062c80),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (selectedCategory == 'Income') {
                    _addIncome(context);
                  } else if (selectedCategory == 'Goals') {
                    _addGoal(context); // Pass context to _addGoal function
                  } else if (selectedCategory == 'Expense') {
                    _addExpense(context);
                  }
                  // Do not close the bottom sheet here
                },
                child: Text(
                  'Add',
                  style: TextStyle(
                    color: Color(0xff062c80),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => _setCategory("Income"),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        // Actual Icon
                        Image.asset(
                          'assets/IncomeIcon.png',
                          color: selectedCategory == "Income"
                              ? Color(0xff93e696)
                              : Colors.black,
                          width: 36, // Adjust the width as needed
                          height: 36, // Adjust the height as needed
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        color: selectedCategory == "Income"
                            ? Color(0xff93e696)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.only(
                          top: 3, bottom: 3, left: 25, right: 25),
                      child: Text(
                        'Income',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _setCategory("Goals"),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        // Shadow for Icon
                        Positioned(
                          top: 1.0,
                          left: 1.0,
                          child: Icon(
                            Icons.savings_outlined,
                            color: Colors.black.withOpacity(0.2),
                            size: 36,
                          ),
                        ),
                        // Actual Icon
                        Icon(
                          Icons.savings_outlined,
                          color: selectedCategory == "Goals"
                              ? Color(0xffffc1d2)
                              : Colors.black,
                          size: 36,
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        color: selectedCategory == "Goals"
                            ? Color(0xffffc1d2)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.only(
                          top: 3, bottom: 3, left: 30.5, right: 30.5),
                      child: Text(
                        'Goals',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _setCategory("Expense"),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        // Actual Icon
                        Image.asset(
                          'assets/IncomeIcon.png',
                          color: selectedCategory == "Expense"
                              ? Color(0xffec6d6d)
                              : Colors.black,
                          width: 36, // Adjust the width as needed
                          height: 36, // Adjust the height as needed
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        color: selectedCategory == "Expense"
                            ? Color(0xffec6d6d)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.only(
                          top: 3, bottom: 3, left: 23.5, right: 23.5),
                      child: Text(
                        'Expense',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (selectedCategory == "Income")
            IncomeForm(
              dateController: _dateController,
              titleController: _titleController,
              amountController: _amountController,
            ),
          if (selectedCategory == "Goals")
            GoalsForm(
              updateGoalTitle: _updateGoalTitle,
              updateEndGoal: _updateEndGoal,
            ),
          if (selectedCategory == "Expense")
            ExpenseForm(
              dateController: _dateController,
              titleController: _titleController,
              amountController: _amountController,
            ),
        ],
      ),
    );
  }
}

class IncomeForm extends StatelessWidget {
  final TextEditingController dateController;
  final TextEditingController titleController;
  final TextEditingController amountController;

  const IncomeForm({
    required this.dateController,
    required this.titleController,
    required this.amountController,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      // Format the picked date in the desired format
      final formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      dateController.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.5),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 0.2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              "Title",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          _buildTextFieldWithShadow(
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              style: TextStyle(fontSize: 15),
              textAlignVertical: TextAlignVertical.center,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        "Date",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildTextFieldWithShadow(
                      child: TextField(
                        controller: dateController,
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        style: TextStyle(fontSize: 15),
                        textAlignVertical: TextAlignVertical.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              "Amount",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          _buildTextFieldWithShadow(
            child: TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              style: TextStyle(fontSize: 15),
              textAlignVertical: TextAlignVertical.center,
            ),
          ),
        ],
      ),
    );
  }
}

class GoalsForm extends StatelessWidget {
  final Function(String) updateGoalTitle;
  final Function(String) updateEndGoal;

  GoalsForm({required this.updateGoalTitle, required this.updateEndGoal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              "Title",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          _buildTextFieldWithShadow(
            child: TextField(
              onChanged: updateGoalTitle,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              style: TextStyle(fontSize: 15),
              textAlignVertical: TextAlignVertical.center,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              "Target Goals",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          _buildTextFieldWithShadow(
            child: TextField(
              onChanged: updateEndGoal,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExpenseForm extends StatelessWidget {
  final TextEditingController dateController;
  final TextEditingController titleController;
  final TextEditingController amountController;

  const ExpenseForm({
    required this.dateController,
    required this.titleController,
    required this.amountController,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      // Format the picked date in the desired format
      final formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      dateController.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.5), // Add padding to see the border clearly
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.black, width: 0.2), // Set border color here
        borderRadius:
            BorderRadius.circular(10), // Adjust border radius as needed
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5), // Padding around the Text widget
            child: Text(
              "Title",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          _buildTextFieldWithShadow(
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ), // Remove default border
                filled: true,
                fillColor: Colors.white,
              ),
              style: TextStyle(fontSize: 15),
              textAlignVertical:
                  TextAlignVertical.center, // Vertically center the text
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: 5), // Padding around the Text widget
                      child: Text(
                        "Date",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildTextFieldWithShadow(
                      child: TextField(
                        controller: dateController,
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        style: TextStyle(fontSize: 15),
                        textAlignVertical: TextAlignVertical.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.only(left: 5), // Padding around the Text widget
            child: Text(
              "Amount",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          _buildTextFieldWithShadow(
            child: TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              style: TextStyle(fontSize: 15),
              textAlignVertical: TextAlignVertical.center,
            ),
          ),
        ],
      ),
    );
  }
}

class BalancePage extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const BalancePage({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  _BalancePageState createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  Future<List<Map<String, dynamic>>?>? _goalData;

  @override
  void initState() {
    super.initState();
    _goalData = fetchData(widget.userData!['accountId'].toString());
  }

  Future<void> _fetchData() async {
    setState(() {
      _goalData = fetchData(widget.userData!['accountId'].toString());
    });
  }

  // Method to fetch data
  Future<List<Map<String, dynamic>>?> fetchData(String accountId) async {
    final String apiUrl = 'http://192.168.0.103:3000/getAllGoal';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'accountId': accountId},
      );

      if (response.statusCode == 200) {
        // Successfully fetched data
        final List<dynamic> data = json.decode(response.body);
        // Convert data to List<Map<String, dynamic>>
        final List<Map<String, dynamic>> goalDataList =
            List<Map<String, dynamic>>.from(data);
        return goalDataList;
      } else {
        // Error fetching data
        print('Failed to fetch data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      // Exception occurred during fetching data
      print('Error during fetching data: $error');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // UI build code
    return FutureBuilder<List<Map<String, dynamic>>?>(
      future: _goalData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child:
                CircularProgressIndicator(), // Or any other loading indicator
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
                'Error: ${snapshot.error}'), // Or any other error handling UI
          );
        } else {
          final List<Map<String, dynamic>>? goalDataList = snapshot.data;

          int totalCurrentGoal = 0;
          int totalEndGoal = 0;

          // Calculate totals from all goals
          for (var goalData in goalDataList!) {
            totalCurrentGoal += (goalData['currentGoal'] ?? 0) as int;
            totalEndGoal += (goalData['endGoal'] ?? 0) as int;
          }

          return Scaffold(
            backgroundColor: Color(0xFFFFFFEC),
            body: Padding(
              padding: const EdgeInsets.only(top: 45, left: 37.5, right: 37.5),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BalanceCard(userData: widget.userData!),
                    SizedBox(height: 20),
                    BalanceTrendCard(userData: widget.userData!),
                    SizedBox(height: 30),
                    OveralGoalsText(),
                    SizedBox(height: 10),
                    OverallGoalsCard(
                      totalCurrentGoal: totalCurrentGoal,
                      totalEndGoal: totalEndGoal,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class BalanceCard extends StatefulWidget {
  final Map<String, dynamic> userData;

  const BalanceCard({Key? key, required this.userData}) : super(key: key);

  @override
  _BalanceCardState createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  late Future<Map<String, dynamic>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = fetchUserData(widget.userData['accountId'].toString());
  }

  Future<Map<String, dynamic>> fetchUserData(String accountId) async {
    final String apiUrl = 'http://192.168.0.103:3000/getAccountData';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'accountId': accountId},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        // Error fetching data
        print('Failed to fetch user data. Status code: ${response.statusCode}');
        throw Exception('Failed to fetch user data');
      }
    } catch (error) {
      // Exception occurred during fetching data
      print('Error during fetching user data: $error');
      throw Exception('Error during fetching user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _userDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final balance = snapshot.data!['balance'];
          return Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color(0xFFF1E4C3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.account_balance_wallet,
                    size: 40, color: Colors.black),
                SizedBox(width: 10),
                Text(
                  balance.toString(),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }
}

class BalanceTrendCard extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const BalanceTrendCard({Key? key, this.userData}) : super(key: key);

  @override
  _BalanceTrendCardState createState() => _BalanceTrendCardState();
}

class _BalanceTrendCardState extends State<BalanceTrendCard> {
  late Future<List<Map<String, dynamic>>> _balanceTrendFuture;

  @override
  void initState() {
    super.initState();
    _balanceTrendFuture =
        fetchBalanceTrend(widget.userData!['accountId'].toString());
  }

  Future<List<Map<String, dynamic>>> fetchBalanceTrend(String accountId) async {
    final String apiUrl = 'http://192.168.0.103:3000/getBalanceTren';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'accountId': accountId},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        print(
            'Failed to fetch balance trend. Status code: ${response.statusCode}');
        throw Exception('Failed to fetch balance trend');
      }
    } catch (error) {
      print('Error during fetching balance trend: $error');
      throw Exception('Error during fetching balance trend');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _balanceTrendFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final trendData = snapshot.data!;
          final balance = trendData.isNotEmpty ? trendData.last['balance'] : 0;
          List<BalanceTrend> trendDatas = parseBalanceTrend(trendData);
          List<BalanceTrend> filteredData = filterTrendData(trendDatas);
          return Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color(0xFFF1E4C3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Balance Trend',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'TODAY',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 220,
                  child: Scaffold(
                    body: SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                        labelStyle:
                            TextStyle(fontSize: 12, color: Colors.black),
                      ),
                      backgroundColor: Color(0xFF7D9A73),
                      series: <LineSeries<BalanceTrend, String>>[
                        LineSeries<BalanceTrend, String>(
                          dataSource: filteredData,
                          xValueMapper: (BalanceTrend trend, _) =>
                              DateFormat('M/dd')
                                  .format(DateTime.parse(trend.x)),
                          yValueMapper: (BalanceTrend trend, _) => trend.y,
                          color: Color(0xFF062C80),
                          name: 'Balance Trend',
                          markerSettings: MarkerSettings(
                            isVisible: true,
                            color: Color(0xFF062C80),
                          ),
                        ),
                      ],
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                        toggleSeriesVisibility: false,
                        textStyle: TextStyle(color: Colors.black),
                      ),
                      primaryYAxis: NumericAxis(
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }
}

class OveralGoalsText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Text(
          'Overall Goals',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Lexend'),
        )
      ],
    ));
  }
}

class OverallGoalsCard extends StatelessWidget {
  final int totalCurrentGoal;
  final int totalEndGoal;

  OverallGoalsCard(
      {required this.totalCurrentGoal, required this.totalEndGoal});

  @override
  Widget build(BuildContext context) {
    double percentage = totalEndGoal != 0
        ? (totalCurrentGoal.toDouble() / totalEndGoal.toDouble())
            .clamp(0.0, 1.0)
        : 0.0;

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xFFF1E4C3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircularPercentIndicator(
                radius: 60.0,
                lineWidth: 22.0,
                percent: percentage,
                center: Text(
                  "${(percentage * 100).toStringAsFixed(0)}%",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                progressColor: Color(0xff597e52),
                backgroundColor: Color(0xffc6a969),
                circularStrokeCap: CircularStrokeCap.round,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Rp$totalCurrentGoal',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Container(
                    width: 110,
                    height: 1.0,
                    color: Colors.black,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Rp$totalEndGoal',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}

class BalanceTrendPage extends StatelessWidget {
  final Map<String, dynamic>? userData;

  const BalanceTrendPage({Key? key, required this.userData}) : super(key: key);

  Future<List<Map<String, dynamic>>?> fetchData(String accountId) async {
    final String apiUrl = 'http://192.168.0.103:3000/getAccountTransaction';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'accountId': accountId},
      );

      if (response.statusCode == 200) {
        // Successfully fetched data
        final List<dynamic> data = json.decode(response.body);
        // Convert data to List<Map<String, dynamic>>
        final List<Map<String, dynamic>> transactionDataList =
            List<Map<String, dynamic>>.from(data);
        return transactionDataList;
      } else {
        // Error fetching data
        print('Failed to fetch data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      // Exception occurred during fetching data
      print('Error during fetching data: $error');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFEC),
      body: Padding(
        padding: const EdgeInsets.only(top: 45, left: 37.5, right: 37.5),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Statisticstext(),
              SizedBox(height: 10),
              Statistictable(userData: userData!),
              SizedBox(height: 30),
              Transactiontext(),
              SizedBox(height: 10),
              FutureBuilder<List<Map<String, dynamic>>?>(
                future: fetchData(userData!['accountId'].toString()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Center(child: Text('No transactions available.'));
                  } else {
                    final List<Map<String, dynamic>> transactionDataList =
                        snapshot.data!;
                    return TransactionBox(transactions: transactionDataList);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Statisticstext extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Text(
          'Statistics',
          style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'Lexend'),
        )
      ],
    ));
  }
}

class Statistictable extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const Statistictable({Key? key, this.userData}) : super(key: key);

  @override
  _StatistictableState createState() => _StatistictableState();
}

class _StatistictableState extends State<Statistictable> {
  late Future<List<Map<String, dynamic>>> _balanceTrendFuture;

  @override
  void initState() {
    super.initState();
    _balanceTrendFuture =
        fetchBalanceTrend(widget.userData!['accountId'].toString());
  }

  Future<List<Map<String, dynamic>>> fetchBalanceTrend(String accountId) async {
    final String apiUrl = 'http://192.168.0.103:3000/getBalanceTren';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'accountId': accountId},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        print(
            'Failed to fetch balance trend. Status code: ${response.statusCode}');
        throw Exception('Failed to fetch balance trend');
      }
    } catch (error) {
      print('Error during fetching balance trend: $error');
      throw Exception('Error during fetching balance trend');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _balanceTrendFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final trendData = snapshot.data!;
          final balance = trendData.isNotEmpty ? trendData.last['balance'] : 0;
          List<BalanceTrend> trendDatas = parseBalanceTrend(trendData);
          List<BalanceTrend> filteredData = filterTrendData(trendDatas);
          return Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color(0xFFF1E4C3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Balance Trend',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'TODAY',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                Text(
                  'Rp.${balance.toStringAsFixed(0)},00',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 220,
                  child: Scaffold(
                    body: SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                        labelStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.black), // Set font color to black
                      ),
                      backgroundColor:
                          Color(0xFF7D9A73), // Set background color to 7D9A73
                      series: <LineSeries<BalanceTrend, String>>[
                        LineSeries<BalanceTrend, String>(
                          dataSource: filteredData,
                          xValueMapper: (BalanceTrend trend, _) =>
                              DateFormat('M/dd')
                                  .format(DateTime.parse(trend.x)),
                          yValueMapper: (BalanceTrend trend, _) => trend.y,
                          color: Color(0xFF062C80), // Set line color to 062C80
                          name: 'Balance Trend', // Set legend name
                          markerSettings: MarkerSettings(
                            isVisible: true,
                            color: Color(
                                0xFF062C80), // Set dot color same as line color
                          ), // Enable markers
                        ),
                      ],
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition
                            .bottom, // Adjust legend position if needed
                        toggleSeriesVisibility: false,
                        textStyle: TextStyle(
                            color:
                                Colors.black), // Set legend font color to black
                      ),
                      primaryYAxis: NumericAxis(
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }
}

class Transactiontext extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Text(
          'Transaction History',
          style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'Lexend'),
        )
      ],
    ));
  }
}

class TransactionBox extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;

  const TransactionBox({Key? key, required this.transactions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Center(
        child: Text('No transactions available.'),
      );
    }

    // Group transactions by transactionDate
    Map<String, List<Map<String, dynamic>>> groupedTransactions = {};
    for (var transaction in transactions) {
      String transactionDate = transaction['timestamps'] ?? '';
      if (!groupedTransactions.containsKey(transactionDate)) {
        groupedTransactions[transactionDate] = [];
      }
      groupedTransactions[transactionDate]!.add(transaction);
    }

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xFFF1E4C3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: groupedTransactions.entries.map((entry) {
          String transactionDate = entry.key;
          List<Map<String, dynamic>> transactionsForDate = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    transactionDate,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Column(
                children: transactionsForDate.map((transaction) {
                  return Row(
                    children: [
                      Image.asset(
                        transaction['transactionType'] == 'expense'
                            ? 'assets/ExpenseIcon.png'
                            : 'assets/IncomeIcon.png',
                        width: 24,
                        height: 24,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          transaction['title'] ?? '',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Text(
                        '${transaction['transactionType'] == 'expense' ? '-Rp' : '+Rp'}${transaction['amount'] ?? ''},00',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: transaction['transactionType'] == 'expense'
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class PlaylistPage extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const PlaylistPage({Key? key, required this.userData}) : super(key: key);

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  Future<List<Map<String, dynamic>>?>? _goalDataFuture;

  @override
  void initState() {
    super.initState();
    _goalDataFuture = fetchData(widget.userData!['accountId'].toString());
  }

  Future<void> _fetchData() async {
    setState(() {
      _goalDataFuture = fetchData(widget.userData!['accountId'].toString());
    });
  }

  Future<List<Map<String, dynamic>>?> fetchData(String accountId) async {
    final String apiUrl = 'http://192.168.0.103:3000/getAllGoal';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'accountId': accountId},
      );

      if (response.statusCode == 200) {
        // Successfully fetched data
        final List<dynamic> data = json.decode(response.body);
        // Convert data to List<Map<String, dynamic>>
        final List<Map<String, dynamic>> goalDataList =
            List<Map<String, dynamic>>.from(data);
        return goalDataList;
      } else {
        // Error fetching data
        print('Failed to fetch data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      // Exception occurred during fetching data
      print('Error during fetching data: $error');
      return null;
    }
  }

  Future<void> _deleteGoal(
      BuildContext context, Map<String, dynamic> goalData) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Are you sure you want to delete this goal?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // Call your deleteGoal API
                  var url = Uri.parse('http://192.168.0.103:3000/deleteGoal');
                  var response = await http.delete(
                    url,
                    body: {
                      'goalId': goalData['goalId'].toString(),
                      'accountId': goalData['accountId'].toString(),
                    },
                  );

                  if (response.statusCode == 200) {
                    // Close the dialog and refresh the page
                    Navigator.of(context).pop();
                    _fetchData();
                  } else {
                    // Handle error response from API
                    // Show error dialog or handle error message
                  }
                } catch (error) {
                  // Handle error during API call
                  print('Error: $error');
                  // Show error dialog or handle error message
                }
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userData == null) {
      // Handle the case where userData is null
      return Center(
        child: CircularProgressIndicator(), // Or any other loading indicator
      );
    }

    return FutureBuilder<List<Map<String, dynamic>>?>(
      future: _goalDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child:
                CircularProgressIndicator(), // Or any other loading indicator
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
                'Error: ${snapshot.error}'), // Or any other error handling UI
          );
        } else if (snapshot.hasData) {
          final List<Map<String, dynamic>>? goalDataList = snapshot.data;
          return Scaffold(
            backgroundColor: Color(0xFFFFFFEC),
            body: Padding(
              padding: const EdgeInsets.only(top: 45, left: 37.5, right: 37.5),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileCard(userData: widget.userData!),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: GoalsText(),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        // Show bottom sheet when GoalsTable is clicked;
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: GoalsTable(),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        children: goalDataList!.map((goalData) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: GoalsTable1(
                              goalData: goalData,
                              deleteGoal: () => _deleteGoal(context, goalData),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: Text('No data available'), // Or any other UI for empty data
          );
        }
      },
    );
  }
}

class ProfileCard extends StatelessWidget {
  final Map<String, dynamic>? userData;

  const ProfileCard({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final username = userData!['accountName'];
    final email = userData!['accountEmail'];

    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Color(0xFFF1E4C3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(
                'assets/profile_image.png'), // Placeholder for profile image
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align children to the start (left)
            children: [
              Text(
                username,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                email,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GoalsText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Text(
          'Goals',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Lexend'),
        )
      ],
    ));
  }
}

class GoalsTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Color(0xFFF1E4C3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              'Set Your Goals',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircularPercentIndicator(
                radius: 53.0,
                lineWidth: 20.0,
                percent: 0.0,
                center: Text(
                  "0%",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                progressColor: Color(0xff597e52),
                backgroundColor: Color(0xffc6a969),
                circularStrokeCap: CircularStrokeCap.round,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '-',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Container(
                    width: 110,
                    height: 1.0,
                    color: Colors.black,
                  ),
                  SizedBox(height: 5),
                  Text(
                    '-',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 5),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Add Goals >',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

class UpdateGoalForm extends StatefulWidget {
  final Map<String, dynamic> goalData;

  const UpdateGoalForm({Key? key, required this.goalData}) : super(key: key);

  @override
  _UpdateGoalFormState createState() => _UpdateGoalFormState();
}

class _UpdateGoalFormState extends State<UpdateGoalForm> {
  late TextEditingController _amountController = TextEditingController();
  late TextEditingController _endGoalController;

  @override
  void initState() {
    super.initState();
    _endGoalController =
        TextEditingController(text: widget.goalData['endGoal'].toString());
  }

  @override
  void dispose() {
    _amountController.dispose();
    _endGoalController.dispose();
    super.dispose();
  }

  Future<void> _updateGoal(BuildContext context) async {
    // Validate input fields
    if (_amountController.text.isEmpty || _endGoalController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please fill in all fields."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    // Implement your logic to update the goal
    final goalId = widget.goalData['goalId'].toString(); // Convert to string
    final accountId =
        widget.goalData['accountId'].toString(); // Convert to string
    final amount = _amountController.text;
    final endGoal = _endGoalController.text;

    // Call your updateGoal API
    try {
      var url = Uri.parse('http://192.168.0.103:3000/updateGoal');
      var response = await http.put(
        url,
        body: {
          'goalId': goalId,
          'accountId': accountId,
          'amount': amount,
          'endGoal': endGoal,
        },
      );

      if (response.statusCode == 200) {
        // Close the update goal form
        Navigator.pop(context);
      } else {
        // Display error message from API response
        final responseData = json.decode(response.body);
        final errorMessage = responseData['message'];

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(errorMessage ?? "Failed to update goal."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      print('Error: $error');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Failed to update goal. Please try again later."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Goal'),
        backgroundColor: Color(0xFFFFFFFEC),
      ),
      backgroundColor: Color(0xFFFFFFFEC), // Background color
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Goal Title: ${widget.goalData['goalTitle']}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20),
            buildTextField(
              controller: _amountController,
              labelText: 'Amount',
            ),
            SizedBox(height: 20),
            buildTextField(
              controller: _endGoalController,
              labelText: 'End Goal',
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _updateGoal(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF1E4C3), // Button background color
                textStyle: TextStyle(
                  color: Color(0xFF597E52), // Button text color
                ),
              ),
              child: Text(
                ('Update Goal'),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF597E52), // Bottom border color
          ),
        ),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            decorationColor: Colors.black,
            color: Colors.black,
            fontSize: 20,
          ),
          border: InputBorder.none, // Remove default border
          focusedBorder: InputBorder.none, // Remove focused border
          enabledBorder: InputBorder.none,
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the goal';
          }
          return null;
        },
      ),
    );
  }
}

class GoalsTable1 extends StatelessWidget {
  final Map<String, dynamic> goalData;
  final Future<void> Function() deleteGoal;

  const GoalsTable1({
    Key? key,
    required this.goalData,
    required this.deleteGoal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final goalTitle = goalData['goalTitle'] ?? 'No Title';
    final endGoal = goalData['endGoal'] ?? 1; // Avoid division by zero
    final currentGoal = goalData['currentGoal'] ?? 0;
    final percent = (currentGoal / endGoal).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UpdateGoalForm(goalData: goalData),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Color(0xFFF1E4C3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                goalTitle,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircularPercentIndicator(
                  radius: 53.0,
                  lineWidth: 20.0,
                  percent: percent,
                  center: Text(
                    "${(percent * 100).toStringAsFixed(0)}%",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  progressColor: Color(0xff597e52),
                  backgroundColor: Color(0xffc6a969),
                  circularStrokeCap: CircularStrokeCap.round,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Rp$currentGoal',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Container(
                      width: 110,
                      height: 1.0,
                      color: Colors.black,
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Rp$endGoal',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: deleteGoal,
                    child: Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Edit',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void logout(BuildContext context) {
  Navigator.of(context).pushReplacementNamed('/login');
}

class ProfilePage extends StatelessWidget {
  final Map<String, dynamic>? userData;

  const ProfilePage({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFEC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfilePic(userData: userData!),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ProfileInText(),
                  SizedBox(height: 10),
                  ProfileInfo(userData: userData!),
                  SizedBox(height: 30),
                  ProfileSetText(),
                  SizedBox(height: 10),
                  ProfileSet(
                    onLogout: () {
                      logout(context);
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePic extends StatelessWidget {
  final Map<String, dynamic>? userData;

  const ProfilePic({Key? key, this.userData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      // Handle the case where userData is null
      return CircularProgressIndicator(); // Or any other loading indicator
    }

    final username = userData!['accountName'] ?? '';
    final email = userData!['accountEmail'] ?? '';

    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff597e52), Color(0xffffffec)])),
      padding: EdgeInsets.only(top: 60, bottom: 30, left: 25, right: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align children to the start (left)
            children: [
              Text(
                username,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                email,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(
                'assets/profile_image.png'), // Placeholder for profile image
          ),
        ],
      ),
    );
  }
}

class ProfileInText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Profile Information',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Lexend'),
        ),
        Icon(Icons.edit, color: Colors.grey),
      ],
    ));
  }
}

class ProfileInfo extends StatelessWidget {
  final Map<String, dynamic>? userData;

  const ProfileInfo({Key? key, this.userData}) : super(key: key);

  Widget build(BuildContext context) {
    if (userData == null) {
      // Handle the case where userData is null
      return CircularProgressIndicator(); // Or any other loading indicator
    }

    final firstName = userData!['firstName'] ?? '';
    final lastName = userData!['lastName'] ?? '';
    final username = userData!['accountName'] ?? '';
    final email = userData!['accountEmail'] ?? '';

    return Container(
      padding: EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Color(0xFFF1E4C3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('First Name'),
                  SizedBox(height: 5),
                  Text(
                    firstName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(width: 120), // Adjust the width as needed for the gap
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Last Name'),
                  SizedBox(height: 5),
                  Text(
                    lastName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Text('User Name'),
          SizedBox(height: 5),
          Text(
            username,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text('Email'),
          SizedBox(height: 5),
          Text(
            email,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class ProfileSetText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Settings and Support',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Lexend'),
        ),
      ],
    ));
  }
}

class SwitchItems extends StatefulWidget {
  const SwitchItems({Key? key}) : super(key: key);

  @override
  State<SwitchItems> createState() => _SwitchItemsState();
}

class _SwitchItemsState extends State<SwitchItems> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.notifications_active),
      title: Text('Daily reminder'),
      trailing: Switch(
        onChanged: (value) {
          setState(() {
            isSelected = !isSelected;
          });
        },
        value: isSelected,
        activeColor: Colors.lightBlue,
      ),
    );
  }
}

class ProfileSet extends StatelessWidget {
  final VoidCallback onLogout;

  const ProfileSet({Key? key, required this.onLogout}) : super(key: key);
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color(0xFFF1E4C3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchItems(),
          ListTile(
            leading: Icon(Icons.policy),
            title: Text('Privacy policy'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('Privacy center'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.contact_support),
            title: Text('Contact us'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About us'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.article),
            title: Text('Terms of Service'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}
