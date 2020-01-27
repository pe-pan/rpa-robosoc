########################################################################################################################
#!!
#! @description: It parses the given e-mail and return values out of it including links it contains (provided the e-mail is in html format). It can also parse an e-mail attached to this e-mail.
#!
#! @input email_address: User's e-mail address.
#! @input message_id: E-mail identifier.
#! @input parse_attachment: If true, it expects an e-mail attached to this e-mail and parses. Otherwise, it parses the e-mail itself.
#!!#
########################################################################################################################
namespace: robosec.office365.message
flow:
  name: parse_message
  inputs:
    - email_address: phishing@rpamf.onmicrosoft.com
    - message_id_old: AAMkADA5M2M2ZDIyLTk4MDQtNGU1ZS1iNzIwLTAwNjYzMjBjNzg1NgBGAAAAAADavuWdUNpKQZmcthyh0_OOBwAxmqAOtaKGTo8NSZVuS-uQAAAAAAEMAAAxmqAOtaKGTo8NSZVuS-uQAAAAoVADAAA=
    - message_id: AAMkADA5M2M2ZDIyLTk4MDQtNGU1ZS1iNzIwLTAwNjYzMjBjNzg1NgBGAAAAAADavuWdUNpKQZmcthyh0_OOBwAxmqAOtaKGTo8NSZVuS-uQAAAAAAEMAAAxmqAOtaKGTo8NSZVuS-uQAAAAAAVbAAA=
    - parse_attachment:
        required: false
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
            - message_id: '${message_id}'
            - o_data_query: '$select=subject,body,sender,toRecipients,hasAttachments'
            - file_path: "c:\\\\temp"
        publish:
          - json: '${return_result}'
        navigate:
          - SUCCESS: is_attachment
          - FAILURE: on_failure
    - parse_json_message:
        do:
          robosec.office365.message.parse_json_message:
            - json_string: '${json}'
        publish:
          - subject
          - sender_name
          - from: '${sender_email}'
          - recipient_name
          - to: '${recipient_email}'
          - content_type
          - body
        navigate:
          - SUCCESS: is_html
    - is_html:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${content_type}'
            - second_string: html
            - ignore_case: null
        navigate:
          - SUCCESS: parse_html_links
          - FAILURE: on_failure
    - parse_html_links:
        do:
          robosec.office365.message.parse_html_links:
            - html_string: '${body}'
        publish:
          - link_list
        navigate:
          - SUCCESS: SUCCESS
    - read_from_file:
        do:
          io.cloudslang.base.filesystem.read_from_file:
            - file_path: "C:\\\\temp\\\\Password expiring soon.eml"
        publish:
          - attachment_string: '${read_text}'
        navigate:
          - SUCCESS: parse_mime_message
          - FAILURE: on_failure
    - parse_mime_message:
        do:
          robosec.office365.message.parse_mime_message:
            - attachment_string: '${attachment_string}'
        publish:
          - subject
          - to
          - from
          - body: '${html_body}'
        navigate:
          - SUCCESS: parse_html_links
    - is_attachment:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${parse_attachment}'
            - second_string: 'true'
            - ignore_case: 'true'
        navigate:
          - SUCCESS: read_from_file
          - FAILURE: parse_json_message
  outputs:
    - subject
    - to
    - from
    - body
    - links
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_email:
        x: 64
        'y': 104
      parse_json_mesasge:
        x: 261
        'y': 88
      is_html:
        x: 470
        'y': 63
      parse_html_links:
        x: 622
        'y': 166
        navigate:
          9562949a-57b7-7f39-46e8-639acd83186a:
            targetId: 8fda87ed-fefe-d9da-59a0-bd753526890d
            port: SUCCESS
      read_from_file:
        x: 260
        'y': 306
      parse_mime_message:
        x: 484
        'y': 304
      is_attachment:
        x: 95
        'y': 295
    results:
      SUCCESS:
        8fda87ed-fefe-d9da-59a0-bd753526890d:
          x: 772
          'y': 160

