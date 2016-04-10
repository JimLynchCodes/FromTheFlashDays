-- Updates the rank of a single user
-- input parameters
--   :username 
--   :rank
--
UPDATE users SET rank = :rank WHERE name = :username
