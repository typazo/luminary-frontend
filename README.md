# Luminary - Focus & Study Tracker

Luminary is an iOS app designed to help students stay focused by preventing phone distractions, tracking focus sessions, and rewarding productivity with stars. Users can post their focus progress to a feed and track their activity in their profile.

---

## Features
- Set a timer to focus and prevent phone distractions.  
- Earn a star for completing a focus session.  
- Post your focus duration and custom message to the feed.  
- View other users’ focus activity in a global feed.  
- Track your own stars and constellations in your profile.  


---

## Backend
This frontend connects to the **Luminary backend** for fetching constellations, creating sessions, and managing attempts.

**Backend repository:** [Luminary Backend](https://github.com/tnt07-t/luminary-backend)

> Make sure the backend server is running and accessible before starting the app.

---

## Screens

### Feed 
The global social timeline for focus achievements.

* **Content:** Scrollable list of user posts.
* **Post Data:** Includes user profile, time elapsed, focus message/duration, and star/plant reward image.

### Profile
The personal achievement tracker.

* **Stats:** Displays Total Focus Hours, Stars Completed, and Constellations Completed.
* **Achievements:** Scrollable, read-only gallery of completed constellations.

### Session
The three-stage focus workflow.

* **Start Session:** Set timer, select constellation, write custom message, and tap Start.
* **During Session:** Displays countdown timer. Must use the Cancel button to stop (app enforces focus).
* **Finished Session:** Summary of session duration and progress. Exit button returns to the Start screen.

---

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/luminary-frontend.git
    ```
2. Open luminary-frontend.xcodeproj in Xcode.
3. Make sure Xcode 15+ and Swift 5.9+ are installed.
4. Update the backend URL in NetworkManager.swift if needed.
5. Run the app on a simulator or device.

---

## Usage
- Select a constellation from the dropdown.
- Choose a session duration.
- Write a custom message to post with your study summary.
- Tap Start to begin a focus session.
- Complete the session to earn stars and post to the feed.
- Work towards completing constellations by completing study sessions.
- See your friends' progress.


## Dependencies
SwiftUI
Alamofire (networking)
