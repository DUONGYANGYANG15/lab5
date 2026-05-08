const router = require("express").Router();
const jwt = require("jsonwebtoken");
const User = require("../models/user.model");
const bcrypt = require("bcrypt");
router.post("/register", async (req, res) => {
    try {
        const { email, password } = req.body;
        const user = new User({ email, password });
        await user.save();
        res.json({ status: true, message: "Đăng ký thành công!" });
    } catch (err) {
        res.json({ status: false, message: "Lỗi đăng ký" });
    }
});
router.post("/login", async (req, res) => {
    try {
        const { email, password } = req.body;
        console.log("--- Kiểm tra đăng nhập ---");
        console.log("Email đăng nhập:", email);
        const user = await User.findOne({ email });
        if (!user) {
            console.log("Kết quả: Không tìm thấy email này!");
            return res.json({ status: false, message: "Email không tồn tại" });
        }
        const isMatch = await bcrypt.compare(password, user.password);
        console.log("Kết quả so sánh mật khẩu:", isMatch);

        if (!isMatch) {
            console.log("Kết quả: Sai mật khẩu!");
            return res.json({ status: false, message: "Sai mật khẩu rồi Dương ơi!" });
        }
        const token = jwt.sign({ _id: user._id }, "secret_key_cua_duong", { expiresIn: '1h' });

        console.log("Kết quả: Đăng nhập thành công, đã cấp Token.");
        res.json({ status: true, token: token });
    } catch (err) {
        console.log("Lỗi đăng nhập hệ thống:", err);
        res.json({ status: false, message: "Lỗi hệ thống" });
    }
});

module.exports = router;