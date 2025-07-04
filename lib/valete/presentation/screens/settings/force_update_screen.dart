import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:valet_app/valete/presentation/components/text/text_utils.dart';
import 'package:valet_app/valete/presentation/resources/colors_manager.dart';
import '../../../../core/l10n/app_locale.dart';
import '../../resources/assets_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/values_manager.dart';

class NotUpdatedVersion extends StatelessWidget {
  const NotUpdatedVersion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: ColorManager.background,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Lottie.asset(
              LottieManager.update, // Replace with the actual path
              width: 300,
              height: 300,
              fit: BoxFit.cover,
            ),
            Container(
              margin: const EdgeInsets.only(top: AppMargin.m10),
              child: TextUtils(
                text:AppLocalizations.of(context)!.pleaseUpdatedLatestVersion,

                  fontSize: FontSize.s17,
                  fontWeight: FontWeight.w400,
                  color: ColorManager.white
                
              ),
            ),
            Container(
              height: AppSizeHeight.s50,
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .25,
                vertical: 20,
              ),
              child: Builder(
                builder:
                    (context) => ElevatedButton(
                      onPressed: () async {
                        // go to google play for updates
                        String url =
                            Platform.isIOS
                                ?'https://apps.apple.com/eg/app/iti-attendance/id6747185582'
                                : 'https://play.google.com/store/apps/details?id=com.iti.attendence' ;
                        launch(url);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.primary,
                        side: BorderSide(color: Theme.of(context).primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizeHeight.s25,
                          ),
                        ),
                      ),
                      child: Container(

                        alignment: Alignment.center,
                        child: TextUtils(
                         text: Platform.isIOS
                              ? AppLocalizations.of(context)!.goToAppStore
                              : AppLocalizations.of(context)!.goToGooglePlay,
                            color: ColorManager.background,
                            fontWeight: FontWeight.bold,
                            fontSize: FontSize.s15,
                          ),
                        ),
                      ),
                    ),
              ),

          ],
        ),
      ),
    );
  }

  // Function to launch a URL
  _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
