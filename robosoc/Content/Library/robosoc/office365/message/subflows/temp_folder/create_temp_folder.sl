namespace: robosoc.office365.message.subflows.temp_folder
operation:
  name: create_temp_folder
  python_action:
    script: |-
      import tempfile
      folder_name = tempfile.mkdtemp('.rpa')
  outputs:
    - folder_name: '${folder_name}'
  results:
    - SUCCESS
