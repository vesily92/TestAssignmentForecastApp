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

> **Note:** The project uses a global variable to store the API key.

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
   * **DataImporter / CoreDataService** handle saving and updating models in Core Data.
   * **ViewModel** contains logic to map Core Data entities to simple UI models for display.
2. **Core Data with Duplicate Checking**

   * Each update searches by a unique key (e.g., city name) to prevent record duplication.
3. **URLComponents**

   * Using `URLComponents` with `URLQueryItem` instead of string concatenation ensures proper parameter encoding (spaces, special characters, etc.).
4. **Pull-to-Refresh via UIRefreshControl**

   * Provides a consistent mechanism for refreshing data on scrollable content screens.
5. **API Key Storage**

   * The API key is currently defined as a static variable in `OpenWeatherEndpoint.swift` (`TestAssignmentForecastApp/TestAssignmentForecastApp/BusinessLogic/Services/NetworkServices/Endpoints/OpenWeatherEndpoint.swift`). This can be replaced with a `PlistAPIKeyProvider` or injected via dependency injection for improved security and testability.

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
   * Replace its value with your OpenWeatherMap API key:

     ```swift
     private static let apiKey = "YOUR_OPENWEATHERMAP_API_KEY"
     ```
4. **Build and run** on an iOS 15+ simulator or device.


## Questions

### Networking

**What is Networking?**
Networking is the layer responsible for exchanging data with external services over the network: constructing HTTP requests, sending them via URLSession (or third-party libraries), receiving responses, checking status codes, and parsing data (JSON, XML, etc.).

**When should you not use URLSession or Alamofire?**

* When no HTTP requests are needed (data is local or accessed via built-in frameworks).
* When using non-HTTP protocols (WebSockets, MQTT, gRPC) that require specialized libraries.
* For very simple GET requests where you don't want extra dependencies: URLSession suffices, and adding Alamofire is unnecessary.

**What's the difference between URLSession and Alamofire?**

* **URLSession** is the built-in iOS low-level API: you configure a `URLRequest`, call `dataTask` or `data(for:)`, check the `HTTPURLResponse`, and decode the response.
* **Alamofire** is a wrapper over URLSession that adds conveniences: request chaining, automatic serialization/deserialization, response validation, retries, and a DSL for building and handling requests.

### Handling Data

**Why use Core Data instead of UserDefaults for complex data?**

* Core Data supports structured models with relationships, batch operations, caching, and background contexts.
* It maintains data integrity and supports schema migrations.
* UserDefaults is intended for simple preferences (numbers, strings, small dictionaries).

**How would you handle API errors?**

1. Define an error enum (`NetworkError`) with cases like `invalidURL`, `badResponse`, `emptyData`, `decodingError`, etc.
2. Throw errors in the network layer and catch them in the ViewModel or controller, presenting the appropriate UI.
3. Conform the enum to `LocalizedError` for user-friendly descriptions in `error.localizedDescription`.
4. Implement retries or custom logic for transient errors (timeouts, connectivity issues).

### Architectural Patterns

**Why use architectural patterns (MVC, MVVM)?**

* They enforce separation of concerns: UI logic is kept separate from business and data logic.
* They improve testability: you can unit-test ViewModels and services without UI.
* They enhance maintainability and scalability by reducing code coupling.

**How would you organize code so business logic is independent of the UI?**

* Move business logic to services (e.g., NetworkService, CoreDataService) that return models or throw errors.
* Use ViewModels or Presenters that have no UIKit dependencies, exposing `@Published` properties, delegates, or callbacks.
* Let ViewControllers or Views bind to the ViewModel's outputs to update the UI.

### Offline Mode

**How would you ensure the app works correctly offline?**

* Use `NWPathMonitor` to detect network status.
* When offline, display cached data from Core Data and an offline indicator.
* Write tests to cover key offline scenarios.

**How would you refresh data when the device reconnects?**

* Subscribe to `NWPathMonitor` and call `viewModel.refresh()` when the network path becomes `.satisfied` after being `.unsatisfied`.
* Queue any offline actions (e.g., updates) and synchronize them when connectivity is restored.
* Merge fresh data into Core Data and notify the ViewModel of updates.

