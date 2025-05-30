import os

def list_directory(path, indent=""):
    try:
        items = os.listdir(path)
    except PermissionError:
        print(indent + "📁 [Permission Denied]")
        return

    for index, item in enumerate(sorted(items)):
        item_path = os.path.join(path, item)
        is_last = index == len(items) - 1
        prefix = "└── " if is_last else "├── "
        connector = "    " if is_last else "│   "

        if os.path.isdir(item_path):
            print(indent + prefix + "📁 " + item)
            list_directory(item_path, indent + connector)
        else:
            print(indent + prefix + "📄 " + item)

if __name__ == "__main__":
    current_dir = os.getcwd()
    print("📂 Directory structure of:", current_dir)
    list_directory(current_dir)
