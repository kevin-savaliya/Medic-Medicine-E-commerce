// ignore_for_file: use_build_context_synchronously, deprecated_member_use, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medic/controller/reminder_controller.dart';
import 'package:medic/model/reminder_data_model.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';
import 'package:medic/widgets/app_dialogue.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddMedicineScreen extends StatelessWidget {
  final ReminderController controller = Get.put(ReminderController());

  AddMedicineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text(ConstString.addMedicine,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontFamily: AppFont.fontBold)),
        elevation: 1.5,
        shadowColor: AppColors.txtGrey.withOpacity(0.2),
      ),
      body: addMedicineWidget(context, controller),
    );
  }

  Widget addMedicineWidget(
      BuildContext context, ReminderController controller) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                ConstString.medicineName,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontFamily: AppFont.fontMedium, color: AppColors.txtGrey),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 50,
              child: TextFormField(
                textCapitalization: TextCapitalization.sentences,
                controller: controller.medicineController,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: AppColors.txtGrey, fontSize: 14.5),
                cursorColor: AppColors.txtGrey,
                decoration: InputDecoration(
                  hintText: "Enter Medicine",
                  hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontFamily: AppFont.fontMedium,
                      color: AppColors.phoneGrey,
                      fontSize: 13.5),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: SvgPicture.asset(
                      AppIcons.pill,
                      color: AppColors.txtGrey.withOpacity(0.8),
                    ),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide(color: AppColors.decsGrey)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.decsGrey, width: 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.decsGrey, width: 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.decsGrey, width: 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  // contentPadding:
                  //     const EdgeInsets.symmetric(vertical: 5, horizontal: 20)
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          ConstString.amount,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  fontFamily: AppFont.fontMedium,
                                  color: AppColors.txtGrey),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          controller: controller.amountController,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: AppColors.txtGrey, fontSize: 14.5),
                          cursorColor: AppColors.txtGrey,
                          decoration: InputDecoration(
                            hintText: "Pills",
                            hintStyle: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontFamily: AppFont.fontMedium,
                                    color: AppColors.phoneGrey,
                                    fontSize: 13.5),
                            prefixIcon: Padding(
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 15),
                              child: SvgPicture.asset(
                                AppIcons.pill,
                                color: AppColors.txtGrey.withOpacity(0.8),
                              ),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide:
                                    BorderSide(color: AppColors.decsGrey)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.decsGrey, width: 1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.decsGrey, width: 1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.decsGrey, width: 1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            // contentPadding:
                            //     const EdgeInsets.symmetric(vertical: 5, horizontal: 20)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          ConstString.dosage,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  fontFamily: AppFont.fontMedium,
                                  color: AppColors.txtGrey),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          controller: controller.doseController,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: AppColors.txtGrey, fontSize: 14.5),
                          cursorColor: AppColors.txtGrey,
                          decoration: InputDecoration(
                            hintText: "Dose",
                            hintStyle: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontFamily: AppFont.fontMedium,
                                    color: AppColors.phoneGrey,
                                    fontSize: 13.5),
                            prefixIcon: Padding(
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 15),
                              child: SvgPicture.asset(
                                AppIcons.pill,
                                color: AppColors.txtGrey.withOpacity(0.8),
                              ),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide:
                                    BorderSide(color: AppColors.decsGrey)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.decsGrey, width: 1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.decsGrey, width: 1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.decsGrey, width: 1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            // contentPadding:
                            //     const EdgeInsets.symmetric(vertical: 5, horizontal: 20)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                ConstString.frequency,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontFamily: AppFont.fontMedium, color: AppColors.txtGrey),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.decsGrey),
                  borderRadius: BorderRadius.circular(50)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AppIcons.calender,
                      height: 18,
                      color: AppColors.txtGrey.withOpacity(0.8),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      child: Obx(
                        () => DropdownButton(
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontSize: 13),
                          hint: Text(
                            "Select Frequency",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    fontSize: 14, color: AppColors.txtGrey),
                          ),
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 130),
                            child: SvgPicture.asset(AppIcons.arrowDown),
                          ),
                          underline: const SizedBox(),
                          borderRadius: BorderRadius.circular(10),
                          onChanged: (value) {
                            controller.frequencyValue.value = value!;
                          },
                          items: controller.frequencyList.isNotEmpty
                              ? controller.frequencyList.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(
                                      items,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(fontSize: 13),
                                    ),
                                  );
                                }).toList()
                              : null,
                          value: controller.frequencyList
                                  .contains(controller.frequencyValue.value)
                              ? controller.frequencyValue.value
                              : null,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(
              () => controller.frequencyValue == "Date-Duration"
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SfDateRangePicker(
                        onSelectionChanged:
                            (DateRangePickerSelectionChangedArgs args) {
                          if (args.value is PickerDateRange) {
                            final range = args.value as PickerDateRange;

                            String? start = range.startDate
                                ?.toIso8601String()
                                .split('T')
                                .first;
                            String? end = range.endDate
                                ?.toIso8601String()
                                .split('T')
                                .first;

                            controller.frequencyValue = "$start to $end".obs;
                          }
                        },
                        selectionMode: DateRangePickerSelectionMode.range,
                        rangeTextStyle: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: 13),
                        startRangeSelectionColor: AppColors.primaryColor,
                        endRangeSelectionColor: AppColors.primaryColor,
                        selectionShape: DateRangePickerSelectionShape.circle,
                        headerStyle: DateRangePickerHeaderStyle(
                            textStyle: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color: AppColors.black,
                                    fontFamily: AppFont.fontMedium)),
                        allowViewNavigation: true,
                        selectionColor: AppColors.primaryColor,
                        selectionTextStyle: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: 13, color: AppColors.white),
                        rangeSelectionColor: AppColors.tilePrimaryColor,
                      ),
                    )
                  : const SizedBox(),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                ConstString.time,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontFamily: AppFont.fontMedium, color: AppColors.txtGrey),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 50,
              child: TextFormField(
                controller: controller.timeController,
                readOnly: true,
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: controller.selectedTime,
                  );
                  if (pickedTime != null) {
                    controller.selectedTime = pickedTime;
                    controller.timeController.text = pickedTime.format(context);
                  }
                },
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: AppColors.txtGrey, fontSize: 14.5),
                cursorColor: AppColors.txtGrey,
                decoration: InputDecoration(
                  hintText: "Select Time",
                  hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontFamily: AppFont.fontMedium,
                      color: AppColors.phoneGrey,
                      fontSize: 13.5),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: SvgPicture.asset(
                      AppIcons.watch,
                      color: AppColors.txtGrey.withOpacity(0.8),
                    ),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide(color: AppColors.decsGrey)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.decsGrey, width: 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.decsGrey, width: 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.decsGrey, width: 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  // contentPadding:
                  //     const EdgeInsets.symmetric(vertical: 5, horizontal: 20)
                ),
              ),
            ),
            const SizedBox(
              height: 200,
            ),
            ElevatedButton(
                onPressed: () {
                  if (controller.validateData()) {
                    showProgressDialogue(context);
                    String id = controller.reminderRef.doc().id;
                    ReminderDataModel reminderModel = ReminderDataModel(
                        id: id,
                        medicineName: controller.medicineController.text.trim(),
                        pillCount: int.parse(controller.amountController.text),
                        dosageInMg: int.parse(controller.doseController.text),
                        frequency: controller.frequencyValue.value,
                        time: controller.timeController.text.trim());
                    controller.addReminderdata(reminderModel);
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    fixedSize: const Size(200, 50),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                child: Text(
                  ConstString.save,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: Colors.white,
                      ),
                )),
          ],
        ),
      ),
    );
  }
}
