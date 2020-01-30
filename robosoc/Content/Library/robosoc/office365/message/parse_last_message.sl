########################################################################################################################
#!!
#! @description: It parses the last received e-mail and return values out of it including links it contains (provided the e-mail is in html format). If there is an e-mail attached to this e-mail, it parses the attachment instead. The attachment must have *.eml extension.
#!               Limitations:
#!               - it assumes there is one attachment (does not care about the others)
#!               - it assumes the attachment is an e-mail in MIME format (would fail if it's not)
#!               - it assumes the e-mail's body (or the attachment's body) is in HTML format (would fail if it's not)
#!               - if there is more e-mail's recipients, it returns the first one
#!
#! @input email_address: User's e-mail address.
#!
#! @output subject: The email/attachment subject.
#! @output recipient_email: The email/attachment to header.
#! @output sender_email: The email/attachment from header.
#! @output body: The email/attachment body (presumably in HTML format)
#! @output links: List of links parsed out of the email/attachment body.
#! @output message_id: The ID of the last message.
#!!#
########################################################################################################################
namespace: robosoc.office365.message
flow:
  name: parse_last_message
  inputs:
    - email_address: phishing@rpamf.onmicrosoft.com
  workflow:
    - get_last_message_id:
        do:
          robosoc.office365.message.subflows.get_last_message_id:
            - email_address: '${email_address}'
        publish:
          - message_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: message_found
    - parse_message:
        do:
          robosoc.office365.message.subflows.parse_message:
            - email_address: '${email_address}'
            - message_id: '${message_id}'
        publish:
          - subject
          - recipient_email
          - sender_email
          - body
          - links
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - message_found:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(message_id) > 0)}'
        navigate:
          - 'TRUE': parse_message
          - 'FALSE': FAILURE
  outputs:
    - subject: '${subject}'
    - recipient_email: '${recipient_email}'
    - sender_email: '${sender_email}'
    - body: '${body}'
    - links: '${links}'
    - message_id: '${message_id}'
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
      message_found:
        x: 192
        'y': 279
        navigate:
          a26323c6-b844-9a65-4190-4c916e09441a:
            targetId: 7244f730-5c71-0935-3ddc-a7e56f130046
            port: 'FALSE'
    results:
      FAILURE:
        7244f730-5c71-0935-3ddc-a7e56f130046:
          x: 384
          'y': 301
      SUCCESS:
        3b8ded9a-5758-df3e-dc7d-d60be3de819d:
          x: 384
          'y': 80

