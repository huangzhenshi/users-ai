<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>用户管理</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h4>用户列表</h4>
        <div class="d-flex gap-2">
            <a href="/ai" class="btn btn-success">AI 助手</a>
            <a href="/users/add" class="btn btn-primary">+ 新增用户</a>
        </div>
    </div>
    <table class="table table-bordered table-hover">
        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>用户名</th>
            <th>邮箱</th>
            <th>手机号</th>
            <th>用户类型</th>
            <th>状态</th>
            <th>创建时间</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="u" items="${users}">
            <tr>
                <td>${u.id}</td>
                <td>${u.username}</td>
                <td>${u.email}</td>
                <td>${u.phone}</td>
                <td>
                    <c:choose>
                        <c:when test="${u.userType == 1}">
                            <span class="badge bg-primary">普通用户</span>
                        </c:when>
                        <c:when test="${u.userType == 2}">
                            <span class="badge bg-warning text-dark">经销商</span>
                        </c:when>
                        <c:when test="${u.userType == 3}">
                            <span class="badge bg-danger">管理员</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-secondary">未知</span>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <c:choose>
                        <c:when test="${u.status == 1}">
                            <span class="badge bg-success">启用</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-secondary">禁用</span>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td>${u.createdAt}</td>
                <td>
                    <a href="/users/edit/${u.id}" class="btn btn-sm btn-warning">编辑</a>
                    <a href="/users/delete/${u.id}" class="btn btn-sm btn-danger"
                       onclick="return confirm('确认删除？')">删除</a>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty users}">
            <tr><td colspan="8" class="text-center text-muted">暂无数据</td></tr>
        </c:if>
        </tbody>
    </table>
</div>
</body>
</html>
