import logging

from jinja2 import Template
from transforms import (
        vertical_summary,
        vertical_vs_shop,
        vertical_detail)


def render_vertical_summary(df, vertical):
    logging.info('Rendering vertical summary')

    uri = 'templates/vertical_summary.html'
    v_summary = vertical_summary(df, vertical)
    with open(uri, 'r') as tmplf:
        template = Template(tmplf.read())
        return template.render(summary=v_summary)


def render_vertical_vs_shop(df, vertical):
    logging.info('Rendering vertical vs shop')

    uri = 'templates/vertical_vs_shop.html'
    vvss = vertical_vs_shop(df, vertical)
    with open(uri, 'r') as tmplf:
        template = Template(tmplf.read())
        return template.render(table=vvss.to_html())


def render_details(df, vertical):
    logging.info('Rendering details')

    uri = 'templates/vertical_detail.html'
    details = vertical_detail(df, vertical)
    with open(uri, 'r') as tmplf:
        template = Template(tmplf.read())
        return template.render(table=details.to_html())


def render_main(df, vertical):
    logging.info('Rendering report')

    vertical_summary = render_vertical_summary(df, vertical)
    vertical_vs_shop = render_vertical_vs_shop(df, vertical)
    vertical_detail = render_details(df, vertical)
    uri = 'templates/report.html'
    style = ''
    with open('style.css', 'r') as sty:
        style = sty.read()

    with open(uri, 'r') as main:
        t = Template(main.read())
        rendered = t.render(vertical=vertical,
                vertical_summary=vertical_summary,
                vertical_vs_shop=vertical_vs_shop,
                vertical_detail=vertical_detail,
                style=style,
                date='')  # TODO
        return rendered


def render_report(df, vertical, ofile='reports/report.html'):
    report = render_main(df, vertical)
    with open(ofile, 'w') as report_file:
        report_file.write(report)


if __name__ == '__main__':
    import sys
    import pandas as pd
    from common import BOM_CSV_CONFIG
    df_path = sys.argv[1]
    vertical = sys.argv[2]
    df = pd.read_csv(df_path,  **BOM_CSV_CONFIG)
    print('Vertical: {}'.format(vertical))
    print('Data: {}'.format(df_path))
    render_report(df, vertical)
