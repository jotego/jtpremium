#!/usr/bin/env python3
# Copyright (c) 2023 José Manuel Barroso Galindo <theypsilon@gmail.com>

import json
from pathlib import Path

with open('db.json', 'r') as file:
    data = json.load(file)

jtbeta_term = max(data['tag_dictionary'].values()) + 1

data['tag_dictionary']['jtbeta'] = jtbeta_term

jtbeta_folders = set()
public_folders = set()

for file, description in data['files'].items():
    parent = str(Path(file).parent)
    if file.lower().endswith('.mra'):
        with open(file, 'r') as file:
            content = file.read().lower()
            if 'jtbeta.zip' in content:
                jtbeta_folders.add(parent)
                description['tags'].append(jtbeta_term)
                continue

    public_folders.add(parent)

for folder in list(jtbeta_folders - public_folders):
    data['folders'][folder]['tags'].append(jtbeta_term)

with open('jtbindb.json', 'w') as output_file:
    json.dump(data, output_file)
