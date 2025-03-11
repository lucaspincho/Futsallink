class FutsalPositions {
  static const String goalkeeper = 'Goleiro';
  static const String fixo = 'Fixo';
  static const String ala = 'Ala';
  static const String pivo = 'Pivô';
  static const String universal = 'Universal';

  static const List<String> all = [
    goalkeeper,
    fixo,
    ala,
    pivo,
    universal,
  ];
}

class DominantFoot {
  static const String right = 'right';
  static const String left = 'left';

  static const List<String> all = [
    right,
    left,
  ];
}

class ProfileType {
  static const String player = 'player';
  static const String club = 'club';

  static const List<String> all = [
    player,
    club,
  ];
}

class TryoutStatus {
  static const String open = 'open';
  static const String closed = 'closed';
  static const String completed = 'completed';

  static const List<String> all = [
    open,
    closed,
    completed,
  ];
}

class MessageStatus {
  static const String sent = 'sent';
  static const String delivered = 'delivered';
  static const String read = 'read';

  static const List<String> all = [
    sent,
    delivered,
    read,
  ];
}

class MediaType {
  static const String text = 'text';
  static const String image = 'image';
  static const String video = 'video';

  static const List<String> all = [
    text,
    image,
    video,
  ];
}