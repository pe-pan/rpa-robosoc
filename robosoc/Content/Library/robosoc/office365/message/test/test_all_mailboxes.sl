########################################################################################################################
#!!
#! @description: Iterates through all existing mailboxes in the tenant (the mailboxes are listed explicitly), lists all their e-mails (up to 100) from all folders and tries to parse them.
#!!#
########################################################################################################################
namespace: robosoc.office365.message.test
flow:
  name: test_all_mailboxes
  inputs:
    - mailbox_list: 'phishing,petr,anas,daniel,hnevky,markus'
    - all_folders: 'true'
  workflow:
    - test_all_messages:
        loop:
          for: mailbox in mailbox_list
          do:
            robosoc.office365.message.test.test_all_messages:
              - email_address: "${mailbox+'@rpamf.onmicrosoft.com'}"
              - all_folders: '${all_folders}'
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      test_all_messages:
        x: 132
        'y': 129
        navigate:
          aa0a37a7-fe27-f60e-ff4e-cb7652830418:
            targetId: 45d367c1-ae66-e38b-5adb-8da70f8677b0
            port: SUCCESS
    results:
      SUCCESS:
        45d367c1-ae66-e38b-5adb-8da70f8677b0:
          x: 304
          'y': 122
