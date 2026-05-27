import pathlib, re
root = pathlib.Path(__file__).resolve().parent.parent
pattern_replacements = [
    (re.compile(r"mysqli_real_escape_string\s*\(\s*\$conn\s*,"), 'db_escape('),
    (re.compile(r"mysqli_query\s*\(\s*\$conn\s*,"), 'db_query('),
    (re.compile(r"mysqli_num_rows\s*\(") , 'db_num_rows('),
    (re.compile(r"mysqli_fetch_assoc\s*\(") , 'db_fetch_assoc('),
    (re.compile(r"mysqli_error\s*\(\s*\$conn\s*\)"), 'db_error()'),
    (re.compile(r"mysqli_data_seek\s*\(") , 'db_data_seek('),
    (re.compile(r"mysqli_fetch_array\s*\(") , 'db_fetch_array('),
    (re.compile(r"mysqli_fetch_all\s*\(") , 'db_fetch_all('),
    (re.compile(r"mysqli_fetch_assoc\s*\(\s*mysqli_query\s*\(\s*\$conn\s*,"), 'db_fetch_assoc(db_query('),
    (re.compile(r"mysqli_query\s*\(\s*\$conn\s*,\s*\$query\s*\)") , 'db_query($query)'),
]
for path in root.rglob('*.php'):
    if path.name == 'database.php':
        continue
    text = path.read_text(encoding='utf-8')
    new_text = text
    for pat, repl in pattern_replacements:
        new_text = pat.sub(repl, new_text)
    if new_text != text:
        path.write_text(new_text, encoding='utf-8')
        print(f'Updated {path.relative_to(root)}')
print('Done')
