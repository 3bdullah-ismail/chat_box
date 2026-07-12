class ChatUtils {
  static String getConversationId(String uid1, String uid2) {
    final ids = [uid1, uid2]..sort();
    return ids.join("_");
  }
}
