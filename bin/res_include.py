#!/usr/bin/env python
import sys
import argparse

css_files = []
js_files = []
arbitrary_js = []


def link_js():
    header = ""
    for f in js_files:
        header += '    <script type="text/javascript" src="{src}"></script>\n'.format(src=f)
    return header


def link_css():
    header = ""
    for f in css_files:
        header += '    <link rel="stylesheet" type="text/css" href="{css_file}">\n'.format(css_file=f)
    return header


def include_arbitrary_js():
    header = ""
    for f in arbitrary_js:
        header += '    <script type="text/javascript">{script}</script>\n'.format(script=f)
    return header


def gen_header(charset='utf-8'):
    header = '''<!DOCTYPE html>
<html>
<head>
    <meta charset="{charset}">
'''.format(charset=charset)
    header += link_css()
    header += link_js()
    header += include_arbitrary_js()
    header += '</head>'
    return header


def gen_body():
    body = "<body>\n"
    for line in sys.stdin:
        body += '    ' + line
    body += '\n</body>'
    return body


def gen_document(css_files, charset='utf-8'):
    print('{h}\n{b}\n</html>'.format(h=gen_header(charset),
          b=gen_body()))

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-c", "--link-css",
                        help="Add a css file", action="append")
    parser.add_argument("-j", "--link-js",
                        help="Add a js file", action="append")
    parser.add_argument("-a", "--include-js",
                        help="Add arbitrary js to the generated file",
                        action="append")
    args = vars(parser.parse_args())
    if(args["link_css"] is not None):
        css_files = args["link_css"]
    if(args["link_js"] is not None):
        js_files = args["link_js"]
    if(args["include_js"] is not None):
        arbitrary_js = args["include_js"]

    gen_document(sys.argv[1:])
