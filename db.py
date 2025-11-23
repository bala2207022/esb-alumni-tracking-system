import sqlite3
from pathlib import Path

# Base folder of this file
BASE_DIR = Path(__file__).resolve().parent
# Our SQLite file (must exist: esb.db)
DB_PATH = BASE_DIR / "esb.db"


def get_conn():
    """Open a new SQLite connection with foreign keys enabled."""
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA foreign_keys = ON;")
    return conn


# ---------- FETCH HELPERS ----------

def get_programs():
    conn = get_conn()
    cur = conn.cursor()
    cur.execute("SELECT program_id, program_name FROM programs ORDER BY program_id;")
    rows = cur.fetchall()
    conn.close()
    return rows


def get_students():
    conn = get_conn()
    cur = conn.cursor()
    cur.execute(
        """
        SELECT student_id, first_name, last_name, email
        FROM students
        ORDER BY first_name, last_name;
        """
    )
    rows = cur.fetchall()
    conn.close()
    return rows


def get_employers():
    conn = get_conn()
    cur = conn.cursor()
    cur.execute("SELECT employer_id, employer_name FROM employers ORDER BY employer_name;")
    rows = cur.fetchall()
    conn.close()
    return rows


def get_internships_for_student(student_id):
    conn = get_conn()
    cur = conn.cursor()
    cur.execute(
        """
        SELECT internship_id, title
        FROM internships
        WHERE student_id = ?;
        """,
        (student_id,),
    )
    rows = cur.fetchall()
    conn.close()
    return rows


def get_organizations():
    conn = get_conn()
    cur = conn.cursor()
    cur.execute("SELECT org_id, org_name FROM organizations ORDER BY org_name;")
    rows = cur.fetchall()
    conn.close()
    return rows


# ---------- INSERT HELPERS ----------


def add_program(program_id, program_name, level, department):
    """
    Insert a program. If it already exists, ignore (no error).
    """
    conn = get_conn()
    cur = conn.cursor()
    cur.execute(
        """
        INSERT OR IGNORE INTO programs (program_id, program_name, level, department)
        VALUES (?, ?, ?, ?);
        """,
        (program_id, program_name, level, department),
    )
    conn.commit()
    conn.close()


def add_student(
    student_id,
    program_id,
    first_name,
    last_name,
    email,
    entry_term,
    grad_term,
    status,
    citizenship_country,
    linkedin_url,
):
    conn = get_conn()
    cur = conn.cursor()
    cur.execute(
        """
        INSERT INTO students
        (student_id, program_id, first_name, last_name, email,
         entry_term, grad_term, status, citizenship_country, linkedin_url)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
        """,
        (
            student_id,
            program_id,
            first_name,
            last_name,
            email,
            entry_term,
            grad_term,
            status,
            citizenship_country,
            linkedin_url,
        ),
    )
    conn.commit()
    conn.close()


def add_employer(employer_id, employer_name, industry, city, state, country, website):
    """
    Insert employer. If same employer_id already exists, ignore.
    """
    conn = get_conn()
    cur = conn.cursor()
    cur.execute(
        """
        INSERT OR IGNORE INTO employers
        (employer_id, employer_name, industry, city, state, country, website)
        VALUES (?, ?, ?, ?, ?, ?, ?);
        """,
        (employer_id, employer_name, industry, city, state, country, website),
    )
    conn.commit()
    conn.close()


def add_internship(
    internship_id,
    student_id,
    employer_id,
    title,
    mode,
    city,
    state,
    country,
    start_date,
    end_date,
    is_related,
):
    conn = get_conn()
    cur = conn.cursor()
    cur.execute(
        """
        INSERT INTO internships
        (internship_id, student_id, employer_id, title, mode,
         city, state, country, start_date, end_date, is_related_to_program)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
        """,
        (
            internship_id,
            student_id,
            employer_id,
            title,
            mode,
            city,
            state,
            country,
            start_date,
            end_date,
            int(is_related),
        ),
    )
    conn.commit()
    conn.close()


def add_job(
    job_id,
    student_id,
    employer_id,
    title,
    job_level,
    job_type,
    employment_status,
    city,
    state,
    country,
    start_date,
    end_date,
    job_sequence,
    source_internship_id,
):
    conn = get_conn()
    cur = conn.cursor()
    cur.execute(
        """
        INSERT INTO jobs
        (job_id, student_id, employer_id, title, job_level, job_type,
         employment_status, city, state, country,
         start_date, end_date, job_sequence, source_internship_id)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
        """,
        (
            job_id,
            student_id,
            employer_id,
            title,
            job_level,
            job_type,
            employment_status,
            city,
            state,
            country,
            start_date,
            end_date,
            job_sequence,
            source_internship_id,
        ),
    )
    conn.commit()
    conn.close()


def add_organization(org_id, org_name, org_type):
    conn = get_conn()
    cur = conn.cursor()
    cur.execute(
        """
        INSERT INTO organizations (org_id, org_name, org_type)
        VALUES (?, ?, ?);
        """,
        (org_id, org_name, org_type),
    )
    conn.commit()
    conn.close()


def add_student_org_link(student_org_id, student_id, org_id, role, start_date, end_date):
    conn = get_conn()
    cur = conn.cursor()
    cur.execute(
        """
        INSERT INTO student_organizations
        (student_org_id, student_id, org_id, role, start_date, end_date)
        VALUES (?, ?, ?, ?, ?, ?);
        """,
        (student_org_id, student_id, org_id, role, start_date, end_date),
    )
    conn.commit()
    conn.close()
