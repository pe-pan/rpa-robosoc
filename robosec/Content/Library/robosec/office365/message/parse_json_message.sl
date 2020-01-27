namespace: robosec.office365.message
operation:
  name: parse_json_message
  inputs:
    - json_string
  python_action:
    script: |-
      import json
      data = json.loads(json_string)

      message_id = data['id']
      subject = data['subject']

      emailAddress = data['sender']['emailAddress']  #todo can be also 'from'?
      sender_name = emailAddress['name']
      sender_email = emailAddress['address']

      #todo handle multiple recipients
      emailAddress = data['toRecipients'][0]['emailAddress']
      recipient_name = emailAddress['name']
      recipient_email = emailAddress['address']

      body = data['body']
      content_type = body['contentType']
      content = body['content']
  outputs:
    - message_id: '${message_id}'
    - subject: '${subject}'
    - sender_name: '${sender_name}'
    - sender_email: '${sender_email}'
    - recipient_name: '${recipient_name}'
    - recipient_email: '${recipient_email}'
    - content_type: '${content_type}'
    - body: '${content}'
  results:
    - SUCCESS
