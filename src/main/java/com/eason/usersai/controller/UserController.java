package com.eason.usersai.controller;

import com.eason.usersai.entity.User;
import com.eason.usersai.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/users")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    // 列表
    @GetMapping
    public String list(Model model) {
        model.addAttribute("users", userService.findAll());
        return "user/list";
    }

    // JSON 列表（供 API 调用）
    @GetMapping("/api/list")
    @ResponseBody
    public List<User> listApi() {
        return userService.findAll();
    }

    // 新增页面
    @GetMapping("/add")
    public String addPage(Model model) {
        model.addAttribute("user", new User());
        return "user/form";
    }

    // 编辑页面
    @GetMapping("/edit/{id}")
    public String editPage(@PathVariable Long id, Model model) {
        model.addAttribute("user", userService.findById(id));
        return "user/form";
    }

    // 保存（新增/编辑）
    @PostMapping("/save")
    public String save(User user) {
        if (user.getId() == null) {
            userService.save(user);
        } else {
            userService.update(user);
        }
        return "redirect:/users";
    }

    // 删除
    @GetMapping("/delete/{id}")
    public String delete(@PathVariable Long id) {
        userService.delete(id);
        return "redirect:/users";
    }
}
