import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storage/storage.dart';
import 'features/chat/cubit/chat_cubit.dart';
import 'features/settings/cubit/settings_cubit.dart';
import 'features/settings/cubit/settings_state.dart';
import 'router/app_router.dart';

class AtlasApp extends StatefulWidget {
  const AtlasApp({
    super.key,
    required this.storageService,
    required this.secureKeyStore,
  });

  final HiveStorageService storageService;
  final SecureKeyStore secureKeyStore;

  @override
  State<AtlasApp> createState() => _AtlasAppState();
}

class _AtlasAppState extends State<AtlasApp> {
  late final SettingsCubit _settingsCubit;
  late final ChatCubit _chatCubit;
  late final _router = createAtlasRouter();

  @override
  void initState() {
    super.initState();
    _settingsCubit = SettingsCubit(
      storageService: widget.storageService,
      secureKeyStore: widget.secureKeyStore,
    )..loadSettings();
    _chatCubit = ChatCubit(
      storageService: widget.storageService,
      secureKeyStore: widget.secureKeyStore,
    )..initialize();
  }

  @override
  void dispose() {
    _settingsCubit.close();
    _chatCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsCubit>.value(value: _settingsCubit),
        BlocProvider<ChatCubit>.value(value: _chatCubit),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settings) {
          return MaterialApp.router(
            title: 'Atlas',
            debugShowCheckedModeBanner: false,
            theme: AtlasTheme.light(),
            darkTheme: AtlasTheme.dark(),
            themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            routerConfig: _router,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(settings.textScaleFactor),
                ),
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
