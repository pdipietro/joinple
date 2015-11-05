
cd $HOME/joinple

sudo mkdir ./db/neo4j/development/data/log

sudo chown -R $USER:$USER ./db/neo4j/development/data/log ./db/neo4j/development/data/graph.db ./db/neo4j/development/data/log/db_load.log ./db/neo4j/development/data/log/db_load_stderr.log

sudo cat ./db/joinple_load_initial.txt | ./db/neo4j/development/bin/neo4j-shell neo4j.properties -path ./db/neo4j/development/data/graph.db > ./db/neo4j/development/data/log/db_load.log   2>./db/neo4j/development/data/log/db_load_stderr.log

sudo chown -R $USER:$USER ./db/neo4j/development/data/log ./db/neo4j/development/data/graph.db ./db/neo4j/development/data/log/db_load.log ./db/neo4j/development/data/log/db_load_stderr.log

sudo chmod -R 777 ./db/neo4j/development/data/log ./db/neo4j/development/data/graph.db ./db/neo4j/development/data/log/db_load.log ./db/neo4j/development/data/log/db_load_stderr.log
