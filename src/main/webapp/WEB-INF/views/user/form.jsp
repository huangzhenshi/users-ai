<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>${empty user.id ? '新增用户' : '编辑用户'}</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-4" style="max-width: 540px;">
    <h4 class="mb-3">${empty user.id ? '新增用户' : '编辑用户'}</h4>
    <form action="/users/save" method="post">
        <input type="hidden" name="id" value="${user.id}">

        <div class="mb-3">
            <label class="form-label">用户名</label>
            <input type="text" name="username" class="form-control" value="${user.username}" required>
        </div>
        <div class="mb-3">
            <label class="form-label">密码</label>
            <input type="password" name="password" class="form-control" value="${user.password}" required>
        </div>
        <div class="mb-3">
            <label class="form-label">邮箱</label>
            <input type="email" name="email" class="form-control" value="${user.email}">
        </div>
        <div class="mb-3">
            <label class="form-label">手机号</label>
            <input type="text" name="phone" class="form-control" value="${user.phone}">
        </div>
        <div class="mb-3">
            <label class="form-label">状态</label>
            <select name="status" class="form-select">
                <option value="1" ${user.status == 1 ? 'selected' : ''}>启用</option>
                <option value="0" ${user.status == 0 ? 'selected' : ''}>禁用</option>
            </select>
        </div>

        <div class="d-flex gap-2">
            <button type="submit" class="btn btn-primary">保存</button>
            <a href="/users" class="btn btn-secondary">取消</a>
        </div>
    </form>
</div>
</body>
</html>
