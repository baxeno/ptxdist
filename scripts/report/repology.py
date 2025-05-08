#!/usr/bin/env python3
#
# Copyright (C) 2025 by Bruno Thomsen <bruno.thomsen@gmail.com>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

from os import environ

from report.report import ReportException


def main():
    print("BTH hello")
    print(environ)
    exit(0)

if __name__ == "__main__":
    try:
        main()
    except ReportException as e:
        print(f'Repology report failed: {e.args[0]}')
        exit(1)

