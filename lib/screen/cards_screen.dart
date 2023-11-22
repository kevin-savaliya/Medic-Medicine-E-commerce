import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medic/controller/cart_controller.dart';
import 'package:medic/model/credit_card_model.dart';
import 'package:medic/screen/card_details.dart';
import 'package:medic/theme/colors.dart';
import 'package:medic/utils/app_font.dart';
import 'package:medic/utils/assets.dart';
import 'package:medic/utils/string.dart';
import 'package:medic/widgets/shimmer_widget.dart';

class CardsScreen extends StatelessWidget {
  CartController controller = Get.put(CartController());

  CardsScreen({super.key});

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
        title: Text(ConstString.creditCards,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontFamily: AppFont.fontBold)),
        elevation: 1.5,
        shadowColor: AppColors.txtGrey.withOpacity(0.2),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
          onPressed: () {
            Get.to(() => CardDetails());
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              fixedSize: const Size(200, 50),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: AppColors.white,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                ConstString.addNewCard,
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ],
          )),
      body: StreamBuilder(
        stream: controller.fetchCards(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Container(height: 600, child: CardShimmer(itemCount: 5)),
            );
          } else if (snapshot.hasData) {
            List<CreditCard> cards = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: ListView.builder(
                padding: EdgeInsets.only(bottom: 50),
                shrinkWrap: true,
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    height: 170,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                            colors: AppColors
                                .cardList[index % AppColors.cardList.length],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight)),
                    child: Stack(
                      children: [
                        index % 2 == 0
                            ? Image.asset(AppImages.card1)
                            : Image.asset(AppImages.card2),
                        index % 2 == 0
                            ? Image.asset(AppImages.card11)
                            : Image.asset(AppImages.card22),
                        Positioned(
                            left: 30,
                            top: 30,
                            child: SvgPicture.asset(AppImages.creditTxtSVG)),
                        Positioned(
                            right: 30,
                            top: 30,
                            child: SvgPicture.asset(AppImages.visa)),
                        Positioned(
                            bottom: 20,
                            left: 30,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${cards[index].cardHolder}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          color: AppColors.white, fontSize: 14),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "${cards[index].cardNumber}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          color: AppColors.white,
                                          letterSpacing: 2),
                                ),
                              ],
                            )),
                      ],
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AppImages.emptyBin),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      ConstString.noCard,
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
      ),
    );
  }
}
