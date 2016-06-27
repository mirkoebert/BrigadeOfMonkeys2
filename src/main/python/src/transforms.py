def transform_state(s):
    """ Transform the state to a string.
    :param s(int or float): The state to transform
    :returns str: The transformed state
    """
    from math import ceil
    transforms = {0: 'Untested', 1: 'Error', 2: 'Warning', 3: 'Ok'}
    return transforms[ceil(s)]


def split_by(df, vertical):
    """ Split the dataframe by the name of the vertical and
    return the two resulting dataframes.
    :param df(DataFrame): The dataframe to split
    :param vertical(str): The vertical to split on
    :returns DataFrame, DataFrame
    """
    vert = df[df['vertical'] == vertical]
    rest = df[df['vertical'] != vertical]
    return vert, rest


def vertical_summary(df, vertical):
    """ Create a vertical summary. The exact keys of the returned
    dictionary are unstable and likely to change.
    :param df(DataFrame): The dataframe
    :returns dict: The summary
    """
    vertical_df = df[df['vertical'] == vertical]
    description = vertical_df.describe()
    summary = {}
    summary['number_of_tests'] = len(vertical_df)
    summary['average_state'] = description['state']['mean']
    return summary


def vertical_vs_shop(df, vertical, squash=True):
    """ Create the vertical vs. shop dataframe.
    :param df(DataFrame): The dataframe
    :returns DataFrame
    """
    if squash:
        vvss = squash_verticals(df, vertical)
    else:
        vvss = df
    vertical_vs_shop_mean = vvss.groupby(['vertical', 'test_rule']).median()
    return vertical_vs_shop_mean


def vertical_detail(df, vertical):
    """ Create the detail dataframe.
    :param df(DataFrame): The dataframe
    :returns DataFrame
    """
    vertical = df[df['vertical'] == vertical]
    vertical_detail = vertical.groupby(['test_rule', 'server']).mean()

    return vertical_detail


def squash_verticals(df, vertical, rename='shop'):
    """ Rename all entries of the vertical column to a value.
    :param df(DataFrame): The dataframe
    :param vertical(str):  The vertical to seperate
    :param rename(str)<optional>: The name to rename all other verticals to
    """
    squashed = df.copy()
    squashed['vertical'] = squashed['vertical'].apply(lambda v: rename if v != vertical else v)
    return squashed
