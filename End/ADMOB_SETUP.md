# AdMob Integration Setup Guide

This Jumping Bird game includes AdMob integration using the [poing-studios Godot AdMob Plugin](https://github.com/poing-studios/godot-admob-plugin).

## Current Ad Configuration

The game displays:
- **Banner Ad**: Shown at the bottom of the screen during gameplay
- **Interstitial Ad**: Shown after each game round (when the player dies)

## Plugin Already Installed

The AdMob plugin is already installed in `addons/admob/`. The Android plugin files are in `android/plugins/`.

## Setup Instructions for Production

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

### 2. Update Ad Unit IDs

Edit `autoload/AdMobManager.gd` and replace the test IDs with your production IDs:

```gdscript
# Replace these with your actual AdMob IDs
const BANNER_AD_UNIT_ID_ANDROID: String = "ca-app-pub-YOUR_BANNER_ID"
const BANNER_AD_UNIT_ID_IOS: String = "ca-app-pub-YOUR_BANNER_ID"
const INTERSTITIAL_AD_UNIT_ID_ANDROID: String = "ca-app-pub-YOUR_INTERSTITIAL_ID"
const INTERSTITIAL_AD_UNIT_ID_IOS: String = "ca-app-pub-YOUR_INTERSTITIAL_ID"
```

### 3. Update Android Manifest

Edit `android/build/AndroidManifest.xml` and replace the test App ID with your production App ID:

```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-YOUR_APP_ID"/>
```

### 4. Export for Android

1. In Godot, go to Project > Export
2. Select the Android preset
3. Ensure "Use Gradle Build" is enabled
4. The AdMob plugin should already be enabled (check `plugins/AdMob=true` in export settings)
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

## Plugin API Usage

The game uses the poing-studios AdMob plugin API:

### Banner Ads
```gdscript
# Load and show banner at bottom
AdMobManager.load_banner(AdPosition.Values.BOTTOM)

# Hide/show/destroy
AdMobManager.hide_banner()
AdMobManager.show_banner()
AdMobManager.destroy_banner()
```

### Interstitial Ads
```gdscript
# Load interstitial (done automatically)
AdMobManager.load_interstitial()

# Show when ready
AdMobManager.show_interstitial()

# Check if loaded
if AdMobManager.is_interstitial_loaded():
    AdMobManager.show_interstitial()
```

## Troubleshooting

### Ads Not Showing

1. Check if the device has internet connection
2. Verify you're testing on a real device (not emulator)
3. Check Godot output for AdMob-related logs (prefixed with `[AdMob]`)
4. Ensure the AdMob plugin is enabled in export settings

### Build Errors

1. Make sure Gradle build is enabled in export settings
2. Verify Android SDK and build tools are installed
3. Check that the `.aar` files exist in `android/plugins/poing-godot-admob-libs/`

### Invalid Plugin Config Error

If you see "Invalid plugin config file" error, make sure only the valid plugin files exist in `android/plugins/`:
- `poing-godot-admob-ads.gdap`
- `poing-godot-admob-libs/` folder with `.aar` files

## AdMob Policy Compliance

Remember to:
- Include a privacy policy in your app
- Don't encourage users to click ads
- Don't place ads where accidental clicks may occur
- Follow all [AdMob program policies](https://support.google.com/admob/answer/6128543)

## Files for AdMob Integration

- `addons/admob/` - poing-studios AdMob plugin
- `autoload/AdMobManager.gd` - AdMob singleton manager
- `scene/MainScreen/main.gd` - Banner ad initialization
- `scene/UserInterface/hud.gd` - Interstitial ad after game over
- `android/build/AndroidManifest.xml` - AdMob App ID
- `android/plugins/poing-godot-admob-ads.gdap` - Plugin definition
- `android/plugins/poing-godot-admob-libs/` - Plugin AAR files
