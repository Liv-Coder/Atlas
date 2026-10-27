import '../models/chat_session.dart';

/// Exact pre-seeded sessions and bilingual messages from Nexus Chat Mock.html
class AtlasSeedSessions {
  const AtlasSeedSessions._();

  static List<ChatSession> buildInitialSessions() {
    return [
      ChatSession(
        id: 's1',
        title: 'Hotel outreach plan',
        timeLabel: 'Pinned · Mon',
        group: SessionGroup.pinned,
        pinned: true,
        kind: 'hotel',
        messages: _sampleMessages('hotel'),
      ),
      ChatSession(
        id: 's2',
        title: 'WhatsApp catalogue prices',
        timeLabel: 'Today · 9:12 AM',
        group: SessionGroup.today,
        pinned: false,
        kind: 'catalogue',
        messages: _sampleMessages('catalogue'),
      ),
      ChatSession(
        id: 's3',
        title: 'Kathmandu → Hetauda route',
        timeLabel: 'Today · 8:47 AM',
        group: SessionGroup.today,
        pinned: false,
        kind: 'route',
        messages: _sampleMessages('route'),
      ),
      ChatSession(
        id: 's4',
        title: 'Flutter migration spec',
        timeLabel: 'Yesterday',
        group: SessionGroup.previous,
        pinned: false,
        kind: 'flutter',
        messages: _sampleMessages('flutter'),
      ),
      ChatSession(
        id: 's5',
        title: 'Artemis vision test notes',
        timeLabel: 'Yesterday',
        group: SessionGroup.previous,
        pinned: false,
        kind: 'generic',
        messages: _sampleMessages('generic'),
      ),
      ChatSession(
        id: 's6',
        title: 'Tihar bulk campaign kit',
        timeLabel: 'Oct 23',
        group: SessionGroup.previous,
        pinned: false,
        kind: 'generic',
        messages: _sampleMessages('generic'),
      ),
    ];
  }

  static List<ChatMessage> _sampleMessages(String kind) {
    switch (kind) {
      case 'hotel':
        return const [
          ChatMessage(
            id: 'm_hotel_1',
            role: MessageRole.user,
            content:
                'D&D Suppliers ko lagi hotel haru lai bulk order ko outreach plan banau.',
          ),
          ChatMessage(
            id: 'm_hotel_2',
            role: MessageRole.assistant,
            content: 'Hotel outreach ko lagi plan ready chha:',
            bulletItems: [
              'Kathmandu–Lalitpur ko 15 hotels lai segment gara — star, rooms, F&B volume anusar',
              'WhatsApp Business catalogue (46 products) ko link sahit first message pathau',
              'Cups, containers ra packaging ko bundle offer rakha — hotels le sadhai line items',
              'Reply naaune lai 3 din pachhi euta matra follow-up',
            ],
            checkedStepIndices: {0, 1, 2},
            footerNote:
                'Chahanchhau bhane ma hotel-wise message draft pani banauchhu.',
          ),
        ];
      case 'catalogue':
        return const [
          ChatMessage(
            id: 'm_cat_1',
            role: MessageRole.user,
            content: 'WhatsApp catalogue ma price kasari add garne?',
          ),
          ChatMessage(
            id: 'm_cat_2',
            role: MessageRole.assistant,
            content:
                'Price WhatsApp Business **phone app** bata add hunchha — Web form ma price field chhaina.',
            bulletItems: [
              'App ma `Catalogue → item → Price` khola',
              '46 items ma ek ek garera wholesale price rakha',
              'Min order qty pehle nai set chha, tyo change nagara',
            ],
          ),
        ];
      case 'route':
        return const [
          ChatMessage(
            id: 'm_route_1',
            role: MessageRole.user,
            content: 'Kathmandu bata Hetauda bike route kasto chha?',
          ),
          ChatMessage(
            id: 'm_route_2',
            role: MessageRole.assistant,
            content:
                'Shortest bike route **Kathmandu → Bhaktapur haina** — Dakshinkali–Hetauda road nai ho:',
            bulletItems: [
              'Kathmandu → Pharping → Dakshinkali → Sisneri → Kulekhani → Hetauda',
              'Karib **85 km**, bike ma 3.5–4.5 ghanta (road condition anusar)',
              'Sisneri–Kulekhani section ukalo ra ghumauro chha — bihan hidda ramro',
            ],
          ),
        ];
      case 'flutter':
        return const [
          ChatMessage(
            id: 'm_fl_1',
            role: MessageRole.user,
            content: 'Cline Personal lai Flutter ma shift garne spec k chha?',
          ),
          ChatMessage(
            id: 'm_fl_2',
            role: MessageRole.assistant,
            content: 'Flutter migration spec ko summary:',
            bulletItems: [
              'Naya naam **Atlas**, package `com.atlas.chat`',
              'v18 ko full feature parity — drawer, agent sheet, modes, settings',
              'Logo: deep navy, single thin gradient arc, text chhaina',
              'Purano Kotlin app ko sessions migrate hudaina — separate install',
            ],
            checkedStepIndices: {0, 1},
          ),
        ];
      default:
        return const [
          ChatMessage(
            id: 'm_gen_1',
            role: MessageRole.user,
            content: 'Yo chat ko summary banau.',
          ),
          ChatMessage(
            id: 'm_gen_2',
            role: MessageRole.assistant,
            content:
                'Yo saved chat ho — Atlas ma tap garera kholne bittikai yas ko conversation yahi load hunchha.',
          ),
        ];
    }
  }
}
