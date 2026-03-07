# dlct_just_audio_background

Maintained by **DayLight Creative Technologies**. Forked from [just_audio_background](https://github.com/ryanheise/just_audio) v0.0.1-beta.17.

This package plugs into [just_audio](https://pub.dev/packages/just_audio) to add background playback support and remote controls (notification, lock screen, headset buttons, smart watches, Android Auto and CarPlay). It supports the simple use case where an app has a single `AudioPlayer` instance.

## Setup

Add the dependency to your `pubspec.yaml` alongside `just_audio`:

```yaml
dependencies:
  just_audio: ^0.10.5
  dlct_just_audio_background:
    git:
      url: https://github.com/DayLight-Creative-Technologies/dlct_just_audio.git
      path: just_audio_background
```

Then add the following initialization code to your app's `main` method:

```dart
Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.yourapp.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(MyApp());
}
```

Create your player as normal:

```dart
player = AudioPlayer();
```

Set a `MediaItem` tag on each `AudioSource` loaded into the player. For example:

```dart
AudioSource.uri(
  Uri.parse('https://example.com/narration.mp3'),
  tag: MediaItem(
    id: '1',
    title: "Tigers vs Eagles",
    artist: "Mar 7, 2026 at 3:30 PM",
  ),
),
```

## Android setup

Make the following changes to your project's `AndroidManifest.xml` file:

```xml
<manifest xmlns:tools="http://schemas.android.com/tools" ...>
  <uses-permission android:name="android.permission.WAKE_LOCK"/>
  <uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
  <uses-permission android:name="android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK"/>

  <application ...>

    <!-- Your main activity MUST extend AudioServiceActivity -->
    <activity android:name="com.ryanheise.audioservice.AudioServiceActivity" ...>
      ...
    </activity>

    <!-- ADD THIS "SERVICE" element -->
    <service android:name="com.ryanheise.audioservice.AudioService"
        android:foregroundServiceType="mediaPlayback"
        android:exported="true" tools:ignore="Instantiatable">
      <intent-filter>
        <action android:name="android.media.browse.MediaBrowserService" />
      </intent-filter>
    </service>

    <!-- ADD THIS "RECEIVER" element -->
    <receiver android:name="com.ryanheise.audioservice.MediaButtonReceiver"
        android:exported="true" tools:ignore="Instantiatable">
      <intent-filter>
        <action android:name="android.intent.action.MEDIA_BUTTON" />
      </intent-filter>
    </receiver>
  </application>
</manifest>
```

If your app uses a custom `MainActivity`, make it extend `AudioServiceActivity` instead of `FlutterActivity`:

```kotlin
import com.ryanheise.audioservice.AudioServiceActivity

class MainActivity: AudioServiceActivity() {
}
```

## iOS setup

Insert this in your `Info.plist` file:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
</array>
```

## License

This project is a fork of [just_audio](https://github.com/ryanheise/just_audio) by Ryan Heise, licensed under the MIT License.
