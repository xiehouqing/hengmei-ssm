package com.wzj.hengmei.entity;

public class Menu {
    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column b_menu.menu_id
     *
     * @mbggenerated
     */
    private Integer menuId;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column b_menu.menu_name
     *
     * @mbggenerated
     */
    private String menuName;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column b_menu.menu_url
     *
     * @mbggenerated
     */
    private String menuUrl;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column b_menu.menu_icon
     *
     * @mbggenerated
     */
    private String menuIcon;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column b_menu.parent_id
     *
     * @mbggenerated
     */
    private Integer parentId;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column b_menu.disp_order
     *
     * @mbggenerated
     */
    private Integer dispOrder;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column b_menu.del_flg
     *
     * @mbggenerated
     */
    private String delFlg;

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column b_menu.menu_id
     *
     * @return the value of b_menu.menu_id
     *
     * @mbggenerated
     */
    public Integer getMenuId() {
        return menuId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column b_menu.menu_id
     *
     * @param menuId the value for b_menu.menu_id
     *
     * @mbggenerated
     */
    public void setMenuId(Integer menuId) {
        this.menuId = menuId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column b_menu.menu_name
     *
     * @return the value of b_menu.menu_name
     *
     * @mbggenerated
     */
    public String getMenuName() {
        return menuName;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column b_menu.menu_name
     *
     * @param menuName the value for b_menu.menu_name
     *
     * @mbggenerated
     */
    public void setMenuName(String menuName) {
        this.menuName = menuName == null ? null : menuName.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column b_menu.menu_url
     *
     * @return the value of b_menu.menu_url
     *
     * @mbggenerated
     */
    public String getMenuUrl() {
        return menuUrl;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column b_menu.menu_url
     *
     * @param menuUrl the value for b_menu.menu_url
     *
     * @mbggenerated
     */
    public void setMenuUrl(String menuUrl) {
        this.menuUrl = menuUrl == null ? null : menuUrl.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column b_menu.menu_icon
     *
     * @return the value of b_menu.menu_icon
     *
     * @mbggenerated
     */
    public String getMenuIcon() {
        return menuIcon;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column b_menu.menu_icon
     *
     * @param menuIcon the value for b_menu.menu_icon
     *
     * @mbggenerated
     */
    public void setMenuIcon(String menuIcon) {
        this.menuIcon = menuIcon == null ? null : menuIcon.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column b_menu.parent_id
     *
     * @return the value of b_menu.parent_id
     *
     * @mbggenerated
     */
    public Integer getParentId() {
        return parentId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column b_menu.parent_id
     *
     * @param parentId the value for b_menu.parent_id
     *
     * @mbggenerated
     */
    public void setParentId(Integer parentId) {
        this.parentId = parentId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column b_menu.disp_order
     *
     * @return the value of b_menu.disp_order
     *
     * @mbggenerated
     */
    public Integer getDispOrder() {
        return dispOrder;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column b_menu.disp_order
     *
     * @param dispOrder the value for b_menu.disp_order
     *
     * @mbggenerated
     */
    public void setDispOrder(Integer dispOrder) {
        this.dispOrder = dispOrder;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column b_menu.del_flg
     *
     * @return the value of b_menu.del_flg
     *
     * @mbggenerated
     */
    public String getDelFlg() {
        return delFlg;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column b_menu.del_flg
     *
     * @param delFlg the value for b_menu.del_flg
     *
     * @mbggenerated
     */
    public void setDelFlg(String delFlg) {
        this.delFlg = delFlg == null ? null : delFlg.trim();
    }
}