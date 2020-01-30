########################################################################################################################
#!!
#! @description: Finds the first *.eml file in the folder.
#!!#
########################################################################################################################
namespace: robosoc.office365.message.subflows.temp_folder
operation:
  name: get_first_file
  inputs:
    - folder_name
  python_action:
    script: "import os,glob\r\nentries = glob.glob(os.path.join(folder_name,'*.eml'))\r\nfile_name = os.path.join(folder_name, entries[0]) if len(entries) > 0 else ''"
  outputs:
    - file_name: '${file_name}'
  results:
    - SUCCESS

