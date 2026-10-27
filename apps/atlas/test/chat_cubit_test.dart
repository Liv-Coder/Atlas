import 'package:atlas/domain/models/atlas_mode.dart';
import 'package:atlas/features/chat/cubit/chat_cubit.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storage/storage.dart';

void main() {
  group('ChatCubit', () {
    late ChatCubit cubit;

    setUp(() {
      cubit = ChatCubit(
        storageService: HiveStorageService.instance,
        secureKeyStore: const SecureKeyStore(),
      );
    });

    tearDown(() => cubit.close());

    test('starts with 6 seeded sessions in Plan mode', () {
      expect(cubit.state.sessions.length, 6);
      expect(cubit.state.mode, AtlasMode.plan);
      expect(cubit.state.activeAgent.provider, 'Cline');
    });

    test('switches mode to Agent and initializes workflow bar', () {
      cubit.selectMode(AtlasMode.agent);
      expect(cubit.state.mode, AtlasMode.agent);
      expect(cubit.state.workflow.statusLabel, 'Ready');
    });

    test('deletes session and restores it on undoDeleteSession', () {
      final firstId = cubit.state.sessions.first.id;
      cubit.deleteSession(firstId);
      expect(cubit.state.sessions.length, 5);
      expect(cubit.state.snackbarHasUndo, isTrue);

      cubit.undoDeleteSession();
      expect(cubit.state.sessions.length, 6);
      expect(cubit.state.sessions.first.id, firstId);
    });
  });
}
