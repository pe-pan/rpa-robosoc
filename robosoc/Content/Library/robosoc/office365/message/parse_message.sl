########################################################################################################################
#!!
#! @description: It parses the given e-mail and return values out of it including links it contains (provided the e-mail is in html format). If there is an e-mail attached to this e-mail, it parses the attachment instead.
#!                
#!               Limitations:
#!               - it assumes there is one attachment (does not care about the others)
#!               - it assumes the attachment is an e-mail in MIME format (would fail if it's not)
#!               - it assumes the e-mail's body (or the attachment's body) is in HTML format (would fail if it's not)
#!               - if there is more e-mail's recipients, it returns the first one
#!
#! @input email_address: User's e-mail address.
#! @input message_id: Message identifier.
#!
#! @output subject: The email/attachment subject.
#! @output recipient_email: The email/attachment to header.
#! @output sender_email: The email/attachment from header.
#! @output body: The email/attachment body (presumably in HTML format)
#! @output links: List of links parsed out of the email/attachment body.
#!!#
########################################################################################################################
namespace: robosoc.office365.message
flow:
  name: parse_message
  inputs:
    - email_address: phishing@rpamf.onmicrosoft.com
    - message_id: AAMkADA5M2M2ZDIyLTk4MDQtNGU1ZS1iNzIwLTAwNjYzMjBjNzg1NgBGAAAAAADavuWdUNpKQZmcthyh0_OOBwAxmqAOtaKGTo8NSZVuS-uQAAAAAAEMAAAxmqAOtaKGTo8NSZVuS-uQAAAAAAVbAAA=
  workflow:
    - create_temp_folder:
        do:
          robosoc.office365.message.subflows.create_temp_folder: []
        publish:
          - folder_name
        navigate:
          - SUCCESS: get_email
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
            - file_path: '${folder_name}'
            - proxy_host: "${get_sp('proxy_host')}"
            - proxy_port: "${get_sp('proxy_port')}"
            - proxy_username: "${get_sp('proxy_username')}"
            - proxy_password:
                value: "${get_sp('proxy_password')}"
                sensitive: true
        publish:
          - json: '${return_result}'
        navigate:
          - SUCCESS: parse_json_message
          - FAILURE: on_failure
    - parse_json_message:
        do:
          robosoc.office365.message.parse_json_message:
            - json_string: '${json}'
        publish:
          - subject
          - sender_name
          - sender_email
          - recipient_name
          - recipient_email
          - content_type
          - body
          - has_attachments
        navigate:
          - SUCCESS: has_attachments
    - is_html:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${content_type}'
            - second_string: html
            - ignore_case: null
        navigate:
          - SUCCESS: remove_temp_folder
          - FAILURE: on_failure
    - parse_html_links:
        do:
          robosoc.office365.message.parse_html_links:
            - html_string: '${body}'
        publish:
          - links
        navigate:
          - SUCCESS: SUCCESS
    - read_from_file:
        do:
          io.cloudslang.base.filesystem.read_from_file:
            - file_path: '${file_name}'
        publish:
          - attachment_string: '${read_text}'
        navigate:
          - SUCCESS: parse_mime_message
          - FAILURE: on_failure
    - parse_mime_message:
        do:
          robosoc.office365.message.parse_mime_message:
            - attachment_string: '${attachment_string}'
        publish:
          - subject: '${header_subject}'
          - recipient_email: '${header_to}'
          - sender_email: '${header_from}'
          - body: '${html_body}'
        navigate:
          - SUCCESS: remove_temp_folder
    - get_first_file:
        do:
          robosoc.office365.message.subflows.get_first_file:
            - folder_name: '${folder_name}'
        publish:
          - file_name
        navigate:
          - SUCCESS: includes_attachment
    - includes_attachment:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(len(file_name) > 0)}'
        navigate:
          - 'TRUE': read_from_file
          - 'FALSE': is_html
    - remove_temp_folder:
        do:
          robosoc.office365.message.subflows.remove_temp_folder:
            - folder_name: '${folder_name}'
        navigate:
          - SUCCESS: parse_html_links
    - has_attachments:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${has_attachments}'
            - second_string: 'true'
            - ignore_case: 'true'
        navigate:
          - SUCCESS: get_first_file
          - FAILURE: is_html
  outputs:
    - subject: '${subject}'
    - recipient_email: '${recipient_email}'
    - sender_email: '${sender_email}'
    - body: '${body}'
    - links: '${links}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      is_html:
        x: 554
        'y': 26
      parse_mime_message:
        x: 489
        'y': 315
      read_from_file:
        x: 243
        'y': 319
      has_attachments:
        x: 377
        'y': 25
      parse_html_links:
        x: 767
        'y': 172
        navigate:
          f0bfd7ad-6b2a-55dc-fd59-f5a637af5cec:
            targetId: 8fda87ed-fefe-d9da-59a0-bd753526890d
            port: SUCCESS
      get_email:
        x: 31
        'y': 182
      get_first_file:
        x: 169
        'y': 185
      create_temp_folder:
        x: 47
        'y': 48
      includes_attachment:
        x: 457
        'y': 159
      parse_json_message:
        x: 175
        'y': 38
      remove_temp_folder:
        x: 623
        'y': 172
    results:
      SUCCESS:
        8fda87ed-fefe-d9da-59a0-bd753526890d:
          x: 914
          'y': 178

