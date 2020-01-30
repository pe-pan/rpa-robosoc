########################################################################################################################
#!!
#! @system_property mailbox_folder: Leave empty for querying over all mailbox folders
#!!#
########################################################################################################################
namespace: ''
properties:
  - tenant: rpamf.onmicrosoft.com
  - client_id: ''
  - client_secret:
      value: ''
      sensitive: true
  - mailbox_folder:
      value: Inbox
      sensitive: false
  - proxy_host: ''
  - proxy_port: ''
  - proxy_username: ''
  - proxy_password:
      value: ''
      sensitive: true
