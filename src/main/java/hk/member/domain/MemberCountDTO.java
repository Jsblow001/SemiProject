package hk.member.domain;

public class MemberCountDTO {

	// 등급별 회원수, 성별 회원수 구현 위해 생성
    private String key; // grade_name 또는 gender
    private int cnt;

    // getter/setter
    public String getKey() {
        return key;
    }
    public void setKey(String key) {
        this.key = key;
    }

    public int getCnt() {
        return cnt;
    }
    public void setCnt(int cnt) {
        this.cnt = cnt;
    }
}
