import 'package:flutter/foundation.dart';

import '../handle.dart';

import 'queries.dart';



int listenToProfile(
  Handle handle
) {

  try {

    queryPublicProfilesTable().stream(primaryKey: ["id"]).listen(

      (List<Map<String, dynamic>> profiles) async {
        
        Map<String, dynamic> profile = profiles.first;

        handle.profile.public.username   = profile["username"];
        handle.profile.public.bio        = profile["bio"];
        handle.profile.public.created_at = profile["created_at"];
        handle.profile.public.status     = profile["status"];

      }

    );

    return 1;

  }
  catch (exception) {
    debugPrint('Failed listening to new profile: $exception');
    return 0;
  }

}
