# Tatoeba iOS

The official Tatoeba iOS client.

[![MIT license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/Tatoeba/tatoeba-ios/master/LICENSE)

## Setup

### Install Carthage dependencies

First, make sure you have Carthage installed. Then run the following command to install all necessary dependencies:

```
$ carthage bootstrap --platform iOS --no-use-binaries
```

### Set up API locally

A more permanent API for Tatoeba will be undergoing development soon, but in the meantime, I've made a quick API for the purpose of testing the app. You can download it [here](https://github.com/jackcook/tatoeba-api), and it should work as soon as you import [Tatoeba's exports](https://tatoeba.org/eng/downloads) into your local MySQL database.

### Download and import localizations (optional)

If you want to have your local build be localized, you're going to need to get a [Transifex API key](https://docs.transifex.com/api/introduction) first. Once you have this, run the following commands to download localization files from Transifex and import them into the Xcode project:

```
$ ./scripts/download_loc [transifex-api-key]
Clearing existing source files... Done!
Downloading strings for en... Done!
Downloading strings for fr... Done!
Downloading strings for zh_TW... Done!
$ ./scripts/import_loc
Clearing existing strings files... Done!
Parsing strings for en... Done!
Parsing strings for fr... Done!
Parsing strings for ZW... Done!
```
