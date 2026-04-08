package jh.qna.domain;

import java.sql.Date;

public class QnaCommentDTO {
    private int commentId;
    private int fkQnaId;
    private String fkMemberId;
    private String content;
    private Date regDate;

    public int getCommentId() { return commentId; }
    public void setCommentId(int commentId) { this.commentId = commentId; }

    public int getFkQnaId() { return fkQnaId; }
    public void setFkQnaId(int fkQnaId) { this.fkQnaId = fkQnaId; }

    public String getFkMemberId() { return fkMemberId; }
    public void setFkMemberId(String fkMemberId) { this.fkMemberId = fkMemberId; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public Date getRegDate() { return regDate; }
    public void setRegDate(Date regDate) { this.regDate = regDate; }
}
