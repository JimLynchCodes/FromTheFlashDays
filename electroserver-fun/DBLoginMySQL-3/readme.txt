This example shows one way to use a database to validate username and password during login, with JDBI and an external MySQL database.  It requires two server level components: DBLoginHandler and DatabasePlugin 

If you set useTwoStepLogin in Extension.xml to true (in both places), this would use a two step login process.  Right after the successful LoginResponse, a client could send a plugin request to DatabasePlugin with action = "l" to log in, and DatabasePlugin would then do the database lookup.

