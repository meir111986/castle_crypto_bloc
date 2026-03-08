abstract class CryptoEvent {}

class loadCryptoData extends CryptoEvent {}

class FilterGainers extends CryptoEvent {}

class ResetFilter extends CryptoEvent {}

class FilterDrop extends CryptoEvent {}

class Top10 extends CryptoEvent {}

class ClearCache extends CryptoEvent {}

class ToggleFavorite extends CryptoEvent {
  final String id;
  ToggleFavorite(this.id);
}

class FilterFavorites extends CryptoEvent {}

// class ClearToggleFavorite extends CryptoEvent {
//   final String id;
//   ClearToggleFavorite(this.id);
// }
