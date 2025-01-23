import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.secondaryColor,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.person,
                    color: AppColors.tertiaryColor,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Full Name',
                    style: TextStyle(
                      color: AppColors.tertiaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        color: AppColors.tertiaryColor,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '15',
                        style: TextStyle(
                          color: AppColors.tertiaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 20),
                  Row(
                    children: [
                      Icon(
                        Icons.monetization_on,
                        color: AppColors.tertiaryColor,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '280',
                        style: TextStyle(
                          color: AppColors.tertiaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
  }
}