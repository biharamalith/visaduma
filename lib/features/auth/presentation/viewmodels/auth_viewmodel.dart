// ============================================================
// FILE: lib/features/auth/presentation/viewmodels/auth_viewmodel.dart
// PURPOSE: Riverpod AsyncNotifier that manages auth state.
//          Exposes login(), register(), logout() to screens.
//          State: AsyncValue<UserEntity?> (null = not logged in).
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../../../core/network/dio_client.dart';

// ── Notifier ──────────────────────────────────────────────

class AuthNotifier extends AsyncNotifier<UserEntity?> {
  late final LoginUsecase _loginUsecase;
  late final RegisterUsecase _registerUsecase;
  late final LogoutUsecase _logoutUsecase;

  @override
  Future<UserEntity?> build() async {
    final repo = AuthRepositoryImpl(
      AuthRemoteDatasourceImpl(DioClient.instance),
      const AuthLocalDatasourceImpl(),
    );
    _loginUsecase = LoginUsecase(repo);
    _registerUsecase = RegisterUsecase(repo);
    _logoutUsecase = LogoutUsecase(repo);

    // Check if the user is already authenticated.
    final result = await repo.getCurrentUser();
    return result.fold((_) => null, (user) => user);
  }

  // ── Actions ───────────────────────────────────────────────

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    // ── DEV BYPASS: skip API when no backend is running ──
    if (email == 'user@gmail.com' && password == '123456') {
      state = AsyncData(UserEntity(
        id: 'dev-user-001',
        fullName: 'Dev User',
        email: email,
        phone: '0712345678',
        role: 'user',
        isVerified: true,
        createdAt: DateTime.now(),
      ));
      return null; // success
    }
    // ── END DEV BYPASS ──────────────────────────────────

    final result = await _loginUsecase(email: email, password: password);
    return result.fold(
      (failure) {
        state = const AsyncData(null);
        return failure.message;
      },
      (user) {
        state = AsyncData(user);
        return null; // null = success
      },
    );
  }

  Future<String?> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    state = const AsyncLoading();
    final result = await _registerUsecase(
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
      role: role,
    );
    return result.fold(
      (failure) {
        state = const AsyncData(null);
        return failure.message;
      },
      (user) {
        state = AsyncData(user);
        return null;
      },
    );
  }

  Future<void> logout() async {
    await _logoutUsecase();
    state = const AsyncData(null);
  }
}

// ── Provider ──────────────────────────────────────────────

/// Global auth state provider.
/// Watch this to check if user is authenticated.
final authProvider = AsyncNotifierProvider<AuthNotifier, UserEntity?>(
  AuthNotifier.new,
);
