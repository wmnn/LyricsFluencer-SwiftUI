# LyricsFluencer App

## What is the goal of the app?
Learning a language through music lyrics. 

## Run yourself? (Not possible currently, the app depends on a backend (implemented in NextJS) and the backend is broken at the moment. It depends on services and doesn't scrape the right data anymore, the project is archived)

  - Add a firebase GoogleService-Info.plist file inside ./LyricsFluencer

## Contents & Features

* SwiftUI - The App source code for IOS
  - Recognize songs with ShazamKit inside the App
  - Look at the songs lyrics in the original and your native language
  - Add words to a flashcard deck

# How does the App work?

## 1. Recognize a Song with Shazam or Search a Song

<img src="/images/Search.png" width="250">

## How does the search work?

Shazam returns the artist name and song title, this is the search query for an api endpoint that returns an url, this url can be scraped to get the lyrics. If you tipe in a search query it works the same.

## 2. Understand the Lyrics

<img src="/images/LyricsMenu.png" width="250">

## How the lyrics are generated?

The Lyrics are scraped from a website and after that translated through the google translate api, possible future steps could be:
* Scraping the google translate results from the google translate website in order to prevent using the api and save costs.
* Saving original lyrics and translated lyrics in an own database structure and implementing a search algorithmn in order to be independent from other ressources

## 3. Google Words you don't know

<img src="/images/GoogleMeaning.png" width="250">

## 4. Add words you don't know to your flashcard decks

<img src="/images/AddToDeck.png" width="250">
 
## 5. Manage your decks
<img src="/images/Decks.png" width="250">
 
## 6. Learn added cards

<img src="/images/Card_2.png" width="250">
 
