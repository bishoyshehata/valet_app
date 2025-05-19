import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/enums.dart';
import '../controllers/re_auth/re_auth_bloc.dart';
import '../controllers/re_auth/re_auth_events.dart';
import '../controllers/re_auth/re_auth_states.dart';

class ReAuthListenerWidget extends StatelessWidget {
  final Widget child;

  const ReAuthListenerWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReAuthBloc, ReAuthState>(
      listener: (context, state) {
        if (state.status == ReAuthStatus.waitingForPassword) {
          String password = '';
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) => AlertDialog(
              title: Text("إعادة تسجيل الدخول"),
              content: TextField(
                obscureText: true,
                onChanged: (val) => password = val,
                decoration: InputDecoration(labelText: "كلمة المرور"),
              ),
              actions: [
                TextButton(
                  onPressed: () => context.read<ReAuthBloc>().add(RequestReAuth(password)),
                  child: Text("تأكيد"),
                )
              ],
            ),
          );
        }

        if (state.status == ReAuthStatus.success) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      },
      child: child,
    );
  }
}
