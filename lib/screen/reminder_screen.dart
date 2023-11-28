// ignore_for_file: must_be_immutable, camel_case_types, unrelated_type_equality_checks, deprecated_member_use

import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medic/controller/reminder_controller.dart';
import 'package:medic/model/reminder_data_model.dart';
import 'package:medic/screen/add_medicine_screen.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';

class ReminderScreen extends StatelessWidget {
  ReminderController controller = Get.put(ReminderController());

  ReminderScreen({super.key});

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
              indicatorColor: AppColors.primaryColor,
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
          bottomSheet: Obx(
            () => controller.weekIndex != "" ||
                    controller.yearIndex != "" ||
                    controller.monthIndex != ""
                ? Container(
                    color: AppColors.white,
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.red,
                                    fixedSize: const Size(200, 45),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30))),
                                child: Text(
                                  ConstString.delete,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
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
                                        borderRadius:
                                            BorderRadius.circular(30))),
                                child: Text(
                                  ConstString.takeMedicine,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(
                    height: 0,
                  ),
          ),
          body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [weekWidget(), monthWidget(), const yearWidget()]),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniEndFloat,
          floatingActionButton: FloatingActionButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              backgroundColor: AppColors.primaryColor,
              onPressed: () {
                Get.to(() => AddMedicineScreen());
              },
              child: Icon(
                Icons.add,
                color: AppColors.white,
              )),
        ));
  }
}

class weekWidget extends StatelessWidget {
  ReminderController controller = Get.put(ReminderController());

  weekWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: controller.fetchReminder(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CupertinoActivityIndicator(
            color: AppColors.primaryColor,
            radius: 15,
          ));
        } else if (snapshot.hasError) {
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColors.tilePrimaryColor),
            child: Text(
              "Error : ${snapshot.error}",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: AppColors.primaryColor,
                  fontSize: 15,
                  fontFamily: AppFont.fontMedium),
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          List<ReminderDataModel> reminders = snapshot.data!;
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
                    itemBuilder: (context, dayNumber, dayName, monthName,
                        fullDate, isSelected) {
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
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      color: isSelected
                                          ? AppColors.white
                                          : AppColors.txtGrey),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "${fullDate.day}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
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
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: reminders.length,
                    itemBuilder: (context, index) {
                      return Obx(() => GestureDetector(
                            onTap: () {
                              controller.weekIndex.value = index.toString();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                        Border.all(color: AppColors.lineGrey)),
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
                                            "${reminders[index].medicineName}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    fontFamily:
                                                        AppFont.fontBold),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "${reminders[index].pillCount} Capsule | ${reminders[index].dosageInMg} mg",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                    color: AppColors.txtGrey),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "${reminders[index].time}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                  color: AppColors.txtGrey,
                                                  fontFamily:
                                                      AppFont.fontRegular,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      controller.weekIndex == "$index"
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
              ],
            ),
          );
        } else {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppImages.emptyBin),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    ConstString.noReminder,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 15, color: AppColors.skipGrey),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class monthWidget extends GetWidget<ReminderController> {
  @override
  ReminderController controller = Get.put(ReminderController());

  monthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: controller.fetchReminder(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CupertinoActivityIndicator(
              color: AppColors.primaryColor,
              radius: 15,
            ),
          );
        } else if (snapshot.hasError) {
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColors.tilePrimaryColor),
            child: Text(
              "Error : ${snapshot.error}",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: AppColors.primaryColor,
                  fontSize: 17,
                  fontFamily: AppFont.fontMedium),
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          List<ReminderDataModel> reminders = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: EasyDateTimeLine(
                    activeColor: Colors.transparent,
                    initialDate: DateTime.now(),
                    // activeColor: AppColors.primaryColor,
                    timeLineProps: const EasyTimeLineProps(),
                    dayProps: const EasyDayProps(
                        dayStructure: DayStructure.dayStrDayNum,
                        height: 85,
                        width: 30),
                    headerProps: EasyHeaderProps(
                        monthPickerType: MonthPickerType.dropDown,
                        monthStyle: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(
                                fontFamily: AppFont.fontMedium, fontSize: 15),
                        padding: EdgeInsets.zero,
                        selectedDateStyle: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(
                                fontFamily: AppFont.fontMedium, fontSize: 15),
                        selectedDateFormat:
                            SelectedDateFormat.fullDateDMonthAsStrY,
                        showMonthPicker: true,
                        showSelectedDate: true),
                    itemBuilder: (context, dayNumber, dayName, monthName,
                        fullDate, isSelected) {
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
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      color: isSelected
                                          ? AppColors.white
                                          : AppColors.txtGrey),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "${fullDate.day}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
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
                  flex: 10,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: reminders.length,
                    itemBuilder: (context, index) {
                      return Obx(() => GestureDetector(
                            onTap: () {
                              controller.monthIndex.value = index.toString();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                        Border.all(color: AppColors.lineGrey)),
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
                                            "${reminders[index].medicineName}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    fontFamily:
                                                        AppFont.fontBold),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "${reminders[index].pillCount} Capsule | ${reminders[index].dosageInMg} mg",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                    color: AppColors.txtGrey),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "${reminders[index].time}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                  color: AppColors.txtGrey,
                                                  fontFamily:
                                                      AppFont.fontRegular,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      controller.monthIndex == "$index"
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
              ],
            ),
          );
        } else {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppImages.emptyBin),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    ConstString.noReminder,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 15, color: AppColors.skipGrey),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class yearWidget extends GetWidget<ReminderController> {
  const yearWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: controller.fetchReminder(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CupertinoActivityIndicator(
            color: AppColors.primaryColor,
            radius: 15,
          ));
        } else if (snapshot.hasError) {
          return Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColors.tilePrimaryColor),
            child: Text(
              "Error : ${snapshot.error}",
              // selectionColor: Colors.transparent,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: AppColors.primaryColor,
                  fontSize: 17,
                  fontFamily: AppFont.fontMedium),
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          List<ReminderDataModel> reminders = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Obx(() => GestureDetector(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    primaryColor: AppColors.primaryColor,
                                    hintColor: AppColors.primaryColor,
                                    datePickerTheme: DatePickerThemeData(
                                        dayStyle: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                        weekdayStyle: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                        headerHelpStyle: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                        headerHeadlineStyle: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                        yearStyle: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                        dividerColor: AppColors.green,
                                        surfaceTintColor: AppColors.green),
                                    colorScheme: ColorScheme.light(
                                      primary: AppColors.primaryColor,
                                      onPrimary: AppColors.white,
                                      onSurface: AppColors.darkPrimaryColor,
                                      secondary: AppColors.darkPrimaryColor,
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        primary: AppColors
                                            .primaryColor, // button text color
                                      ),
                                    ),
                                    // Other text styles can be set here too
                                    textTheme: TextTheme(
                                      subtitle1: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                      button: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ),
                                  child: child!,
                                );
                              });

                          if (pickedDate != null) {
                            controller.selectedDate = pickedDate;
                            controller.selectedFormateDate.value =
                                DateFormat('dd MMMM yyyy')
                                    .format(controller.selectedDate!);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          height: 38,
                          width: 210,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: AppColors.decsGrey,
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(AppIcons.calender, height: 20),
                                const SizedBox(width: 10),
                                Text(
                                  "${controller.selectedFormateDate.value}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                          fontSize: 14,
                                          color: AppColors.txtGrey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                ),
                Expanded(
                  flex: 9,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: reminders.length,
                    itemBuilder: (context, index) {
                      return Obx(() => GestureDetector(
                            onTap: () {
                              controller.yearIndex.value = index.toString();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                        Border.all(color: AppColors.lineGrey)),
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
                                            "${reminders[index].medicineName}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    fontFamily:
                                                        AppFont.fontBold),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "${reminders[index].pillCount} Capsule | ${reminders[index].dosageInMg} mg",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                    color: AppColors.txtGrey),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "${reminders[index].time}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                  color: AppColors.txtGrey,
                                                  fontFamily:
                                                      AppFont.fontRegular,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      controller.yearIndex == "$index"
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
              ],
            ),
          );
        } else {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppImages.emptyBin),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    ConstString.noReminder,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 15, color: AppColors.skipGrey),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
