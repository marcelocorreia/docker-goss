# convert yaml to json
# pip3 install pyyaml
# http://pyyaml.org/wiki/PyYAMLDocumentation
# py3 yaml2json.py < ~/code/manpow/homeland/heartland/puphpet/config.yaml
# gist https://gist.github.com/noahcoad/51934724e0896184a2340217b383af73

import yaml, json, sys
sys.stdout.write(yaml.safe_dump(json.load(sys.stdin), encoding='utf-8', allow_unicode=True))