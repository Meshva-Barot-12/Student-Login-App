# Student Portal & Authentication Application

> [!CAUTION]
> ### 🛡️ STRICT COPYRIGHT & ANTI-PLAGIARISM NOTICE
> **Copyright © 2026 Meshva Barot ([@Meshva-Barot-12](https://github.com/Meshva-Barot-12)). All Rights Reserved.**
> 
> This repository, source code, UI/UX design, custom widgets, state architecture, and documentation are the exclusive intellectual property of **Meshva Barot**.
> 
> * **NO REPRODUCTION OR COPYING**: Strictly prohibited from cloning, copying, distributing, modifying, or claiming as your own.
> * **ACADEMIC PLAGIARISM RESTRICTION**: Under NO circumstances should this code or any derived version be used or submitted by another student for academic coursework or evaluation. Code hashing and plagiarism verification are active.
> * Refer to the [LICENSE](LICENSE) file for complete legal terms.

---

A modern, responsive, and secure Student Authentication & Dashboard application built with **Flutter**, featuring real-time form validation, multi-gesture interactions, state management, a companion pure-Dart CLI console, and Dockerized web deployment.

**Developer:** Meshva Barot ([@Meshva-Barot-12](https://github.com/Meshva-Barot-12))  
**License:** Proprietary — All Rights Reserved  
**Status:** Production Ready  

---

## Key Features & PDF Specification Alignment

| PDF Requirement | Status | Implementation Details |
|---|---|---|
| **1. Login Screen** | Supported | • Email / Username field<br>• Password field with visibility toggle<br>• Primary Login button with loading indicator<br>• "Create New Account" navigation action |
| **2. Registration Screen** | Supported | • Full Name (Title-cased input)<br>• Email Address with pattern matching<br>• 10-digit Mobile Number<br>• Password with live strength indicator<br>• Confirm Password with equality verification<br>• Register action button |
| **3. Form Validation** | Supported | Centralized `Validators` class enforcing non-empty requirements, RFC-compliant email formatting, strict 10-digit mobile rule, minimum 6-character passwords, and matching confirmation. |
| **4. Stateful & Stateless Widgets** | Supported | • **Stateless**: `AppLogo`, `AuthShell`, `PasswordStrengthMeter`, `_FeatureBadge`, `_MetricCard`<br>• **Stateful**: `LoginScreen`, `RegistrationScreen`, `DashboardScreen` |
| **5. Navigator Flow** | Supported | Smooth navigation transitions using `Navigator.push`, `Navigator.pop`, and `Navigator.pushReplacement` across Login, Registration, and the Student Dashboard. |
| **6. Gesture Interactions** | Supported | **Multi-Gesture Suite**:<br>• **Double-Tap on Logo**: Instantly auto-fills demo credentials for Meshva Barot with animated feedback.<br>• **Long-Press on Logo**: Triggers an interactive Security Bottom Sheet.<br>• **Double-Tap on Student Card**: Flips card to cryptographic token view.<br>• **Long-Press on Student Card**: Copies Student ID to clipboard. |
| **7. Success Messages** | Supported | Floating `SnackBar` notifications with status icons confirming successful login, registration, gesture triggers, and clipboard actions. |

---

## Innovative Highlights

1. **Interactive Student Dashboard**  
   Upon successful login, students are routed to an interactive digital portal showcasing student identity, department details, attendance (94.2%), CGPA (3.88), active courses, and quick actions.
2. **Live Password Strength Meter**  
   Dynamic real-time evaluation assessing character count, uppercase, lowercase, numbers, and special symbols with color-coded progress feedback.
3. **Multi-Gesture Shortcuts**  
   Productivity gestures built into interactive elements for quick authentication and security inspection.
4. **Adaptive Responsive Shell**  
   Automatically adjusts between a unified split-screen desktop layout and a streamlined mobile layout based on screen width.
5. **Standalone Pure-Dart CLI**  
   Terminal console interface (`tool/cli.dart`) sharing validation logic with the Flutter client without UI dependencies.
6. **Containerized Production Web**  
   Multi-stage Docker build packaging the compiled Flutter Web application inside an ultra-lightweight Alpine Nginx container.

---

## Project Structure

```text
student_login_app_M/
├── lib/
│   ├── core/
│   │   └── validators.dart            # Validation logic for all form fields
│   ├── models/
│   │   └── student_account.dart       # Student entity and profile metadata
│   ├── screens/
│   │   ├── dashboard_screen.dart      # Interactive post-login student portal
│   │   ├── login_screen.dart          # Login form with multi-gesture shortcuts
│   │   └── registration_screen.dart   # Registration form with live password meter
│   ├── state/
│   │   └── auth_controller.dart       # Reactive ChangeNotifier state management
│   ├── widgets/
│   │   ├── app_logo.dart              # Multi-gesture interactive logo
│   │   ├── auth_shell.dart            # Responsive split-panel layout
│   │   └── password_strength_meter.dart # Real-time password complexity bar
│   └── main.dart                      # Flutter app entry point & theme setup
├── test/
│   ├── auth_test.dart                 # Authentication & profile tests
│   └── validators_test.dart           # Form validator unit tests
├── tool/
│   └── cli.dart                       # Pure-Dart interactive terminal console
├── web/
│   ├── index.html                     # Web entry point
│   └── manifest.json                  # PWA configuration
├── docker/
│   └── nginx.conf                     # Production Nginx reverse proxy configuration
├── scripts/
│   └── prepare_flutter_platforms.ps1  # Platform scaffolding script
├── .vscode/
│   └── launch.json                    # F5 debug configurations for Chrome and Web
├── Dockerfile                         # Multi-stage Flutter Web build
├── compose.yaml                       # Docker Compose specification
├── LICENSE                            # Strict proprietary license & anti-plagiarism notice
├── pubspec.yaml                       # Dependencies and asset declarations
└── README.md                          # Project documentation
```

---

## Credentials for Demo & Testing

A pre-configured demo account is available for testing:

- **Full Name:** `Meshva Barot`
- **Email:** `meshva.barot@example.com`
- **Password:** `Student@123`
- **Student ID:** `STU-2026-8942`
- **Quick Fill Shortcut:** Double-tap the logo on the Login screen to load automatically.

---

## Local Execution Instructions (PowerShell)

### Prerequisites
- Flutter SDK (3.5.0 or later)
- Google Chrome (for web execution)
- Docker Desktop (optional, for containerized run)

---

### 1. Run Flutter Web in Google Chrome

Open PowerShell in the project directory:

```powershell
flutter pub get
flutter run -d chrome
```

---

### 2. Run via VS Code (F5 Workflow)

1. Open the project folder in Visual Studio Code.
2. Ensure the Flutter and Dart extensions are installed.
3. Open the **Run and Debug** panel (`Ctrl + Shift + D`).
4. Select **Student Login App — Chrome (F5)** from the dropdown.
5. Press **F5** to start debugging.

---

### 3. Run on Android Device / Emulator

Check connected devices:

```powershell
flutter devices
```

Launch on your target device:

```powershell
flutter run -d <device-id>
```

Build a production Android release APK:

```powershell
flutter build apk --release
```

Generated APK location:
```text
build\app\outputs\flutter-apk\app-release.apk
```

---

### 4. Run the Pure-Dart Terminal CLI

From the project root:

```powershell
dart run tool/cli.dart
```

Available menu options:
1. `Login` — Authenticate using email or full name.
2. `Register New Student` — Register account with strict form validation.
3. `View Student Profile` — Inspect the active student credentials.
4. `Exit` — Close session.

---

### 5. Run with Docker Compose

Build and launch the Flutter Web app served through Nginx:

```powershell
docker compose up --build
```

Access the application in your browser:
```text
http://localhost:3000
```

Run in the background (detached mode):

```powershell
docker compose up -d --build
```

Stop the container:

```powershell
docker compose down
```

---

## Verification & Testing

Run unit tests and lint analysis:

```powershell
flutter analyze
flutter test
```

---

## Author & Copyright

**Developer:** Meshva Barot  
**GitHub:** [@Meshva-Barot-12](https://github.com/Meshva-Barot-12)  
**Copyright:** © 2026 Meshva Barot. All rights reserved.  
*Any unauthorized copying, mirroring, academic plagiarism, or distribution without explicit permission is strictly prohibited.*
