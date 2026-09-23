# 🛍️ WhatShop Vendor — Merchant Management App

<div align="center">

  [![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
  [![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
  [![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)](https://supabase.com)
  [![BLoC](https://img.shields.io/badge/State_Management-BLoC-blue?style=for-the-badge)](https://bloclibrary.dev)
  [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)
  [![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android%20%7C%20Web-lightgrey?style=for-the-badge)]()

  <p align="center">
    <strong>A high-performance, cross-platform mobile application designed for e-commerce vendors to manage products, monitor store analytics, and handle catalog inventory seamlessly in real-time.</strong>
  </p>

  [Features](#-key-features) •
  [Architecture](#-architecture--design) •
  [Tech Stack](#-tech-stack) •
  [Database Schema](#-database-schema) •
  [Getting Started](#-getting-started) •
  [Roadmap](#-future-roadmap)
</div>

---

## 📌 Overview

**WhatShop Vendor** serves as the merchant portal for the WhatShop multi-vendor e-commerce ecosystem. Built with **Flutter** and powered by **Supabase** (PostgreSQL, Auth, Storage), it empowers store owners to run their business on the go. 

Merchants can onboard with custom store handles, build complex multi-variant product listings (with color pickers, size-based pricing, and image carousels), and track inventory across devices with reactive state management powered by the **BLoC pattern**.

---

## ✨ Key Features

- **🔐 Secure Vendor Onboarding & Auth**:
  - Email & password authentication with automated role verification via Supabase Auth.
  - Smart unique store handle generator (`@storename` with collision detection).
  - Role-based route gating (`all_profiles` role guard).
- **📦 Advanced Product Catalog Management**:
  - **Multi-Step Creation Flow**: Intuitive stepped creation wizard for adding new listings.
  - **Variant Configurations**: Interactive RGB hex color picker (`flutter_colorpicker`) and size-price matrices.
  - **Media Pipeline**: Multi-image selection, local previews, and asynchronous cloud storage uploading.
- **📊 Real-time Dashboard & Analytics**:
  - Quick insights into active products, average store ratings, and inventory volume.
- **🏷️ Inventory & Catalog Browser**:
  - Searchable and filterable merchant inventory views.
  - Live status toggles (Active / Inactive) and instant product updates.
  - Rich interactive product preview screens with image carousels.
- **🏪 Store Profile & Settings**:
  - Merchant information, store address, contact coordinates, and location management.

---

## 🏗️ Architecture & Design

WhatShop Vendor follows the **BLoC (Business Logic Component)** architectural pattern, enforcing a strict separation between UI rendering, business logic, and backend data access:

```
┌────────────────────────────────────────────────────────┐
│                   Presentation Layer                   │
│   (GoRouter • Material 3 • Custom Themes • Widgets)    │
└───────────────────────────┬────────────────────────────┘
                            │ Dispatches Events
                            │ Receives States
┌───────────────────────────▼────────────────────────────┐
│                    BLoC Logic Layer                    │
│      (ProductBloc • VendorBloc • Stream Controllers)   │
└───────────────────────────┬────────────────────────────┘
                            │ Requests / Mutations
                            │ Data Streams
┌───────────────────────────▼────────────────────────────┐
│                   Data & Backend Layer                 │
│         Supabase Client (Auth • Postgres • Storage)     │
└────────────────────────────────────────────────────────┘
```

### Application Flow
```
User Action ──► BLoC Event ──► Supabase Query / Storage ──► BLoC State ──► Reactive UI Update
```

---

## 💻 Tech Stack

| Technology | Purpose |
| :--- | :--- |
| **[Flutter SDK](https://flutter.dev)** (v3.x) | Cross-platform UI toolkit targeting iOS, Android, and Web |
| **[Dart](https://dart.dev)** | Modern, soundly typed client-optimized language |
| **[Supabase](https://supabase.com)** | Backend-as-a-Service: PostgreSQL, Auth, and Object Storage |
| **[flutter_bloc](https://pub.dev/packages/flutter_bloc)** | Predictable reactive state management |
| **[go_router](https://pub.dev/packages/go_router)** | Declarative, URL-driven routing system |
| **[cached_network_image](https://pub.dev/packages/cached_network_image)** | High-performance image caching with placeholder shimmer |
| **[flutter_colorpicker](https://pub.dev/packages/flutter_colorpicker)** | Granular color palette selector for variant generation |
| **[google_fonts](https://pub.dev/packages/google_fonts)** | Custom typography via Lexend Deca font family |

---

## 🗄️ Database Schema

The application interfaces with PostgreSQL on Supabase using the following core entities:

```sql
-- 1. Global Profiles (Role management)
create table all_profiles (
  id uuid references auth.users on delete cascade primary key,
  role text not null check (role in ('vendor', 'customer', 'admin')),
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- 2. Vendor Profiles
create table vendors (
  id uuid default gen_random_uuid() primary key,
  vendor_id text unique not null,
  name text not null,
  shop_name text not null,
  address text,
  phone text,
  email text not null,
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- 3. Product Catalog
create table products (
  product_id uuid default gen_random_uuid() primary key,
  vendor_id text references vendors(vendor_id) on delete cascade,
  name text not null,
  description text,
  category text,
  is_active boolean default true,
  rating_avg numeric default 0.0,
  colors jsonb default '[]'::jsonb,
  size_price jsonb default '[]'::jsonb,
  pic_path text[] default '{}',
  created_at timestamp with time zone default timezone('utc'::text, now())
);
```

---

## 🚀 Getting Started

### Prerequisites

Ensure you have the following installed on your machine:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`^3.8.0` or higher)
- [Git](https://git-scm.com/)
- An active [Supabase Account & Project](https://supabase.com)

### Installation & Setup

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/NasibGojayev/whatshop_vendor.git
   cd whatshop_vendor
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure Environment Variables**:
   Copy the `.env.example` file and supply your Supabase credentials:
   ```bash
   cp .env.example .env
   ```
   Provide your values inside `.env`:
   ```dotenv
   SUPABASE_URL=https://your-project-id.supabase.co
   SUPABASE_ANON_KEY=your-supabase-anon-key
   ```

4. **Run the Application**:
   - **Debug Mode**:
     ```bash
     flutter run --dart-define-from-file=.env
     ```
   - **Targeting iOS Simulator**:
     ```bash
     flutter run -d iPhone --dart-define-from-file=.env
     ```
   - **Targeting Android Emulator**:
     ```bash
     flutter run -d android --dart-define-from-file=.env
     ```
   - **Targeting Web**:
     ```bash
     flutter run -d chrome --dart-define-from-file=.env
     ```

---

## 📁 Project Directory Layout

```text
lib/
├── auth/                       # Authentication flow, login, registration & guards
│   ├── auth_gate.dart          # Session listener & route redirection
│   ├── auth_service.dart       # Supabase auth & vendor profile creation
│   ├── sign_in.dart            # Merchant sign-in screen
│   └── sign_up.dart            # Merchant registration & handle assignment
├── bloc_management/            # BLoC state management layer
│   ├── product_bloc/           # Product CRUD events, states, and logic
│   └── vendor_bloc/            # Vendor profile events and states
├── pages/                      # Presentation layer / Screens
│   ├── add_product_flow.dart   # Stepped multi-attribute product wizard
│   ├── dashboard.dart          # Store metrics and performance summary
│   ├── edit_product_page.dart  # Product modification interface
│   ├── my_products_page.dart   # Interactive product list
│   ├── product_view.dart       # Detailed product preview screen
│   ├── profile.dart            # Vendor settings and personal data
│   └── vendorDetailsPage.dart  # Public-facing vendor store details
├── tools/                      # Core styling, routing & components
│   ├── app_route_config.dart   # GoRouter declaration & route table
│   ├── colors.dart             # Application color tokens
│   └── navigation_menu.dart    # Bottom navigation bar shell
└── main.dart                   # Application entry point & service initialization
```

---

## 🛣️ Future Roadmap

- [ ] **Offline Sync**: Implement local cache (Hive / Isar) for offline product browsing and draft management.
- [ ] **Order Management**: Real-time push notifications for new customer orders using Supabase Realtime subscriptions.
- [ ] **Sales Analytics & Charts**: Interactive revenue and sales charts (`fl_chart`).
- [ ] **Automated CI/CD**: GitHub Actions workflow for automated testing, linting, and Play Store / TestFlight deployments.
- [ ] **Dark Mode Support**: Dynamic system-adaptive theme tokens.

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!  
Feel free to check the [issues page](https://github.com/NasibGojayev/whatshop_vendor/issues).

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'feat: Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
