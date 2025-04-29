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

    public List<ReviewResponse> getTopRatedReviews(String subjectKeyword, String courseKeyword, Float minRating) {
        List<Object[]> result = entityManager
                .createNativeQuery("EXEC sp_GetTopRatedCoursesWithFilter :subjectKeyword, :courseKeyword, :minRating")
                .setParameter("subjectKeyword", subjectKeyword)
                .setParameter("courseKeyword", courseKeyword)
                .setParameter("minRating", minRating)
                .getResultList();

        List<ReviewResponse> reviews = new ArrayList<>();
        for (Object[] row : result) {
            // Map kết quả từ SQL trực tiếp vào ReviewResponse mà không cần kiểm tra kiểu dữ liệu quá nhiều
            ReviewResponse dto = new ReviewResponse();
            dto.setCourseName((String) row[0]); // CourseName
            dto.setRatingScore(((Number) row[1]).floatValue()); // AvgRating
            dto.setOfferName((String) row[2]); // OfferedBy
            dto.setNumberOfRegisters(((Number) row[3]).intValue()); // NumCompletedOrders
            dto.setFee(((Number) row[4]).intValue());
            dto.setReviewCount(((Number) row[5]).intValue());
            reviews.add(dto);
        }
        return reviews;
    }
}