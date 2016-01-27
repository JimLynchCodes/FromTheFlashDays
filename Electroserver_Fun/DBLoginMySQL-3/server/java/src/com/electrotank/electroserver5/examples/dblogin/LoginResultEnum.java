package com.electrotank.electroserver5.examples.dblogin;

public enum LoginResultEnum {
    
    UsernameTaken,
    UsernameEmpty,
    AlreadyLoggedOn,
    AlreadyRegistered,
    WrongPassword,
    UserNotFound,
    DatabaseError,
    Error,
    Status,
    RegistrationsNotAllowed,
    Approved;

}
