import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valet_app/core/utils/enums.dart';
import 'package:valet_app/valete/presentation/controllers/profile/profile_states.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../core/l10n/app_locale.dart';
import '../../../controllers/profile/profile_bloc.dart';
import '../../../controllers/profile/profile_events.dart';
import '../../../resources/strings_manager.dart';

class TermAndConditions extends StatelessWidget {
  const TermAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) {
          context.read<ProfileBloc>().add(LoadTermsEvent());
        },
        onPageFinished: (_) {
          context.read<ProfileBloc>().add(TermsLoadedEvent());
        },
      ))
      ..loadRequest(Uri.parse('https://valet.vps.kirellos.com/terms'));

    return Scaffold(
      appBar: AppBar(title:  Text(AppLocalizations.of(context)!.termsAndConditions)),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          switch (state.termsState) {
            case RequestState.loading:
              return const Center(child: CircularProgressIndicator());
            case RequestState.loaded:
              return WebViewWidget(controller: controller);
            case RequestState.error:
              return  Center(child: Text(AppLocalizations.of(context)!.errorLoadingTermsAndConditions));
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
