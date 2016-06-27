
LOG_FMT = '[%(asctime)s] %(levelname)s: %(message)s'

COL_NAMES = ['state', 'type', 'date', 'disruption_pattern', 'test_rule',
             'server', 'measured_value', 'expected_value', 'vertical']

BOM_CSV_CONFIG = {
    'sep': ',',
    'names': COL_NAMES,
    'header': None,
    'index_col': 2,
    'parse_dates': True,
    'infer_datetime_format': True,
}
