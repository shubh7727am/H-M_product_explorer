![AppIcon](android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png)

# H&M Product Explorer

The **H&M Product Explorer** app provides users with a curated selection of H&M products, categorized for convenience and easy navigation. Using **Flutter** and **Riverpod**, the app efficiently fetches and displays data from the H&M API via **RapidAPI**. The design focuses on clean UI, pagination for large datasets, and a maintainable architecture with **MVVM** principles.

---

## Features

- **Product List Screen**: Displays H&M products with images, names, and relevant details.
- **Category Selection**: Filter products based on specific categories.
- **Pagination Support**: Fetches and displays 30 products per page as the user scrolls.
- **API Integration**: Utilizes H&M API endpoints from **RapidAPI** to fetch product data.
- **Light and Dark Mode**: Theme switching for better user experience.
- **State Management**: Handled using **Riverpod** for reactive and scalable code.
- **Error Handling**: Gracefully handles API errors and network issues.

---

## Technical Stack

- **Flutter**: For cross-platform development.
- **Dart**: The core programming language.
- **Riverpod**: State management.
- **MVVM Architecture**: Ensures a clean and scalable codebase.
- **RapidAPI**: H&M API integration.

---

## App Architecture

The app follows the **MVVM** design pattern for better separation of concerns:

```
lib/
├── core/
│   ├── theme/
│   │   ├── theme_profiles.dart        // Light and dark mode profiles
│   │   └── theme_provider.dart        // Theme management with Riverpod
│   └── utils/
│       └── utils.dart                 // Utility functions
│
├── models/
│   ├── product.dart                   // Product model class
│   └── category.dart                  // Category model
│
├── services/
│   └── product_service.dart           // API integration to fetch product data
│
├── view_models/
│   ├── product_notifier.dart          // State notifier for product data
│   └── category_notifier.dart         // State notifier for categories
│
├── views/
│   ├── widgets/
│   │   └── product_tile.dart          // Product card widget
│   │
│   ├── product_list_screen.dart       // Main screen displaying paginated product list
│   └── select_category_screen.dart    // Screen for selecting product categories
│
└── main.dart                          // App entry point
```

---

## Setup Instructions

### Prerequisites:

- **Flutter**: 3.24.5
- **Dart**: 3.5.4
- **RapidAPI Key**: Obtain an API key from [RapidAPI H&M](https://rapidapi.com).

### Steps:

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd hm_productexplorer
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Add your **RapidAPI Key**:
    - Open `product_service.dart` under `lib/core/services/`.
    - Replace `YOUR_API_KEY` with your valid RapidAPI key.

4. Run the app:
   ```bash
   flutter run
   ```

---

## API Integration

The app uses the **H&M API** provided via **RapidAPI**. Key endpoint:

- **Fetch Product List**: `/products/list`
    - Fetches products with pagination support.

Example API Call:
```dart
final response = await http.get(
  Uri.parse('https://apidojo-hm-hennes-mauritz-v1.p.rapidapi.com/products/list?page=1&pageSize=30'),
  headers: {
    'X-RapidAPI-Key': 'YOUR_API_KEY',
    'X-RapidAPI-Host': 'apidojo-hm-hennes-mauritz-v1.p.rapidapi.com',
  },
);
```

---

## Key Functionalities

1. **Product List with Pagination**:
    - The product list fetches data in chunks of 30 items.
    - Automatically loads the next page as the user scrolls.

2. **Category Selection**:
    - Users can filter products based on categories.
    - Category data is fetched and displayed dynamically.

3. **Theming**:
    - Supports Light and Dark themes for better accessibility.

---


This app demonstrates:

- **Technical Proficiency**: Implementation of **Flutter** best practices and API integration.
- **State Management**: Efficient state handling with **Riverpod**.
- **API Integration**: Seamless fetching and display of paginated product data.
- **UI/UX**: Clean and functional user interface for better usability.
- **Code Quality**: Modular architecture adhering to **MVVM** principles.

---

## Future Enhancements

- Add search functionality to filter products further.
- Implement product details screen with additional information.
- Improve offline caching for faster loading.

---


Developed by **Shubham Choudhary**

---
