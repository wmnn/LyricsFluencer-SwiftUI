# LyricsFluencer SwiftUI App  

Easily add words from song lyrics to your flashcard decks.  

## How Does the App Work?  

LyricsFluencer relies on a [backend](https://github.com/wmnn/LyricsFluencerBackend) that also serves a React/Next.js website.  

You can either:  
- Perform a **quick search**, which fetches lyrics immediately but may not always match the exact song.  
- **Browse songs manually**, selecting the correct track before retrieving its lyrics.  

In both cases, an API request is sent to the backend, which uses the Musixmatch API to find a corresponding song based on your search query.  

The Musixmatch API response includes a link to a webpage where the lyrics are displayed.  
- **Quick Search**: The backend directly returns the lyrics along with a translation.  
- **Manual Search**: The app first displays search results. After selecting the correct song, another API request retrieves the lyrics.  

For more details on how lyrics are retrieved, see the **"How Lyrics Are Generated"** section.  

### Authentication & Subscription  

Authentication is handled through Firebase and is independent of the backend.  

A role-based subscription system was originally implemented. While subscriptions were available on the backend-hosted website via Stripe and PayPal, they were **not** available in the app due to App Store policies. Though subscriptions have been removed from the website, the relevant API endpoints and code remain in the backend.  

## How Are Lyrics Generated?  

Finding a reliable lyrics API is challenging. Musixmatch offers a free API, but it only provides partial lyrics. Other services typically require enterprise-level plans.  

To display full song lyrics, the app **scrapes** them from the Musixmatch website. Translations are then generated using the Google Translate API. The backend response includes both the original and translated lyrics, which the client displays side by side.  

If scraping fails, the app falls back on Musixmatch’s limited free lyrics. If translation via Google Translate is unsuccessful, only the original lyrics will be shown.  


## Run yourself? 

In 2023 the app was available in the apple app store, but I didn't renew my app developer license. You can clone the repository and run it local in XCode.

 1. Run the [backend](https://github.com/wmnn/LyricsFluencerBackend)
 2. Add the firebase GoogleService-Info.plist file, of your firebase project, to ./LyricsFluencer
 3. Add the api route to `Models > Constants.swift`

## Possible future implementations:

* Scraping the google translate results from the google translate website in order to prevent using the api and save costs.
* Saving original lyrics and translated lyrics in an own database structure and implementing a search algorithmn in order to be independent from other ressources

## Previews

A [video preview](https://youtu.be/r6hOcPQAIJY) is available.

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
 
