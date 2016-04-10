-- Used to create the users table if it does not yet exist
CREATE TABLE 
	users (
  name varchar(32) NOT NULL,
  pword varchar(32) NOT NULL,
  rank integer NOT NULL,
  PRIMARY KEY  (name)
)
