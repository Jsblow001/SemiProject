package jh.notice.domain;

public class NoticeDTO {

    private int noticeId;      // NOTICE_ID
    private String adminId;    // FK_ADMIN_ID
    private String subject;    // SUBJECT
    private String regDate;    // REGDATE (to_char로 String)
    private String updateDate; // UPDATEDATE
    private String content;    // CONTENT
    private int isFixed;       // IS_FIXED (0/1)

    public NoticeDTO() {}

    public int getNoticeId() { return noticeId; }
    public void setNoticeId(int noticeId) { this.noticeId = noticeId; }

    public String getAdminId() { return adminId; }
    public void setAdminId(String adminId) { this.adminId = adminId; }

    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }

    public String getRegDate() { return regDate; }
    public void setRegDate(String regDate) { this.regDate = regDate; }

    public String getUpdateDate() { return updateDate; }
    public void setUpdateDate(String updateDate) { this.updateDate = updateDate; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public int getIsFixed() { return isFixed; }
    public void setIsFixed(int isFixed) { this.isFixed = isFixed; }
}
