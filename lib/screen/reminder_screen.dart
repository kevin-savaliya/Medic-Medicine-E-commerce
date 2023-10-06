import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medic/controller/reminder_controller.dart';
import 'package:medic/screen/add_medicine_screen.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SvgPicture.asset(
                  AppIcons.back,
                ),
              ),
            ),
            titleSpacing: 0,
            title: Text(ConstString.reminder,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontFamily: AppFont.fontBold)),
            elevation: 1.5,
            shadowColor: AppColors.txtGrey.withOpacity(0.2),
            bottom: TabBar(
              automaticIndicatorColorAdjustment: true,
              tabs: const [
                Tab(
                  text: 'Week',
                  height: 40,
                ),
                Tab(
                  text: 'Month',
                  height: 40,
                ),
                Tab(
                  text: 'Year',
                  height: 40,
                ),
              ],
              // physics: const BouncingScrollPhysics(),
              labelColor: AppColors.primaryColor,
              labelStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontSize: 13.5,
                  letterSpacing: 0.3,
                  fontFamily: AppFont.fontMedium),
              unselectedLabelColor: AppColors.txtGrey,
              indicatorSize: TabBarIndicatorSize.tab,
              unselectedLabelStyle: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(
                      fontSize: 14,
                      letterSpacing: 0.3,
                      fontFamily: AppFont.fontMedium),
              indicatorWeight: 2,
            ),
          ),
          body:
              TabBarView(children: [weekWidget(), monthWidget(), yearWidget()]),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 65),
            child: FloatingActionButton(
                backgroundColor: AppColors.primaryColor,
                onPressed: () {
                  Get.to(() => AddMedicineScreen());
                },
                child: Icon(
                  Icons.add,
                  color: AppColors.white,
                )),
          ),
        ));
  }
}

class weekWidget extends StatelessWidget {
  ReminderController controller = Get.put(ReminderController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: EasyDateTimeLine(
              initialDate: DateTime.now(),
              // activeColor: AppColors.primaryColor,
              timeLineProps: const EasyTimeLineProps(),
              dayProps: const EasyDayProps(
                  dayStructure: DayStructure.dayStrDayNum,
                  height: 85,
                  width: 30),
              headerProps: const EasyHeaderProps(
                  showMonthPicker: false, showSelectedDate: false),
              itemBuilder: (context, dayNumber, dayName, monthName, fullDate,
                  isSelected) {
                return Container(
                  width: 45,
                  decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.decsGrey,
                      borderRadius: BorderRadius.circular(50)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayName,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: isSelected
                                ? AppColors.white
                                : AppColors.txtGrey),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${fullDate.day}",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: 14,
                            fontFamily: AppFont.fontMedium,
                            color: isSelected
                                ? AppColors.white
                                : AppColors.txtGrey),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 9,
            child: Container(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Obx(() => GestureDetector(
                        onTap: () {
                          controller.index.value = index;
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.lineGrey)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
                              child: Row(
                                children: [
                                  Image.asset("asset/medicinebox.jpg",
                                      height: 50),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Iconic Remedies",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontFamily: AppFont.fontBold),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "1 Capsule | 20 mg",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(color: AppColors.txtGrey),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "7:00 AM",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                              color: AppColors.txtGrey,
                                              fontFamily: AppFont.fontRegular,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  controller.index == index
                                      ? SvgPicture.asset(
                                          AppIcons.checkFill,
                                          height: 22,
                                          color: AppColors.primaryColor,
                                        )
                                      : SvgPicture.asset(
                                          AppIcons.checkUnFill,
                                          height: 22,
                                        )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ));
                },
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        fixedSize: const Size(200, 45),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    child: Text(
                      ConstString.delete,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 14,
                            color: AppColors.white,
                          ),
                    )),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        fixedSize: const Size(200, 45),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    child: Text(
                      ConstString.takeMedicine,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class monthWidget extends GetWidget<ReminderController> {
  ReminderController controller = Get.put(ReminderController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: EasyDateTimeLine(
              initialDate: DateTime.now(),
              // activeColor: AppColors.primaryColor,
              timeLineProps: const EasyTimeLineProps(),
              dayProps: const EasyDayProps(
                  dayStructure: DayStructure.dayStrDayNum,
                  height: 85,
                  width: 30),
              headerProps: const EasyHeaderProps(
                  showMonthPicker: false, showSelectedDate: false),
              itemBuilder: (context, dayNumber, dayName, monthName, fullDate,
                  isSelected) {
                return Container(
                  width: 45,
                  decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.decsGrey,
                      borderRadius: BorderRadius.circular(50)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayName,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: isSelected
                                ? AppColors.white
                                : AppColors.txtGrey),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${fullDate.day}",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: 14,
                            fontFamily: AppFont.fontMedium,
                            color: isSelected
                                ? AppColors.white
                                : AppColors.txtGrey),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 9,
            child: Container(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Obx(() => GestureDetector(
                        onTap: () {
                          controller.index.value = index;
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.lineGrey)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
                              child: Row(
                                children: [
                                  Image.asset("asset/medicinebox.jpg",
                                      height: 50),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Iconic Remedies",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontFamily: AppFont.fontBold),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "1 Capsule | 20 mg",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(color: AppColors.txtGrey),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "7:00 AM",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                              color: AppColors.txtGrey,
                                              fontFamily: AppFont.fontRegular,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  controller.index == index
                                      ? SvgPicture.asset(
                                          AppIcons.checkFill,
                                          height: 22,
                                          color: AppColors.primaryColor,
                                        )
                                      : SvgPicture.asset(
                                          AppIcons.checkUnFill,
                                          height: 22,
                                        )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ));
                },
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        fixedSize: const Size(200, 45),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    child: Text(
                      ConstString.delete,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 14,
                            color: AppColors.white,
                          ),
                    )),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        fixedSize: const Size(200, 45),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    child: Text(
                      ConstString.takeMedicine,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class yearWidget extends GetWidget<ReminderController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: EasyDateTimeLine(
              initialDate: DateTime.now(),
              // activeColor: AppColors.primaryColor,
              timeLineProps: const EasyTimeLineProps(),
              dayProps: const EasyDayProps(
                  dayStructure: DayStructure.dayStrDayNum,
                  height: 85,
                  width: 30),
              headerProps: const EasyHeaderProps(
                  showMonthPicker: false, showSelectedDate: false),
              itemBuilder: (context, dayNumber, dayName, monthName, fullDate,
                  isSelected) {
                return Container(
                  width: 45,
                  decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.decsGrey,
                      borderRadius: BorderRadius.circular(50)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayName,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: isSelected
                                ? AppColors.white
                                : AppColors.txtGrey),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${fullDate.day}",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: 14,
                            fontFamily: AppFont.fontMedium,
                            color: isSelected
                                ? AppColors.white
                                : AppColors.txtGrey),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 9,
            child: Container(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Obx(() => GestureDetector(
                        onTap: () {
                          controller.index.value = index;
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.lineGrey)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
                              child: Row(
                                children: [
                                  Image.asset("asset/medicinebox.jpg",
                                      height: 50),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Iconic Remedies",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontFamily: AppFont.fontBold),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "1 Capsule | 20 mg",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(color: AppColors.txtGrey),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "7:00 AM",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                              color: AppColors.txtGrey,
                                              fontFamily: AppFont.fontRegular,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  controller.index == index
                                      ? SvgPicture.asset(
                                          AppIcons.checkFill,
                                          height: 22,
                                          color: AppColors.primaryColor,
                                        )
                                      : SvgPicture.asset(
                                          AppIcons.checkUnFill,
                                          height: 22,
                                        )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ));
                },
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        fixedSize: const Size(200, 45),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    child: Text(
                      ConstString.delete,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 14,
                            color: AppColors.white,
                          ),
                    )),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        fixedSize: const Size(200, 45),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    child: Text(
                      ConstString.takeMedicine,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }
}
