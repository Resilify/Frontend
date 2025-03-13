import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/models/user_main.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});
  
  @override
  _CustomAppBarState createState() => _CustomAppBarState();
  
  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class _CustomAppBarState extends State<CustomAppBar> {
  String firstName = "User"; // Default name if Hive data is empty
  
  @override
  void initState() {
    super.initState();
    _loadUserName(); // Fetch latest name from Hive
  }
  
  Future<void> _loadUserName() async {
    var userBox = Hive.box<UserMain>('user_main');
    if (userBox.isNotEmpty) {
      setState(() {
        firstName = userBox.values.last.firstName; // Get latest added name
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.secondaryColor,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              //Icon(Icons.person, color: AppColors.primaryTextColor),
             // const SizedBox(width: 8),
              Text("Hello $firstName", style: TextStyle(color: AppColors.primaryTextColor)),
            ],
          ),
          Row(
            children: [
              Text("15", style: TextStyle(color: AppColors.primaryTextColor)),
              const SizedBox(width: 4),
              Image.asset(
                'assets/img/streak.png',
                height: 25,
                width: 25,
              ),
              const SizedBox(width: 10),
              Text("280", style: TextStyle(color: AppColors.primaryTextColor)),
              const SizedBox(width: 4),
              Image.asset(
                'assets/img/star.png',
                height: 30,
                width: 30,
              ),
            ],
          ),
        ],
      ),
    );
  }
}