package task.controller;

import com.opensymphony.xwork2.ActionSupport;
import task.service.UserManager;

public class DeleteAction extends ActionSupport {

    private Integer userId;
    private UserManager userManager;

    public String deleteUser() {
        userManager.deleteUserByID(userId);
        return SUCCESS;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public void setUserManager(UserManager userManager) {
        this.userManager = userManager;
    }
}
