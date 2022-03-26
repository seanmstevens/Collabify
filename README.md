
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

* [list first screen here]
   * [list associated required story here]
   * ...
* [list second screen here]
   * [list associated required story here]
   * ...

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
[Add picture of your hand sketched wireframes in this section]
<img src="YOUR_WIREFRAME_IMAGE_URL" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
