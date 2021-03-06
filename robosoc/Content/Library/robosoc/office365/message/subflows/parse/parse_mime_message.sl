namespace: robosoc.office365.message.subflows.parse
operation:
  name: parse_mime_message
  inputs:
    - attachment_string
  python_action:
    script: "import email\n\nhtml_body = ''\ntext_body = ''\n\nmsg = email.message_from_string(attachment_string)\n\nif msg.is_multipart():\n  for message in msg.get_payload():\n    if message.get_content_type() == 'text/html':\n      html_body = message.get_payload()\n    if message.get_content_type() == 'text/plain':\n      text_body = message.get_payload()\nelse:  \n  if msg.get_content_type() == 'text/html':\n    html_body = msg.get_payload()\n  if msg.get_content_type() == 'text/plain':\n    text_body = msg.get_payload()\n\nheader_to = msg.get('to')\nheader_from = msg.get('from')\nheader_subject = msg.get('subject')"
  outputs:
    - header_subject: '${header_subject}'
    - header_to: '${header_to}'
    - header_from: '${header_from}'
    - text_body: '${text_body}'
    - html_body: '${html_body}'
  results:
    - SUCCESS
