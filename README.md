# 🚀 flutter_infinite_scroll_pagination
```
flutter_infinite_scroll_pagination is a simple, lightweight and customizable infinite scrolling pagination library for Flutter.

It helps developers easily load more data automatically while scrolling through lists and grids without manually managing page states, loading indicators or scroll listeners.

The library provides pagination controller support, automatic next-page loading, pull-to-refresh, error handling, loading indicators, empty states and reusable infinite list/grid widgets.

Developers can create modern feed-style interfaces, product lists, social timelines, chat history, search results and other endless scrolling experiences for Android, iOS, Web and Desktop applications using a simple API.
```

--------------------------

## ✨ Features
```
- 🔄 Automatic Infinite Scrolling Pagination
- 📃 InfiniteListView for paginated lists
- 🧩 InfiniteGridView for paginated grids
- 📦 PaginationController with page tracking
- ⚡ Automatic next page loading on scroll
- 🔃 Pull To Refresh support
- ⏳ Built-in loading indicator widget
- ❌ Built-in error indicator with retry
- 📭 Empty state when no data is available
- 📄 Supports custom item widgets
- 🛠 Reusable and easy to customize
- 🌐 Supports Android, iOS, Web & Desktop
- 📦 Lightweight and high performance
```

------------------------------------

## 📦 Installation

Add dependency in your pubspec.yaml
```
dependencies:
  flutter_infinite_scroll_pagination:
    path: https://github.com/Excelsior-Technologies-Community/flutter_infinite_scro
```
Then run:
```
flutter pub get
```

-----------------------------------

## 🎬 Preview

https://github.com/user-attachments/assets/d8bf11b1-8cdc-4c77-9174-ab1a01a9926a

--------------------------------------

## 🗂 File Structure 
```
flutter_infinite_scroll_pagination/
│
├─ lib/
│   ├─ flutter_infinite_scroll_pagination.dart
│   │   // Main library export file
│   │
│   ├─ main.dart
│   │       // Example demo application
│   │ 
│   └─ src/
│       ├─ infinite_scroll_pagination.dart
│       │   // Base pagination wrapper
│       │
│       ├─ pagination_controller.dart
│       │   // Handles loading and pagination state
│       │
│       ├─ pagination_state.dart
│       │   // Stores list, page and error state
│       │
│       ├─ pagination_status.dart
│       │   // Enum for loading/success/failure/completed
│       │
│       └─ widgets/
│           ├─ infinite_list_view.dart
│           │   // Infinite scrolling ListView widget
│           │
│           ├─ infinite_grid_view.dart
│           │   // Infinite scrolling GridView widget
│           │
│           ├─ loading_indicator.dart
│           │   // Reusable loading widget
│           │
│           ├─ error_indicator.dart
│           │   // Reusable error widget with retry
│           │
│           └─ empty_indicator.dart
│               // Reusable empty state widget
│
│
├─ README.md
│   // Package documentation
│
├─ LICENSE
│   // Open source license file
│
└─ pubspec.yaml
    // Package configuration file
```

--------------------------------

## 🚀 How To Use

1️⃣ Import Package
```
import 'package:flutter_infinite_scroll_pagination/flutter_infinite_scroll_pagination.dart';
```
2️⃣ Create Pagination Controller
```
late PaginationController<String> controller;

@override
void initState() {
  super.initState();

  controller = PaginationController<String>(
    onLoadPage: (page) async {
      await Future.delayed(const Duration(seconds: 2));

      if (page > 5) {
        return [];
      }

      return List.generate(
        20,
        (index) => 'Item ${(page - 1) * 20 + index + 1}',
      );
    },
  );
}
```
3️⃣ Use InfiniteListView
```
InfiniteListView<String>(
  controller: controller,
  padding: const EdgeInsets.all(16),
  itemBuilder: (context, item, index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          child: Text('${index + 1}'),
        ),
        title: Text(item),
      ),
    );
  },
)
```
4️⃣ Use InfiniteGridView
```
InfiniteGridView<String>(
  controller: controller,
  padding: const EdgeInsets.all(12),
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 12,
    mainAxisSpacing: 12,
    childAspectRatio: 1,
  ),
  itemBuilder: (context, item, index) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        item,
        style: const TextStyle(color: Colors.white),
      ),
    );
  },
)
```
5️⃣ Pull To Refresh
```
RefreshIndicator(
  onRefresh: controller.refresh,
  child: InfiniteListView<String>(
    controller: controller,
    itemBuilder: (context, item, index) {
      return ListTile(title: Text(item));
    },
  ),
)
```
6️⃣ Empty State Example
```
PaginationController<String>(
  onLoadPage: (page) async {
    await Future.delayed(const Duration(seconds: 1));
    return [];
  },
)
```

Output:
```
📭 No items found
There is nothing to display right now.
```
7️⃣ Error State Example
```
PaginationController<String>(
  onLoadPage: (page) async {
    throw Exception('Failed to load data');
  },
)
```

--------------------------------

## 🎨 Pagination States

| State         | Description                  |
| ------------- | ---------------------------- |
| `initial`     | Initial state before loading |
| `loading`     | Loading first page           |
| `success`     | Data loaded successfully     |
| `loadingMore` | Loading next page            |
| `failure`     | Failed to load data          |
| `completed`   | No more data available       |

----------------------------------

## ⚙️ PaginationController Methods

| Method          | Description                      |
| --------------- | -------------------------------- |
| `loadInitial()` | Loads first page                 |
| `loadMore()`    | Loads next page                  |
| `refresh()`     | Refreshes and reloads first page |

--------------------------------

## 📄 Example Full Usage
```
body: InfiniteListView<String>(
  controller: controller,
  padding: const EdgeInsets.all(16),
  itemBuilder: (context, item, index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          child: Text('${index + 1}'),
        ),
        title: Text(item),
      ),
    );
  },
)
```

--------------------------------

## 📄 MIT License
```
Copyright (c) 2026

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files to deal in the Software without restriction.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND.
```













