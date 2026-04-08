package hk.member.domain;

public class AddressDTO {

    private int addrId;            // ADDR_ID (PK)
    private String fkMemberId;     // FK_MEMBER_ID
    private String postcode;       // POSTCODE
    private String address;        // ADDRESS
    private String detailaddress;  // DETAILADDRESS
    private String extraaddress;   // EXTRAADDRESS (nullable)

    // ===== getter / setter =====
    public int getAddrId() {
        return addrId;
    }
    public void setAddrId(int addrId) {
        this.addrId = addrId;
    }

    public String getFkMemberId() {
        return fkMemberId;
    }
    public void setFkMemberId(String fkMemberId) {
        this.fkMemberId = fkMemberId;
    }

    public String getPostcode() {
        return postcode;
    }
    public void setPostcode(String postcode) {
        this.postcode = postcode;
    }

    public String getAddress() {
        return address;
    }
    public void setAddress(String address) {
        this.address = address;
    }

    public String getDetailaddress() {
        return detailaddress;
    }
    public void setDetailaddress(String detailaddress) {
        this.detailaddress = detailaddress;
    }

    public String getExtraaddress() {
        return extraaddress;
    }
    public void setExtraaddress(String extraaddress) {
        this.extraaddress = extraaddress;
    }
}
