import 'package:crypto_bloc/crypto_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:crypto_bloc/bloc/crypto_event.dart';
import 'package:crypto_bloc/bloc/crypto_state.dart';

class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  final CryptoRepository cryptoRepository;

  CryptoBloc(this.cryptoRepository) : super(const CryptoState()) {
    on<loadCryptoData>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null));

      try {
        final data = await cryptoRepository.fetchCryptoData();

        emit(state.copyWith(cryptoList: data, isLoading: false));
      } catch (e) {
        print('object $e');
        emit(state.copyWith(error: e.toString(), isLoading: false));
      }
    });

    on<FilterGainers>((event, emit) {
      final gainers = state.cryptoList.where(
        (item) => double.parse(item.percentChange24h) > 0,
      );

      emit(state.copyWith(cryptoList: gainers.toList()));
    });

    on<ResetFilter>((event, emit) {
      add(loadCryptoData());
    });
  }
}
