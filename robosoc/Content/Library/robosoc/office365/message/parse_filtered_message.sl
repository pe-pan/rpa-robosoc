########################################################################################################################
#!!
#! @description: It parses the last received e-mail meeting filter criteria and return values out of it including links it contains (provided the e-mail is in html format). If there is an e-mail attached to this e-mail, it parses the attachment instead.
#!                
#!               Limitations:
#!               - it assumes there is one attachment (does not care about the others)
#!               - it assumes the attachment is an e-mail in MIME format (would fail if it's not)
#!               - it assumes the e-mail's body (or the attachment's body) is in HTML format (would fail if it's not)
#!               - if there is more e-mail's recipients, it returns the first one
#!
#! @input email_address: User's e-mail address.
#! @input search_filter: Provide filter like "subject:test" or "from:petr@mf.com"; filters can't be combined
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
  name: parse_filtered_message
  inputs:
    - email_address: phishing@rpamf.onmicrosoft.com
    - search_filter: 'subject:Office account'
  workflow:
    - get_last_filtered_message_id:
        do:
          robosoc.office365.message.subflows.get_last_filtered_message_id:
            - search_filter: '${search_filter}'
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
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_last_filtered_message_id:
        x: 50
        'y': 85
      parse_message:
        x: 225
        'y': 73
        navigate:
          9f52e813-a366-88ef-88d6-3573fd2d3e77:
            targetId: 3b8ded9a-5758-df3e-dc7d-d60be3de819d
            port: SUCCESS
      message_found:
        x: 172
        'y': 259
        navigate:
          e57078ff-4a33-46d9-1ad9-09fac80bba21:
            targetId: d7d3b569-fff5-bb7b-92dc-db34f2149137
            port: 'FALSE'
    results:
      SUCCESS:
        3b8ded9a-5758-df3e-dc7d-d60be3de819d:
          x: 384
          'y': 80
      FAILURE:
        d7d3b569-fff5-bb7b-92dc-db34f2149137:
          x: 400
          'y': 278
