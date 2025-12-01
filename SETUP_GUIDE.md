# Inventory Manager App

A comprehensive Flutter-based inventory management application that allows you to:
- Capture product photos using camera or gallery
- Record product specifications (name, material, size, color)
- Track buying and selling prices in INR
- Add multiple entries for each product
- Generate PDF reports with full inventory details

## Features

### 1. Product Management
- **Image Capture**: Take photos directly with the camera or select from gallery
- **Product Details**: Record material, name, size, and color
- **Pricing**: Enter buying and selling prices in INR with automatic profit calculation
- **Add Multiple Entries**: Add as many products as needed one by one

### 2. Inventory Tracking
- **Product List View**: Display all products with thumbnails and key information
- **Quick Stats**: View total products, total cost, and profit at a glance
- **Search & Filter**: Easily manage your inventory
- **Edit/Delete**: Modify or remove product entries

### 3. PDF Export
- **Generate Reports**: Export entire inventory as PDF
- **Detailed Information**: Includes all product specs, pricing, profit margins
- **Professional Format**: Well-formatted tables with summary statistics
- **Date Stamped**: Each report shows generation date

### 4. Local Storage
- **Persistent Data**: All products are saved locally on device
- **No Internet Required**: Work completely offline
- **Auto Save**: Changes are automatically saved

## Setup Instructions

### Prerequisites
- Flutter SDK (3.10.1 or higher)
- Dart SDK (included with Flutter)
- Android Studio / Xcode (for testing on emulator/device)

### Installation

1. **Navigate to project directory**
   ```bash
   cd inventory_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── product.dart         # Product data model
├── screens/
│   ├── home_screen.dart     # Main inventory list screen
│   └── product_entry_screen.dart  # Product entry form
└── services/
    ├── database_service.dart # Local data persistence
    └── pdf_service.dart      # PDF generation
```

## Dependencies

- **image_picker**: For camera and gallery access
- **pdf**: PDF generation
- **path_provider**: File system access
- **shared_preferences**: Local storage
- **intl**: Internationalization (for currency formatting)

## Usage Guide

### Adding a Product

1. Tap the **+** button (FAB) on home screen
2. Tap the image area to capture a photo (camera/gallery option will appear)
3. Fill in all required fields:
   - Product Name
   - Material
   - Size
   - Color
   - Buying Price (₹)
   - Selling Price (₹)
4. Tap **Save Product**

### Viewing Products

- The home screen displays all products in a card list
- Each card shows:
  - Product thumbnail
  - Product name and specifications
  - Cost and selling prices
  - Quick edit/delete options

### Managing Products

- **Edit**: Tap menu (3 dots) and select Edit to modify product details
- **Delete**: Tap menu (3 dots) and select Delete to remove a product
- **View Summary**: Top card shows total statistics

### Generating PDF Report

1. Tap the **PDF icon** in app bar
2. PDF is automatically generated with:
   - Full inventory summary
   - Detailed product table
   - Profit calculations
   - Current date and time
3. File is saved to device documents folder

### Clearing Data

1. Tap the menu (hamburger) in top right
2. Select "Clear All" to delete all products
3. Confirm the action (cannot be undone)

## Data Storage

All data is stored locally using SharedPreferences in JSON format. No data is sent to external servers.

### Storage Location
- **Android**: `/data/data/com.example.inventory_app/shared_prefs/`
- **iOS**: App Documents folder
- **Windows**: Local app data folder

## Profit Calculation

The app automatically calculates:
- **Profit per unit** = Selling Price - Buying Price
- **Profit Margin %** = (Profit / Buying Price) × 100

## Permissions Required

### Android
- Camera access (for taking photos)
- Storage read/write (for selecting images and saving PDFs)

### iOS
- Camera permission
- Photo Library access

### Windows
- File system access (for saving PDFs)

## Tips for Best Results

1. **Image Quality**: Use well-lit photos for better product visibility
2. **Consistent Naming**: Use standard naming conventions for products
3. **Regular Backups**: Periodically export PDFs as backup
4. **Price Updates**: Edit products to update prices if needed

## Troubleshooting

**Images not showing?**
- Check file permissions
- Ensure image files haven't been moved/deleted

**PDF not generating?**
- Ensure device has storage space
- Check storage permissions

**Data not saving?**
- Force close and reopen app
- Clear app cache if issues persist

## Future Enhancements

Potential features to add:
- Barcode scanning
- Bulk import/export (CSV)
- Cloud backup
- Multi-user support
- Inventory history tracking
- Low stock alerts
- Product categorization

## Support

For issues or feature requests, please check the project documentation or contact the development team.

## License

This project is open source and available for personal and commercial use.
