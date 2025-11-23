PRAGMA foreign_keys = ON;

--------------------------------------------------
-- PROGRAMS
--------------------------------------------------
CREATE TABLE IF NOT EXISTS programs (
    program_id      TEXT PRIMARY KEY,
    program_name    TEXT NOT NULL,
    level           TEXT,
    department      TEXT
);

--------------------------------------------------
-- STUDENTS
--------------------------------------------------
CREATE TABLE IF NOT EXISTS students (
    student_id           TEXT PRIMARY KEY,
    program_id           TEXT NOT NULL,
    first_name           TEXT NOT NULL,
    last_name            TEXT NOT NULL,
    email                TEXT NOT NULL UNIQUE,
    entry_term           TEXT,
    grad_term            TEXT,
    status               TEXT,
    citizenship_country  TEXT,
    linkedin_url         TEXT,
    FOREIGN KEY (program_id) REFERENCES programs(program_id)
);

--------------------------------------------------
-- COURSES
--------------------------------------------------
CREATE TABLE IF NOT EXISTS courses (
    course_id        TEXT PRIMARY KEY,
    course_code      TEXT NOT NULL,
    course_title     TEXT NOT NULL,
    credits          INTEGER,
    level            TEXT,
    home_program_id  TEXT,
    FOREIGN KEY (home_program_id) REFERENCES programs(program_id)
);

--------------------------------------------------
-- FACULTY
--------------------------------------------------
CREATE TABLE IF NOT EXISTS faculty (
    faculty_id   TEXT PRIMARY KEY,
    first_name   TEXT NOT NULL,
    last_name    TEXT NOT NULL,
    email        TEXT UNIQUE,
    title        TEXT,
    department   TEXT
);

--------------------------------------------------
-- COURSE SECTIONS
--------------------------------------------------
CREATE TABLE IF NOT EXISTS course_sections (
    section_id      TEXT PRIMARY KEY,
    course_id       TEXT NOT NULL,
    faculty_id      TEXT NOT NULL,
    term            TEXT,
    year            INTEGER,
    section_number  TEXT,
    modality        TEXT,
    room            TEXT,
    FOREIGN KEY (course_id)  REFERENCES courses(course_id),
    FOREIGN KEY (faculty_id) REFERENCES faculty(faculty_id)
);

--------------------------------------------------
-- ENROLLMENTS (Students ↔ Course Sections)
--------------------------------------------------
CREATE TABLE IF NOT EXISTS enrollments (
    enrollment_id  TEXT PRIMARY KEY,
    section_id     TEXT NOT NULL,
    student_id     TEXT NOT NULL,
    grade          TEXT,
    status         TEXT,
    FOREIGN KEY (section_id) REFERENCES course_sections(section_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

--------------------------------------------------
-- EMPLOYERS
--------------------------------------------------
CREATE TABLE IF NOT EXISTS employers (
    employer_id    TEXT PRIMARY KEY,
    employer_name  TEXT NOT NULL,
    industry       TEXT,
    city           TEXT,
    state          TEXT,
    country        TEXT,
    website        TEXT
);

--------------------------------------------------
-- OPPORTUNITIES
--------------------------------------------------
CREATE TABLE IF NOT EXISTS opportunities (
    opportunity_id   TEXT PRIMARY KEY,
    employer_id      TEXT NOT NULL,
    title            TEXT NOT NULL,
    opportunity_type TEXT,
    location_type    TEXT,
    city             TEXT,
    state            TEXT,
    country          TEXT,
    posted_date      TEXT,
    is_active        INTEGER DEFAULT 1,
    FOREIGN KEY (employer_id) REFERENCES employers(employer_id)
);

--------------------------------------------------
-- STUDENT APPLICATIONS (Students ↔ Opportunities)
--------------------------------------------------
CREATE TABLE IF NOT EXISTS student_applications (
    application_id      TEXT PRIMARY KEY,
    student_id          TEXT NOT NULL,
    opportunity_id      TEXT NOT NULL,
    application_date    TEXT,
    application_status  TEXT,
    FOREIGN KEY (student_id)     REFERENCES students(student_id),
    FOREIGN KEY (opportunity_id) REFERENCES opportunities(opportunity_id)
);

--------------------------------------------------
-- INTERNSHIPS
--------------------------------------------------
CREATE TABLE IF NOT EXISTS internships (
    internship_id          TEXT PRIMARY KEY,
    student_id             TEXT NOT NULL,
    employer_id            TEXT NOT NULL,
    title                  TEXT,
    mode                   TEXT,
    city                   TEXT,
    state                  TEXT,
    country                TEXT,
    start_date             TEXT,
    end_date               TEXT,
    is_related_to_program  INTEGER DEFAULT 0,
    FOREIGN KEY (student_id)  REFERENCES students(student_id),
    FOREIGN KEY (employer_id) REFERENCES employers(employer_id)
);

--------------------------------------------------
-- JOBS (Alumni Outcomes)
--------------------------------------------------
CREATE TABLE IF NOT EXISTS jobs (
    job_id               TEXT PRIMARY KEY,
    student_id           TEXT NOT NULL,
    employer_id          TEXT NOT NULL,
    title                TEXT,
    job_level            TEXT,
    job_type             TEXT,
    employment_status    TEXT,
    city                 TEXT,
    state                TEXT,
    country              TEXT,
    start_date           TEXT,
    end_date             TEXT,
    job_sequence         INTEGER,
    source_internship_id TEXT,
    FOREIGN KEY (student_id)           REFERENCES students(student_id),
    FOREIGN KEY (employer_id)          REFERENCES employers(employer_id),
    FOREIGN KEY (source_internship_id) REFERENCES internships(internship_id)
);

--------------------------------------------------
-- EVENTS
--------------------------------------------------
CREATE TABLE IF NOT EXISTS events (
    event_id       TEXT PRIMARY KEY,
    event_name     TEXT NOT NULL,
    event_type     TEXT,
    event_date     TEXT,
    location       TEXT,
    organizer_unit TEXT
);

--------------------------------------------------
-- EVENT ATTENDANCE (Students ↔ Events)
--------------------------------------------------
CREATE TABLE IF NOT EXISTS event_attendance (
    attendance_id  TEXT PRIMARY KEY,
    event_id       TEXT NOT NULL,
    student_id     TEXT NOT NULL,
    role           TEXT,
    check_in_time  TEXT,
    FOREIGN KEY (event_id)   REFERENCES events(event_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

--------------------------------------------------
-- ORGANIZATIONS (Clubs)
--------------------------------------------------
CREATE TABLE IF NOT EXISTS organizations (
    org_id    TEXT PRIMARY KEY,
    org_name  TEXT NOT NULL,
    org_type  TEXT
);

--------------------------------------------------
-- STUDENT ORGANIZATIONS (Students ↔ Clubs)
--------------------------------------------------
CREATE TABLE IF NOT EXISTS student_organizations (
    student_org_id  TEXT PRIMARY KEY,
    student_id      TEXT NOT NULL,
    org_id          TEXT NOT NULL,
    role            TEXT,
    start_date      TEXT,
    end_date        TEXT,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (org_id)     REFERENCES organizations(org_id)
);
