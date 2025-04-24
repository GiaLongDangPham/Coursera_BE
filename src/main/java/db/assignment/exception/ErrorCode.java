package db.assignment.exception;

public enum ErrorCode {

    UNCATEGORIZED_EXCEPTION(9999, "Uncategorized error"),
    USER_ID_NULL(400, "User ID cannot be null or empty"),
    EMAIL_NULL(400, "Email cannot be null or empty"),
    USERNAME_NULL(400, "Username cannot be null or empty"),
    PASSWORD_NULL(400, "Password cannot be null or empty"),
    USER_ID_EXISTED(400, "User with this ID already exists"),
    USER_ID_NOT_EXISTED(400, "User with this ID does not exists"),
    USERNAME_EXISTED(400, "Username is already taken"),
    EMAIL_INVALID(400, "Invalid email format"),
    PASSWORD_TOO_SHORT(400, "Password must be at least 8 characters long"),
    USER_TOO_YOUNG(400, "User must be at least 13 years old"),
    USER_HAS_ROLES(400, "Cannot delete user: user has assigned roles. Remove roles first."),
    USER_HAS_ADDRESSES(400, "Cannot delete user: user has associated addresses. Remove addresses first."),
    USER_HAS_REVIEWS(400, "Cannot delete user: user has course reviews. Remove reviews first."),
    USER_HAS_LEARNING_RECORDS(400, "Cannot delete user: user has learning records. Remove them first."),
    USER_HAS_FOLLOWS(400, "Cannot delete user: user has follow relationships. Remove follow records first."),
    USER_HAS_OFFERED_COURSES(400, "Cannot delete user: user has offered courses. Remove course offerings first."),
    USER_HAS_ORDERS(400, "Cannot delete user: user has existing orders. Remove orders first."),
    USER_HAS_CERTIFICATES(400, "Cannot delete user: user has obtained certificates. Remove certificates first."),

    UNAUTHENTICATED(400, "Username or Password is incorrect"),
    DATABASE_ERROR(500, "Unexpected database error"),

    ;

    ErrorCode(int code, String message) {
        this.code = code;
        this.message = message;
    }

    private int code;
    private String message;

    public int getCode() {
        return code;
    }

    public String getMessage() {
        return message;
    }
}
