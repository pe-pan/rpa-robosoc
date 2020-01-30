namespace: robosoc.office365.message.test
flow:
  name: test_all_messages
  inputs:
    - email_address: phishing@rpamf.onmicrosoft.com
    - all_folders: 'true'
    - max_messages: '100'
  workflow:
    - get_email:
        do:
          io.cloudslang.microsoft.office365.get_email:
            - tenant: "${get_sp('tenant')}"
            - client_id: "${get_sp('client_id')}"
            - client_secret:
                value: "${get_sp('client_secret')}"
                sensitive: true
            - email_address: '${email_address}'
            - folder_id: "${get_sp('mailbox_folder') if all_folders.lower() != 'true' else ''}"
            - count: '${max_messages}'
            - o_data_query: $select=subject
            - proxy_host: "${get_sp('proxy_host')}"
            - proxy_port: "${get_sp('proxy_port')}"
            - proxy_username: "${get_sp('proxy_username')}"
            - proxy_password:
                value: "${get_sp('proxy_password')}"
                sensitive: true
        publish:
          - message_id_list: '${message_id_list.strip()}'
        navigate:
          - SUCCESS: has_emails
          - FAILURE: on_failure
    - parse_message:
        loop:
          for: message_id in message_id_list
          do:
            robosoc.office365.message.subflows.parse_message:
              - email_address: '${email_address}'
              - message_id: '${message_id}'
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - has_emails:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(message_id_list) > 0)}'
        navigate:
          - 'TRUE': parse_message
          - 'FALSE': SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_email:
        x: 92
        'y': 101
      parse_message:
        x: 265
        'y': 105
        navigate:
          c5d6e0c8-8998-5385-04c9-2968088d7b7b:
            targetId: 62042f26-24b5-84fa-4910-e8d730177a40
            port: SUCCESS
      has_emails:
        x: 215
        'y': 301
        navigate:
          de925a57-8c69-491e-29b3-86e82a3ac69e:
            targetId: 62042f26-24b5-84fa-4910-e8d730177a40
            port: 'FALSE'
    results:
      SUCCESS:
        62042f26-24b5-84fa-4910-e8d730177a40:
          x: 421
          'y': 87
