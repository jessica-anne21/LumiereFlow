// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cycle_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Cycle)
final cycleProvider = CycleProvider._();

final class CycleProvider extends $StreamNotifierProvider<Cycle, CycleState> {
  CycleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cycleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cycleHash();

  @$internal
  @override
  Cycle create() => Cycle();
}

String _$cycleHash() => r'c470f3a91f019e1024dae1dab83b352e89ec7930';

abstract class _$Cycle extends $StreamNotifier<CycleState> {
  Stream<CycleState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<CycleState>, CycleState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CycleState>, CycleState>,
              AsyncValue<CycleState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
