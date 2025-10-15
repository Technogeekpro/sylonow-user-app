# Fix: Install Rosetta for Apple Silicon

## Problem
Flutter's bundled `libimobiledevice` binaries are x86_64 and need Rosetta to run on Apple Silicon Macs.

## Solution

### Step 1: Install Rosetta

Open Terminal and run:

```bash
sudo softwareupdate --install-rosetta --agree-to-license
```

**You'll need to enter your Mac password.**

This will install Rosetta 2, which allows x86_64 (Intel) apps to run on ARM (Apple Silicon) Macs.

### Step 2: Verify Installation

After Rosetta is installed, run:

```bash
cd "/Users/arbazkudekar/Downloads/flutter projects/sylonow-user-app-1"
flutter run -d 00008110-0014298A1181401E
```

## Why This is Needed

Flutter's iOS tools (`idevicesyslog`, `ideviceinstaller`, etc.) are currently distributed as x86_64 binaries. Even though we installed ARM-native versions via Homebrew, Flutter uses its own bundled versions from:

```
/opt/homebrew/share/flutter/bin/cache/artifacts/libimobiledevice/
```

Until Flutter updates these to universal binaries or ARM-native binaries, Rosetta is required.

## Alternative (Advanced)

If you don't want to install Rosetta, you could manually replace Flutter's bundled binaries with symlinks to Homebrew's ARM versions, but this is not recommended as Flutter updates may break it.

## After Installing Rosetta

Once Rosetta is installed, your app should:
1. Build successfully
2. Deploy to your iPhone 13
3. Run with full Apple Sign In support (since you're on a real device!)

Then you can test Apple Sign In properly! 🎉
