CREATE DATABASE 'D:\AB\edu\edu.db' LOG ON 'edu.log' COLLATION 'UTF8BIN' NCHAR COLLATION 'UTF8BIN' DBA USER 'dba' DBA PASSWORD '***' MINIMUM PASSWORD LENGTH 3;

dbinit -z "UTF8BIN" -zn "UTF8BIN" -dba "dba","sql" -mpl 3 -t "osp.log" "D:\AB\osp\osp.db"
