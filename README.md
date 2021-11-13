# ASN1Parser

![tests](https://github.com/DominikHorn/ASN1Parser/actions/workflows/test.yml/badge.svg)
![coverage](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/DominikHorn/abb8b96dc5a9b8354fb3d70216aedc7d/raw/coverage-badge.json)


ASN.1 parsing in swift. 

Please note that I will most likely only implement functionality I require for other upstream projects myself. 
I decided to opensource this codebase mainly in the hopes of providing a decent starting point for others. 

Feel free to extend this package using pull requests. Maybe this will turn into a fully fledged ASN.1 parser through community effort ;)

## Features

- safe parsing, i.e., corrupted data will lead to a well defined error being thrown
- DER support
