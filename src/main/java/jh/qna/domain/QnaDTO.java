package jh.qna.domain;

import java.sql.Date;

public class QnaDTO {

    private long qnaId;
    private String fkMemberId;
    private String fkAdminId;
    private String subject;
    private String content;
    private int isSecret;
    private String answer;

    private Date regDate;
    private Date updateDate;

    // ===== 목록 화면용 파생 상태 =====
    private boolean hasReply;     // 댓글 존재 여부
    private boolean answered;     // 관리자 답변 여부

    // getter / setter
    public long getQnaId() { return qnaId; }
    public void setQnaId(long qnaId) { this.qnaId = qnaId; }

    public String getFkMemberId() { return fkMemberId; }
    public void setFkMemberId(String fkMemberId) { this.fkMemberId = fkMemberId; }

    public String getFkAdminId() { return fkAdminId; }
    public void setFkAdminId(String fkAdminId) { this.fkAdminId = fkAdminId; }

    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public int getIsSecret() { return isSecret; }
    public void setIsSecret(int isSecret) { this.isSecret = isSecret; }

    public String getAnswer() { return answer; }
    public void setAnswer(String answer) { this.answer = answer; }

    public Date getRegDate() { return regDate; }
    public void setRegDate(Date regDate) { this.regDate = regDate; }

    public Date getUpdateDate() { return updateDate; }
    public void setUpdateDate(Date updateDate) { this.updateDate = updateDate; }

    public boolean isHasReply() { return hasReply; }
    public void setHasReply(boolean hasReply) { this.hasReply = hasReply; }

    public boolean isAnswered() { return answered; }
    public void setAnswered(boolean answered) { this.answered = answered; }
}
