package db.assignment.controller;

import db.assignment.dto.request.UserDTO;
import db.assignment.dto.response.ResponseData;
import db.assignment.exception.AppException;
import db.assignment.model.User;
import db.assignment.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/users")
@CrossOrigin(origins = "*")
public class UserController {
    private final UserService userService;

    @GetMapping
    public ResponseData<List<User>> getAllUsers() {
        List<User> users = userService.getAllUsers();
        return ResponseData.<List<User>>builder()
                .code(HttpStatus.OK.value())
                .message("Fetched users successfully")
                .result(users)
                .build();
    }

    @PostMapping
    public ResponseData<?> insertUser(@RequestBody UserDTO dto) throws AppException {
        userService.insertUserViaSP(dto);
        return ResponseData.builder()
                .code(HttpStatus.CREATED.value())
                .message("Insert user successfully")
                .build();
    }

    @PutMapping
    public ResponseData<?> updateUser(@RequestBody UserDTO dto) throws AppException {
        userService.updateUserViaSP(dto);
        return ResponseData.builder()
                .code(HttpStatus.ACCEPTED.value())
                .message("Update user successfully")
                .build();
    }

    @DeleteMapping("/{id}")
    public ResponseData<?> deleteUser(@PathVariable Integer id,
                                      @RequestParam(defaultValue = "false") boolean force) {
        userService.deleteUserViaSP(id, force);
        return ResponseData.builder()
                .code(HttpStatus.ACCEPTED.value())
                .message("Delete user successfully")
                .build();
    }
}
