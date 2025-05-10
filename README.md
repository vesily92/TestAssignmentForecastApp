# TestAssignmentForecastApp

A simple iOS application that fetches and displays current weather from the OpenWeatherMap API with local caching in Core Data.

## Project Description

This project demonstrates:

* Fetching current weather by city name using the **OpenWeatherMap API**
* Parsing the response with **Codable** and **JSONDecoder**
* Saving and updating data in **Core Data** without creating duplicate records
* Displaying a list and detailed weather information using **UIKit** (UITableView + UIViewController)
* Supporting Pull-to-Refresh via **UIRefreshControl**
* Downloading and displaying weather icons from a separate URL

## Technologies Used

* **Swift 5**
* **UIKit**
* **Core Data** for local storage and data merging
* **URLSession + URLComponents** for constructing and executing network requests
* **Codable** for JSON decoding
* **Design Patterns:** MVVM (ViewController ↔ ViewModel ↔ Service)

## Architecture Rationale

1. **Separation of Concerns**

   * **Network Layer** (network requests via URLSession and URLComponents) is isolated in a dedicated service.
   * **CoreDataService** handle saving and updating models in Core Data.
   * **ViewModel** contains logic to make network requests and map Core Data entities to simple UI models for display.
2. **Core Data with Duplicate Checking**

   * Each update searches by a unique key (e.g., city name) to prevent record duplication.
3. **URLComponents**

   * Using `URLComponents` with `URLQueryItem` instead of string concatenation ensures proper parameter encoding (spaces, special characters, etc.).
4. **Pull-to-Refresh via UIRefreshControl**

   * Provides a consistent mechanism for refreshing data on scrollable content screens.
5. **API Key Storage**

   * The API key is currently defined as a static variable in `OpenWeatherEndpoint.swift`.

## Installation and Running Instructions

1. **Clone the repository**:

   ```bash
   git clone https://github.com/vesily92/TestAssignmentForecastApp.git
   cd TestAssignmentForecastApp
   ```

2. **Open the project in Xcode** (version 13+):

   * Open `TestAssignmentForecastApp.xcodeproj`.

3. **Configure the API key**:

   * Locate the file where the global `apiKey` variable is defined (in `TestAssignmentForecastApp/TestAssignmentForecastApp/BusinessLogic/Services/NetworkServices/Endpoints/OpenWeatherEndpoint.swift`).
