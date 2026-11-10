\# Smart Charity App



A mobile application developed using Flutter and Firebase to provide users with an accessible platform for exploring charity campaigns and supporting charitable activities.



\## About the Project



Smart Charity is a mobile application developed as part of a university Mobile Application Development project.



The application aims to make charity-related information more accessible by allowing users to explore campaigns and interact with the application through a user-friendly mobile interface.



\## Objectives



\- Provide an accessible platform for charity campaigns.

\- Allow users to register and log in securely.

\- Display available charity campaigns.

\- Facilitate campaign-related donation activities.

\- Provide a simple and user-friendly mobile experience.



\## Technologies Used



| Technology | Purpose |

|---|---|

| Flutter | Mobile application development |

| Dart | Main programming language |

| Firebase Authentication | User authentication |

| Cloud Firestore | Database management |

| Firebase Core | Firebase integration |



\## Main Features



\### 1. User Authentication

\- User registration.

\- User login using email and password.

\- User logout functionality.



\### 2. Home Interface

\- Main application interface.

\- Navigation between application sections.



\### 3. Charity Campaigns

\- Display charity campaign information.

\- Retrieve campaign data from Cloud Firestore.

\- Handle campaign-related donation records.



\### 4. Map Interface

\- Dedicated map screen within the application.



\### 5. User Profile

\- User-related application section.



\## Project Structure



```text

smart-charity-app/

│

├── assets/

│   ├── animations/

│   ├── images/

│   └── sounds/

│

├── lib/

│   ├── models/

│   ├── screens/

│   │   ├── auth/

│   │   ├── home/

│   │   └── map/

│   ├── services/

│   │   ├── auth\_service.dart

│   │   └── campaign\_service.dart

│   ├── firebase\_options.dart

│   └── main.dart

│

├── android/

├── ios/

├── web/

├── test/

│

├── pubspec.yaml

└── README.md

```



\## Screenshots



Application screenshots will be added here to demonstrate the user interface and main functionalities.



\## Installation and Setup



1\. Clone this repository:



```bash

git clone https://github.com/hanishamsan/smart-charity-app.git

```



2\. Navigate to the project directory:



```bash

cd smart-charity-app

```



3\. Install the required dependencies:



```bash

flutter pub get

```



4\. Configure your own Firebase project and ensure the required Firebase configuration files are available.



5\. Run the application:



```bash

flutter run

```



\## Learning Outcomes



Through this project, I gained practical experience in:



\- Developing mobile applications using Flutter and Dart.

\- Implementing user authentication using Firebase.

\- Managing application data using Cloud Firestore.

\- Organizing application code using models, screens and services.

\- Integrating Firebase services into a mobile application.



\## Developer



Developed as part of a university academic project.



\*\*Technologies:\*\* Flutter | Dart | Firebase

