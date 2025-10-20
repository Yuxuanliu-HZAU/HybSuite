from setuptools import setup, find_packages

setup(
    name="hybsuite",
    version="1.1.5",
    packages=find_packages(),
    install_requires=[
        'pyqt5',
        'ete3',
        'pandas',
        'seaborn',
        'matplotlib',
        'numpy',
        'phylopypruner'
    ],
    scripts=['bin/HybSuite.sh'],
    package_data={
        'hybsuite': ['bin/*', 'config/*'], 
    },
)