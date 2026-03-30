package com.eason.usersai.controller;

import com.eason.usersai.entity.User;
import com.eason.usersai.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.client.advisor.MessageChatMemoryAdvisor;
import org.springframework.ai.chat.memory.InMemoryChatMemoryRepository;
import org.springframework.ai.chat.memory.MessageWindowChatMemory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/ai")
public class AiController {

    private final ChatClient chatClient;
    private final UserService userService;
    private final MessageWindowChatMemory chatMemory;

    public AiController(ChatClient.Builder chatClientBuilder, UserService userService) {
        this.chatClient = chatClientBuilder.build();
        this.userService = userService;
        // 创建共享的 ChatMemory，conversationId 在 advisor 里指定
        this.chatMemory = MessageWindowChatMemory.builder()
                .chatMemoryRepository(new InMemoryChatMemoryRepository())
                .build();
    }

    @GetMapping
    public String page(Model model) {
        return "ai/chat";
    }

    @PostMapping("/chat")
    @ResponseBody
    public String chat(@RequestParam String message, HttpSession session) {
        String sessionId = session.getId();

        // 全量获取用户表数据作为知识库
        List<User> users = userService.findAll();
        String systemPrompt = """
                你是一个用户管理系统的智能助手。
                以下是当前系统中所有用户的数据：
                
                %s
                
                请基于以上用户数据回答用户的问题。如果问题与用户数据无关，也可以正常回答。
                """.formatted(buildUserContext(users));

        return chatClient.prompt()
                .system(systemPrompt)
                .user(message)
                .advisors(MessageChatMemoryAdvisor.builder(chatMemory)
                        .conversationId(sessionId)
                        .build())
                .call()
                .content();
    }

    @PostMapping("/clear")
    @ResponseBody
    public String clear(HttpSession session) {
        chatMemory.clear(session.getId());
        return "ok";
    }

    private String buildUserContext(List<User> users) {
        if (users.isEmpty()) {
            return "（当前系统中没有用户数据）";
        }
        return users.stream()
                .map(u -> "ID:%d | 用户名:%s | 邮箱:%s | 手机:%s | 状态:%s | 创建时间:%s"
                        .formatted(
                                u.getId(),
                                u.getUsername(),
                                u.getEmail() != null ? u.getEmail() : "-",
                                u.getPhone() != null ? u.getPhone() : "-",
                                u.getStatus() == 1 ? "启用" : "禁用",
                                u.getCreatedAt() != null ? u.getCreatedAt().toString() : "-"
                        ))
                .collect(Collectors.joining("\n"));
    }
}
