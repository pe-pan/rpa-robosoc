namespace: robosec.office365.message
flow:
  name: get_last_message_id
  inputs:
    - email_address: phishing@rpamf.onmicrosoft.com
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
            - count: '1'
            - o_data_query: $select=subject
        publish:
          - message_id: '${message_id_list}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - message_id: '${message_id}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_email:
        x: 72
        'y': 81
        navigate:
          ca360a79-620e-af38-e12f-c830fdd83825:
            targetId: 56155222-d2ea-ebf8-c119-f19a43a3a53d
            port: SUCCESS
    results:
      SUCCESS:
        56155222-d2ea-ebf8-c119-f19a43a3a53d:
          x: 265
          'y': 88
