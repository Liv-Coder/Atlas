import 'package:routing/routing.dart';
import '../features/chat/presentation/chat_screen.dart';
import '../features/settings/presentation/settings_screen.dart';

GoRouter createAtlasRouter() {
  return GoRouter(
    initialLocation: AtlasRoutes.chat,
    routes: [
      GoRoute(
        path: AtlasRoutes.chat,
        builder: (context, state) => const ChatScreen(),
      ),
      GoRoute(
        path: AtlasRoutes.settings,
        pageBuilder: (context, state) => buildHorizontalSlidePage(
          key: state.pageKey,
          child: const SettingsScreen(),
        ),
      ),
    ],
  );
}
