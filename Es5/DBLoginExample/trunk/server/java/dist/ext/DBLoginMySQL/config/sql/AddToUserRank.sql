-- Increments the rank of a single user by the given amount
-- input parameters
--   :username 
--   :amount
--
UPDATE users SET rank = (rank + :amount) WHERE name = :username
