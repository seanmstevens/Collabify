
# Collaborative Playlist

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
A 'shared playlists' app where a user can make collaborative playlists with their peers. The main feature is that everyone in the group has to approve an incoming song request, only then it will be added to the playlist. This ensures only those songs get added to the playlist which are approved, or 'liked', by everyone.

### App Evaluation
- **Category:** Social Networking / Music
- **Mobile:** This app is focused primarily for mobiles. Such a concept can be extended for a web application as well, but, users would prefer the mobile version more than it's web application.  
- **Story:** User invites and makes a group of friends, creating a common playlist. Anytime a user enters a song, all of the group has to approve it for it to be added to the playlist.  
- **Market:** An individual belonging to any age group who has an affinity to music and discovering new songs! 
- **Habit:** This app could be used as often or unoften as the user wanted. 
- **Scope:** The scope could be increased to playing music on the app, suggesting new music based on the group's playlist. 

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User sees custom app icon in home screen.
* User sees a styled launch screen when opening the app.
* User can log in using a spoitfy account.
* User can log out.
* User stays logged in across restarts.
* User sees can create playlist.
* User can add friends to playlist.
* User can see playlist detail (songs pending approvoal, members of playlist).
* User can approve/decline a song on a pending state in the playlist.

**Optional Nice-to-have Stories**

* User can play songs with a custom music player
* Users accors different app can listen to the same music together
* User can chat with members inside the app.

### 2. Screen Archetypes

* **Feed - Collection View**
   * User sees and can create playlists.
   * User can log out.
* **Playlist Detail View**
   * User can create playlists.
   * User can add friends to playlist.
   * User can see playlist detail (edits pending approval, playlist members).
   * User can approve/decline a song in a pending state in the playlist.
* **Login View**
   * User can log in using a Spotify account.

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* **Global Feed:** This is where all playlists created by all users of the app will be diplayed in a table view or collection view.
* **User Feed:** This tab will filter the playlists to only those created or contributed to by the authenticated user. Since the playlists in this tab will be part-owned by the user, they will be editable.
* **Settings:** General user profile settings. Enables the user to set their display name, change their password, and edit their profile picture, among other options.

**Flow Navigation** (Screen to Screen)

* **Global Feed:** A collection view of playlists with basic information displayed.
   * **Playlist Detail View:** In this view, details about the particular playlist selected in the collection view will be displayed to the user. Information such as the contributors to the playlist, the songs (including artist), total length of the playlist, and a custom playlist image will be shown.
   * **Player View:** When a user hits the play button on a playlist, it will bring them to a player view that will automatically start the playlist from the beginning track.
* **User Feed:** Another collection view of playlists, filtered to those playlists that the authenticated user owns.
   * **Playlist Detail View:** Similar to the detail view associated with the global feed, this view will show details about each playlist, and will include additional contextual controls for editing the playlist details.
   * **Edit View:** When a user selects the "edit" button, they will be presented with a modal interface where they can change the playlist information including title, custom image, in addition to adding, removing, and reordering the tracks in the playlist.

## Wireframes
Figma Wireframes/mockups: https://www.figma.com/file/MvkJd9Yeq0w9gZkvZw5FQe/Spotify-Colab?node-id=0%3A1

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 

### Models

#### Playlist

<table>
  <tr>
   <td><strong>Property</strong>
   </td>
   <td><strong>Type</strong>
   </td>
   <td><strong>Description</strong>
   </td>
  </tr>
  <tr>
   <td>objectId
   </td>
   <td>String
   </td>
   <td>unique ID for the playlist (default field)
   </td>
  </tr>
  <tr>
   <td>name
   </td>
   <td>String
   </td>
   <td>the plain text name of the playlist
   </td>
  </tr>
  <tr>
   <td>authors
   </td>
   <td>[Pointer to User]
   </td>
   <td>an array of pointers to Users that are collaborators on the playlist.
   </td>
  </tr>
  <tr>
   <td>image
   </td>
   <td>File
   </td>
   <td>the custom image used for the playlist
   </td>
  </tr>
  <tr>
   <td>tracks
   </td>
   <td>[Pointer to Song]
   </td>
   <td>an array of pointers to Song objects that make up the items of the playlist
   </td>
  </tr>
  <tr>
   <td>spotifyId
   </td>
   <td>String
   </td>
   <td>unique Spotify ID for the playlist. Will be null until the playlist is created via the Spotify API.
   </td>
  </tr>
  <tr>
   <td>isUnderVote
   </td>
   <td>Boolean
   </td>
   <td>indicates if the playlist is being voted on for publication to Spotify API
   </td>
  </tr>
  <tr>
   <td>voteCount
   </td>
   <td>Number
   </td>
   <td>the number of votes the playlist has received for publication
   </td>
  </tr>
  <tr>
   <td>votesToSucceed
   </td>
   <td>Number
   </td>
   <td>the number of affirmative votes the playlist must receive to be published to the Spotify API. Serves as a snapshot of the voting user count when a vote is initiated.
   </td>
  </tr>
  <tr>
   <td>createdAt
   </td>
   <td>DateTime
   </td>
   <td>date when the playlist is created (default field)
   </td>
  </tr>
  <tr>
   <td>updatedAt
   </td>
   <td>DateTime
   </td>
   <td>date when the playlist is updated (default field)
   </td>
  </tr>
</table>

#### Song

<table>
  <tr>
   <td><strong>Property</strong>
   </td>
   <td><strong>Type</strong>
   </td>
   <td><strong>Description</strong>
   </td>
  </tr>
  <tr>
   <td>objectId
   </td>
   <td>String
   </td>
   <td>unique ID for the playlist (default field)
   </td>
  </tr>
  <tr>
   <td>title
   </td>
   <td>String
   </td>
   <td>the title of the song
   </td>
  </tr>
  <tr>
   <td>artist
   </td>
   <td>String
   </td>
   <td>the name of the artist(s) that are listed on the song
   </td>
  </tr>
  <tr>
   <td>album
   </td>
   <td>String
   </td>
   <td>the name of the album to which the song belongs
   </td>
  </tr>
  <tr>
   <td>duration
   </td>
   <td>Number
   </td>
   <td>the duration of the song, in seconds
   </td>
  </tr>
  <tr>
   <td>spotifyId
   </td>
   <td>String
   </td>
   <td>unique Spotify ID for the song.
   </td>
  </tr>
  <tr>
   <td>imageUrl
   </td>
   <td>String
   </td>
   <td>the Spotify-hosted image url for the song item
   </td>
  </tr>
</table>

### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]


### GIFs 
![](https://i.imgur.com/1ba6g38.gif)

