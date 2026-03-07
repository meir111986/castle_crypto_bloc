import 'package:crypto_bloc/crypto_repository.dart';
import 'package:crypto_bloc/models/crypto_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:crypto_bloc/bloc/crypto_event.dart';
import 'package:crypto_bloc/bloc/crypto_state.dart';

class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  final CryptoRepository cryptoRepository;

  CryptoBloc(this.cryptoRepository) : super(const CryptoState()) {
    on<loadCryptoData>((event, emit) async {
      final localData = cryptoRepository.getLocalCryptoData();

      if (localData.isEmpty) {
        emit(
          state.copyWith(cryptoList: localData, isLoading: true, error: null),
        );
      } else {
        emit(state.copyWith(isLoading: true, error: null));
      }

      await Future.delayed(Duration(seconds: 5));

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

    on<FilterDrop>((event, emit) {
      final drop = state.cryptoList.where(
        (item) => double.parse(item.percentChange24h) < 0,
      );
      emit(state.copyWith(cryptoList: drop.toList()));
    });

    on<Top10>((event, emit) {
      final top10 = List<CryptoModel>.from(state.cryptoList)
        ..sort(
          (firstPrice, secondPrice) =>
              (double.tryParse(secondPrice.priceUsd) ?? 0).compareTo(
                double.tryParse(firstPrice.priceUsd) ?? 0,
              ),
        );
      emit(state.copyWith(cryptoList: top10.take(10).toList()));
    });

    on<ResetFilter>((event, emit) {
      add(loadCryptoData());
    });

    on<ClearCache>((event, emit) async {
      await cryptoRepository.clearCache();
      emit(state.copyWith(cryptoList: []));
    });
  }
}
