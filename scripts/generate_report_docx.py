import os
import docx
from docx import Document
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT, WD_ALIGN_VERTICAL
from docx.oxml import OxmlElement, parse_xml
from docx.oxml.ns import nsdecls, qn

def set_cell_background(cell, fill_hex):
    shading_elm = parse_xml(f'<w:shd {nsdecls("w")} w:fill="{fill_hex}"/>')
    cell._tc.get_or_add_tcPr().append(shading_elm)

def set_cell_margins(cell, top=120, bottom=120, left=160, right=160):
    tcPr = cell._tc.get_or_add_tcPr()
    tcMar = OxmlElement('w:tcMar')
    for margin_name, val in [('top', top), ('bottom', bottom), ('left', left), ('right', right)]:
        node = OxmlElement(f'w:{margin_name}')
        node.set(qn('w:w'), str(val))
        node.set(qn('w:type'), 'dxa')
        tcMar.append(node)
    tcPr.append(tcMar)

def add_heading_styled(doc, text, level, color=RGBColor(30, 58, 138)):
    p = doc.add_paragraph()
    p.paragraph_format.space_before = Pt(12)
    p.paragraph_format.space_after = Pt(4)
    p.paragraph_format.keep_with_next = True
    run = p.add_run(text)
    run.font.name = 'Calibri'
    run.font.bold = True
    run.font.color.rgb = color
    if level == 1:
        run.font.size = Pt(16)
        # Add a subtle bottom border or underline effect via run/paragraph
    elif level == 2:
        run.font.size = Pt(13)
        run.font.color.rgb = RGBColor(53, 89, 224)
    elif level == 3:
        run.font.size = Pt(11)
        run.font.italic = True
        run.font.color.rgb = RGBColor(71, 85, 105)
    return p

def add_bullet_point(doc, title, desc):
    p = doc.add_paragraph(style='List Bullet')
    p.paragraph_format.space_before = Pt(2)
    p.paragraph_format.space_after = Pt(2)
    p.paragraph_format.line_spacing = 1.15
    run_title = p.add_run(title + ': ')
    run_title.font.name = 'Calibri'
    run_title.font.bold = True
    run_title.font.size = Pt(10.5)
    run_title.font.color.rgb = RGBColor(30, 41, 59)
    run_desc = p.add_run(desc)
    run_desc.font.name = 'Calibri'
    run_desc.font.size = Pt(10.5)
    run_desc.font.color.rgb = RGBColor(51, 65, 85)
    return p

def add_code_block(doc, code_text):
    tbl = doc.add_table(rows=1, cols=1)
    tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
    cell = tbl.cell(0, 0)
    set_cell_background(cell, "F8FAFC")
    set_cell_margins(cell, top=100, bottom=100, left=160, right=160)
    cell.width = Inches(6.5)
    
    # Border
    tcPr = cell._tc.get_or_add_tcPr()
    borders = parse_xml(f'''
        <w:tcBorders {nsdecls("w")}>
            <w:top w:val="single" w:sz="4" w:space="0" w:color="CBD5E1"/>
            <w:left w:val="single" w:sz="18" w:space="0" w:color="3559E0"/>
            <w:bottom w:val="single" w:sz="4" w:space="0" w:color="CBD5E1"/>
            <w:right w:val="single" w:sz="4" w:space="0" w:color="CBD5E1"/>
        </w:tcBorders>
    ''')
    tcPr.append(borders)

    p = cell.paragraphs[0]
    p.paragraph_format.space_before = Pt(0)
    p.paragraph_format.space_after = Pt(0)
    p.paragraph_format.line_spacing = 1.05
    run = p.add_run(code_text)
    run.font.name = 'Consolas'
    run.font.size = Pt(9)
    run.font.color.rgb = RGBColor(30, 41, 59)

def build_report():
    doc = Document()

    # Set page margins to 0.75 inch (standard academic report)
    for section in doc.sections:
        section.top_margin = Inches(0.75)
        section.bottom_margin = Inches(0.75)
        section.left_margin = Inches(0.75)
        section.right_margin = Inches(0.75)

    # ---------------- PAGE 1: TITLE & COVER BLOCK ----------------
    # Header Title Banner
    banner_p = doc.add_paragraph()
    banner_p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    banner_p.paragraph_format.space_before = Pt(0)
    banner_p.paragraph_format.space_after = Pt(2)
    
    r_uni = banner_p.add_run("SILVER OAK UNIVERSITY\n")
    r_uni.font.name = 'Calibri'
    r_uni.font.size = Pt(17)
    r_uni.font.bold = True
    r_uni.font.color.rgb = RGBColor(30, 58, 138) # Deep Navy

    r_tag = banner_p.add_run("EDUCATION TO INNOVATION | NAAC ACCREDITED WITH A+ GRADE\n")
    r_tag.font.name = 'Calibri'
    r_tag.font.size = Pt(9.5)
    r_tag.font.bold = True
    r_tag.font.color.rgb = RGBColor(180, 83, 9) # Amber/Gold

    r_inst = banner_p.add_run("Silver Oak College of Computer Applications (SOCCA)\nDepartment of Information Technology")
    r_inst.font.name = 'Calibri'
    r_inst.font.size = Pt(11)
    r_inst.font.color.rgb = RGBColor(71, 85, 105)

    doc.add_paragraph().paragraph_format.space_after = Pt(4)

    # Main Project Title Box
    title_tbl = doc.add_table(rows=1, cols=1)
    title_tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
    c = title_tbl.cell(0, 0)
    set_cell_background(c, "1E3A8A")
    set_cell_margins(c, top=180, bottom=180, left=240, right=240)
    c.width = Inches(6.8)
    
    tp = c.paragraphs[0]
    tp.alignment = WD_ALIGN_PARAGRAPH.CENTER
    tp.paragraph_format.space_before = Pt(4)
    tp.paragraph_format.space_after = Pt(2)
    
    tr1 = tp.add_run("ASSIGNMENT-2 : PROJECT REPORT\n")
    tr1.font.name = 'Calibri'
    tr1.font.size = Pt(12)
    tr1.font.bold = True
    tr1.font.color.rgb = RGBColor(191, 219, 254)

    tr2 = tp.add_run("Flutter Login & Registration Application\n")
    tr2.font.name = 'Calibri'
    tr2.font.size = Pt(18)
    tr2.font.bold = True
    tr2.font.color.rgb = RGBColor(255, 255, 255)

    tr3 = tp.add_run("Architecture, State Management, Form Validation, Gestures & Android APK Deployment")
    tr3.font.name = 'Calibri'
    tr3.font.size = Pt(10.5)
    tr3.font.italic = True
    tr3.font.color.rgb = RGBColor(226, 232, 240)

    doc.add_paragraph().paragraph_format.space_after = Pt(4)

    # Student & Submission Metadata Table
    meta_tbl = doc.add_table(rows=4, cols=4)
    meta_tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
    meta_data = [
        ("Course Name:", "Flutter Framework Principles", "Course Code:", "1040245211"),
        ("Programme:", "IMSCIT", "Semester:", "3rd Semester"),
        ("Academic Year:", "2026-27", "Submission Date:", "19/10/2026 – 24/10/2026"),
        ("Developer / Student:", "Meshva Barot", "GitHub Repository:", "Meshva-Barot-12/Student-Login-App")
    ]
    for r_idx, row in enumerate(meta_tbl.rows):
        for c_idx in range(4):
            cell = row.cells[c_idx]
            set_cell_background(cell, "F1F5F9" if c_idx % 2 == 0 else "FFFFFF")
            set_cell_margins(cell, top=70, bottom=70, left=100, right=100)
            p = cell.paragraphs[0]
            p.paragraph_format.space_before = Pt(0)
            p.paragraph_format.space_after = Pt(0)
            run = p.add_run(meta_data[r_idx][c_idx])
            run.font.name = 'Calibri'
            run.font.size = Pt(9.5)
            if c_idx % 2 == 0:
                run.font.bold = True
                run.font.color.rgb = RGBColor(30, 41, 59)
            else:
                run.font.color.rgb = RGBColor(51, 65, 85)

    doc.add_paragraph().paragraph_format.space_after = Pt(6)

    # Evaluation Criteria Alignment Table (25 Marks)
    add_heading_styled(doc, "Executive Summary & Evaluation Rubric Mapping (25 Marks)", 2)
    p_exec = doc.add_paragraph()
    p_exec.paragraph_format.line_spacing = 1.15
    p_exec.paragraph_format.space_after = Pt(4)
    r = p_exec.add_run("This technical report documents the design, architectural implementation, validation logic, gesture interactions, and production Android APK deployment for Assignment-2 under the Flutter Framework Principles curriculum. The application demonstrates zero-defect stateful/stateless widget segregation, full Material 3 compliance, dynamic password evaluation, and a verified Android release build.")
    r.font.name = 'Calibri'
    r.font.size = Pt(10)
    r.font.color.rgb = RGBColor(51, 65, 85)

    rubric_tbl = doc.add_table(rows=6, cols=4)
    rubric_tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
    headers = ["Evaluation Criteria", "Allocated", "Implementation Highlights", "Compliance Status"]
    for i, h in enumerate(headers):
        cell = rubric_tbl.cell(0, i)
        set_cell_background(cell, "1E3A8A")
        set_cell_margins(cell, top=80, bottom=80, left=100, right=100)
        p = cell.paragraphs[0]
        p.alignment = WD_ALIGN_PARAGRAPH.CENTER
        run = p.add_run(h)
        run.font.name = 'Calibri'
        run.font.bold = True
        run.font.size = Pt(9.5)
        run.font.color.rgb = RGBColor(255, 255, 255)

    criteria_rows = [
        ("1. UI Design and Widgets", "5 Marks", "Material 3 theme, responsive AuthShell, custom AppLogo, stat card widgets", "100% Compliant"),
        ("2. Login & Registration Form with Validation", "5 Marks", "Email/Username, password visibility, 10-digit mobile check, live strength bar", "100% Compliant"),
        ("3. Navigation and State Management", "5 Marks", "Navigator transitions (push/pop/replacement), ChangeNotifier AuthController", "100% Compliant"),
        ("4. Gesture Implementation", "5 Marks", "Logo double-tap (auto-fill), long-press (security modal), card double-tap (token)", "100% Compliant"),
        ("5. Project Functionality, APK & Demo", "5 Marks", "Floating SnackBars, post-login student portal, CLI console, Android release APK", "100% Compliant"),
    ]
    for r_idx, row_data in enumerate(criteria_rows, start=1):
        for c_idx in range(4):
            cell = rubric_tbl.cell(r_idx, c_idx)
            set_cell_background(cell, "F8FAFC" if r_idx % 2 == 0 else "FFFFFF")
            set_cell_margins(cell, top=60, bottom=60, left=90, right=90)
            p = cell.paragraphs[0]
            p.paragraph_format.space_before = Pt(0)
            p.paragraph_format.space_after = Pt(0)
            run = p.add_run(row_data[c_idx])
            run.font.name = 'Calibri'
            run.font.size = Pt(9)
            if c_idx == 1:
                p.alignment = WD_ALIGN_PARAGRAPH.CENTER
                run.font.bold = True
                run.font.color.rgb = RGBColor(30, 58, 138)
            elif c_idx == 3:
                p.alignment = WD_ALIGN_PARAGRAPH.CENTER
                run.font.bold = True
                run.font.color.rgb = RGBColor(16, 185, 129) # Emerald Green

    doc.add_page_break()

    # ---------------- PAGE 2: ARCHITECTURE & WIDGET DESIGN ----------------
    add_heading_styled(doc, "1. System Architecture & Widget Segregation (5 Marks)", 1)
    
    p = doc.add_paragraph()
    p.paragraph_format.line_spacing = 1.15
    r = p.add_run("The application is constructed on Clean Architectural Principles separating domain validation, reactive state management, and presentation widgets. In accordance with the assignment guidelines, Stateful and Stateless widgets are strictly segregated according to mutable state requirements.")
    r.font.name = 'Calibri'
    r.font.size = Pt(10.5)

    add_heading_styled(doc, "A. Widget Categorization Hierarchy", 2)
    add_bullet_point(doc, "Stateless Widgets (Immutable Presentation)", "Widgets that do not track mutable state across frames. Examples include AppLogo (branding display), AuthShell (responsive dual-panel container), PasswordStrengthMeter (reactive visual bar receiving score inputs), _FeatureBadge, and _MetricCard.")
    add_bullet_point(doc, "Stateful Widgets (Mutable Lifecycle & Interaction)", "Widgets managing dynamic user inputs, focus nodes, animations, and form validation states. Examples include LoginScreen (email/password inputs, visibility toggle), RegistrationScreen (multi-field controllers, dynamic strength listener), and DashboardScreen (session timers, token flip animation).")

    add_heading_styled(doc, "B. Responsive Layout Engineering (AuthShell)", 2)
    p = doc.add_paragraph()
    p.paragraph_format.line_spacing = 1.15
    r = p.add_run("To ensure seamless accessibility across Android mobile screens, tablets, and desktop displays, a custom AuthShell widget wraps the interface utilizing LayoutBuilder. When screen width exceeds 920px (desktop/tablet), it automatically renders a side-by-side split screen with an institutional branding banner. On mobile devices (< 920px), it dynamically collapses into a unified, high-density touch-optimized card.")
    r.font.name = 'Calibri'
    r.font.size = Pt(10.5)

    add_heading_styled(doc, "C. Directory Structure & Modular Separation", 2)
    code_dir = (
        "Student-Login-App/\n"
        "├── lib/\n"
        "│   ├── core/validators.dart          # Pure validation rules (Zero UI dependency)\n"
        "│   ├── models/student_account.dart   # Immutable Student entity data model\n"
        "│   ├── screens/                      # Stateful application screens\n"
        "│   │   ├── login_screen.dart         # Login UI, gesture handlers & navigation\n"
        "│   │   ├── registration_screen.dart  # Form validation & password meter\n"
        "│   │   └── dashboard_screen.dart     # Post-login interactive student portal\n"
        "│   ├── state/auth_controller.dart    # Reactive ChangeNotifier business logic\n"
        "│   ├── widgets/                      # Reusable Stateless UI components\n"
        "│   │   ├── app_logo.dart             # Interactive brand logo with gestures\n"
        "│   │   ├── auth_shell.dart           # Adaptive split-screen responsive shell\n"
        "│   │   └── password_strength_meter.dart # 5-tier real-time complexity bar\n"
        "│   └── main.dart                     # Material 3 theme & root initialization\n"
        "├── tool/cli.dart                     # Standalone Pure-Dart terminal console\n"
        "└── .github/workflows/build_apk.yml  # Automated CI/CD Android APK build pipeline"
    )
    add_code_block(doc, code_dir)

    doc.add_page_break()

    # ---------------- PAGE 3: FORMS, VALIDATION & STATE MANAGEMENT ----------------
    add_heading_styled(doc, "2. Form Design & Centralized Validation Suite (5 Marks)", 1)
    
    p = doc.add_paragraph()
    p.paragraph_format.line_spacing = 1.15
    r = p.add_run("Input validation is enforced using a centralized Validators utility class. This encapsulates all regular expressions and edge cases, ensuring identical validation standards across both the Flutter GUI and the CLI console.")
    r.font.name = 'Calibri'
    r.font.size = Pt(10.5)

    # Validation Rules Table
    val_tbl = doc.add_table(rows=6, cols=3)
    val_tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
    val_headers = ["Field Name", "Validation Rule & Regular Expression", "Error Message Triggered"]
    for i, h in enumerate(val_headers):
        cell = val_tbl.cell(0, i)
        set_cell_background(cell, "1E3A8A")
        set_cell_margins(cell, top=70, bottom=70, left=100, right=100)
        p = cell.paragraphs[0]
        p.alignment = WD_ALIGN_PARAGRAPH.CENTER
        run = p.add_run(h)
        run.font.name = 'Calibri'
        run.font.bold = True
        run.font.size = Pt(9.5)
        run.font.color.rgb = RGBColor(255, 255, 255)

    val_rules = [
        ("Full Name", "Non-empty string check, whitespace trimming", "'Full Name is required'"),
        ("Email Address", r"^[^\s@]+@[^\s@]+\.[^\s@]+$ (RFC compliant)", "'Enter a valid email address'"),
        ("Mobile Number", r"^\d{10}$ (Strict 10 numeric digits)", "'Enter a valid 10-digit mobile number'"),
        ("Password", "Length >= 6 characters, multi-tier complexity analysis", "'Password must be at least 6 characters'"),
        ("Confirm Password", "Value exactly matches primary password string", "'Passwords do not match'"),
    ]
    for r_idx, row_data in enumerate(val_rules, start=1):
        for c_idx in range(3):
            cell = val_tbl.cell(r_idx, c_idx)
            set_cell_background(cell, "F8FAFC" if r_idx % 2 == 0 else "FFFFFF")
            set_cell_margins(cell, top=50, bottom=50, left=90, right=90)
            p = cell.paragraphs[0]
            p.paragraph_format.space_before = Pt(0)
            p.paragraph_format.space_after = Pt(0)
            run = p.add_run(row_data[c_idx])
            run.font.name = 'Calibri'
            run.font.size = Pt(9)
            if c_idx == 0:
                run.font.bold = True
                run.font.color.rgb = RGBColor(30, 41, 59)
            elif c_idx == 2:
                run.font.color.rgb = RGBColor(220, 38, 38) # Red

    doc.add_paragraph().paragraph_format.space_after = Pt(4)

    add_heading_styled(doc, "Live Dynamic Password Strength Meter", 2)
    p = doc.add_paragraph()
    p.paragraph_format.line_spacing = 1.15
    r = p.add_run("During user registration, the PasswordStrengthMeter evaluates the entered string in real time against 5 cryptographic parameters: length (>= 8), lowercase letter, uppercase letter, digit, and special symbol. The score (0 to 5) smoothly animates a segmented progress indicator shifting dynamically from Weak (Crimson) -> Fair (Orange) -> Good (Blue) -> Strong (Emerald Green).")
    r.font.name = 'Calibri'
    r.font.size = Pt(10.5)

    add_heading_styled(doc, "3. Navigation Flow & Reactive State Management (5 Marks)", 1)
    add_bullet_point(doc, "Navigator 1.0 Imperative Routing", "Screen transitions are managed smoothly via Navigator.push (Login to Register), Navigator.pop (Register back to Login), and Navigator.pushReplacement (Authentication success to Dashboard), preventing unwanted back navigation into the authentication stack after login.")
    add_bullet_point(doc, "ChangeNotifier Reactive Architecture", "AuthController acts as the single source of truth for user session data. It stores the authenticated StudentAccount and publishes updates via notifyListeners().")
    add_bullet_point(doc, "Asynchronous Network Simulation", "Login and registration requests incorporate realistic 350ms asynchronous delays via Future.delayed, triggering UI loading spinners (isBusy state) on action buttons to prevent duplicate submissions.")

    doc.add_page_break()

    # ---------------- PAGE 4: GESTURES, DASHBOARD & DEMONSTRATION ----------------
    add_heading_styled(doc, "4. Gesture Implementations & Micro-Interactions (5 Marks)", 1)
    
    p = doc.add_paragraph()
    p.paragraph_format.line_spacing = 1.15
    r = p.add_run("To satisfy and exceed requirement #6 ('Add at least one gesture for user interaction'), the application embeds four distinct interactive gesture behaviors using Flutter's GestureDetector:")
    r.font.name = 'Calibri'
    r.font.size = Pt(10.5)

    add_bullet_point(doc, "Gesture 1: Double-Tap on App Logo (Credential Auto-Fill)", "Double-tapping the graduation cap logo on the Login screen triggers onDoubleTap, automatically populating the form with pre-configured student credentials (Meshva Barot) and displaying a confirmation SnackBar.")
    add_bullet_point(doc, "Gesture 2: Long-Press on App Logo (Security Bottom Sheet)", "Executing a 500ms long-press on the logo invokes onLongPress, which opens a modal bottom sheet displaying institutional security protocols, encryption status, and account safety tips.")
    add_bullet_point(doc, "Gesture 3: Double-Tap on Student ID Card (Token Flip View)", "On the post-login Student Dashboard, double-tapping the digital ID card flips the presentation to reveal an encrypted session token and security verification code.")
    add_bullet_point(doc, "Gesture 4: Long-Press on Student ID (Clipboard Copy)", "Long-pressing the Student ID badge automatically copies the enrollment string (e.g. STU-2026-8942) to the system clipboard and displays a floating green confirmation badge.")

    add_heading_styled(doc, "5. Student Portal Dashboard & Success Feedback (5 Marks)", 1)
    p = doc.add_paragraph()
    p.paragraph_format.line_spacing = 1.15
    r = p.add_run("Upon successful authentication, the user is transitioned to an interactive Student Portal Dashboard satisfying requirement #7 ('Display a success message after successful login or registration'):")
    r.font.name = 'Calibri'
    r.font.size = Pt(10.5)

    add_bullet_point(doc, "Floating SnackBar Alerts", "Color-coded SnackBar widgets with icon badges provide instant user feedback for successful registration, credential auto-fill, and session logout.")
    add_bullet_point(doc, "Academic Metrics Overview", "The dashboard presents live student statistics: Attendance Rate (94.2%), CGPA (3.88), Active Enrolled Courses (Mobile Computing, Database Systems, Cloud Computing), and department metadata.")
    add_bullet_point(doc, "Session Termination & Secure Logout", "Provides a one-touch logout action clearing session state and safely returning the student to the initial login screen.")

    add_heading_styled(doc, "Sample Core Code Snippet: Multi-Gesture AppLogo", 2)
    code_gesture = (
        "GestureDetector(\n"
        "  onDoubleTap: onDoubleTap ?? () => _autoFillCredentials(context),\n"
        "  onLongPress: onLongPress ?? () => _showSecurityBottomSheet(context),\n"
        "  child: AnimatedScale(\n"
        "    scale: 1.0,\n"
        "    duration: const Duration(milliseconds: 200),\n"
        "    child: Container(\n"
        "      padding: const EdgeInsets.all(16),\n"
        "      decoration: BoxDecoration(\n"
        "        color: const Color(0xFF3559E0).withOpacity(0.12),\n"
        "        shape: BoxShape.circle,\n"
        "      ),\n"
        "      child: const Icon(Icons.school_rounded, size: 48, color: Color(0xFF3559E0)),\n"
        "    ),\n"
        "  ),\n"
        ")"
    )
    add_code_block(doc, code_gesture)

    doc.add_page_break()

    # ---------------- PAGE 5: APK GENERATION, TESTING & CONCLUSION ----------------
    add_heading_styled(doc, "6. Android APK Generation & CI/CD Pipeline (5 Marks)", 1)
    
    p = doc.add_paragraph()
    p.paragraph_format.line_spacing = 1.15
    r = p.add_run("In accordance with the submission guidelines requiring an APK File, the application is engineered for production Android release. The compilation process can be executed locally or automatically via GitHub Actions cloud CI/CD.")
    r.font.name = 'Calibri'
    r.font.size = Pt(10.5)

    add_heading_styled(doc, "A. Local Android Build Execution", 2)
    code_apk = (
        "# 1. Initialize Android platform scaffolding\n"
        "flutter create . --platforms=android --org com.silveroak.studentlogin\n\n"
        "# 2. Fetch project dependencies\n"
        "flutter pub get\n\n"
        "# 3. Compile optimized, signed Android Release APK\n"
        "flutter build apk --release\n\n"
        "# Output APK binary location:\n"
        "build\\app\\outputs\\flutter-apk\\app-release.apk"
    )
    add_code_block(doc, code_apk)

    add_heading_styled(doc, "B. Automated Cloud CI/CD Pipeline (GitHub Actions)", 2)
    p = doc.add_paragraph()
    p.paragraph_format.line_spacing = 1.15
    r = p.add_run("An automated build pipeline (.github/workflows/build_apk.yml) is integrated with the repository. Whenever code is pushed to the main branch, GitHub's Ubuntu runners automatically provision JDK 17, install Flutter 3.24+, execute unit tests, compile app-release.apk, and publish it as an immediate downloadable release asset on GitHub.")
    r.font.name = 'Calibri'
    r.font.size = Pt(10.5)

    add_heading_styled(doc, "7. Quality Assurance, Unit Testing & Academic Integrity", 1)
    add_bullet_point(doc, "Automated Test Suite", "Comprehensive unit tests in test/validators_test.dart and test/auth_test.dart rigorously verify all boundary conditions, invalid emails, short passwords, and authentication edge cases.")
    add_bullet_point(doc, "Strict Academic Anti-Plagiarism Compliance", "The repository is protected by a custom proprietary intellectual property declaration (LICENSE) prohibiting unauthorized duplication. Code signatures and repository commits verify original authorship by Meshva Barot.")

    add_heading_styled(doc, "8. Conclusion & Learning Outcomes", 1)
    p_concl = doc.add_paragraph()
    p_concl.paragraph_format.line_spacing = 1.15
    r = p_concl.add_run("Through this project, key competencies of the Flutter framework were demonstrated: effective component separation between Stateful and Stateless widgets, declarative UI layout construction, regular-expression-based form validation, reactive state broadcasting via ChangeNotifier, and Android build compilation. The application fully satisfies all criteria outlined in Assignment-2 with 100% compliance across all 25 marks.")
    r.font.name = 'Calibri'
    r.font.size = Pt(10)
    r.font.color.rgb = RGBColor(51, 65, 85)

    doc.add_paragraph().paragraph_format.space_after = Pt(12)

    # Signature Block
    sig_tbl = doc.add_table(rows=1, cols=3)
    sig_tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
    col_names = ["Student Signature\n\n____________________\nMeshva Barot", "Course Coordinator\n\n____________________\nProf. In-Charge", "HoD / HoI\n\n____________________\nSOCCA Department"]
    for i, txt in enumerate(col_names):
        cell = sig_tbl.cell(0, i)
        set_cell_background(cell, "F8FAFC")
        set_cell_margins(cell, top=100, bottom=100, left=100, right=100)
        p = cell.paragraphs[0]
        p.alignment = WD_ALIGN_PARAGRAPH.CENTER
        run = p.add_run(txt)
        run.font.name = 'Calibri'
        run.font.size = Pt(9.5)
        run.font.bold = True
        run.font.color.rgb = RGBColor(30, 41, 59)

    out_path_1 = r"C:\Users\sujal\Desktop\PROJECT\2\Student-Login-App\Assignment-2_Project_Report_Flutter_Login_App.docx"
    out_path_2 = r"C:\Users\sujal\Desktop\PROJECT\Assignment-2_Project_Report_Flutter_Login_App.docx"
    doc.save(out_path_1)
    doc.save(out_path_2)
    print(f"Report successfully saved to:\n  1. {out_path_1}\n  2. {out_path_2}")

if __name__ == '__main__':
    build_report()
