del /F osp.db
del /F osp.log
SET default_isql_encoding = 'UTF-8'
dbinit -z "UTF8BIN" -zn "UTF8BIN" -dba "dba","sql" -mpl 3 -t "osp.log" "D:\AB\osp\osp.db"
echo "----ANDMEBAAS LOODUD----"
dbisql -c "UID=dba;PWD=sql;Server=MyServerName;DBF=osp.db" project.sql
pause
dbisql -c "UID=dba;PWD=sql;Server=MyServerName;DBF=osp.db"