package db.assignment.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.Column;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import lombok.Getter;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
public class UserResponse {

    private Integer id;
    private String email;
    private String fName;
    private String lName;
    private Date dateOfBirth;
    private String username;
    private String password;
    private String phoneNumber;
}
