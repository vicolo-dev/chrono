<div align="center">

<image src="icon.png" height="100"/>

# Chrono

### A modern and powerful clock, alarms, timer and stopwatch app for Android!
![alt text](cover.png)

![tests](https://github.com/vicolo-dev/chrono/actions/workflows/tests.yml/badge.svg)
[![codecov](https://codecov.io/gh/vicolo-dev/chrono/branch/master/graph/badge.svg?token=cKxMm8KVev)](https://codecov.io/gh/vicolo-dev/chrono)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/7dc1e51c1616482baa5392bc0826c50a)](https://app.codacy.com/gh/vicolo-dev/chrono/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)
<a href="https://hosted.weblate.org/engage/chrono/">
<img src="https://hosted.weblate.org/widget/chrono/app/svg-badge.svg" alt="Translation status" />
</a>
<span class="badge-patreon"><a href="https://patreon.com/vicolo" title="Donate to this project using Patreon"><img src="https://img.shields.io/badge/patreon-donate-orange.svg" alt="Patreon donate button" /></a></span>

<a href="https://hosted.weblate.org/engage/chrono/">
<img src="https://hosted.weblate.org/widget/chrono/app/287x66-grey.png" alt="Translation status" />
</a>

[<img src="https://fdroid.gitlab.io/artwork/badge/get-it-on.png" alt="Get it on F-Droid" height="80">](https://f-droid.org/packages/com.vicolo.chrono)
[<img src="https://gitlab.com/IzzyOnDroid/repo/-/raw/master/assets/IzzyOnDroid.png" alt="Get it on IzzyOnDroid" height=80/>](https://apt.izzysoft.de/fdroid/index/apk/com.vicolo.chrono)
[<img src="https://i.ibb.co/q0mdc4Z/get-it-on-github.png" alt="Get it on Github" height=80/>](https://github.com/vicolo-dev/chrono/releases/latest)


</div>


Its usable, but still WIP, so you might encounter some bugs. Make sure to test it out thorougly on your device before using it for critical alarms. Feel free to open an issue.

# Table of Content
- [Features](#features)
- [Platforms](#platforms)
- [Contribute](#contribute)
- [Development](#development)
- [Todo](#todo)
- [Screenshots](#screenshots)

## Features
- Modern and easy to use interface
- Available in variety of [languages](#translations)
### Alarms
- Customizable schedules (Daily, Weekly, Specific week days, Specific dates, Date range)
- Configure melody/ringtone, rising volume and vibrations
- Configure Snooze length, max snoozes and other snooze behaviour
- Option to auto delete dismissed alarms and skip alarms
- Alarm tasks (Math problems, Retype text, Sequence, more to come)
- Dial, spinner and text time pickers
- Filter and sort alarms
- Add tags
### Clock
- Customizable clock display
- World clocks with relative time difference
- Search and add cities
### Timer
- Support for multiple timers
- Configure melody/ringtone, rising volume and vibrations
- Timer presets
- Option to fullscreen a timer
- Dial and spinner duration pickers
- Filter and sort timers
- Add tags
### Stopwatch
- Lap history with lap times and elapsed times
- Lap comparisons (fastest, slowest, average, previous)
### Appearance
- Material You icons and themes
- Highly customizable color themes
- Highly customizable style themes
- Other options like animations, nav bar styles, time picker styles

## Platforms
Currently, the app is only available for android. I don't have an apple device to develop for iOS, but feel free
to contribute if you want iOS support. The alarm and timer features
use android-only code, so that will need to be ported. Everything else should mostly work fine.

## Contribute
All contributions are welcome, whether creating issues, pull requests or translations. 
### Issues
Feel free to create issues regarding any issues you might be facing, any improvements or enhancements, or any feature-requests. Try to follow the templates and include as much information as possible in your issues.
### Pull Requests
Pull Requests are highly welcome. When contributing to this repository, please first discuss the change you wish to make via an issue. Also, please refer to [Effective Dart](https://dart.dev/effective-dart) as a guideline for the coding standards expected from pull requests.
### Translations
You can help translate the app into your preferred language using weblate at https://hosted.weblate.org/projects/chrono/.

<a href="https://hosted.weblate.org/engage/chrono/">
<img src="https://hosted.weblate.org/widget/chrono/app/287x66-grey.png" alt="Translation status" />
</a>

Current progress:

<a href="https://hosted.weblate.org/engage/chrono/">
<img src="https://hosted.weblate.org/widget/chrono/app/horizontal-auto.svg" alt="Translation status" />
</a>

### Spread the word!
If you found the app useful, you can help the project by sharing it with friends and family.
### Donate
The amount of time I can given to the app is bound by financial constraints. Donations will really help allow me in giving more and more time to the development of this app.

<span class="badge-patreon"><a href="https://patreon.com/vicolo" title="Donate to this project using Patreon"><img src="https://img.shields.io/badge/patreon-donate-orange.svg" alt="Patreon donate button" /></a></span>

### Our generous patreons
- Potato @potatocinna
- Thorsten @th23x

## Development

This app is built using flutter. To start developing:
1. Follow [this](https://docs.flutter.dev/get-started/install) guide to install flutter and all required tools.
2. Run the app by `flutter run --flavor dev`. For production builds, use `flutter build apk --release --split-per-abi --flavor prod`.

## Todo
Stuff I would like to do soon™. In no particular order:
- Alarms
  - Alarm reliability testing system
  - Vibration patterns
  - Alternative time picker interfaces
  - Array alarms (alarm that will ring after set interval (10 minutes etc.)
  - More tasks
- Color schemes
  - More prebuilt themes  
  - Filter
  - Tags
  - Icon colors
- Theme
  - Icon themes
  - Font themes
  - System fonts
- Timer
  - Alternative duration picker interfaces
- Widgets
  - Clock
  - Clock faces
  - Alarms
  - Timers
  - Stopwatch
  - Customization
 
## Screenshots
<p float="left">
<image src="fastlane/metadata/android/en-US/images/phoneScreenshots/1.png" height="400"/>
<image src="fastlane/metadata/android/en-US/images/phoneScreenshots/2.png" height="400"/>
<image src="fastlane/metadata/android/en-US/images/phoneScreenshots/3.png" height="400"/>
<image src="fastlane/metadata/android/en-US/images/phoneScreenshots/4.png" height="400"/>
<image src="fastlane/metadata/android/en-US/images/phoneScreenshots/5.png" height="400"/>
</p>


