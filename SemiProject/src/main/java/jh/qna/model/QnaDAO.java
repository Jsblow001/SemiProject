package jh.qna.model;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import jh.qna.domain.QnaDTO;
import jh.qna.domain.QnaFileDTO;

public interface QnaDAO {

    long insertQna(Connection conn, QnaDTO dto) throws SQLException;
    int insertQnaFile(Connection conn, QnaFileDTO fileDto) throws SQLException;

    List<QnaFileDTO> selectFilesByQnaId(Connection conn, long qnaId) throws SQLException;

    int deleteFilesByQnaId(Connection conn, long qnaId) throws SQLException;
    int deleteQna(Connection conn, long qnaId) throws SQLException;

    List<Map<String, Object>> selectQnaList(String searchType, String keyword) throws SQLException;
}
