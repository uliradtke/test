[app]
title = Barcode Scanner
package.name = barcodescanner
package.domain = org.test
source.dir = .
source.include_exts = py,png,jpg,kv,atlas
version = 0.1
requirements = python3,kivy==2.3.1,kivymd,opencv-python,pyzbar
orientation = portrait
osx.kivy_version = 2.3.1
fullscreen = 0
android.permissions = CAMERA
android.api = 33
android.minapi = 21
android.ndk_api = 21
android.archs = armeabi-v7a, arm64-v8a
p4a.branch = master

[buildozer]
log_level = 2
warn_on_root = 1
