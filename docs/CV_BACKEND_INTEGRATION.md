# CV Builder Backend Integration

This document explains how the CV Builder feature has been integrated with the backend API.

## Overview

The CV Builder feature now fully integrates with the backend API for creating and downloading resumes. The integration includes:

1. **Data Collection**: Each page collects user input and stores it in the BuildCVBloc
2. **API Integration**: Submits collected data to backend and handles responses
3. **Download Feature**: Allows users to download their generated CV

## API Endpoints

- **POST** `/api/resume` - Create a new resume
- **GET** `/api/resume/{id}` - Get resume download link

## Architecture

### Services

- `CVService` - Handles API communication for CV operations

### State Management

- `BuildCVBloc` - Manages CV data collection and submission
- `BuildCVEvent` - Events for updating CV data and submitting
- `BuildCVState` - States including loading, success, and error states

### Data Models

- `CVModel` - Main CV data model matching backend response structure
- `CVKontak` - Contact information model
- `CVPengalaman` - Experience model
- `CVPendidikan` - Education model
- `CVKeterampilan` - Skills model
- `CVBahasa` - Languages model
- `CVSertifikasi` - Certifications model
- `CVPenghargaan` - Awards model
- `CVMediaSosial` - Social media links model

## Data Flow

1. **Contact Page** - Collects and stores contact information
2. **Experience Page** - Collects work experience data
3. **Education Page** - Collects education information
4. **Skills Page** - Collects skills with proficiency levels
5. **Summary Page** - Collects or generates CV summary
6. **Additional Page** - Collects languages, certifications, awards, and social links
7. **Result Page** - Displays success and handles download

## Features

### Data Persistence

- Each page saves data to BuildCVBloc before navigation
- Data is preserved throughout the CV building process
- Form validation ensures required fields are completed

### Loading States

- Loading indicators during submission
- Error handling with user-friendly messages
- Success states with download functionality

### Download Integration

- Automatic download link generation from backend
- URL launcher integration for opening download links
- Fallback error handling for download issues

## Usage Example

```dart
// Submit CV data
context.read<BuildCVBloc>().add(SubmitCV());

// Handle states
BlocListener<BuildCVBloc, BuildCVState>(
  listener: (context, state) {
    if (state is CVSubmitSuccess) {
      // Handle success - navigate to result page
    } else if (state is CVSubmitError) {
      // Show error message
    }
  },
  child: // Your UI
)
```

## Backend Response Format

The backend should return responses in this format:

```json
{
  "success": true,
  "message": "Resume berhasil dibuat dan PDF disimpan",
  "data": {
    "userId": "690b4935312fdb7fb72ee5c9",
    "_id": "resume_id_here",
    "resumeLink": "https://cloudinary.com/download/link",
    "kontak": { ... },
    "pengalaman": [ ... ],
    // ... other CV data
  }
}
```

## Dependencies Added

- `url_launcher: ^6.2.4` - For opening download links in external browser
