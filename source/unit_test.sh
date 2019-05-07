echo Build on Alchemic database .....................
export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe
export PATH=$ORACLE_HOME/bin:$PATH
export PROJECT_DIR=/home/gerri/Workspace/GitHub/alchemic-wealth

cd $PROJECT_DIR/source/unit_tests

sqlplus tst/tstpaw@dev @unit_test_selected.sql dev
