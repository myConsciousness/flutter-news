import 'package:flutter/material.dart';
import 'package:flutter_news/src/twitter_resource_user.dart';
import 'package:twitter_oauth2_pkce/twitter_oauth2_pkce.dart';
import 'package:twitter_api_v2/twitter_api_v2.dart';

class FlutterNewsHome extends StatefulWidget {
  const FlutterNewsHome({Key? key}) : super(key: key);

  @override
  State<FlutterNewsHome> createState() => _FlutterNewsHomeState();
}

class _FlutterNewsHomeState extends State<FlutterNewsHome> {
  late TwitterOAuth2Client _oauth2Client;

  @override
  void initState() {
    super.initState();

    _oauth2Client = TwitterOAuth2Client(
      clientId: const String.fromEnvironment(
        'FLUTTER_NEWS_TWITTER_CLIENT_ID',
      ),
      clientSecret: const String.fromEnvironment(
        'FLUTTER_NEWS_TWITTER_CLIENT_SECRET',
      ),
      redirectUri: const String.fromEnvironment(
        'FLUTTER_NEWS_TWITTER_REDIRECT_URI',
      ),
      customUriScheme: const String.fromEnvironment(
        'FLUTTER_NEWS_TWITTER_URI_SCHEME',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: FutureBuilder(
            future: _oauth2Client.executeAuthCodeFlowWithPKCE(
              scopes: [Scope.tweetRead],
            ),
            builder: (_, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              final twitter =
                  TwitterApi(bearerToken: snapshot.data.accessToken);

              return FutureBuilder(
                future: twitter.tweets.lookupTweets(
                  userId: TwitterResourceUser.flutterDev.id,
                  maxResults: 20,
                  expansions: TweetExpansion.values,
                  userFields: UserField.values,
                  mediaFields: MediaField.values,
                ),
                builder: (_, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  final TwitterResponse<List<TweetData>, TweetMeta> tweets =
                      snapshot.data;

                  return ListView.builder(
                    itemCount: tweets.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      final tweet = tweets.data[index];

                      return Card(
                        child: Text(tweet.text),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
