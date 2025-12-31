package jh.qna.domain;

public class QnaDTO {
    private long qnaId;
    private String fkMemberId;
    private String fkAdminId;   // 답변자(관리자) - 없을 수 있음
    private String subject;
    private String content;
    private int isSecret;       // 0/1
    private String answer;      // CLOB

    // getter/setter
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
}
