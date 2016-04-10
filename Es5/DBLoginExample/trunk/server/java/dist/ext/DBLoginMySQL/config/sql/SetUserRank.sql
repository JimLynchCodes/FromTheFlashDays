-- Sets the rank of a single user, ignoring the current value
-- input parameters
--   :username 
--   :rank
--
UPDATE users SET rank = :rank WHERE name = :username
