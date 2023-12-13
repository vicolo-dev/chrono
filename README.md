# Chrono
A modern and powerful clock, alarms, timer and stopwatch app for Android!

Its usable, but still WIP, so you might encounter some bugs. Feel free to open an issue.

![tests](https://github.com/AhsanSarwar45/clock/actions/workflows/tests.yml/badge.svg)
[![codecov](https://codecov.io/gh/AhsanSarwar45/clock/branch/master/graph/badge.svg?token=cKxMm8KVev)](https://codecov.io/gh/AhsanSarwar45/clock)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/7dc1e51c1616482baa5392bc0826c50a)](https://app.codacy.com/gh/AhsanSarwar45/clock/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)

# Table of Content
- [Features](#features)
- [Installation](#installation)
- [Platforms](#platforms)
- [Development](#development)
- [Todo](#todo)

## Features
- Modern and easy to use interface
### Alarms
- Customizable schedules (Daily, Weekly, Specific week days, Specific dates, Date range)
- Configure Melody, rising volume and vibrations
- Configure Snooze length and max snoozes
- Alarm tasks (Math problems, Retype text, Sequence, more to come)
- Filter alarms (all, today, tomorrow, snoozed, disabled, completed)
### Clock
- Customizable clock display
- World clocks with relative time difference
- Search and add cities
### Timer
- Configure Melody, rising volume and vibrations
- Timer presets
- Filter timers (all, running, paused, stopped)
### Stopwatch
- Lap history with lap times and elapsed times
- Lap comparisons
### Appearance
- Highly customizable color themes
- Highly customizable style themes

## Installation
- Download the relevant apk from the [latest release](https://github.com/AhsanSarwar45/clock/releases/latest/downloads)
- Install (make sure to allow install from unknown sources)

## Platforms
Currently, the app is only available for android. I don't have an apple device to develop for iOS, but feel free
to contribute if you want iOS support. The alarm and timer features
use android-only code, so that will need to be ported. Everything else should mostly work fine.

## Development

This app is built using flutter. All you need is to follow [this](https://docs.flutter.dev/get-started/install) 
guide to install it, and you should be able to start developing it.

## Todo
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
- Timer
  - Alternative duration picker interfaces
- Online?
  - Sync?
  - Community themes?
