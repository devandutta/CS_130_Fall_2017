# Xplorer
Our team's project for CS 130 Fall 2017

Disclaimer: The github repository is private. It is however, shared with our TA.

# Motivation
A lot of us like to travel and explore new places. However, building an itinerary is a time consuming task, especially when your purpose of travel is a short business trip. Many times, it is quite cumbersome to find places in a new city based on your interests. It is even more difficult to plan out your day to visit these places in your free time during the day. More often than not, you just end up going to the local tourist attractions and call it a day. 

Maps applications, such as Google Maps, currently restrict you to either searching specifically for one interest (food/grocery store/gas station), local tourist attractions, or offering the fastest route from a start point to a destination. This is really useful, but these recommendations do not take into account your personal interests and what the rest of your day looks like. When you’re travelling, you usually have an end destination in mind that you want to get to at a certain time.

**Example:** You’re in New York for an interview and your interview is at 4pm. In this situation, you might want to leave your hotel in the morning and travel through some locations of interest to you and reach your interview location after sightseeing in New York. Or you might want to do sightseeing in New York after your interview before you head to the airport. Our application helps you do that and suggests a route that recommends locations en route to your destination, according to your interests and time constraints. You can then customize these places based on budget constraints and travel history.

# Feature Description and Requirements
Our application offers three main features as described below:
### Feature 1: Itinerary planning based on user interests and time constraints
The itinerary planning feature offers the user an itinerary based on their interests and time constraints. The user specifies their interests when they first open our application. Examples of interests are: live concerts, art, museums, popular tourist spots, restaurants, etc. The application keeps this information stored on the local device. The user can edit their interests at any time by going to the Settings section of the application. Once the user has finalized their interests, they are taken to the home screen of the application which requests the following information from the user: A start location and departure time, and an end location and arrival time. This information represents the time constraint of the user. Once the user enters this information, they are taken to a new screen and are presented with a list of places which match their interests, and the route they must take to visit these places such that they arrive at their destination on time.

The itinerary also lists the cost of visiting a place (entry fee, meal cost etc.), and the recommended amount of time to spend in that place. If the user is not happy with the itinerary generated, he/she can refresh the list of places generated (by pressing a “refresh” button at the top of the itinerary) to see a different itinerary which matches his/her interests. He/she can also change any information he/she provided (start/end locations, arrival/departure time) to generate a new itinerary by simply pressing the back button and entering his/her information again on the home screen. 

### Feature 2: Customizing itinerary based on user travel history and cost
Users can do more than just refresh or generate new itineraries, they can also apply filters to change the suggested places. The filter icon will be at the top section of the displayed itinerary, next to the “refresh” button. Applying filters will automatically refresh the itinerary. 
We are planning to implement two useful filters, described as follows:
1. **Filter based on cost:** The user can specify a total budget which they do not want to exceed while visiting all the places in the itinerary. The application will then generate a new itinerary which will be in line with the user’s budget. The users can also specify a cost constraint on any single place. Example: The user does not want to spend more than $30 at any single place. This filter will be very similar to what users are already familiar with in other applications such as Google Maps, Yelp, UberEats etc. 
1. **Filter based on travel history:** Once the user selects an itinerary, the application will track and store information about the places that the user visits. When generating a new itinerary, the user can use this filter to include or exclude places they’ve already visited. The default behavior will be to exclude places already visited.

### Feature 3: Effective route planning based on current itinerary
Once the user selects a particular set of places to visit, the application would enable to user to find the most effective route covering all points of interest. The application would be able to minimize both the distance travelled by the user and the time taken to travel between distances. Route planning would also involve modes of transportation. For instance, assume that the user is interested in museum 1, waterfall 1 and hill 1. The most effective route between the museum and the hill could involve travel via car or ride-share, meanwhile the most effective route between the hill and the waterfall could involve hiking through the hill. The application would consider the user’s priority and suggest the most optimal route accordingly.

# User Stories
1. A brand new user to the app will begin by downloading the app, entering his/her personal interests, and then specifying start time and departure location, as well as end time and arrival location.  The app will return a list of POIs (containing associated costs and transportation methods) that are along the fastest route to the arrival location.  The user, delighted by this automation, follows the itinerary in the app and enjoys the day!
1. A user who has used the app before will be able to open the app without specifying his/her interests again (but does have the option to change them if he/she so desires), enter the start and end times and locations, and then filter the returned list of POIs to get back only new places that he/she has not visited yet.

# Usage scenarios:
### Scenario 1: User is totally new to the app
1. User downloads the app from the iOS App Store.
1. User is in a city he/she would like to explore, while honoring their commitments for the day.
1. User opens our iOS app on his/her iPhone.
1. The app asks him/her for his/her interests (examples being art, museums, beaches, restaurants etc.) after displaying the splash screen.
1. User sees home screen asking him/her for start destination, departure time, end destination and arrival time.
  1. If user wants to change his/her interests, he/she can go to Settings and change the interests.
1. After filling out the information, user sees a list of places as an itinerary, complete with POI distances and associated costs (if the itinerary involves transportation, entrance fees, or food cost).
1. User can adapt this list based on cost and travel history filters.
1. Upon finalizing the itinerary by selecting options of interest, the user sees a route from his/her start to end destination, with the places he/she selected as en route stops for visiting.
1. The app keeps track of what places the user visits based on the itinerary he/she follows.

### Scenario 2: User is visiting a city that he/she has been in before and wants to explore more
1. User opens app.
1. Splash screen displays and then takes the user to the home screen with departure time and location and arrival time and location.
  1. If user wants to change his/her interests, he/she can go to Settings and change the interests.
1. After filling out the information, user sees a list of places as an itinerary, complete with POI distances and associated costs (if the itinerary involves transportation, entrance fees, or food cost).
1. If the app displays locations that the user has visited, the user can press the “Refresh” button to have the app generate a list that does not contain previously visited POIs.
  1. If the user wants to modify his/her interests, then he/she can press the “Back” button, and follow step 2a to go to Settings and modify his/her profile interests.
1. The user would then follow steps 7-9 of the previous scenario.




# UML Use Case Diagram



# Feasibility
It is inevitable that when visiting a new city, possibly for the first time, it requires an ample amount of meticulous planning and preparation. And while apps such as Google Maps, Yelp, and TripAdvisor might help you figure out popular destinations to visit, it is still currently up to the consumer to manually wade through a plethora of online suggestions, tourist attractions, and friends’ recommendations to see which places they can explore in a limited time frame at a reasonable travel distance and price.

Until now. What separates our application from the rest is that you don’t have to create your itinerary from scratch by consolidating all this information from different places and struggling to manually come up with the best possible plan. Our app will take into consideration the timeframe you’re free, the types of attractions you’re interested in, the location of the attraction, the average amount of time taken at popular destinations, and the approximate cost of the whole excursion. By doing all the heavy lifting for the user, this allows them to have a personalized and customizable plan in seconds.

To successfully develop and design this app, it is necessary to keep common pitfalls in mind and take the necessary precautions to avoid them throughout the course of the quarter. For iOS app development, most of us are familiar with the APIs we’re going to use such as Apple’s Cocoa and UIKit frameworks, the Google Maps API, and the Google Places API, all of which are extremely reliable and relatively accurate. We will have Google Maps Services objects from the Google Maps and Places APIs inside our UIViewControllers. Performance-wise, there are no expected speed delays associated with our app due to the relatively inexpensive operations of finding nearby attractions within a specified category and finding data such as prices and time taken to explore. The features list is enough to differentiate our product from others and make it an invaluable tool for anyone traveling to a new location, but not infeasible to implement during the quarter. Lastly, developing this software will not pose the problem of excessive cost, since all the APIs and technologies we are using are free.

**UML Class Diagram below**



**Explanation of Class Diagram:**
The app will be run by UIViewControllers, derived from UIViewController from the UIKit in iOS.  UIResponder and UIApplicationDelegate have been included because AppDelegate needs to implement and extend them, respectively.  UIViewController has been included because every ViewController will have to extend it.  All object types that begin with “GMS” indicate Google Mapping Services objects from the Google Maps API, as well as the Google Places API.  All other object types that begin with “UI” indicate views that were used from Apple’s UIKit for iOS.

# Capability
**Shashank Khanna** has iOS development and System design. He has developed several iOS applications in Objective-C, one of which was chosen for the app store with over 200 downloads across three countries and another was responsible for winning the grand prize for HackGT. He has system design experience, through designing high-traffic backend web features for large e-commerce companies. His estimated role in the team would be to do class design and do the Objective-C implementation of the iOS application. He would be developing the application layer that will interact with the API, display the required data and contain the business logic. For Part A, Shashank contributed to the feature description, researched the Google Distance Matrix API, and estimated its feasibility as to displaying different route types within the application. 

**Devan Dutta** has built an Objective-C app, as well as a Swift app.  The Objective-C app was a math game that quizzed users with addition and subtraction questions, while tracking progress, increasing difficulty, and rewarding players with custom animations that he programmed himself.  The Swift app was a mapping app that made use of the MapKit and CoreLocation frameworks within iOS to display a user’s displacement from a starting point on a map, as well as a dashboard of useful metrics, like horizontal accuracy and speed.  In addition to these apps, he has interned twice at Symantec and once at Facebook and has therefore been introduced to development along various points of a software stack.  In Part A of the project, Devan created the usage scenarios, user stories, the UML class diagram and the UML use case diagram.  He also researched the Google Maps API and Google Places API and edited both the report and the presentation.

**Avirudh Theraja** has made several apps for the Android platform. These include a face identification app, a music downloader app and an app for an NGO (Non governmental organization). He has also used various APIs in making these apps and has a good general grasp of mobile development principles. In addition to mobile development, he has experience in backend API development through interning at Amazon Web Services. For part A of the project, he wrote the motivation and the features. He also contributed to the user interaction stories.

**Vamsi Mokkapati** has experience working in iOS development, web applications, developing backend web features, and front-end automation in both the Protractor framework for AngularJS and the Jasmine framework in Java. He developed the main front-end interface for Feedr, an iOS application that enables users to share their recipe ideas on social media, and has created a VR game simulation using WebGL on a NodeJS server. He has gained experience in software development both in backend and front-end through internships at Ethertronics and IBM. For part A of the project, he wrote the feasibility section and researched the APIs and technologies required to build this app.

**Rishabh Aggarwal** has User Interface and User Experience Design experience and has designed several apps and websites for startups and other clients including Spotify, Sonos, Facebook and the City of LA. He is also experienced in front end web development using Angular and React and has built web apps from the ground up at various hackathons. For Part A of the project, he came up with the idea and worked with the team to decide on the core features, motivation and the user stories. He also designed the mockups and prototypes for the app. 

**Dhruv Thakur** has experience in backend development and databases. He also has some experience in working with the user interface component of applications through work done in internships. While he does not have much experience in app development, he is armed with the drive and desire to learn so he does not consider many tasks outside his reach. For Part A, Dhruv worked on the PowerPoint presentation.

