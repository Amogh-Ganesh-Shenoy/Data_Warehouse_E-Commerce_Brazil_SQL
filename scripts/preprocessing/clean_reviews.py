"""
--------------------------------------------------
Bronze Layer - olist_order_reviews_dataset cleanup
--------------------------------------------------
Purpose:
    Fixes olist_order_reviews_dataset.csv so SQL Server's BULK INSERT can
    load it. Review comments contain line breaks inside quoted text, which
    BULK INSERT reads as the start of a new row and so splits one review
    across several rows.

What it does:
    1. Reads the original file with Python's csv module, which understands
       line breaks inside quoted fields.
    2. Replaces every line break (\\r, \\n) inside a field with a single space.
    3. Counts the rows that do not have exactly 7 columns.
    4. Writes a cleaned copy with every field quoted and Carriage Return + Line Feed(CRLF) row endings.

Input:
    olist_order_reviews_dataset.csv   (original file, never modified)

Output:
    reviews_clean.csv                 (loaded by bronze.load_bronze)

Encoding:
    Read as UTF-8 with Byte Order Mark(BOM) handling (utf-8-sig), written as UTF-8. This
    matches CODEPAGE = '65001' in the BULK INSERT and keeps the Portuguese
    accents intact.

Console output:
    Rows written (including header): total rows in the cleaned file
    Rows without 7 columns:  should be 0; any other value means the
                             file still has malformed rows

Requirements:
    Python 3. Uses only the standard library (csv); nothing to install.

Usage:
    python clean_reviews.py
    (update the source and cleaned paths below if the folder moves)

Note:
    Line breaks inside comments are replaced with spaces, so multi-line
    comments become single-line. The original file keeps the raw data.
===============================================================================
"""

import csv

# Original file (stays untouched) and the cleaned copy
source = r"C:\SQL_Data_Warehouse_Project_2\archive\olist_order_reviews_dataset.csv"
cleaned = r"C:\SQL_Data_Warehouse_Project_2\archive\reviews_clean.csv"

row_count = 0
bad_rows = 0

# Open the original for reading and the new file for writing
with open(source, "r", encoding="utf-8-sig", newline="") as infile, open(cleaned, "w", encoding="utf-8", newline="") as outfile:
    
    reader = csv.reader(infile)  # Understands line breaks inside quotes
    writer = csv.writer(outfile, quoting=csv.QUOTE_ALL, lineterminator="\r\n")

    for row in reader:
        # Replace any line break inside a field with a space
        row = [field.replace("\r", " ").replace("\n", " ") for field in row]

        # Count rows that don't have exactly 7 columns
        if len(row) != 7:
            bad_rows += 1

        writer.writerow(row)
        row_count += 1

print("Rows written (including header):", row_count)
print("Rows without 7 columns:", bad_rows)
