# GearShare
### iOS Programming Project Proposal
By Joseph Young, Larry Liu, and Lap Yan Cheung

## Overview
GearShare is a location-based application that allows for on-demand rentals of Camera Equipment from their community. 
Similar to AirBnB or Uber, our application GearShare allows users to view nearby products available for rent, but in our case they are able to rent camera equipment. Once a user (the renter) has created an account, they will be able to view nearby users (the loaners) who are loaning out their camera equipment for a set daily price. 
The renter is able to view the name of the product, descriptions, photos, product conditions, and prices. Once the renter has found their suitable equipment, he or she can click to request their desired equipment. A calendar will pop-up prompting the user to select available rental dates.
The user is then able to set a nearby pin for a public meeting place that will be confirmed by the loaner. Equipment transactions will take place in person, but money will ideally be handled within the application with payments being transferred to the loaner when the equipment has been given to the renter from the loaner and both have confirmed the trade in the application. 
For equipment that has an MSRP greater than $1000, deposits will be taken from the renter and held. After the rental time-period has ended, the renter and loaner will meet on the set date, at the set time, and location that was confirmed by both parties during initial rent request. Photos of the product will be taken during the transaction to ensure quality control. Both parties are then able to rate the other user and provide comments. 
Additionally, the loaner will inspect his equipment and check for damages. When damage has occurred both parties will be contacted for photos of the product that had been taken before and after in the application. The GearShare team will review. Depending on the GearShare team’s findings, the deposit and additional money may be sent to the loaner, or returned to the renter.  

## Audience 
Aspiring Photographers & Filmers (Renter): A user who is either thinking about pursuing photography/film or can’t afford to buy equipment. The aspiring photographer is able to use GearShare to pursue their passion at a reasonable cost.
Photographers & Filmers with One-Time Use Cases (Renter): A user who needs an expensive lens or camera body for single usage. This may be a user who requires a specific or expensive lens for a one-time film or photo-shoot, or a user who has broken their current equipment, but requires it urgently nonetheless; like a wedding photographer who has a job the next day and is missing a specific lens.
Photographers & Filmers with Equipment Laying Around (Loaner): This is the user with extra equipment that they do not use daily. Instead of facing sunk costs, they can get a better return on their investment by loaning it to aspiring photographers and filmers.

## Technical Challenges and Resources Needed
Some of the most significant technical challenges that we will likely encounter revolve around lack of experience working with our specific language and its associated libraries and frameworks. For example, since all of us learned Objective-C but are using Swift for this assignment, we’ll be facing an uphill climb in regards to learning this new language and its intricacies. We chose Swift over its counterpart due to the immense quantity of resources found online, such as the available map features which are integral to the core identity of our product. We’ll definitely take advantage of available resources online such as Lynda, which is an online tutorial site given to NYU students for free. Furthermore, the documentation for the tools we will be implementing will be essential to crafting our product correctly. For example, while we still haven’t guaranteed which database we want to work with, Firebase or Couchbase Lite, regardless of which one we choose, we’ll need to extensively study the syntax behind them in order to properly store user information.
In order to ensure success, we have the project broken down into steps. Our first round will include the implementation of our database, user login/account creation, user profile information,  adding products, and searching for products on a list view. The first iteration ensures that all critical components to have a usable application have been completed. Our second iteration will add in the Map API, Pins that include a user’s product offering, and the ability to select meeting points. This will give users a more streamlined and intuitive interface to work with. Our third iteration (if time permits), will allow us to focus on adding additional features that will enhance our product. In terms of priority, the additional features will include an in-app payment system, calendar view, complaint handling, and notifications.

## Overall Logic and Flow Chart
The site will begin with a login / user registration launch page that will take in either an existing username and password to access account, or an option for creating a new account by putting in a desired username, password, and corresponding email address. After registration, in which there are certain restrictions such as no duplicate usernames in the database or having to type in your password twice, the user can log in to their account. From here, a map will be displayed that showcases the local community given a specific radius of size that has yet to be decided by the company. Filtering can then be made through the search bar, and matches will be shown based on how much each product being rented matches the user’s criteria. 
On the bottom of the app, there are three tabs that take the user to three different pages. The first will be the map, which is the default screen after logging in. This is the main page that the user can use to access requests for the equipment that they need. The second tab reflects the offering page, in which users can experience the contrary feature of the app, which involves putting up their own equipment for others to rent. Lastly, we will have a profile tab in which the user can view different aspects of their account such as transaction history, current rentals, current products up for lease, and other logistical information.

## Intial Design Layout 
### Mock Up of the User Interface
### Login Screen and Map Homepage
### Search Results (or Filter) for Device on Map and Request
### Post Item for Rent
### Profile and approve requests

## Responsibility and Roles
### Joseph Young
Front and Backend Integration
Connecting the database (Larry Liu) to the front end (Lap Yan Cheung) and implementation of user interactions. My role will be responsible for collecting and sending relevant data to the database setup by Larry. Data to be sent and receive will include passwords and user data (photos, items for rent, etc…). I will also be working with Lap Yan Cheung to implement the user design with the user interaction within the application like moving between views and working with posts to store the data. Ultimately, my job will focus on tying the back and front end together.

### Larry Liu
Backend
Implementation of the backend focusing on the database to store data for passwords and other user data. 

### Lap Yan Cheung
Product Design
Mainly responsible for the overall user experience and user interface of the application. Integrating objects on the interface with inputs and outputs from the database, Maps SDK and backend services.

## Projected Features (End of Semester)
Map and Search: A dynamic map with a search bar. Once a query of an item is passed in, it will be evaluated and relevant results will be displayed on the map as pins. The results will be retrieved from the database according to the terms derived from the search query, and their respective GPS location. We will utilize either Apple Maps SDK or Google Maps SDK and will be using a listview for our first round implementation.
Once the pins appear, users will be able to interact with them. A click on a pin will display information regarding the lender’s item, including the item’s name, lender’s name, rental rates, and a button to submit a rental request to the lender.
Lender Posting: Lenders can upload an item by including images of it, as well as its name, description, condition and rental rates. Once the lender clicks the post button, the data inputs will be submitted to the database as well as the GPS data by the user.
User Profile:  User profiles will include their names, interests, contact information, and any items they may have for rent. All users can view their rental and lending history, as well as approving or rejecting rental requests submitting to them.
Once a rental request is approved, the lender can send the renter a location and meeting time in text. The renter can see the location suggestion and either send back a rescheduled time and location, or agree to the lender’s recommendation

## Additional Features (Coming Months)
Payment System: Integration with a payment system API like Venmo, Apple Pay, Paypal or Amazon so that payments can be handled through the app instead of face to face. In-App money handling would also including deposit handling. 
Before Implementation of the Payment System: Similar to craigslist, transactions between users will take place in person using either cash or venmo. Both parties will confirm within the application that the correct amount has been transferred. 
Setting Up Meeting Areas: Either through the integration of an in-app messaging system for users to communicate or a map-based implementation that allows users to select and confirm locations to meet nearby. We also hope to supply GPS directions to designated locations.
Before Implementation of Meeting Areas: Similar to craigslist, users will supply a form of communication (cell phone or email) to contact one another and set a neutral meeting place.
Calendar View: When selecting a product, users are able to view a calendar and select the days they would like to rent the product(s). Blocked out days will show when the products have already been booked.  
Before Implementation of Calendar View: The renter and loaner will have to discuss rental dates through email or text-messaging. 
Handling Complaints: Complaints will be handled by the users uploading photos of the products during their initial exchange and when returning the products. If either user has a complaint they will be able to send a complaint request to GearShare within the application, where the team will examine the photos and determine the outcome of damage done to a product. Then the team will choose to send the deposit and possibly additional money to the loaner or return the money to the renter. There will be a 30 day period in which the loaner can report his product as damaged, but can no longer report it after the 30 day period. 
Notifications: Integrate a reminder system for when users need to meet and remaining days left on the rental period.
