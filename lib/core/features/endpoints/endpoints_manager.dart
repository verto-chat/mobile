import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import '../../../common/common.dart';
import 'endpoints.dart';

class EndpointsManager {
  static const _endpointsMapKey = 'endpoints';

  static const List<IEndpoints> _endpoints = [ProductionEndpoints(), PreReleaseEndpoints()];

  final ISharedPreferences _sharedPreferences;
  final bool useProdApiWhenDebug;

  EndpointsManager(this._sharedPreferences, {this.useProdApiWhenDebug = false});

  List<IEndpoints> get endpointsList => _endpoints;

  Future<IEndpoints> getEndpoints() async {
    final endpointsId = await _sharedPreferences.getString(_endpointsMapKey);

    if (endpointsId != null) {
      final endpoints = _endpoints.firstWhereOrNull((e) => e.id == endpointsId);
      if (endpoints != null) {
        return endpoints;
      }
    }

    return kReleaseMode || useProdApiWhenDebug ? const ProductionEndpoints() : const PreReleaseEndpoints();
  }

  Future<bool> setEndpoints(IEndpoints endpoints) => _sharedPreferences.setString(_endpointsMapKey, endpoints.id);
}
