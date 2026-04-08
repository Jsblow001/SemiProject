package jh.qna.domain;

public class QnaFileDTO {
    private long qnaFileId;
    private long fkQnaId;
    private String orgFilename;
    private String saveFilename;
    private long fileSize;
    private String contentType;

    public long getQnaFileId() { return qnaFileId; }
    public void setQnaFileId(long qnaFileId) { this.qnaFileId = qnaFileId; }

    public long getFkQnaId() { return fkQnaId; }
    public void setFkQnaId(long fkQnaId) { this.fkQnaId = fkQnaId; }

    public String getOrgFilename() { return orgFilename; }
    public void setOrgFilename(String orgFilename) { this.orgFilename = orgFilename; }

    public String getSaveFilename() { return saveFilename; }
    public void setSaveFilename(String saveFilename) { this.saveFilename = saveFilename; }

    public long getFileSize() { return fileSize; }
    public void setFileSize(long fileSize) { this.fileSize = fileSize; }

    public String getContentType() { return contentType; }
    public void setContentType(String contentType) { this.contentType = contentType; }
}
