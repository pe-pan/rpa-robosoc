namespace: robosec.office365.message.subflows
operation:
  name: get_first_file
  inputs:
    - folder_name
  python_action:
    script: "import os\r\nentries = os.listdir(folder_name)\r\nfile_name = os.path.join(folder_name, entries[0]) if len(entries) > 0 else ''"
  outputs:
    - file_name: '${file_name}'
  results:
    - SUCCESS
