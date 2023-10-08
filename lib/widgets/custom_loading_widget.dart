import 'package:flutter/cupertino.dart';
import 'package:medic/_dart/_init.dart';

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(
      color: AppColors.primaryColor,
      animating: true,
      radius: 20,
    );
  }
}
