import 'package:flutter/material.dart';
import 'package:too_too/core/di/service_locator.dart';
import 'package:too_too/core/theme/colors.dart';
import 'package:too_too/features/dashboard/models/status.dart';
import 'package:too_too/shared/service/user_service.dart';
import 'widgets/account_widget.dart';

class ProfileScreen extends StatefulWidget {
  final String? accountId;
  const ProfileScreen({super.key, this.accountId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Account?> _accountFuture;

  @override
  void initState() {
    super.initState();
    if (widget.accountId != null) {
      _accountFuture = getIt<UserService>().getAccount(widget.accountId!);
    } else {
      _accountFuture = getIt<UserService>().getCurrentAccount();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.primary,
          onPressed: () {
            if (Navigator.canPop(context)) Navigator.pop(context);
          },
        ),
        title: const Text('PROFILER_VIEW', style: TextStyle(letterSpacing: 2, fontSize: 16)),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<Account?>(
        future: _accountFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          } else if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Failed to load profile data.', style: TextStyle(color: AppColors.error)));
          }

          final account = snapshot.data!;

          return AccountWidget(account: account);
        },
      ),
    );
  }
}
