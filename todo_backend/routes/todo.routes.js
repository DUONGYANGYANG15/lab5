const router = require("express").Router();
const Todo = require("../models/todo.model");
// 1. Hàm Thêm To-Do
router.post("/storeTodo", async (req, res) => {
    try {
        console.log("Dữ liệu nhận từ Flutter:", req.body);
        const { userId, title, desc } = req.body;
        const newTodo = new Todo({
            userId: userId,
            title: title,
            desc: desc
        });

        await newTodo.save();
        res.json({ status: true, success: "Lưu thành công!" });
    } catch (err) {
        console.log("Lỗi lưu Todo:", err);
        res.json({ status: false, message: err.message });
    }
});
router.post("/getUserTodoList", async (req, res) => {
    try {
        const { userId } = req.body;
        const todos = await Todo.find({ userId });
        res.json({ status: true, success: todos });
    } catch (err) {
        res.json({ status: false, message: err.message });
    }
});
router.post("/deleteTodo", async (req, res) => {
    try {
        const { id } = req.body;
        await Todo.findByIdAndDelete(id);
        res.json({ status: true });
    } catch (err) {
        res.json({ status: false, message: err.message });
    }
});

module.exports = router;