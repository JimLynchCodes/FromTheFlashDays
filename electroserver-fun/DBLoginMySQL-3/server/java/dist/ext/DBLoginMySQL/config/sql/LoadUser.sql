-- Used to load info about a single user
-- input parameter
--   :username 
--
select *
from
    users
where name = :username

