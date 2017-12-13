#!/usr/bin/env bash


make-env2bash(){
    cat $1  | perl -p -e 's/\?\=/=/g' | \
        perl -p -e 's/\$\(shell\s?/\$\(/g'
}

make-env2yaml(){
    cat $1  | perl -p -e 's/\?\=/: /g' | \
        perl -p -e 's/\$\(shell\s?/\$\(/g' | \
        perl -p -e 's/\=/: /g'
}

make-env2json(){
    make-env2yaml $1 | yaml2json
}

yaml2hcl(){
	cat $1 | python /usr/local/bin/yaml2json.py | json2hcl
}

yaml2json(){
	cat $1 | python /usr/local/bin/yaml2json.py
}

json2yaml(){
	cat $1 | python /usr/local/bin/json2yaml.py
}

hcl2json(){
	cat $1 | json2hcl $1 -reverse
}

hcl2yaml(){
	cat $1 | json2hcl $1 -reverse | python /usr/local/bin/json2yaml.py
}
