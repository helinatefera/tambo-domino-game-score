# NPoint.io Setup Guide

This app uses npoint.io to store and share the top 10 winners across all users.

## Setup Steps

1. **Go to npoint.io**
   - Visit https://npoint.io/

2. **Create a New Bin**
   - Click the "+ New" button or "Create JSON Bin"
   - In the editor, enter the initial JSON structure:
     ```json
     {
       "record": []
     }
     ```
   - Click "Save"

3. **Get Your Bin ID**
   - Look at the URL in your browser address bar. It will look like:
     `https://npoint.io/docs/YOUR_BIN_ID_HERE`
     or if you are editing:
     `https://npoint.io/YOUR_BIN_ID_HERE`
   - Copy that ID string.

4. **Configure the App**
   - Open `lib/utils/npoint_config.dart`
   - Paste your Bin ID into the `binId` constant:
     ```dart
     static const String binId = 'abc1234567890def'; 
     ```

5. **Important Note**
   - npoint.io bins are generally public if the ID is known. Ensure you are comfortable with this for a simple leaderboard.
   - If you need to lock the bin, check npoint.io documentation for authentication options, but this implementation assumes a public read/write bin for simplicity.
