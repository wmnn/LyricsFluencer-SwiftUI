# LyricsFluencer App

## What can you do with the app ?

The goal of the app is to learn a language through music lyrics. Each bar will be translated to your mother tongue and a bar will be displayed under the bar of the orginal lyrics. You can click on a word and add it to your vocabulary deck. You can also google the meaning and display conjugation within the app. It is possible to recognize the song you are currently playing through the ShazamKit.

## How does the app work ?

The app depends on a [backend](https://github.com/wmnn/LyricsFluencerBackend), that will also display a website, but not feature complete. You can either do a quick search (the lyrics will be displayed afterwards without selecting the right song) or click on browse songs and select the right song manually. In both cases an api endpoint will be called. The backend will then use the musixmatch api to find a corresponding song in relation to the search query. 

The musixmatch api reponse will contain a link to a site where the lyrics are displayed. On quicksearch the backend will repond with the lyrics and translated lyrics right away. On manual search, where the user can select the right song, only the search results will be displayed and after clicking on the right song, the api will be called and the lyrics will be generated. Look into the "How the lyrics are generated" section to find out more about how the lyrics are generated.

Authentication is done through firebase and is not depended on the backend. A role and subscription system was implemented, subscriptions were possible on the website served from the backend, not in app due to app store policies. Subscriptions were possible through stripe and paypal, the api endpoints and the code for the subscriptions is still available on the backend, but subscriptions are removed from the website.

## How the lyrics are generated ?

It is quite hard to find a good api for music lyrics, musixmatch offers a free api, where only a part of the lyrics will be send and not the whole song. Other services only provide enterprise solutions. In order to display the lyrics of the whole song the lyrics will be scraped from the musixmatch website. The translated lyrics in the native tongue, the lyrics will be translated through the google translate api. The backend reponse for the client will contain the original and the translated lyrics. The client is responsible for showing it correctly beneath each other.

The search results of the musixmatch api will contain a link, where the right lyrics are displayed.  


## Run yourself? 

In 2023 the app was available in the apple app store, but I didn't renew my app developer license.

Due to the dependence on the musixmatch service and the google translation api it is not possible currently, the backend doesn't scrape the right data anymore, the project is archived.

- Run the [backend](https://github.com/wmnn/LyricsFluencerBackend)
- Add api route to `Models > Constants.swift`
- Add a firebase GoogleService-Info.plist file inside ./LyricsFluencer

## Possible future implementations:

* Scraping the google translate results from the google translate website in order to prevent using the api and save costs.
* Saving original lyrics and translated lyrics in an own database structure and implementing a search algorithmn in order to be independent from other ressources

## Previews

A video preview is available.

[![Preview](https://img.youtube.com/vi/r6hOcPQAIJY/0.jpg)](https://youtu.be/r6hOcPQAIJY)

### 1. Recognize a Song with Shazam or Search a Song

<img src="/images/Search.png" width="125">


### 2. Understand the Lyrics

<img src="/images/LyricsMenu.png" width="125">

### 3. Google Words you don't know

<img src="/images/GoogleMeaning.png" width="125">

### 4. Add words you don't know to your flashcard decks

<img src="/images/AddToDeck.png" width="125">
 
### 5. Manage your decks
<img src="/images/Decks.png" width="125">
 
### 6. Learn added cards

<img src="/images/Card_2.png" width="125">
 
