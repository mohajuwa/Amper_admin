import os
import re
import yaml

LIB_DIR = "lib"

# Get project name from pubspec.yaml
def get_project_name():
    with open("pubspec.yaml", "r") as file:
        config = yaml.safe_load(file)
        return config["name"]

PROJECT_NAME = get_project_name()

# Regular expression to find relative imports
IMPORT_RE = re.compile(r'''import\s+['"](\.{1,2}/[^'"]+)['"]''')

def fix_imports_in_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as file:
        lines = file.readlines()

    changed = False
    new_lines = []

    for line in lines:
        match = IMPORT_RE.search(line)
        if match:
            rel_path = os.path.normpath(os.path.join(os.path.dirname(filepath), match.group(1)))
            if rel_path.startswith(LIB_DIR + os.sep):
                pkg_path = rel_path.replace(LIB_DIR + os.sep, '')
                new_import = f"import 'package:{PROJECT_NAME}/{pkg_path.replace(os.sep, '/')}'"
                line = IMPORT_RE.sub(new_import, line)
                changed = True
        new_lines.append(line)

    if changed:
        with open(filepath, 'w', encoding='utf-8') as file:
            file.writelines(new_lines)
        print(f"✅ Fixed imports in: {filepath}")

# Walk through all Dart files in lib/
for root, _, files in os.walk(LIB_DIR):
    for file in files:
        if file.endswith(".dart"):
            fix_imports_in_file(os.path.join(root, file))

print("\n🎉 All relative imports have been updated to use 'package:{project_name}/...' style.")
