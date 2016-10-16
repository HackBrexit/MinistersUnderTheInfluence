try:
    from setuptools import setup
except ImportError:
    from distutils.core import setup

config = {
    'description': 'Data Preprocessor',
    'author': 'My Name',
    'version': '0.1',
    'install_requires': ['nose'],
    'packages': ['datapreprocessor']
}

setup(**config)
