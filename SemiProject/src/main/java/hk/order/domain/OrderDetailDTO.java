package hk.order.domain;

public class OrderDetailDTO {

    private int odrDetailNo;        // ODRDETAILNO
    private int odrCode;            // FK_ODRCODE
    private int productId;          // FK_PRODUCT_ID
    private int odrQty;             // ODRQTY
    private int odrPrice;           // ODRPRICE
    private int deliveryStatus;     // DELIVERYSTATUS
    private String deliveryDate;    // DELIVERYDATE

    // ===== 조회용 =====
    private String productName;
    private String deliveryStatusName;

    public int getOdrDetailNo() { return odrDetailNo; }
    public void setOdrDetailNo(int odrDetailNo) { this.odrDetailNo = odrDetailNo; }

    public int getOdrCode() { return odrCode; }
    public void setOdrCode(int odrCode) { this.odrCode = odrCode; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getOdrQty() { return odrQty; }
    public void setOdrQty(int odrQty) { this.odrQty = odrQty; }

    public int getOdrPrice() { return odrPrice; }
    public void setOdrPrice(int odrPrice) { this.odrPrice = odrPrice; }

    public int getDeliveryStatus() { return deliveryStatus; }
    public void setDeliveryStatus(int deliveryStatus) { this.deliveryStatus = deliveryStatus; }

    public String getDeliveryDate() { return deliveryDate; }
    public void setDeliveryDate(String deliveryDate) { this.deliveryDate = deliveryDate; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getDeliveryStatusName() { return deliveryStatusName; }
    public void setDeliveryStatusName(String deliveryStatusName) { this.deliveryStatusName = deliveryStatusName; }
}
