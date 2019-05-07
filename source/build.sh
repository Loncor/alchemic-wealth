echo Build on Alchemic database .....................
export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe
export PATH=$ORACLE_HOME/bin:$PATH
export PROJECT_DIR=/home/gerri/Workspace/GitHub/alchemic-wealth

cd $PROJECT_DIR/source/database

sqlplus sys/syspaw@dev as sysdba @build_selected.sql dev
