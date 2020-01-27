namespace: robosec.office365.message
flow:
  name: parse_last_message
  inputs:
    - email_address: phishing@rpamf.onmicrosoft.com
  workflow:
    - get_last_message_id:
        do:
          robosec.office365.message.get_last_message_id:
            - email_address: '${email_address}'
        publish:
          - message_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: parse_message
    - parse_message:
        do:
          robosec.office365.message.parse_message:
            - email_address: '${email_address}'
            - message_id: '${message_id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_last_message_id:
        x: 53
        'y': 76
      parse_message:
        x: 225
        'y': 73
        navigate:
          9f52e813-a366-88ef-88d6-3573fd2d3e77:
            targetId: 3b8ded9a-5758-df3e-dc7d-d60be3de819d
            port: SUCCESS
    results:
      SUCCESS:
        3b8ded9a-5758-df3e-dc7d-d60be3de819d:
          x: 384
          'y': 80
