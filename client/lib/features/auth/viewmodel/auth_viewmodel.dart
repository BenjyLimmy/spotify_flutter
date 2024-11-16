import 'package:client/features/auth/model/user_model.dart';
import 'package:client/features/auth/repositories/auth_local_repository.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

//dart run build_runner watch -d

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthRemoteRepository _authRemoteRepository;
  late AuthLocalRepository _authLocalRepository;

  @override
  // AsyncValue for toggling between loading error and data states
  // Nullable as initial value is null (user has not signed up/logged in)
  // Updated once user does so
  // build keeps tracks of dependencies and updates them
  AsyncValue<UserModel>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    return null;
  }

  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.signup(
      name: name,
      email: email,
      password: password,
    );

    // check if success (Right) / failure (Left)
    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
          l.message,
          StackTrace.current,
        ),
      Right(value: final r) => state = AsyncValue.data(r),
    };

    print(val);
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.login(
      email: email,
      password: password,
    );

    // check if success (Right) / failure (Left)
    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
          l.message,
          StackTrace.current,
        ),
      Right(value: final r) => _loginSuccess(r),
    };

    print(val);
  }

  AsyncValue<UserModel>? _loginSuccess(UserModel user) {
    _authLocalRepository.setToken(user.token);
    return state = AsyncValue.data(user);
  }
}
