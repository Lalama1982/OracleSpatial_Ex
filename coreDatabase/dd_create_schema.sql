-- Create the Dino Date Schema
--
-- Authors: Christopher Jones and Steven Feuerstein
--
-- 2014-09-25

SET SERVEROUTPUT ON
-- SET ECHO ON

WHENEVER SQLERROR EXIT

REVOKE CREATE SESSION FROM dd;

DECLARE
   lc_username   VARCHAR2 (32) := 'DD';
BEGIN
  FOR ln_cur IN (SELECT sid, serial# FROM v$session WHERE username = lc_username) LOOP
    EXECUTE IMMEDIATE ('ALTER SYSTEM KILL SESSION ''' || ln_cur.sid || ',' || ln_cur.serial# || ''' IMMEDIATE');
  END LOOP;

  EXECUTE IMMEDIATE 'DROP USER dd CASCADE';
  EXCEPTION
  WHEN OTHERS
  THEN
  IF SQLCODE <> -1918
  THEN
    RAISE;
  END IF;
END;
/

CREATE USER dd IDENTIFIED BY dd;
ALTER USER dd DEFAULT TABLESPACE users QUOTA UNLIMITED ON users;
ALTER USER dd TEMPORARY TABLESPACE temp;
ALTER USER dd ENABLE EDITIONS;

GRANT CREATE SESSION, RESOURCE, UNLIMITED TABLESPACE TO dd;

GRANT CREATE TABLE,
CREATE VIEW,
CREATE SEQUENCE,
CREATE PROCEDURE,
CREATE TYPE,
CREATE SYNONYM
TO dd;

GRANT EXECUTE ON DBMS_LOCK TO dd;

/* For Advanced Queueing.

   AQ also has its own queue and system privilege model e.g. so one
   user can be a queue owner and others can consume.  This model is
   not shown in this demo.
*/

GRANT EXECUTE ON DBMS_AQ TO dd;
GRANT EXECUTE ON DBMS_AQADM TO dd;


/* For Oracle Text */

GRANT ctxapp TO dd;
GRANT EXECUTE ON ctx_ddl TO dd;

/* dd_non_ebr Schema for non editionable objects */

REVOKE CREATE SESSION FROM dd_non_ebr;

DECLARE
   lc_username   VARCHAR2 (32) := 'DD_NON_EBR';
BEGIN
  FOR ln_cur IN (SELECT sid, serial# FROM v$session WHERE username = lc_username) LOOP
    EXECUTE IMMEDIATE ('ALTER SYSTEM KILL SESSION ''' || ln_cur.sid || ',' || ln_cur.serial# || ''' IMMEDIATE');
  END LOOP;
   
  EXECUTE IMMEDIATE 'DROP USER dd_non_ebr CASCADE';
  EXCEPTION
  WHEN OTHERS
  THEN
  IF SQLCODE <> -1918
  THEN
    RAISE;
  END IF;
END;
/

CREATE USER dd_non_ebr IDENTIFIED BY dd;
ALTER USER dd_non_ebr DEFAULT TABLESPACE users QUOTA UNLIMITED ON users;
ALTER USER dd_non_ebr TEMPORARY TABLESPACE temp;

GRANT CREATE SESSION, RESOURCE, UNLIMITED TABLESPACE TO dd_non_ebr;

GRANT CREATE TABLE,
CREATE SEQUENCE,
CREATE PROCEDURE,
CREATE TYPE,
CREATE SYNONYM
TO dd_non_ebr;

GRANT EXECUTE ON DBMS_LOCK TO dd_non_ebr;
GRANT EXECUTE ON DBMS_AQ TO dd_non_ebr;
GRANT EXECUTE ON DBMS_AQADM TO dd_non_ebr;
