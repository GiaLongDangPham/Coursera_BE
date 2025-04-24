package db.assignment.repository;

import db.assignment.dto.response.ReviewResponse;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;

@Repository
public class ReviewRepository {

    @PersistenceContext
    private EntityManager entityManager;

    public List<ReviewResponse> getTopRatedReviews(Float minRating) {
        List<Object[]> result = entityManager
                .createNativeQuery("EXEC sp_GetTopRatedCourseReviews :minRating")
                .setParameter("minRating", minRating)
                .getResultList();

        List<ReviewResponse> reviews = new ArrayList<>();
        for (Object[] row : result) {
            // Map kết quả từ SQL trực tiếp vào ReviewResponse mà không cần kiểm tra kiểu dữ liệu quá nhiều
            ReviewResponse dto = new ReviewResponse();
            dto.setCourseId((Integer) row[0]);
            dto.setCourseName((String) row[1]);
            dto.setUserId((Integer) row[2]);
            dto.setUsername((String) row[3]);
            dto.setRatingScore(((Number) row[4]).floatValue()); // Sử dụng Number để lấy giá trị float từ BigDecimal hoặc Double
            dto.setComment((String) row[5]);
            dto.setDate((java.sql.Timestamp) row[6]); // Trực tiếp chuyển về Timestamp, sau đó Java sẽ tự chuyển thành Date nếu cần
            reviews.add(dto);
        }
        return reviews;
    }
}