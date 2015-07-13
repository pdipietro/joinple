# set -vx
cd $HOME/gsn

sudo cat ./db/batchload.txt | ./db/neo4j/development/bin/neo4j-shell neo4j.properties -path ./db/neo4j/development/data/graph.db > ./db/neo4j/development/data/log/db_load.log   2>./db/neo4j/development/data/log/db_load_stderr.log

#sudo cat ./content_cypher.txt | ./neo4j/bin/neo4j-shell neo4j.properties -path ./neo4j/data/graph.db > ./log/db_load.log   2>./log/db_load_stderr.log

#sudo chown -R pdipietro:pdipietro ./neo4j/data/graph.db ./log/db_load.log ./log/db_load_stderr.log

