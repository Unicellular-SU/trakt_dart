import 'dart:convert';
import 'dart:io';

import 'package:dotenv/dotenv.dart' show load;
import 'package:flutter_test/flutter_test.dart';

import 'package:trakt_dart/trakt_dart.dart';

import 'setup_script.dart';

void main() {
  setUp(() {
    load();
    if (Keys.clientId == null || Keys.clientSecret == null) {
      throw Exception(
          "Set the CLIENT_KEY and/or CLIENT_SECRET variables to run local tests");
    }
    TraktManager.instance.initializeTraktMananager(
        clientId: Keys.clientId!,
        clientSecret: Keys.clientSecret!,
        redirectURI: "");
  });

  test('Calendar Request - Null startdate - nonnull numberOfDays', () async {
    expect(() async {
      await TraktManager.instance
          .getCalendarAllShows(startDate: null, numberOfDays: 7);
    }, throwsAssertionError);
  });

  test('Parse Calendar Show Data', () async {
    final file = File('test/test_data/calendar_show_data.json');
    final json = jsonDecode(await file.readAsString());
    final myCalendarShow = MyCalendarShow.fromJsonModel(json);

    expect(myCalendarShow.firstAired, equals("2014-07-14T01:00:00.000Z"));
    expect(myCalendarShow.show.title, equals("True Blood"));
    expect(myCalendarShow.episode.season, equals(7));
  });

  test('Parse Calendar Movie Data', () async {
    final file = File('test/test_data/calendar_movie_data.json');
    final json = jsonDecode(await file.readAsString());
    final myCalendarShow = MyCalendarMovie.fromJsonModel(json);

    expect(myCalendarShow.released, equals("2014-08-01"));
    expect(myCalendarShow.movie.title, equals("Guardians of the Galaxy"));
  });

  test('Get all calendar shows', () async {
    final shows =
        await TraktManager.instance.getCalendarAllShows(extendedFull: true);
    expect(shows.length, isNonZero);
  });

  test('Get all calendar movies', () async {
    final movies =
        await TraktManager.instance.getCalendarAllMovies(extendedFull: true);
    expect(movies.length, isNonZero);
  });
}
