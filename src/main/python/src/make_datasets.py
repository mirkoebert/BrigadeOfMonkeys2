#!/usr/bin/env python

"""
Main script for creating the data files used by the report.
"""

import sys
import argparse
import pandas as pd
from datetime import datetime
from common import BOM_CSV_CONFIG


def daily_range(start, freq='D', periods=3):
    """ Generates a date range.
    @param start(str): Must be in format YEAR-MONTH-DAY
    @param freq(str): One of 'D' (daily), 'W' (weekly), optional.
        Default is 'D'
    @param periods(int): How many days/weeks the range should have, optional.
        Default is 3
    @returns DatetimeIndex: The range between start and the next day
    """
    assert periods > 0
    assert freq in ['D', 'W']
    span = pd.date_range(start, periods=periods, freq=freq)
    return span


def select_daterange(df, start_date, freq='D', periods=3):
    """ Select a subset of the DataFrame which is indexed by dates.
    @param df(DataFrame): The dataframe to filter
    @param start_date(str): The start date as a string in format YEAR-MONTH-DAY
    @param freq(str): One of 'D' (daily), 'W' (weekly), optional.
        Default is 'D'
    @param periods(int): How many days/weeks the range should have, optional.
        Default is 3
    @returns DataFrame: The filtered DataFrame
    """
    r = daily_range(start_date, freq=freq, periods=periods)
    df.index = df.index.to_datetime()
    mask = (df.index >= r[0]) & (df.index <= r[-1])
    return df.loc[mask]


def valid_date(date):
    """ If the given object is a date, the formatted version is returned,
    otherwise an error is raised.

    @param date(object): The object to validate
    @returns str: The formatted value
    @raises ArgumentTypeError
    """
    try:
        return datetime.strptime(date, '%Y-%m-%d')
    except ValueError:
        msg = 'Not a valid date: {}'.format(date)
        raise argparse.ArgumentTypeError(msg)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(__doc__)
    parser.add_argument('dataset', type=str, help='The main raw file')
    parser.add_argument('vertical', type=str, help='The vertical to analyze')
    parser.add_argument(
        '-d', '--date',
        type=valid_date,
        default=str(datetime.now()),
        help='The start date')

    args = parser.parse_args()
    dataset = args.dataset
    vertical = args.vertical
    dateselect = args.date

    data_raw = pd.read_csv(dataset, **BOM_CSV_CONFIG)

    if vertical not in data_raw['vertical'].unique():
        print('{} is not a valid vertical. Exiting.'.format(vertical))
        sys.exit(-1)

    # TODO Filter by date
    # TODO Get rid of pandas warnings

    data_vertical = data_raw[data_raw['vertical'] == vertical]
    # data_vertical.drop('vertical', inplace=True, axis=1)
    data_vertical.to_csv('data/interm/{}.csv'.format(vertical))
    select_daterange(data_vertical, dateselect).to_csv('data/processed/{}_date_filter.csv'.format(vertical))

    data_shop = data_raw[data_raw['vertical'] != vertical]
    # data_shop.drop('vertical', inplace=True, axis=1)
    data_shop.to_csv('data/interm/shop.csv')
    select_daterange(data_shop, dateselect).to_csv('data/processed/shop_date_filter.csv')
