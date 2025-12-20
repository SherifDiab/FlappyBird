# AdMob Integration Setup Guide

This Flappy Bird game includes AdMob integration for displaying banner and interstitial ads. Follow this guide to set up AdMob for your Android/iOS builds.

## Current Ad Configuration

The game displays:
- **Banner Ad**: Shown at the bottom of the screen during gameplay
- **Interstitial Ad**: Shown after each game round (when the player dies)

## Setup Instructions

### 1. Get AdMob Account and App IDs

1. Create an AdMob account at [https://admob.google.com](https://admob.google.com)
2. Create a new app in AdMob dashboard
3. Create ad units:
   - **Banner Ad Unit** (320x50 or Adaptive)
   - **Interstitial Ad Unit**
4. Note down your:
   - **App ID** (format: `ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX`)
   - **Banner Ad Unit ID** (format: `ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX`)
   - **Interstitial Ad Unit ID** (format: `ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX`)

### 2. Install Godot AdMob Plugin

For Godot 4.x, download the AdMob plugin:
- GitHub: [https://github.com/poing-studios/godot-admob-plugin](https://github.com/poing-studios/godot-admob-plugin)

Installation:
1. Download the latest release for your Godot version
2. Extract the `addons` folder to your project root
3. Enable the plugin in Project Settings > Plugins

### 3. Update Ad Unit IDs

Edit `autoload/AdMobManager.gd` and replace the test IDs with your production IDs:

```gdscript
# Replace these with your actual AdMob IDs
const BANNER_AD_UNIT_ID_ANDROID: String = "ca-app-pub-YOUR_BANNER_ID"
const BANNER_AD_UNIT_ID_IOS: String = "ca-app-pub-YOUR_BANNER_ID"
const INTERSTITIAL_AD_UNIT_ID_ANDROID: String = "ca-app-pub-YOUR_INTERSTITIAL_ID"
const INTERSTITIAL_AD_UNIT_ID_IOS: String = "ca-app-pub-YOUR_INTERSTITIAL_ID"
```

### 4. Update Android Manifest

Edit `android/build/AndroidManifest.xml` and replace the test App ID:

```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-YOUR_APP_ID" />
```

### 5. Disable Test Mode for Production

In `autoload/AdMobManager.gd`, change the test mode setting:

```gdscript
# Set to false for production builds
var is_test_mode: bool = false
```

### 6. Export for Android

1. In Godot, go to Project > Export
2. Select the Android preset
3. Enable "Use Gradle Build" in the export options
4. Make sure the AdMob plugin is enabled
5. Export the APK/AAB

## Test Ad Unit IDs (Development)

The current configuration uses Google's official test IDs:

| Platform | Ad Type | Test ID |
|----------|---------|---------|
| Android | Banner | ca-app-pub-3940256099942544/6300978111 |
| Android | Interstitial | ca-app-pub-3940256099942544/1033173712 |
| iOS | Banner | ca-app-pub-3940256099942544/2934735716 |
| iOS | Interstitial | ca-app-pub-3940256099942544/4411468910 |
| Both | App ID (Test) | ca-app-pub-3940256099942544~3347511713 |

**Note**: Always use test IDs during development. Using production IDs during development may result in account suspension.

## Troubleshooting

### Ads Not Showing

1. Check if the device has internet connection
2. Verify AdMob plugin is properly installed
3. Check Godot output for AdMob-related logs
4. Ensure you're testing on a real device (not emulator)

### Build Errors

1. Make sure Gradle build is enabled
2. Verify Android SDK and build tools are installed
3. Check that Google Play Services is available

## AdMob Policy Compliance

Remember to:
- Include a privacy policy in your app
- Don't encourage users to click ads
- Don't place ads where accidental clicks may occur
- Follow all [AdMob program policies](https://support.google.com/admob/answer/6128543)

## Files Modified for AdMob Integration

- `autoload/AdMobManager.gd` - AdMob singleton manager
- `scene/MainScreen/main.gd` - Banner ad initialization
- `scene/UserInterface/hud.gd` - Interstitial ad after game over
- `project.godot` - Autoload configuration
- `android/build/AndroidManifest.xml` - AdMob App ID
- `android/plugins/GodotAdMob.gdap` - Plugin definition
- `export_presets.cfg` - Export configuration
