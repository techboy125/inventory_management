# Quick Start Guide - Inventory Manager App

## 🚀 Getting Started in 5 Minutes

### Step 1: Prepare Your System
Make sure you have Flutter installed. Open PowerShell and run:
```powershell
flutter --version
```

### Step 2: Install Dependencies
In the project directory, run:
```powershell
flutter pub get
```

### Step 3: Run the App
Connect a device or start an emulator, then run:
```powershell
flutter run
```

---

## 📸 Using the App

### First Time Setup
1. **App opens** - You'll see an empty inventory screen
2. **Tap the + button** (bottom right) to add your first product

### Adding a Product (Step-by-Step)

**Step 1: Capture/Select Image**
- Tap the gray area at the top
- Choose **Camera** to take a photo OR **Gallery** to select existing image
- Image preview will show immediately

**Step 2: Enter Product Name**
- Example: "Blue Shirt", "Plastic Chair", "Steel Rod"

**Step 3: Enter Material**
- Example: "100% Cotton", "Steel", "Plastic"

**Step 4: Enter Size**
- Example: "M", "L", "10cm", "5 inches"

**Step 5: Enter Color**
- Example: "Blue", "Red", "Mixed"

**Step 6: Enter Buying Price (₹)**
- This is the cost price
- Example: "250" for ₹250

**Step 7: Enter Selling Price (₹)**
- This is the retail price
- Example: "500" for ₹500
- Profit will automatically show: ₹250

**Step 8: Save**
- Tap "Save Product" button
- Product added to your inventory!

---

## 📋 Managing Your Inventory

### View All Products
- Home screen shows all your products in cards
- Each card displays:
  - Product image thumbnail
  - Product name
  - Material, Size, Color
  - Cost and Selling prices

### View Inventory Summary
- Top card shows total statistics:
  - Total products count
  - Total investment (all buying prices)
  - Total profit
  - Total selling value

### Edit a Product
1. Tap any product card's menu (⋯ icon)
2. Select **Edit**
3. Modify any field or image
4. Tap "Save Product"

### Delete a Product
1. Tap product card's menu (⋯ icon)
2. Select **Delete**
3. Confirm deletion
4. Product removed from inventory

---

## 📊 Generating PDF Report

### Export Inventory to PDF
1. From home screen, tap **PDF icon** in top app bar
2. PDF generates with:
   - All products and details
   - Profit calculations
   - Summary statistics
   - Current date/time
3. Success message shows file location
4. PDF saved in device documents folder

### Using the PDF
- **Share**: Send to team members or partners
- **Print**: Print from your computer
- **Backup**: Keep as record of inventory
- **Analysis**: Review profits and margins

---

## 💰 Understanding Profit Calculation

### Profit per Unit
```
Profit = Selling Price - Buying Price
```
Example:
- Buying Price: ₹250
- Selling Price: ₹500
- Profit: ₹250 per unit

### Profit Margin %
```
Profit Margin % = (Profit / Buying Price) × 100
```
Example:
- Profit: ₹250
- Buying Price: ₹250
- Margin: 100% (profit is 100% of cost)

### Summary Statistics
The app automatically calculates:
- **Total Cost**: Sum of all buying prices
- **Total Selling**: Sum of all selling prices
- **Total Profit**: Total Selling - Total Cost

---

## ⚙️ Tips & Tricks

### ✅ Best Practices
- Use clear, descriptive product names
- Maintain consistent material/size/color formats
- Take clear product photos for better visibility
- Update prices regularly for accuracy
- Export PDF regularly as backup

### 🔍 Organization Tips
- Add products in batches
- Group similar items for easy tracking
- Use consistent naming conventions
- Review summary regularly

### 📱 Phone Tips
- Grant camera permissions when prompted
- Allow storage access for photo saving
- Close other apps for faster operation
- Use good lighting for product photos

---

## ❓ Common Questions

### Q: Can I edit a product after saving?
**A:** Yes! Tap the product menu (⋯) and select Edit. Modify any field and save.

### Q: What happens if I delete a product?
**A:** It's permanently removed from inventory. You cannot undo this action.

### Q: Can I backup my data?
**A:** Yes! Export to PDF regularly. The PDF contains all product information. You can also manually backup by exporting each PDF.

### Q: Is internet required?
**A:** No! The app works completely offline. No internet connection needed.

### Q: Where are photos stored?
**A:** Photos are stored on your device with each product. If you delete a product, its photo is also deleted.

### Q: Can I add the same product multiple times?
**A:** Yes! You can add multiple entries of the same product type (e.g., "Blue Shirt" multiple times).

### Q: How do I clear all data?
**A:** Tap menu (hamburger) icon → "Clear All" → Confirm. All products will be deleted (cannot be undone).

---

## 🐛 Troubleshooting

### Problem: App crashes on startup
- **Solution**: Run `flutter clean` then `flutter pub get`

### Problem: Camera permission denied
- **Solution**: Go to phone Settings → Apps → Inventory Manager → Permissions → Enable Camera

### Problem: Cannot save images
- **Solution**: Check storage permissions in phone Settings

### Problem: PDF not generating
- **Solution**: Ensure you have storage space and write permissions

### Problem: Products not showing after restart
- **Solution**: The app saves automatically. If data lost, check file permissions.

---

## 🎯 Workflow Example

**Scenario: You have 5 products to add to inventory**

1. **Open app** → See empty inventory
2. **Tap +** → Add Product 1 (Shirt)
   - Take photo, fill details, save
3. **Taps +** → Add Product 2 (Pants)
   - Gallery select, fill details, save
4. **Repeat** for Products 3-5
5. **Home screen** now shows all 5 products
6. **Review summary** - Total cost, profit shown
7. **Export PDF** for record-keeping
8. **Edit prices** if needed
9. **Share PDF** with stakeholders

---

## 📞 Support

For issues or questions:
1. Check this guide first
2. Review SETUP_GUIDE.md for detailed setup
3. Check FEATURES_GUIDE.md for all features
4. Verify all permissions are granted

---

## ✨ Key Features Summary

✓ Take/Upload product photos
✓ Record detailed specifications
✓ Track buying & selling prices in INR
✓ Automatic profit calculation
✓ Multiple product entries
✓ View inventory summary
✓ Edit/delete products
✓ Generate PDF reports
✓ Local data storage
✓ No internet required

---

**Happy Inventory Managing! 📦📊**
