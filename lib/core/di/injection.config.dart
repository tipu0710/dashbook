// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:rocket_phone_contact/app/theme/theme_cubit.dart' as _i1006;
import 'package:rocket_phone_contact/features/contacts/data/datasources/contacts_data_source.dart'
    as _i191;
import 'package:rocket_phone_contact/features/contacts/data/datasources/mock_contacts_data_source.dart'
    as _i288;
import 'package:rocket_phone_contact/features/contacts/data/repositories/contacts_repository_impl.dart'
    as _i950;
import 'package:rocket_phone_contact/features/contacts/domain/repositories/contacts_repository.dart'
    as _i13;
import 'package:rocket_phone_contact/features/contacts/domain/usecases/get_contacts_usecase.dart'
    as _i117;
import 'package:rocket_phone_contact/features/contacts/presentation/cubit/contacts_cubit.dart'
    as _i705;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i1006.ThemeCubit>(() => _i1006.ThemeCubit());
    gh.lazySingleton<_i191.ContactsDataSource>(
      () => _i288.MockContactsDataSource.create(),
    );
    gh.lazySingleton<_i13.ContactsRepository>(
      () => _i950.ContactsRepositoryImpl(gh<_i191.ContactsDataSource>()),
    );
    gh.factory<_i117.GetContactsUseCase>(
      () => _i117.GetContactsUseCase(gh<_i13.ContactsRepository>()),
    );
    gh.factory<_i705.ContactsCubit>(
      () => _i705.ContactsCubit(gh<_i117.GetContactsUseCase>()),
    );
    return this;
  }
}
