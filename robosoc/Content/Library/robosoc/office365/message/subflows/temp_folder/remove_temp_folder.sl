namespace: robosoc.office365.message.subflows.temp_folder
operation:
  name: remove_temp_folder
  inputs:
    - folder_name
  python_action:
    script: |-
      import shutil
      shutil.rmtree(folder_name)
  results:
    - SUCCESS
