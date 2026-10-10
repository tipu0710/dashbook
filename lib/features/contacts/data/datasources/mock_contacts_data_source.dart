import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../models/contact_dto.dart';
import '../models/contacts_response_dto.dart';
import 'contacts_data_source.dart';

@LazySingleton(as: ContactsDataSource)
class MockContactsDataSource implements ContactsDataSource {
  @factoryMethod
  static MockContactsDataSource create() => MockContactsDataSource(
    loadJson: () => rootBundle.loadString('assets/data/contacts.json'),
    failOnceOnPage: const int.fromEnvironment('MOCK_FAIL_PAGE'),
    failurePercent: const int.fromEnvironment('MOCK_FAILURE_PERCENT'),
  );

  MockContactsDataSource({
    required this.loadJson,
    this.latency,
    this.failOnceOnPage = 0,
    this.failurePercent = 0,
    Random? random,
  }) : assert(failurePercent >= 0 && failurePercent <= 100),
       _random = random ?? Random();

  final Future<String> Function() loadJson;

  final Duration? latency;
  final int failOnceOnPage;

  final int failurePercent;
  final Random _random;
  bool _didFail = false;
  Future<List<ContactDto>>? _dataset;

  static const _latencies = [
    Duration(milliseconds: 500),
    Duration(milliseconds: 700),
    Duration(milliseconds: 1000),
  ];
  static final _nonPhoneChars = RegExp(r'[^0-9+]');
  static final _digit = RegExp(r'[0-9]');

  Future<List<ContactDto>> _load() async =>
      compute(_parseContacts, await loadJson());

  static List<ContactDto> _parseContacts(String raw) =>
      (jsonDecode(raw) as List<dynamic>)
          .map((entry) => ContactDto.fromJson(entry as Map<String, dynamic>))
          .toList();

  @override
  Future<ContactsResponseDto> getContacts({
    required int page,
    required int limit,
    required String search,
  }) async {
    if (page < 1 || limit < 1) {
      throw ArgumentError('Page and limit must be positive.');
    }
    final failOnce = page == failOnceOnPage && !_didFail;
    if (failOnce) _didFail = true;
    final shouldFail = failOnce || _random.nextInt(100) < failurePercent;
    await Future<void>.delayed(
      latency ?? _latencies[_random.nextInt(_latencies.length)],
    );
    if (shouldFail) throw const ContactsApiException();
    late final List<ContactDto> dataset;
    try {
      dataset = await (_dataset ??= _load());
    } catch (_) {
      _dataset = null;
      rethrow;
    }
    final query = search.trim().toLowerCase();
    final List<ContactDto> matches;
    if (query.isEmpty) {
      matches = dataset;
    } else {
      final phoneQuery = query.replaceAll(_nonPhoneChars, '');
      final matchPhone = phoneQuery.contains(_digit);
      matches = dataset
          .where(
            (contact) =>
                contact.name.toLowerCase().contains(query) ||
                (matchPhone && contact.phone.contains(phoneQuery)),
          )
          .toList();
    }
    final offset = (page - 1) * limit;
    return ContactsResponseDto(
      contacts: matches.skip(offset).take(limit).toList(),
      page: page,
      total: matches.length,
      hasMore: offset + limit < matches.length,
    );
  }
}
