USE Coursera
GO
-- Bảng User
CREATE TABLE [user] (
    id INT PRIMARY KEY,
    Email NVARCHAR(255) NOT NULL,
    FName NVARCHAR(100),
    Lname NVARCHAR(100),
    Date_of_birth DATE,
    Username NVARCHAR(100) NOT NULL UNIQUE,
    Password NVARCHAR(255) NOT NULL,
    Created_at DATETIME DEFAULT GETDATE(),
    Updated_at DATETIME DEFAULT GETDATE(),
    Phone_number NVARCHAR(20)
);
GO

-- Bảng follow
CREATE TABLE follow (
    User_id INT,
    Follower_id INT,
    PRIMARY KEY (User_id, Follower_id),
    FOREIGN KEY (User_id) REFERENCES [User](id),
    FOREIGN KEY (Follower_id) REFERENCES [User](id)
);
GO

-- Bảng user_address
CREATE TABLE user_address (
    User_id INT,
    User_addr NVARCHAR(255),
	PRIMARY KEY (User_id, User_addr),
    FOREIGN KEY (User_id) REFERENCES [User](id)
);
GO

-- Bảng role
CREATE TABLE [role] (
    id INT PRIMARY KEY,
    RName NVARCHAR(100) NOT NULL,
    RDescription NVARCHAR(MAX)
);
GO

-- Bảng permission
CREATE TABLE permission (
    id INT PRIMARY KEY,
    PName NVARCHAR(100) NOT NULL,
    PDescription NVARCHAR(MAX)
);
GO

-- Bảng has_role
CREATE TABLE has_role (
    User_id INT NOT NULL,
    Role_id INT NOT NULL,
    PRIMARY KEY (User_id, Role_id),
    FOREIGN KEY (User_id) REFERENCES [User](id),
    FOREIGN KEY (Role_id) REFERENCES [role](id)
);
GO

-- Bảng has_permission
CREATE TABLE has_permission (
    Role_id INT NOT NULL,
    Permission_id INT NOT NULL,
    PRIMARY KEY (Role_id, Permission_id),
    FOREIGN KEY (Role_id) REFERENCES [role](id),
    FOREIGN KEY (Permission_id) REFERENCES permission(id)
);
GO

-- Bảng Subject
CREATE TABLE Subject (
    id INT PRIMARY KEY,
    SName NVARCHAR(100) NOT NULL,
    SDescription NVARCHAR(MAX)
);
GO

-- Bảng Course
CREATE TABLE Course (
    id INT PRIMARY KEY,
    CName NVARCHAR(255) NOT NULL,
    CDescription NVARCHAR(MAX),
    Outcome_info NVARCHAR(MAX),
    Fee INT,
    Enrollment_count INT DEFAULT 0,
    Rating DECIMAL(3,1) DEFAULT 0.0,
);
GO

-- Bảng review_course
CREATE TABLE review_course (
    User_id INT NOT NULL,
    Course_id INT NOT NULL,
    Comment NVARCHAR(MAX),
    Date DATETIME DEFAULT GETDATE(),
    Rating_score DECIMAL(2,1) CHECK (Rating_score BETWEEN 0.0 AND 5.0),
    PRIMARY KEY (User_id, Course_id),
    FOREIGN KEY (User_id) REFERENCES [User](id),
    FOREIGN KEY (Course_id) REFERENCES Course(id)
);
GO

-- Bảng has_course (kết nối Course và Subject)
CREATE TABLE has_course (
    Subject_id INT NOT NULL,
    Course_id INT NOT NULL,
    PRIMARY KEY (Subject_id, Course_id),
    FOREIGN KEY (Subject_id) REFERENCES Subject(id),
    FOREIGN KEY (Course_id) REFERENCES Course(id)
);
GO

-- Bảng Offer
CREATE TABLE Offer (
    Course_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    FOREIGN KEY (Course_id) REFERENCES Course(id),
	FOREIGN KEY (user_id) REFERENCES [User](id)
);
GO


-- Bảng Chapter
CREATE TABLE Chapter (
    Chapter_id INT,
    Course_id INT NOT NULL,
	CName NVARCHAR(255) NOT NULL,
    CDescription NVARCHAR(MAX),
	PRIMARY KEY(Chapter_id, Course_id),
    FOREIGN KEY (Course_id) REFERENCES Course(id),
);
GO

-- Bảng Lesson (lưu trữ thông tin bài học)
CREATE TABLE Lesson (
    Course_id INT NOT NULL,
    Chapter_id INT NOT NULL,
    Lesson_id INT NOT NULL,
    LName NVARCHAR(255) NOT NULL,
    LDescription NVARCHAR(MAX),
    LType NVARCHAR(50) NOT NULL CHECK (LType IN ('Reading', 'Video', 'Assignment', 'Quiz')),
    PRIMARY KEY (Course_id, Chapter_id, Lesson_id),
    FOREIGN KEY (Chapter_id, Course_id) REFERENCES Chapter(Chapter_id, Course_id)
);
GO

-- Bảng Learn (lưu trữ tiến trình học tập của người dùng)
CREATE TABLE Learn (
    User_id INT NOT NULL,
    Course_id INT NOT NULL,
    Chapter_id INT NOT NULL,
    Lesson_id INT NOT NULL,
    status NVARCHAR(50) NOT NULL CHECK (status IN ('completed', 'in-progress', 'not-started')),
    score DECIMAL(5,1),
    attempt INT DEFAULT 1,
    PRIMARY KEY (User_id, Course_id, Chapter_id, Lesson_id),
    FOREIGN KEY (User_id) REFERENCES [User](id),
    FOREIGN KEY (Course_id, Chapter_id, Lesson_id) REFERENCES Lesson(Course_id, Chapter_id, Lesson_id)
);
GO

-- Bảng Assignment (bài tập lớn)
CREATE TABLE Assignment (
    Course_id INT NOT NULL,
    Chapter_id INT NOT NULL,
    Lesson_id INT NOT NULL,
    Number_of_attempts INT DEFAULT 1,
    Number_of_days INT, -- Thời hạn nộp bài (số ngày)
    Passing_score DECIMAL(5,1),
    Instruction NVARCHAR(MAX),
    PRIMARY KEY (Course_id, Chapter_id, Lesson_id),
    FOREIGN KEY (Course_id, Chapter_id, Lesson_id) REFERENCES Lesson(Course_id, Chapter_id, Lesson_id)
);
GO



-- Bảng Quiz (bài kiểm tra)
CREATE TABLE Quiz (
    Course_id INT NOT NULL,
    Chapter_id INT NOT NULL,
    Lesson_id INT NOT NULL,
    Number_of_attempts INT DEFAULT 1,
    Passing_score DECIMAL(5,1),
    Time_limit INT, -- Thời gian làm bài (phút)
    Number_of_question INT,
    PRIMARY KEY (Course_id, Chapter_id, Lesson_id),
    FOREIGN KEY (Course_id, Chapter_id, Lesson_id) REFERENCES Lesson(Course_id, Chapter_id, Lesson_id)
);
GO

-- Bảng Video
CREATE TABLE Video (
    Course_id INT NOT NULL,
    Chapter_id INT NOT NULL,
    Lesson_id INT NOT NULL,
    Video_link NVARCHAR(MAX) NOT NULL,
    Duration INT, -- Thời lượng tính bằng phút
    PRIMARY KEY (Course_id, Chapter_id, Lesson_id),
    FOREIGN KEY (Course_id, Chapter_id, Lesson_id) REFERENCES Lesson(Course_id, Chapter_id, Lesson_id)
);
GO

-- Bảng Reading 
CREATE TABLE Reading (
    Course_id INT NOT NULL,
    Chapter_id INT NOT NULL,
    Lesson_id INT NOT NULL,
    Link NVARCHAR(MAX) NOT NULL,
    PRIMARY KEY (Course_id, Chapter_id, Lesson_id),
    FOREIGN KEY (Course_id, Chapter_id, Lesson_id) REFERENCES Lesson(Course_id, Chapter_id, Lesson_id)
);
GO

-- Bảng Question (câu hỏi)
CREATE TABLE Question (
    Question_id INT PRIMARY KEY,
    Qtext NVARCHAR(MAX) NOT NULL,
    Qtype NVARCHAR(50) NOT NULL CHECK (Qtype IN ('MCQS', 'TFQ')), -- Ví dụ: 'multiple-choice', 'true-false'
    Course_id INT NOT NULL,
    Chapter_id INT NOT NULL,
    Lesson_id INT NOT NULL,
    FOREIGN KEY (Course_id, Chapter_id, Lesson_id) REFERENCES Quiz(Course_id, Chapter_id, Lesson_id)
);
GO

-- Bảng Answer (đáp án)
CREATE TABLE Answer (
    Answer_id INT NOT NULL,
    Question_id INT NOT NULL,
    Answer_text NVARCHAR(MAX) NOT NULL,
    is_correct BIT DEFAULT 0, -- 0: Sai, 1: Đúng
    PRIMARY KEY (Answer_id, Question_id),
    FOREIGN KEY (Question_id) REFERENCES Question(Question_id)
);
GO

-- Bảng Certificate (lưu thông tin chứng chỉ)
CREATE TABLE Certificate (
    Certificate_id INT PRIMARY KEY,
    Cer_name NVARCHAR(255) NOT NULL,
    Awarding_institution NVARCHAR(255) NOT NULL,
    Certificate_url NVARCHAR(MAX) NOT NULL,
    Course_id INT NOT NULL,
    FOREIGN KEY (Course_id) REFERENCES Course(id)
);
GO

-- Bảng obtain_certificate (lưu thông tin người dùng nhận chứng chỉ)
CREATE TABLE obtain_certificate (
    Certificate_id INT NOT NULL,
    User_id INT NOT NULL,
    Issue_date DATE NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY (Certificate_id, User_id),
    FOREIGN KEY (Certificate_id) REFERENCES Certificate(Certificate_id),
    FOREIGN KEY (User_id) REFERENCES [User](id)
);
GO

-- Bảng Coupon
CREATE TABLE Coupon (
    Coupon_id INT PRIMARY KEY,
    Coupon_code NVARCHAR(50) NOT NULL UNIQUE,
    Start_date DATETIME NOT NULL,
    End_date DATETIME NOT NULL,
    Discount_type NVARCHAR(20) NOT NULL CHECK (Discount_type IN ('Percentage', 'Fixed')),
    Discount_value INT,
    Coupon_type NVARCHAR(50),
    Amount INT,
    Duration INT,
    CHECK (End_date > Start_date)
);
GO

-- Bảng Order
CREATE TABLE [Order] (
    Order_id INT PRIMARY KEY,
    User_id INT NOT NULL,
    Ord_status NVARCHAR(20) NOT NULL CHECK (Ord_status IN ('Pending', 'Completed', 'Cancelled', 'Refunded')),
    Ord_date DATETIME NOT NULL DEFAULT GETDATE(),
    Total_fee INT NOT NULL,
    Certificate_url NVARCHAR(MAX),
    FOREIGN KEY (User_id) REFERENCES [User](id)
);
GO

-- Bảng use_coupon (quan hệ giữa Order và Coupon)
CREATE TABLE use_coupon (
    Coupon_id INT NOT NULL,
    Order_id INT NOT NULL,
    PRIMARY KEY (Coupon_id, Order_id),
    FOREIGN KEY (Coupon_id) REFERENCES Coupon(Coupon_id),
    FOREIGN KEY (Order_id) REFERENCES [Order](Order_id)
);
GO

-- Bảng include_course (quan hệ giữa Order và Course)
CREATE TABLE include_course (
    Order_id INT NOT NULL,
    Course_id INT NOT NULL,
    PRIMARY KEY (Order_id, Course_id),
    FOREIGN KEY (Order_id) REFERENCES [Order](Order_id),
    FOREIGN KEY (Course_id) REFERENCES Course(id)
);
GO

-- Bảng Order_receipt 
CREATE TABLE Order_receipt (
	Receipt_id INT PRIMARY KEY,
    Export_date DATETIME NOT NULL DEFAULT GETDATE(),
    Total_fee INT NOT NULL CHECK (Total_fee >= 0),
    Order_id INT NOT NULL,
    FOREIGN KEY (Order_id) REFERENCES [Order](Order_id)
);
GO

-- 1. Người dùng phải đủ 13 tuổi
CREATE TRIGGER trg_check_min_age_13
ON [user]
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra tuổi
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE DATEDIFF(YEAR, date_of_birth, GETDATE()) < 13
    )
    BEGIN
        RAISERROR ('Người dùng phải đủ 13 tuổi trở lên.', 16, 1);
        RETURN;
    END;

    -- Nếu đủ tuổi thì thực hiện INSERT hoặc UPDATE
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        -- Nếu là INSERT
        IF NOT EXISTS (SELECT * FROM deleted)
        BEGIN
            INSERT INTO [user] (id, email, fname, lname, date_of_birth, username, password, created_at, updated_at, phone_number)
            SELECT id, email, fname, lname, date_of_birth, username, password, created_at, updated_at, phone_number
            FROM inserted;
        END
        ELSE
        BEGIN
            -- Nếu là UPDATE
            UPDATE u
            SET u.email = i.email,
                u.fname = i.fname,
                u.lname = i.lname,
                u.date_of_birth = i.date_of_birth,
                u.username = i.username,
                u.password = i.password,
                u.created_at = i.created_at,
                u.updated_at = i.updated_at,
                u.phone_number = i.phone_number
            FROM [user] u
            JOIN inserted i ON u.id = i.id;
        END
    END
END;
GO

-- Thử insert sai
INSERT INTO [User] (id, Email, FName, LName, Date_of_birth, Username, Password, Phone_number)
VALUES
 (999,'xxx@example.com','x','x','2020-05-15','x','Password123!','0123456789')
GO
-- Thử insert sai
UPDATE [user]
SET date_of_birth = '2015-05-01'
WHERE id = 1;
GO


-- 2. Password phải có tối thiểu 8 kí tự
ALTER TABLE [user]
ADD CONSTRAINT CHK_Password_Length CHECK (LEN(Password) >= 8);
GO

-- Thử insert sai
INSERT INTO [User] (id, Email, FName, LName, Date_of_birth, Username, Password, Phone_number)
VALUES
 (999,'xxx@example.com','x','x','2000-05-15','x','1234567','0123456789')
GO

-- 3. Học phí khóa học ≥ 0
ALTER TABLE Course
ADD CONSTRAINT CHK_Course_Fee CHECK (Fee >= 0);
GO

-- 4. Điểm đánh giá mỗi khóa học được tính theo số sao từ 0 đến 5.
ALTER TABLE dbo.course
ADD CONSTRAINT chk_rating_range
CHECK (rating >= 0 AND rating <= 5);
GO

--5 Người dùng chỉ có thể đánh giá khóa học nếu họ đã hoàn thành hơn 50% nội dung.
CREATE OR ALTER TRIGGER trg_check_review_progress
ON review_course
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        CROSS APPLY (
            SELECT 
                -- Tổng số bài học (duy nhất)
                (SELECT COUNT(*) 
                 FROM (SELECT DISTINCT Chapter_id, Lesson_id
                       FROM Learn
                       WHERE Course_id = i.Course_id) AS TotalLessons) AS total_lessons,

                -- Số bài học đã hoàn thành (duy nhất)
                (SELECT COUNT(*) 
                 FROM (SELECT DISTINCT Chapter_id, Lesson_id
                       FROM Learn
                       WHERE Course_id = i.Course_id 
                         AND User_id = i.User_id
                         AND Status = 'completed') AS CompletedLessons) AS completed_lessons
        ) AS progress
        WHERE progress.total_lessons = 0
           OR (1.0 * progress.completed_lessons / progress.total_lessons) <= 0.5
    )
    BEGIN
        RAISERROR('Người dùng phải hoàn thành hơn 50%% nội dung khóa học để đánh giá.', 16, 1);
        RETURN;
    END

    -- Chèn bình thường nếu đủ điều kiện
    INSERT INTO review_course (User_id, Course_id, Comment, Date, Rating_score)
    SELECT User_id, Course_id, Comment, Date, Rating_score
    FROM inserted;
END;
GO

-- Kiểm tra user chưa hoàn thành 50% khóa học mà review
select * from Learn
select * from review_course
select * from Course
select * from [User]
INSERT INTO review_course (User_id, Course_id, Comment, Date, Rating_score)
VALUES
 (4,101,'Great introduction to programming!','2024-01-15',4.5),
 (2,101,'Great introduction to programming!','2024-01-15',4.5)
GO
INSERT INTO review_course (User_id, Course_id, Comment, Date, Rating_score)
VALUES
  (2, 101, 'Solid content, but I wish there were more practical exercises.', '2024-01-16', 4.0),
  (5, 102, 'The course was very detailed and the instructor was clear. Highly recommended for advanced learners.', '2024-01-17', 5.0),
  (6, 103, 'Not engaging enough, I expected more interactivity.', '2024-01-18', 3.0),
  (3, 104, 'A comprehensive course, but some topics could be explained better.', '2024-01-19', 3.5),
  (7, 106, 'Great content, but the pace was a bit fast for beginners.', '2024-01-21', 4.2),
  (6, 107, 'I didn’t learn much from this course. The material wasn’t very up to date.', '2024-01-22', 2.5),
  (7, 108, 'Good course but lacks depth in certain areas. Could use more real-world examples.', '2024-01-23', 3.8),
  (100, 109, 'Loved it! The hands-on approach helped me understand the concepts better.', '2024-01-24', 5.0);
GO

DELETE FROM review_course WHERE user_id = 4 AND Course_id = 101;

-- 6. Mỗi user chỉ đánh giá mỗi course 1 lần
-- (Đã được đảm bảo bởi PRIMARY KEY (User_id, Course_id))
-- Không cần thêm ràng buộc

-- 7. Ngày hết hiệu lực của mã giảm giá phải sau ngày bắt đầu có hiệu lực.
-- (Đã check lúc tạo bảng)

-- 8. Điểm assignment và quiz ≥ 0
ALTER TABLE Assignment
ADD CONSTRAINT CHK_Assignment_Score CHECK (Passing_score >= 0);
GO

ALTER TABLE Quiz
ADD CONSTRAINT CHK_Quiz_Score CHECK (Passing_score >= 0);
GO

-- Thử insert sai
INSERT INTO Assignment (Course_id, Chapter_id, Lesson_id, Number_of_attempts, Number_of_days, Passing_score, Instruction)
VALUES
 (101,1,4,0,7,70,'Submit a console program that prints Hello World')
GO

-- 9. Number_of_attempts và Number_of_days của Assignment > 0

ALTER TABLE Assignment
ADD CONSTRAINT CHK_Assignment_Attempts CHECK (Number_of_attempts > 0),
    CONSTRAINT CHK_Assignment_Days CHECK (Number_of_days > 0)
GO


-- 10. Phải hoàn thành 100% các bài học trong thời gian 180 ngày kể 
	--từ ngày mua khóa học mới có thể đươc cấp chứng chỉ.

CREATE TRIGGER trg_check_certificate_eligibility
ON obtain_certificate
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted ic
        JOIN Certificate c ON ic.Certificate_id = c.Certificate_id
        JOIN include_course inc ON inc.Course_id = c.Course_id
        JOIN [Order] o ON o.Order_id = inc.Order_id AND o.User_id = ic.User_id
        JOIN Order_receipt r ON r.Order_id = o.Order_id
        CROSS APPLY (
            SELECT 
                COUNT(*) AS total_lessons,
                SUM(CASE 
                    WHEN l.status = 'completed' 
                         AND DATEDIFF(DAY, r.Export_date, GETDATE()) <= 180 
                    THEN 1 ELSE 0 END) AS completed_lessons
					-- completed_lessons: Số bài học người dùng đã hoàn thành trong vòng 180 ngày kể từ ngày bắt đầu học.
            FROM Lesson le
            JOIN Learn l ON l.Lesson_id = le.Lesson_id AND l.Course_id = le.Course_id
                         AND l.Chapter_id = le.Chapter_id AND l.User_id = ic.User_id
            WHERE le.Course_id = c.Course_id
        ) AS progress
        WHERE progress.completed_lessons < progress.total_lessons
    )
    BEGIN
        RAISERROR('Bạn phải hoàn thành 100%% bài học trong vòng 180 ngày để được cấp chứng chỉ.', 16, 1);
        RETURN;
    END;

    -- Nếu hợp lệ thì chèn vào
    INSERT INTO obtain_certificate (Certificate_id, User_id, Issue_date)
    SELECT Certificate_id, User_id, Issue_date
    FROM inserted;
END;
GO




USE Coursera;
GO

-- Bảng [User]
INSERT INTO [User] (id, Email, FName, LName, Date_of_birth, Username, Password, Phone_number)
VALUES
 (1,'alice@example.com','Alice','Nguyen','1990-05-15','alice90','Password123!','0123456789'),
 (2,'bob@example.com','Bob','Tran','1985-08-20','bob85','SecurePass456!','0987654321'),
 (3,'charlie@example.com','Charlie','Le','2000-12-01','charlie00','MyP@ssw0rd','0912345678'),
 (4,'david@example.com','David','Pham','1995-02-10','david95','PassWord789!','0901234567'),
 (5,'eve@example.com','Eve','Hoang','2002-07-25','eve02','EvePass321!','0932123456');
GO

-- Bảng follow
INSERT INTO follow (User_id, Follower_id)
VALUES
 (1,2),
 (1,3),
 (2,4),
 (2,5),
 (3,4);
GO

-- Bảng user_address
INSERT INTO user_address (User_id, User_addr)
VALUES
 (1,'123 Le Loi, District 1, HCMC'),
 (2,'456 Tran Hung Dao, District 5, HCMC'),
 (3,'789 Nguyen Trai, District 3, HCMC'),
 (4,'321 Pham Ngu Lao, District 1, HCMC'),
 (5,'654 Pasteur, District 3, HCMC');
GO

-- Bảng role
INSERT INTO role (id, RName, RDescription)
VALUES
 (1,'Admin','System administrator with full privileges'),
 (2,'Instructor','Can create and manage courses'),
 (3,'Student','Can enroll in and review courses'),
 (4,'Moderator','Can manage user comments and feedback'),
 (5,'Guest','Read-only access to public course catalog');
GO

-- Bảng permission
INSERT INTO permission (id, PName, PDescription)
VALUES
 (1,'create_course','Permission to create courses'),
 (2,'review_course','Permission to review courses'),
 (3,'enroll_course','Permission to enroll in courses'),
 (4,'manage_users','Permission to manage user accounts'),
 (5,'view_reports','Permission to view analytics reports');
GO

-- Bảng has_role
INSERT INTO has_role (User_id, Role_id)
VALUES
 (1,3),  -- Alice là Student
 (2,2),  -- Bob là Instructor
 (3,3),  -- Charlie là Student
 (4,4),  -- David là Moderator
 (5,5);  -- Eve là Guest
GO

-- Bảng has_permission
INSERT INTO has_permission (Role_id, Permission_id)
VALUES
 (1,1),
 (1,4),
 (2,1),
 (3,3),
 (4,2);
GO

-- Bảng Subject
INSERT INTO Subject (id, SName, SDescription)
VALUES
 (1,'Computer Science','Courses about algorithms, programming, and systems'),
 (2,'Data Science','Courses about data analysis, machine learning, and statistics'),
 (3,'Business','Courses about management, finance, and entrepreneurship'),
 (4,'Art','Courses about fine arts, design, and creativity'),
 (5,'Mathematics','Courses about algebra, calculus, and more');
GO

-- Bảng Course
INSERT INTO Course (id, CName, CDescription, Outcome_info, Fee, Enrollment_count, Rating)
VALUES
(106, 'Web Development Bootcamp', 'Full-stack web development course', 'Build modern websites using HTML, CSS, JS, and Node.js', 180, 300, 4.8),
  (107, 'Machine Learning Basics', 'Introduction to machine learning concepts', 'Train and evaluate ML models using Python', 220, 210, 4.6),
  (108, 'Creative Writing Workshop', 'Improve your storytelling and writing style', 'Write compelling short stories and essays', 75, 130, 4.2),
  (109, 'Cybersecurity Fundamentals', 'Learn the principles of cybersecurity and ethical hacking', 'Identify and prevent common security threats', 160, 175, 4.5),
  (110, 'Project Management Essentials', 'Master the basics of project planning and execution', 'Manage small to medium-sized projects effectively', 140, 190, 4.3),
 (101,'Intro to Programming','Learn the basics of programming','Write simple programs',100,200,4.5),
 (102,'Data Analysis with Python','Analyze data using Python libraries','Create data visualizations',150,180,4.7),
 (103,'Financial Markets','Understand how financial markets operate','Evaluate investment opportunities',200,120,4.3),
 (104,'Digital Painting','Learn digital art techniques','Produce digital artwork',80,90,4.6),
 (105,'Calculus I','Fundamentals of differential calculus','Solve derivatives and limits',120,250,4.4);
GO

-- Bảng review_course
INSERT INTO review_course (User_id, Course_id, Comment, Date, Rating_score)
VALUES
 (1,101,'Great introduction to programming!','2024-01-15',4.5),
 (2,102,'Very practical and hands‑on.','2024-02-10',4.7),
 (3,103,'Good coverage of markets.','2024-03-05',4.2),
 (1,105,'Challenging but rewarding.','2024-04-01',4.4),
 (5,104,'Loved the creative projects.','2024-04-10',4.6);
GO

-- Bảng has_course
INSERT INTO has_course (Subject_id, Course_id)
VALUES
 (1,101),
 (2,102),
 (3,103),
 (4,104),
 (5,105);
GO

-- Bảng Offer
INSERT INTO Offer (Course_id, User_id)
VALUES
 (101,2),
 (102,2),
 (103,3),
 (104,4),
 (105,3);
GO

-- Bảng Chapter (5 chương cho Course 101)
INSERT INTO Chapter (Chapter_id, Course_id, CName, CDescription)
VALUES
 (1,101,'Getting Started','Introduction to the course and setup'),
 (2,101,'Basics','Core programming concepts'),
 (3,101,'Control Flow','Conditional statements and loops'),
 (4,101,'Data Structures','Arrays, lists, and dictionaries'),
 (5,101,'Functions','Writing reusable code');
GO

-- Bảng Lesson (4 bài mỗi chương của Course 101)
INSERT INTO Lesson (Course_id, Chapter_id, Lesson_id, LName, LDescription, LType)
VALUES
 -- Chương 1
 (101,1,1,'Welcome','Course overview','Reading'),
 (101,1,2,'Environment Setup','Install tools','Video'),
 (101,1,3,'Hello Assignment','Write your first program','Assignment'),
 (101,1,4,'Intro Quiz','Test basic concepts','Quiz'),
 -- Chương 2
 (101,2,1,'Variables','Understanding variables','Reading'),
 (101,2,2,'Data Types','Different data types','Video'),
 (101,2,3,'Variables Assignment','Practice with variables','Assignment'),
 (101,2,4,'Variables Quiz','Quiz on variables','Quiz'),
 -- Chương 3
 (101,3,1,'If Statements','Conditionals explained','Reading'),
 (101,3,2,'Loops','For and while loops','Video'),
 (101,3,3,'Control Flow Assignment','Use loops and if','Assignment'),
 (101,3,4,'Control Flow Quiz','Test control flow','Quiz'),
 -- Chương 4
 (101,4,1,'Lists','Working with lists','Reading'),
 (101,4,2,'Dictionaries','Key-value pairs','Video'),
 (101,4,3,'Data Struct Assignment','Practice data structures','Assignment'),
 (101,4,4,'Data Struct Quiz','Quiz on data structures','Quiz'),
 -- Chương 5
 (101,5,1,'Functions','Defining functions','Reading'),
 (101,5,2,'Parameters','Function parameters','Video'),
 (101,5,3,'Functions Assignment','Build functions','Assignment'),
 (101,5,4,'Functions Quiz','Quiz on functions','Quiz');
GO

-- Bảng Assignment
INSERT INTO Assignment (Course_id, Chapter_id, Lesson_id, Number_of_attempts, Number_of_days, Passing_score, Instruction)
VALUES
 (101,1,3,3,7,70,'Submit a console program that prints Hello World'),
 (101,2,3,3,7,70,'Create and use variables in code'),
 (101,3,3,3,7,70,'Implement a loop that sums numbers'),
 (101,4,3,3,7,70,'Use lists and dictionaries to store data'),
 (101,5,3,3,7,70,'Write a function with parameters');
GO

-- Bảng Quiz
INSERT INTO Quiz (Course_id, Chapter_id, Lesson_id, Number_of_attempts, Passing_score, Time_limit, Number_of_question)
VALUES
 (101,1,4,2,80,15,5),
 (101,2,4,2,80,15,5),
 (101,3,4,2,80,15,5),
 (101,4,4,2,80,15,5),
 (101,5,4,2,80,15,5);
GO

-- Bảng Video
INSERT INTO Video (Course_id, Chapter_id, Lesson_id, Video_link, Duration)
VALUES
 (101,1,2,'https://example.com/videos/setup.mp4',10),
 (101,2,2,'https://example.com/videos/datatypes.mp4',12),
 (101,3,2,'https://example.com/videos/loops.mp4',15),
 (101,4,2,'https://example.com/videos/dicts.mp4',14),
 (101,5,2,'https://example.com/videos/parameters.mp4',13);
GO

-- Bảng Reading
INSERT INTO Reading (Course_id, Chapter_id, Lesson_id, Link)
VALUES
 (101,1,1,'https://example.com/readings/welcome.html'),
 (101,2,1,'https://example.com/readings/variables.html'),
 (101,3,1,'https://example.com/readings/if_statements.html'),
 (101,4,1,'https://example.com/readings/lists.html'),
 (101,5,1,'https://example.com/readings/functions.html');
GO

-- Bảng Learn
INSERT INTO Learn (User_id, Course_id, Chapter_id, Lesson_id, status, score, attempt)
VALUES
 (1,101,1,1,'completed',100,1),
 (1,101,1,2,'completed', 95,1),
 (2,101,1,1,'completed',100,1),
 (3,101,2,1,'in-progress',NULL,1),
 (4,101,3,4,'not-started', NULL,1);
GO

-- Bảng Question
INSERT INTO Question (Question_id, Qtext, Qtype, Course_id, Chapter_id, Lesson_id)
VALUES
 (1001,'What does GETDATE() return?','TFQ',101,1,4),
 (1002,'Which keyword defines a function in Python?','MCQS',101,5,4),
 (1003,'What symbol denotes a list?','MCQS',101,4,4),
 (1004,'True or False: Python is statically typed.','TFQ',101,2,4),
 (1005,'Choose the correct loop structure for repeating code.','MCQS',101,3,4);
GO

-- Bảng Answer
INSERT INTO Answer (Answer_id, Question_id, Answer_text, is_correct)
VALUES
 (1,1001,'Current date and time',1),
 (2,1001,'Current username',0),
 (1,1002,'def',1),
 (2,1002,'function',0),
 (1,1003,'[]',1),
 (2,1003,'{}',0),
 (1,1004,'True',0),
 (2,1004,'False',1),
 (1,1005,'while',1),
 (2,1005,'if',0);
GO

-- Bảng Certificate
INSERT INTO Certificate (Certificate_id, Cer_name, Awarding_institution, Certificate_url, Course_id)
VALUES
 (1,'Programming Basics Certificate','Coursera','https://certs.example.com/1',101),
 (2,'Python Data Analysis Certificate','Coursera','https://certs.example.com/2',102),
 (3,'Financial Markets Certificate','Coursera','https://certs.example.com/3',103),
 (4,'Digital Painting Certificate','Coursera','https://certs.example.com/4',104),
 (5,'Calculus I Certificate','Coursera','https://certs.example.com/5',105);
GO

-- Bảng obtain_certificate
INSERT INTO obtain_certificate (Certificate_id, User_id, Issue_date)
VALUES
 (1,1,'2024-05-01'),
 (2,2,'2024-06-15'),
 (3,3,'2024-07-20'),
 (4,5,'2024-08-10'),
 (5,4,'2024-09-05');
GO

-- Bảng Coupon
INSERT INTO Coupon (Coupon_id, Coupon_code, Start_date, End_date, Discount_type, Discount_value, Coupon_type, Amount, Duration)
VALUES
 (1,'WELCOME10','2024-01-01','2024-12-31','Percentage',10,'NewUser',100,30),
 (2,'SPRING20','2024-03-01','2024-06-30','Fixed',20,'Seasonal',50,15),
 (3,'STUDENT5','2024-01-01','2024-12-31','Percentage',5,'Loyalty',200,60),
 (4,'SUMMER15','2024-06-01','2024-08-31','Percentage',15,'Seasonal',80,30),
 (5,'BLACKFRI','2024-11-20','2024-11-30','Percentage',25,'Promotion',150,10);
GO

-- Bảng [Order]
INSERT INTO [Order] (Order_id, User_id, Ord_status, Ord_date, Total_fee, Certificate_url)
VALUES
 (1001,1,'Completed','2024-05-02',100,'https://orders.example.com/1001'),
 (1002,2,'Pending','2024-06-16',150,NULL),
 (1003,3,'Completed','2024-07-21',200,'https://orders.example.com/1003'),
 (1004,4,'Cancelled','2024-08-01',80,NULL),
 (1005,5,'Completed','2024-09-06',120,'https://orders.example.com/1005');
GO

-- Bảng use_coupon
INSERT INTO use_coupon (Coupon_id, Order_id)
VALUES
 (1,1001),
 (2,1002),
 (3,1003),
 (4,1004),
 (1,1005);
GO

-- Bảng include_course
INSERT INTO include_course (Order_id, Course_id)
VALUES
 (1001,101),
 (1002,102),
 (1003,103),
 (1004,104),
 (1005,105);
GO

-- Bảng Order_receipt
INSERT INTO Order_receipt (Receipt_id, Export_date, Total_fee, Order_id)
VALUES
 (5001,'2024-05-02',100,1001),
 (5002,'2024-06-16',150,1002),
 (5003,'2024-07-21',200,1003),
 (5004,'2024-08-01',80,1004),
 (5005,'2024-09-06',120,1005);
GO

-------------------------------------------------------------------------------------------------------------
-- 2. Viết các trigger, thủ tục, hàm (4 điểm) 
-- 2.1
-- Stored procedure to insert a new user
CREATE OR ALTER PROCEDURE sp_InsertUser
    @id INT,
    @Email NVARCHAR(255),
    @FName NVARCHAR(100),
    @LName NVARCHAR(100),
    @Date_of_birth DATE,
    @Username NVARCHAR(100),
    @Password NVARCHAR(255),
    @Phone_number NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Validate required fields
    IF @id IS NULL OR @id = ''
    BEGIN
        RAISERROR('User ID cannot be null or empty', 16, 1);
        RETURN;
    END
    
    IF @Email IS NULL OR @Email = ''
    BEGIN
        RAISERROR('Email cannot be null or empty', 16, 1);
        RETURN;
    END
    
    IF @Username IS NULL OR @Username = ''
    BEGIN
        RAISERROR('Username cannot be null or empty', 16, 1);
        RETURN;
    END
    
    IF @Password IS NULL OR @Password = ''
    BEGIN
        RAISERROR('Password cannot be null or empty', 16, 1);
        RETURN;
    END
    
    -- Check if ID already exists
    IF EXISTS (SELECT 1 FROM [User] WHERE id = @id)
    BEGIN
        RAISERROR('User with ID %d already exists', 16, 1, @id);
        RETURN;
    END
    
    -- Check if Username already exists
    IF EXISTS (SELECT 1 FROM [User] WHERE Username = @Username)
    BEGIN
        RAISERROR('Username "%s" is already taken', 16, 1, @Username);
        RETURN;
    END
    
    -- Check email format
    IF @Email NOT LIKE '%_@__%.__%'
    BEGIN
        RAISERROR('Invalid email format: %s', 16, 1, @Email);
        RETURN;
    END
    
    -- Check password length
    IF LEN(@Password) < 8
    BEGIN
        RAISERROR('Password must be at least 8 characters long', 16, 1);
        RETURN;
    END
    
    -- Check age constraint
    IF @Date_of_birth IS NOT NULL AND DATEDIFF(YEAR, @Date_of_birth, GETDATE()) < 13
    BEGIN
        RAISERROR('User must be at least 13 years old', 16, 1);
        RETURN;
    END
    
    -- Insert new user
    BEGIN TRY
        INSERT INTO [User] (id, Email, FName, LName, Date_of_birth, Username, Password, Phone_number)
        VALUES (@id, @Email, @FName, @LName, @Date_of_birth, @Username, @Password, @Phone_number);
        
        PRINT 'User inserted successfully';
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO

-- Stored procedure to update a user
CREATE OR ALTER PROCEDURE sp_UpdateUser
    @id INT,
    @Email NVARCHAR(255) = NULL,
    @FName NVARCHAR(100) = NULL,
    @LName NVARCHAR(100) = NULL,
    @Date_of_birth DATE = NULL,
    @Username NVARCHAR(100) = NULL,
    @Password NVARCHAR(255) = NULL,
    @Phone_number NVARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if user exists
    IF NOT EXISTS (SELECT 1 FROM [User] WHERE id = @id)
    BEGIN
        RAISERROR('User with ID %d does not exist', 16, 1, @id);
        RETURN;
    END
    
    -- Validate username uniqueness if changing it
    IF @Username IS NOT NULL AND LTRIM(RTRIM(@Username)) <> '' AND EXISTS (SELECT 1 FROM [User] WHERE Username = @Username AND id <> @id)
    BEGIN
        RAISERROR('Username "%s" is already taken', 16, 1, @Username);
        RETURN;
    END
    
    -- Check email format if provided
    IF @Email IS NOT NULL AND LTRIM(RTRIM(@Email)) <> '' AND @Email NOT LIKE '%_@__%.__%'
    BEGIN
        RAISERROR('Invalid email format: %s', 16, 1, @Email);
        RETURN;
    END
    
    -- Check password length if provided
    IF @Password IS NOT NULL AND LTRIM(RTRIM(@Password)) <> '' AND LEN(@Password) < 8
    BEGIN
        RAISERROR('Password must be at least 8 characters long', 16, 1);
        RETURN;
    END
    
    -- Check age constraint if provided
    IF @Date_of_birth IS NOT NULL AND DATEDIFF(YEAR, @Date_of_birth, GETDATE()) < 13
    BEGIN
        RAISERROR('User must be at least 13 years old', 16, 1);
        RETURN;
    END

    -- Build dynamic SQL for update
    DECLARE @SQL NVARCHAR(MAX) = 'UPDATE [User] SET Updated_at = GETDATE()';
    
    IF @Email IS NOT NULL AND LTRIM(RTRIM(@Email)) <> ''
        SET @SQL = @SQL + ', Email = @Email';
    IF @FName IS NOT NULL AND LTRIM(RTRIM(@FName)) <> ''
        SET @SQL = @SQL + ', FName = @FName';
    IF @LName IS NOT NULL AND LTRIM(RTRIM(@LName)) <> ''
        SET @SQL = @SQL + ', LName = @LName';
    IF @Date_of_birth IS NOT NULL
        SET @SQL = @SQL + ', Date_of_birth = @Date_of_birth';
    IF @Username IS NOT NULL AND LTRIM(RTRIM(@Username)) <> ''
        SET @SQL = @SQL + ', Username = @Username';
    IF @Password IS NOT NULL AND LTRIM(RTRIM(@Password)) <> ''
        SET @SQL = @SQL + ', Password = @Password';
    IF @Phone_number IS NOT NULL AND LTRIM(RTRIM(@Phone_number)) <> ''
        SET @SQL = @SQL + ', Phone_number = @Phone_number';
    
    SET @SQL = @SQL + ' WHERE id = @id';
    
    -- Execute update
    BEGIN TRY
        EXEC sp_executesql @SQL, 
            N'@id INT, @Email NVARCHAR(255), @FName NVARCHAR(100), @LName NVARCHAR(100), 
              @Date_of_birth DATE, @Username NVARCHAR(100), @Password NVARCHAR(255), @Phone_number NVARCHAR(20)',
            @id, @Email, @FName, @LName, @Date_of_birth, @Username, @Password, @Phone_number;
        
        PRINT 'User updated successfully';
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO

-- Stored procedure to delete a user
CREATE OR ALTER PROCEDURE sp_DeleteUser
    @id INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if user exists
    IF NOT EXISTS (SELECT 1 FROM [User] WHERE id = @id)
    BEGIN
        RAISERROR('User with ID %d does not exist', 16, 1, @id);
        RETURN;
    END
    
    -- Check for dependencies in has_role table
    IF EXISTS (SELECT 1 FROM has_role WHERE User_id = @id)
    BEGIN
        RAISERROR('Cannot delete user with ID %d: User has assigned roles. Remove roles first.', 16, 1, @id);
        RETURN;
    END
    
    -- Check for dependencies in user_address table
    IF EXISTS (SELECT 1 FROM user_address WHERE User_id = @id)
    BEGIN
        RAISERROR('Cannot delete user with ID %d: User has address records. Remove addresses first.', 16, 1, @id);
        RETURN;
    END
    
    -- Check for dependencies in review_course table
    IF EXISTS (SELECT 1 FROM review_course WHERE User_id = @id)
    BEGIN
        RAISERROR('Cannot delete user with ID %d: User has course reviews. Remove reviews first.', 16, 1, @id);
        RETURN;
    END
    
    -- Check for dependencies in Learn table
    IF EXISTS (SELECT 1 FROM Learn WHERE User_id = @id)
    BEGIN
        RAISERROR('Cannot delete user with ID %d: User has learning records. Remove learning records first.', 16, 1, @id);
        RETURN;
    END
    
    -- Check for dependencies in follow table (as either user or follower)
    IF EXISTS (SELECT 1 FROM follow WHERE User_id = @id OR Follower_id = @id)
    BEGIN
        RAISERROR('Cannot delete user with ID %d: User has follow relationships. Remove follow records first.', 16, 1, @id);
        RETURN;
    END
    
    -- Check for dependencies in Offer table
    IF EXISTS (SELECT 1 FROM Offer WHERE user_id = @id)
    BEGIN
        RAISERROR('Cannot delete user with ID %d: User has offered courses. Remove course offerings first.', 16, 1, @id);
        RETURN;
    END
    
    -- Check for dependencies in Order table
    IF EXISTS (SELECT 1 FROM [Order] WHERE User_id = @id)
    BEGIN
        RAISERROR('Cannot delete user with ID %d: User has orders. Remove orders first.', 16, 1, @id);
        RETURN;
    END
    
    -- Check for dependencies in obtain_certificate table
    IF EXISTS (SELECT 1 FROM obtain_certificate WHERE User_id = @id)
    BEGIN
        RAISERROR('Cannot delete user with ID %d: User has certificates. Remove certificates first.', 16, 1, @id);
        RETURN;
    END
    
    -- Delete user
    BEGIN TRY
        DELETE FROM [User] WHERE id = @id;
        PRINT 'User deleted successfully';
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO

-- Example of successfully adding a new user
EXEC sp_InsertUser 
    @id = 6, 
    @Email = 'michael.johnson@example.com', 
    @FName = 'Michael', 
    @LName = 'Johnson', 
    @Date_of_birth = '1994-06-15', 
    @Username = 'michael94', 
    @Password = 'Michael@Pass123', 
    @Phone_number = '0923456789';
-- Output: User inserted successfully

-- Verify the new user was added successfully
SELECT * FROM [User] WHERE id = 6; 

-- Attempting to add a user with an ID that already exists
EXEC sp_InsertUser 
    @id = 1, -- ID 1 already belongs to Alice Nguyen
    @Email = 'mark.wilson@example.com', 
    @FName = 'Mark', 
    @LName = 'Wilson', 
    @Date_of_birth = '1995-05-05', 
    @Username = 'markw95', 
    @Password = 'Wilson@Pass456', 
    @Phone_number = '0987654321';
-- Output: User with ID 1 already exists

-- Attempting to add a user with a username that's already taken
EXEC sp_InsertUser 
    @id = 7, 
    @Email = 'sophie.lee@example.com', 
    @FName = 'Sophie', 
    @LName = 'Lee', 
    @Date_of_birth = '1995-05-05', 
    @Username = 'bob85', -- Username already used by Bob Tran (ID 2)
    @Password = 'Sophie@Pass789', 
    @Phone_number = '0987654321';
-- Output: Username "bob85" is already taken

-- Attempting to add a user with invalid email format
EXEC sp_InsertUser 
    @id = 7, 
    @Email = 'invalid-email', 
    @FName = 'Sophie', 
    @LName = 'Lee', 
    @Date_of_birth = '1995-05-05', 
    @Username = 'sophie95', 
    @Password = 'Sophie@Pass789', 
    @Phone_number = '0987654321';
-- Output: Invalid email format: invalid-email

-- Attempting to add a user with a password less than 8 characters
EXEC sp_InsertUser 
    @id = 7, 
    @Email = 'sophie.lee@example.com', 
    @FName = 'Sophie', 
    @LName = 'Lee', 
    @Date_of_birth = '1995-05-05', 
    @Username = 'sophie95', 
    @Password = 'short', 
    @Phone_number = '0987654321';
-- Output: Password must be at least 8 characters long

-- Attempting to add an underage user (less than 13 years old)
EXEC sp_InsertUser 
    @id = 7, 
    @Email = 'young.student@example.com', 
    @FName = 'Young', 
    @LName = 'Student', 
    @Date_of_birth = '2020-01-01', -- Only 5 years old in 2025
    @Username = 'youngstudent', 
    @Password = 'Student@Pass123', 
    @Phone_number = '0987654321';
-- Output: User must be at least 13 years old

-- Example of successfully updating Alice's contact information
EXEC sp_UpdateUser 
    @id = 1, 
    @Email = 'alice.nguyen.updated@example.com', 
    @Phone_number = '0901234999';
-- Output: User updated successfully

-- Update multiple fields for Bob, who got married and changed his name
EXEC sp_UpdateUser 
    @id = 2, 
    @FName = 'Bob', 
    @LName = 'Nguyen', 
    @Password = 'BobNewSecurePass456!';
-- Output: User updated successfully

-- Attempting to update a user that doesn't exist
EXEC sp_UpdateUser 
    @id = 99, 
    @Email = 'nonexistent@example.com';
-- Output: User with ID 99 does not exist

-- Attempting to update Charlie's username to one that's already taken
EXEC sp_UpdateUser 
    @id = 3, 
    @Username = 'alice90'; -- Username already belongs to Alice (user 1)
-- Output: Username "alice90" is already taken

-- Attempting to update David's email with invalid format
EXEC sp_UpdateUser 
    @id = 4, 
    @Email = 'invalid-format';
-- Output: Invalid email format: invalid-format

-- Attempting to update Eve's password to something too short
EXEC sp_UpdateUser 
    @id = 5, 
    @Password = 'short'; -- Password too short
-- Output: Password must be at least 8 characters long

-- Attempting to delete Alice (user 1) who has roles, follows, and reviews
EXEC sp_DeleteUser @id = 1;
-- Output: Cannot delete user with ID 1: User has assigned roles. Remove roles first.

-- Remove Michael's (new user 6) dependencies one by one
-- First, make sure Michael has some dependencies (add them if needed)
INSERT INTO has_role (User_id, Role_id) VALUES (6, 3); -- Michael is a Student
INSERT INTO user_address (User_id, User_addr) VALUES (6, '789 Le Duan, District 3, HCMC');

-- Then remove dependencies systematically
DELETE FROM has_role WHERE User_id = 6;
DELETE FROM user_address WHERE User_id = 6;
-- Remove any other dependencies...

-- Now we can delete Michael's account
EXEC sp_DeleteUser @id = 6;
-- Output: User deleted successfully

-- Attempting to delete a user that doesn't exist
EXEC sp_DeleteUser @id = 99;
-- Output: User with ID 99 does not exist

GO
-- 2.2
-- Trigger 1
-- update Rating from user --
CREATE TRIGGER trg_Update_Course_Rating
ON review_course
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @AffectedCourses TABLE (Course_id INT);

    INSERT INTO @AffectedCourses(Course_id)
    SELECT Course_id FROM INSERTED
    UNION
    SELECT Course_id FROM DELETED;

    UPDATE C
    SET C.Rating = (
        SELECT AVG(Rating_score)
        FROM review_course
        WHERE Course_id = C.id
    )
    FROM Course C
    WHERE C.id IN (SELECT Course_id FROM @AffectedCourses);
END;
GO

-- Test Trigger 1
SELECT * FROM review_course WHERE Course_id = 101;

INSERT INTO review_course (User_id, Course_id, Comment, Rating_score)
VALUES (4, 101, 'This helped me a lot!', 2.5);
GO

DELETE FROM review_course
WHERE User_id = 4 AND Course_id = 101;

UPDATE review_course
SET Comment = 'Loved it!',
    Rating_score = 3.5,
    Date = GETDATE()
WHERE User_id = 1 AND Course_id = 101;
GO

-- Check if Course Rating updated
SELECT * FROM Course WHERE id = 101;
GO

-- Trigger 2
-- update TotalFee from Course --
CREATE TRIGGER trg_Update_TotalFee
ON include_course
AFTER INSERT, DELETE
AS
BEGIN
    DECLARE @Order_id INT;

    -- Handle INSERT
    IF EXISTS (SELECT * FROM INSERTED)
        SELECT @Order_id = Order_id FROM INSERTED;
    ELSE
        SELECT @Order_id = Order_id FROM DELETED;

    UPDATE O
    SET O.Total_fee = (
        SELECT SUM(C.Fee)
        FROM include_course IC
        JOIN Course C ON IC.Course_id = C.id
        WHERE IC.Order_id = @Order_id
    )
    FROM [Order] O
    WHERE O.Order_id = @Order_id;
END;
GO


-- Test Trigger 2
-- Check it's created correctly
SELECT * FROM [Order] WHERE Order_id = 3001;
GO

INSERT INTO include_course (Order_id, Course_id)
VALUES 
(3001, 101)
GO

DELETE FROM include_course
WHERE Order_id = 3001 AND Course_id = 101;

SELECT * FROM Course
GO
SELECT * FROM include_course
GO


DELETE FROM include_course
WHERE Order_id = 3001 AND Course_id = 101;
GO

-- 2.3
-- Procedure 1
CREATE OR ALTER PROCEDURE sp_GetTopRatedCourseReviews
    @MinRating DECIMAL(2,1)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        c.id AS CourseId,
        c.CName AS CourseName,
        u.id AS UserId,
        u.Username,
        rc.Rating_score,
        rc.Comment,
        rc.Date
    FROM 
        review_course rc
        INNER JOIN Course c ON rc.Course_id = c.id
        INNER JOIN [User] u ON rc.User_id = u.id
    WHERE 
        rc.Rating_score >= @MinRating
    ORDER BY 
        rc.Rating_score DESC;
END;
GO

SELECT * FROM review_course

EXEC sp_GetTopRatedCourseReviews @MinRating = 2.5;

GO

-- Procedure 2
CREATE PROCEDURE GetUserNetworkStats
    @MinFollowers INT = 0,    
    @MinFollowing INT = 0    
AS
BEGIN
    SELECT
        u.id AS UserId, u.Username AS UserName,
        COUNT(DISTINCT f1.Follower_id) AS FollowerCount,
        COUNT(DISTINCT f2.User_id)     AS FollowingCount
    FROM [User] AS u
    LEFT JOIN follow AS f1
        ON u.id = f1.User_id            
    LEFT JOIN follow AS f2
        ON u.id = f2.Follower_id        
    GROUP BY
        u.id, u.Username
    HAVING
        COUNT(DISTINCT f1.Follower_id) >= @MinFollowers
        AND COUNT(DISTINCT f2.User_id)    >= @MinFollowing
    ORDER BY
        FollowerCount DESC,
        FollowingCount DESC;
END;
GO

EXEC GetUserNetworkStats;
GO

EXEC GetUserNetworkStats
     @MinFollowers = 2,
     @MinFollowing = 0;
GO

-- 2.4
-- Function 1

CREATE OR ALTER FUNCTION getComplete
(
    @user_id INT,
	@threshold FLOAT
)
RETURNS @Result TABLE
(
	u_id INT,
    course_id INT,
	current_process FLOAT
)
AS
BEGIN
	-- ktra id đúng format chưa
    IF @user_id <= 0 --OR LEN(CAST(@user_id AS VARCHAR)) != 8
        RETURN;

    DECLARE @course_id INT;
    DECLARE @total INT;
    DECLARE @done INT;
	DECLARE @cur_rate FLOAT;

    DECLARE cur CURSOR FOR
        SELECT DISTINCT course_id FROM Learn WHERE user_id = @user_id;

    OPEN cur;
    FETCH NEXT FROM cur INTO @course_id;

    WHILE @@FETCH_STATUS = 0
    BEGIN

		SELECT @total = COUNT(*)
		FROM (SELECT DISTINCT Chapter_id, Lesson_id as total
					FROM Learn
					WHERE course_id = @course_id) as SUB;

		SELECT @done = COUNT(*)
		FROM (
			SELECT DISTINCT Course_id, Chapter_id, Lesson_id
			FROM Learn
			WHERE course_id = @course_id 
				AND user_id = @user_id 
				AND status = 'completed'
		) AS completed_lessons;

		SET @cur_rate = CAST(@done AS FLOAT) / @total;
        IF @cur_rate >= @threshold
        BEGIN
            INSERT INTO @Result(u_id, course_id, current_process) VALUES (@user_id, @course_id, @cur_rate);
        END

        FETCH NEXT FROM cur INTO @course_id;
    END

    CLOSE cur;
    DEALLOCATE cur;

    RETURN;
END;

GO
SELECT * FROM Learn
SELECT * FROM getComplete(1,0.0);

GO 
-- Function 2
CREATE OR ALTER FUNCTION overDay
(
	@threshold FLOAT,
	@days INT
)

RETURNS @Result TABLE (
	u_id INT,
	c_id INT,
	cur_proc FLOAT
)
AS
BEGIN 
	DECLARE @id INT;
	DECLARE @o_dat DATETIME;
	DECLARE @c_id INT;
	DECLARE @dif_d DATETIME;
	DECLARE @cur_rate FLOAT;

	DECLARE cur CURSOR FOR
        SELECT User_id, Ord_date, Course_id, DATEDIFF(DAY, Ord_date, GETDATE()) as diff_day
			FROM [Order] O, [user] U, include_course I
			WHERE O.User_id = U.id 
				AND O.Order_id = I.Order_id 
				AND O.Ord_status = 'completed'
				AND DATEDIFF(DAY, Ord_date, GETDATE()) > @days;

	OPEN cur;
    FETCH NEXT FROM cur INTO @id, @o_dat, @c_id, @dif_d;
	WHILE @@FETCH_STATUS = 0
    BEGIN
		SELECT @cur_rate = current_process
		FROM getComplete(@id,0)
		WHERE course_id = @c_id

		IF @cur_rate < @threshold
		BEGIN
            INSERT INTO @Result(u_id, c_id, cur_proc) VALUES (@id, @c_id, 0);
        END

		IF @threshold <= @cur_rate AND @cur_rate < 1 
		BEGIN
            INSERT INTO @Result(u_id, c_id, cur_proc) VALUES (@id, @c_id, @cur_rate);
        END
		FETCH NEXT FROM cur INTO @id, @o_dat, @c_id, @dif_d;
	END
	RETURN;
END;

GO

SELECT * FROM [Order]
SELECT *
FROM overDay(0.4, 180)