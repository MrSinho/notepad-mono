import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

import '../handle.dart';


SupabaseQueryBuilder queryPublicProfilesTable(
) {
    return Supabase.instance.client.from("public_profiles");
}

SupabaseQueryBuilder queryPrivateProfilesTable(
) {
    return Supabase.instance.client.from("private_profiles");
}

Future<int> queryCreateUserProfile(
  Handle handle
) async {

  try {
    
    String user_id = "";

    var response = await queryPrivateProfilesTable()
      .select()
      .eq("email", handle.profile.private.email);

    if (response.isEmpty) {
      
      await queryPrivateProfilesTable().insert(
        {
          "email"      : handle.profile.private.email, 
          "plan"       : "free",
        }
      );

    }

    response = await queryPrivateProfilesTable()
      .select()
      .eq("email", handle.profile.private.email);

    user_id = response.first["id"];

    response = await queryPublicProfilesTable()
      .select()
      .eq("profile_id", user_id);

    if (response.isEmpty) {
      
      await queryPublicProfilesTable().insert(
        {
          "username"   : handle.profile.private.email.split("@")[0], 
          "created_at" : DateTime.now().toUtc(), 
          "bio"        : "a softy user", 
          "status"     : "active",
        }
      );

    }

    return 1;
  }
  catch (exception) {
    debugPrint('Error creating user profile: $exception');
    return 0;
  }

}

Future<int> queryUpdatePublicUserProfile(
  Handle handle,
  String username,
  String bio
) async {

  try {

    await queryPublicProfilesTable().update(
      {
        "username"   : username, 
        "bio"        : bio, 
      }
    ).eq("profile_id", handle.profile.private.id);

    handle.types.profileViewInfo.key.currentState?.graphics_updateProfile();

    return 1;
  }
  catch (exception) {
    debugPrint('Error getting current profile: $exception');
    return 0;
  }

}

Future<int> queryProfileInfo(
  Handle handle
) async {

   try {
    
    var private_response = await queryPrivateProfilesTable()
     .select()
     .eq("email", handle.profile.private.email);

    handle.profile.private.id         = private_response.first["id"];
    handle.profile.private.email      = private_response.first["email"];
    handle.profile.private.plan       = private_response.first["plan"];

    var public_response = await queryPublicProfilesTable()
      .select()
      .eq("profile_id", handle.profile.private.id);

    handle.profile.public.username    = public_response.first["username"];
    handle.profile.public.created_at  = public_response.first["created_at"].toString();
    handle.profile.public.bio         = public_response.first["bio"];
    handle.profile.public.status      = public_response.first["status"];

    return 1;
  }
  catch (exception) {
    debugPrint('Error getting current profile: $exception');
    return 0;
  }

}

