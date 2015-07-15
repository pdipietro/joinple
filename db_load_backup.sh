# set -vx
cd $HOME/joinple

sudo cat ./db/dev_backup.txt | ./db/neo4j/development/bin/neo4j-shell neo4j.properties -path ./db/neo4j/development/data/graph.db > ./db/neo4j/development/data/log/db_load.log   2>./db/neo4j/development/data/log/db_load_stderr.log

