## Cross compiling ffmpeg for android

- Make sure ANDROID_HOME is set to the android sdk directory, and you have latest ndk version installed (you can install ndk using sdkmanager or from Android Studio)

```bash
git clone https://github.com/yhbsh/FFmpeg-Android.git ffmpeg_android --recursive
cd ffmpeg_android
./fetch.sh
./build.sh
```
