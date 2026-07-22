


import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_database/firebase_database.dart' as _i345;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/datasource/auth_remote_data_source.dart'
    as _i24;
import '../../features/auth/data/datasource/auth_remote_data_source_impl.dart'
    as _i68;
import '../../features/auth/data/repositories/auth_repo.dart' as _i913;
import '../../features/auth/data/repositories/auth_repo_impl.dart' as _i662;
import '../../features/auth/presentation/manager/auth_cubit.dart' as _i888;
import '../../features/chat/data/data_sources/chat_data_source.dart' as _i665;
import '../../features/chat/data/data_sources/chat_data_source_impl.dart'
    as _i58;
import '../../features/chat/data/repositories/chat_repo.dart' as _i962;
import '../../features/chat/data/repositories/chat_repo_impl.dart' as _i250;
import '../../features/chat/presentation/manager/chat_cubit.dart' as _i770;
import '../../features/chat/presentation/manager/chat_room_cubit.dart' as _i36;
import '../../features/friends/data/datasources/friend_data_source.dart'
    as _i436;
import '../../features/friends/data/datasources/friend_data_source_imp.dart'
    as _i262;
import '../../features/friends/data/repositories/friend_repo.dart' as _i65;
import '../../features/friends/data/repositories/friend_repo_impl.dart'
    as _i563;
import '../../features/friends/presentation/manager/friend_cubit.dart' as _i154;
import '../../features/profile/data/datasource/profile_remote_data_source.dart'
    as _i559;
import '../../features/profile/data/datasource/profile_remote_data_source_impl.dart'
    as _i358;
import '../../features/profile/data/repositories/profile_repo.dart' as _i945;
import '../../features/profile/data/repositories/profile_repo_impl.dart'
    as _i988;
import '../../features/profile/presentation/manager/profile_cubit.dart'
    as _i735;
import '../services/firebase_module.dart' as _i436;

extension GetItInjectableX on _i174.GetIt {
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final firebaseModule = _$FirebaseModule();
    gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => firebaseModule.fireStore);
    gh.lazySingleton<_i116.GoogleSignIn>(() => firebaseModule.googleSignIn);
    gh.lazySingleton<_i345.FirebaseDatabase>(
      () => firebaseModule.firebaseDatabase,
    );
    gh.lazySingleton<_i436.FriendDataSource>(
      () => _i262.FriendDataSourceImp(
        firebaseAuth: gh<_i59.FirebaseAuth>(),
        fireStore: gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i24.AuthRemoteDataSource>(
      () => _i68.AuthRemoteDataSourceImpl(
        firebaseAuth: gh<_i59.FirebaseAuth>(),
        fireStore: gh<_i974.FirebaseFirestore>(),
        googleSignIn: gh<_i116.GoogleSignIn>(),
      ),
    );
    gh.lazySingleton<_i65.FriendRepository>(
      () => _i563.FriendRepositoryImp(
        friendDataSource: gh<_i436.FriendDataSource>(),
      ),
    );
    gh.lazySingleton<_i665.ChatDataSource>(
      () => _i58.ChatRemoteDataSourceImpl(
        database: gh<_i345.FirebaseDatabase>(),
        firebaseAuth: gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.factory<_i962.ChatRepository>(
      () =>
          _i250.ChatRepositoryImpl(chatDataSource: gh<_i665.ChatDataSource>()),
    );
    gh.lazySingleton<_i559.ProfileRemoteDataSource>(
      () => _i358.ProfileRemoteDataSourceImpl(
        fireStore: gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i913.AuthRepo>(
      () => _i662.AuthRepoImpl(authDataSource: gh<_i24.AuthRemoteDataSource>()),
    );
    gh.factory<_i888.AuthCubit>(
      () => _i888.AuthCubit(authRepo: gh<_i913.AuthRepo>()),
    );
    gh.factory<_i770.ChatCubit>(
      () => _i770.ChatCubit(chatRepository: gh<_i962.ChatRepository>()),
    );
    gh.lazySingleton<_i945.ProfileRepo>(
      () => _i988.ProfileRepoImpl(
        profileRemoteDataSource: gh<_i559.ProfileRemoteDataSource>(),
      ),
    );
    gh.factory<_i154.FriendCubit>(
      () => _i154.FriendCubit(friendRepository: gh<_i65.FriendRepository>()),
    );
    gh.factory<_i735.ProfileCubit>(
      () => _i735.ProfileCubit(profileRepo: gh<_i945.ProfileRepo>()),
    );
    gh.factory<_i36.ChatRoomCubit>(
      () => _i36.ChatRoomCubit(
        chatRepository: gh<_i962.ChatRepository>(),
        profileRepo: gh<_i945.ProfileRepo>(),
      ),
    );
    return this;
  }
}

class _$FirebaseModule extends _i436.FirebaseModule {}