import 'package:loading_indicator/loading_indicator.dart';
import 'package:medic/_dart/_init.dart';

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.center,
      child: SizedBox(
        height: 50,
        width: 50,
        child: LoadingIndicator(
          colors: [AppColors.primaryColor],
          indicatorType: Indicator.ballScale,
          strokeWidth: 1,
        ),
      ),
    );
  }

  /*@override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(
      color: AppColors.primaryColor,
      animating: true,
      radius: 20,
    );
  }*/
}
