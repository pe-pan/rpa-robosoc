namespace: robosoc.office365.message.subflows.parse
operation:
  name: parse_html_links
  inputs:
    - html_string
  python_action:
    script: "from HTMLParser import HTMLParser\r\n\r\nclass MyHTMLParser(HTMLParser):\r\n\r\n    def handle_starttag(self, tag, attrs):\r\n        # Only parse the 'anchor' tag.\r\n        if tag == \"a\":\r\n           # Check the list of defined attributes.\r\n           for name, value in attrs:\r\n               # If href is defined, print it.\r\n               if name == \"href\":\r\n                   links.append(value)\r\n\r\n\r\nlinks = []\r\n\r\nparser = MyHTMLParser()\r\nparser.feed(html_string)"
  outputs:
    - links: '${str(links)[1:-1]}'
  results:
    - SUCCESS
