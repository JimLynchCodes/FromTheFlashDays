-- Adds a new username to the database
insert into users
(name, pword, rank)
values
(:username, :password, 0)
